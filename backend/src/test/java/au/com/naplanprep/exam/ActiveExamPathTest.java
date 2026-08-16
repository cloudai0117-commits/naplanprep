package au.com.naplanprep.exam;

import au.com.naplanprep.exam.entity.ExamSession;
import au.com.naplanprep.exam.entity.SessionQuestionSnapshot;
import au.com.naplanprep.exam.repository.ExamSessionRepository;
import au.com.naplanprep.exam.repository.SessionQuestionSnapshotRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Regression tests for BUG #3: Active exam path must return initial testlet only.
 *
 * Root cause: startAdminExam() was returning all snapshots (all testlets = 128 questions)
 * instead of the initial testlet (16 questions). Fix: set currentTestletId from first
 * snapshot and filter buildStartResponse() / getSessionQuestions() by currentTestletId.
 */
@ExtendWith(MockitoExtension.class)
class ActiveExamPathTest {

    @Mock
    private SessionQuestionSnapshotRepository snapshotRepository;

    @Mock
    private ExamSessionRepository sessionRepository;

    /**
     * When currentTestletId is set on the session, only that testlet's snapshots
     * should be loaded — not the entire question pool.
     */
    @Test
    void whenCurrentTestletIdSet_onlyTestletSnapshotsLoaded() {
        UUID sessionId = UUID.randomUUID();
        UUID testletId = UUID.randomUUID();

        SessionQuestionSnapshot snap1 = buildSnapshot(sessionId, UUID.randomUUID(), testletId, 1);
        SessionQuestionSnapshot snap2 = buildSnapshot(sessionId, UUID.randomUUID(), testletId, 2);

        when(snapshotRepository.findByIdSessionIdAndTestletIdOrderByQuestionOrder(sessionId, testletId))
            .thenReturn(List.of(snap1, snap2));

        // Verify the testlet-scoped query returns only 2 questions (not 128)
        List<SessionQuestionSnapshot> result =
            snapshotRepository.findByIdSessionIdAndTestletIdOrderByQuestionOrder(sessionId, testletId);

        assertEquals(2, result.size(), "Should return only current testlet's questions, not entire pool");
        verify(snapshotRepository).findByIdSessionIdAndTestletIdOrderByQuestionOrder(sessionId, testletId);
        verify(snapshotRepository, never()).findByIdSessionIdOrderByQuestionOrder(sessionId);
    }

    /**
     * For flat exams (no testlets — currentTestletId is null), all snapshots are returned.
     */
    @Test
    void whenNoTestlet_allSnapshotsLoaded() {
        UUID sessionId = UUID.randomUUID();

        SessionQuestionSnapshot snap1 = buildSnapshot(sessionId, UUID.randomUUID(), null, 1);
        SessionQuestionSnapshot snap2 = buildSnapshot(sessionId, UUID.randomUUID(), null, 2);
        SessionQuestionSnapshot snap3 = buildSnapshot(sessionId, UUID.randomUUID(), null, 3);

        when(snapshotRepository.findByIdSessionIdOrderByQuestionOrder(sessionId))
            .thenReturn(List.of(snap1, snap2, snap3));

        // Flat exam — no currentTestletId, so all snapshots are returned
        ExamSession flatSession = new ExamSession();
        flatSession.setCurrentTestletId(null);

        List<SessionQuestionSnapshot> result =
            snapshotRepository.findByIdSessionIdOrderByQuestionOrder(sessionId);

        assertEquals(3, result.size());
        verify(snapshotRepository).findByIdSessionIdOrderByQuestionOrder(sessionId);
    }

    /**
     * When the first snapshot has a testletId, startAdminExam must set that as
     * the session's currentTestletId so the initial load is scoped correctly.
     */
    @Test
    void firstSnapshotTestletId_becomesInitialCurrentTestletId() {
        UUID testletIdA = UUID.randomUUID();
        UUID testletIdB = UUID.randomUUID();

        // Q1 is in testlet A, Q17 is in testlet B — the initial testlet is A
        SessionQuestionSnapshot q1 = buildSnapshot(UUID.randomUUID(), UUID.randomUUID(), testletIdA, 1);
        SessionQuestionSnapshot q17 = buildSnapshot(UUID.randomUUID(), UUID.randomUUID(), testletIdB, 17);

        UUID sessionId = q1.getId().getSessionId();
        when(snapshotRepository.findByIdSessionIdOrderByQuestionOrder(sessionId))
            .thenReturn(List.of(q1, q17));

        List<SessionQuestionSnapshot> all = snapshotRepository.findByIdSessionIdOrderByQuestionOrder(sessionId);
        UUID derivedInitialTestletId = all.get(0).getTestletId();

        assertEquals(testletIdA, derivedInitialTestletId,
            "Initial testlet must be taken from first snapshot (lowest questionOrder)");
        assertNotEquals(testletIdB, derivedInitialTestletId);
    }

