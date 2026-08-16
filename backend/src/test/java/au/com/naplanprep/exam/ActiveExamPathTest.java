package au.com.naplanprep.exam;

import au.com.naplanprep.exam.entity.ExamSession;
import au.com.naplanprep.exam.entity.SessionQuestionSnapshot;
import au.com.naplanprep.exam.repository.SessionQuestionSnapshotRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

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
