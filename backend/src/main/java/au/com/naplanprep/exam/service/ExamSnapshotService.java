package au.com.naplanprep.exam.service;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.ExamQuestion;
import au.com.naplanprep.exam.entity.ExamSession;
import au.com.naplanprep.exam.entity.SessionQuestionSnapshot;
import au.com.naplanprep.exam.entity.Stimulus;
import au.com.naplanprep.exam.repository.ExamQuestionRepository;
import au.com.naplanprep.exam.repository.SessionQuestionSnapshotRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Writes immutable question snapshots for a session at start time.
 *
 * Once snapshots exist (hasSnapshot == true on the session), the session reads
 * exclusively from session_question_snapshots — never from the live questions table.
 * This ensures admin question edits after session start do not affect in-flight students.
 *
 * The snapshot JSONB for each question contains all rendering and grading data.
 * correctAnswer and explanation are included server-side but MUST NOT be sent
 * to student-facing API responses — they are used only for server-side scoring.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ExamSnapshotService {

    private final ExamQuestionRepository examQuestionRepository;
    private final SessionQuestionSnapshotRepository snapshotRepository;

    @Transactional
    public void createSnapshots(ExamSession session) {
        if (Boolean.TRUE.equals(session.getHasSnapshot())) {
            log.warn("Snapshot already exists for session {}, skipping", session.getId());
            return;
        }

        List<ExamQuestion> examQuestions =
            examQuestionRepository.findByExamIdOrderByQuestionOrder(session.getExamId());

        List<SessionQuestionSnapshot> snapshots = new ArrayList<>(examQuestions.size());

        for (ExamQuestion eq : examQuestions) {
            Question q = eq.getQuestion();
            Map<String, Object> snapshotData = buildSnapshot(q);

            SessionQuestionSnapshot snap = SessionQuestionSnapshot.builder()
                .id(new SessionQuestionSnapshot.SessionQuestionSnapshotId(session.getId(), q.getId()))
                .questionOrder(eq.getQuestionOrder())
                .testletId(eq.getTestletId())
                .sectionId(eq.getSectionId())
                .snapshot(snapshotData)
                .build();

            snapshots.add(snap);
        }

        snapshotRepository.saveAll(snapshots);
        session.setHasSnapshot(true);
        log.debug("Created {} question snapshots for session {}", snapshots.size(), session.getId());
    }

    private Map<String, Object> buildSnapshot(Question q) {
        Map<String, Object> s = new HashMap<>();

        // ── Render data (sent to student) ──────────────────────────
        s.put("questionId",    q.getId().toString());
        s.put("questionType",  q.getQuestionType().name());
        s.put("questionText",  q.getQuestionText());
        s.put("domain",        q.getDomain().name());
        s.put("yearLevel",     q.getYearLevel());
        s.put("topic",         q.getTopic());
        s.put("difficultyBand",q.getDifficultyBand());
        s.put("marks",         q.getMarks() != null ? q.getMarks() : 1);
        s.put("options",       q.getOptions());
        s.put("audioUrl",      q.getAudioUrl());
        s.put("calculatorAllowed", q.getCalculatorAllowed() != null ? q.getCalculatorAllowed() : true);

        // Inline stimulus
        s.put("stimulusText",  q.getStimulusText());
        s.put("stimulusType",  q.getStimulusType());

        // Shared stimulus
        Stimulus sharedStim = q.getStimulus();
        if (sharedStim != null) {
            s.put("stimulusId",          sharedStim.getId().toString());
            s.put("stimulusSharedType",  sharedStim.getStimulusType().name());
            s.put("stimulusContent",     sharedStim.getContent());
            s.put("stimulusAssetUrl",    sharedStim.getAssetUrl());
            s.put("stimulusTitle",       sharedStim.getTitle());
            // transcript is NEVER included — admin-only field
        }

        // Cognitive metadata
        if (q.getCognitiveSkill() != null) {
            s.put("cognitiveSkill", q.getCognitiveSkill().name());
        }
        s.put("curriculumStrand", q.getCurriculumStrand());

        // ── Grading data (server-side ONLY — never returned to student) ──
        s.put("correctAnswer",   q.getCorrectAnswer());
        s.put("markingRubric",   q.getMarkingRubric());
        // explanation withheld until after submission
        s.put("explanation",     q.getExplanation());

        return s;
    }
}