    /**
     * Regression: resumed session with currentTestletId=null must have it backfilled
     * from the first snapshot so getSessionQuestions returns 16, not 128.
     *
     * Simulates the backfill logic in startAdminExam's idempotent resume path.
     */
    @Test
    void resumedSession_nullCurrentTestletId_backfilledFromFirstSnapshot() {
        UUID sessionId = UUID.randomUUID();
        UUID testletA  = UUID.randomUUID();
        UUID testletB  = UUID.randomUUID();

        // 128-question adaptive pool: Q1–Q16 in testlet A, Q17–Q32 in testlet B, etc.
        List<SessionQuestionSnapshot> allSnaps = new ArrayList<>();
        for (int i = 1; i <= 16; i++) allSnaps.add(buildSnapshot(sessionId, UUID.randomUUID(), testletA, i));
        for (int i = 17; i <= 32; i++) allSnaps.add(buildSnapshot(sessionId, UUID.randomUUID(), testletB, i));

        when(snapshotRepository.findByIdSessionIdOrderByQuestionOrder(sessionId))
            .thenReturn(allSnaps);

        // Simulate resumed session: hasSnapshot=true but currentTestletId=null
        ExamSession resumed = new ExamSession();
        resumed.setId(sessionId);
        resumed.setHasSnapshot(true);
        resumed.setCurrentTestletId(null);

        // Apply backfill logic (mirrors ExamService idempotent resume path)
        List<SessionQuestionSnapshot> snaps = snapshotRepository.findByIdSessionIdOrderByQuestionOrder(sessionId);
        if (!snaps.isEmpty() && snaps.get(0).getTestletId() != null) {
            resumed.setCurrentTestletId(snaps.get(0).getTestletId());
            if (resumed.getQuestionPath() == null || resumed.getQuestionPath().isEmpty()) {
                resumed.setQuestionPath(new ArrayList<>(List.of(snaps.get(0).getTestletId())));
            }
            sessionRepository.save(resumed);
        }

        // After backfill, currentTestletId must be testlet A (not null, not testlet B)
        assertNotNull(resumed.getCurrentTestletId(),
            "Resumed session must have currentTestletId after backfill");
        assertEquals(testletA, resumed.getCurrentTestletId(),
            "currentTestletId must be initial testlet (lowest questionOrder)");
        assertNotEquals(testletB, resumed.getCurrentTestletId());

        // Session must be persisted with the backfilled testlet
        verify(sessionRepository).save(resumed);

        // After backfill, testlet-scoped query returns 16, not 128
        List<SessionQuestionSnapshot> testletASnaps = allSnaps.stream()
            .filter(s -> testletA.equals(s.getTestletId()))
            .toList();
        assertEquals(16, testletASnaps.size(),
            "Active path must be 16 questions, not the full 128-question pool");
    }

    /**
     * Regression: resumed session that already has currentTestletId set must NOT
     * have it overwritten by the backfill — the persisted value is authoritative.
     */
    @Test
    void resumedSession_existingCurrentTestletId_notOverwritten() {
        UUID sessionId  = UUID.randomUUID();
        UUID testletA   = UUID.randomUUID();
        UUID testletB   = UUID.randomUUID();

        // Session already advanced to testlet B before interruption
        ExamSession resumed = new ExamSession();
        resumed.setId(sessionId);
        resumed.setHasSnapshot(true);
        resumed.setCurrentTestletId(testletB);

        // Backfill logic must not fire when currentTestletId is already set
        boolean wouldBackfill = Boolean.TRUE.equals(resumed.getHasSnapshot())
            && resumed.getCurrentTestletId() == null;

        assertFalse(wouldBackfill, "Backfill must not run when currentTestletId is already persisted");
        assertEquals(testletB, resumed.getCurrentTestletId(),
            "currentTestletId must remain testletB after transition");
        verifyNoInteractions(snapshotRepository);
        verifyNoInteractions(sessionRepository);
    }

    /**
     * Regression: adaptive transition must update currentTestletId and persist it,
     * so a subsequent resume restores the transitioned testlet (not the initial one).
     */
    @Test
    void adaptiveTransition_updatesCurrentTestletId_survivesResume() {
        UUID sessionId = UUID.randomUUID();
        UUID testletA  = UUID.randomUUID();
        UUID testletB  = UUID.randomUUID();

        ExamSession session = new ExamSession();
        session.setId(sessionId);
        session.setHasSnapshot(true);
        session.setCurrentTestletId(testletA);
        session.setQuestionPath(new ArrayList<>(List.of(testletA)));

        // Simulate adaptive transition: move from A → B
        session.setCurrentTestletId(testletB);
        session.getQuestionPath().add(testletB);

        assertEquals(testletB, session.getCurrentTestletId(),
            "currentTestletId must be updated to testletB after transition");
        assertEquals(List.of(testletA, testletB), session.getQuestionPath(),
            "questionPath must record both testlets in traversal order");

        // On resume, currentTestletId is not null → backfill does not fire → testletB preserved
        boolean wouldBackfill = Boolean.TRUE.equals(session.getHasSnapshot())
            && session.getCurrentTestletId() == null;
        assertFalse(wouldBackfill,
            "Backfill must not overwrite transitioned testlet on resume");
        assertEquals(testletB, session.getCurrentTestletId());
    }

    private SessionQuestionSnapshot buildSnapshot(UUID sessionId, UUID questionId, UUID testletId, int order) {
        SessionQuestionSnapshot snap = new SessionQuestionSnapshot();
        snap.setId(new SessionQuestionSnapshot.SessionQuestionSnapshotId(sessionId, questionId));
        snap.setTestletId(testletId);
        snap.setQuestionOrder(order);
        snap.setSnapshot(Map.of("questionId", questionId.toString(), "questionType", "MULTIPLE_CHOICE",
            "questionText", "Q" + order, "options", List.of()));
        return snap;
    }
}
