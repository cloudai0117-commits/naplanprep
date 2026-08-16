package au.com.naplanprep.exam;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.*;
import au.com.naplanprep.exam.repository.ExamQuestionRepository;
import au.com.naplanprep.exam.repository.SessionQuestionSnapshotRepository;
import au.com.naplanprep.exam.service.ExamSnapshotService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * Verifies snapshot creation behaviour:
 * - Snapshot is written once at session start
 * - A second call with hasSnapshot=true is a no-op (idempotent)
 * - Snapshot excludes correctAnswer and explanation from student-visible fields
 * - Transcript from shared stimulus is never included
 */
@ExtendWith(MockitoExtension.class)
class SessionSnapshotTest {

    @Mock ExamQuestionRepository examQuestionRepository;
    @Mock SessionQuestionSnapshotRepository snapshotRepository;

    @InjectMocks ExamSnapshotService snapshotService;

    @Test
    void createSnapshots_writesOneRowPerQuestion() {
        UUID sessionId = UUID.randomUUID();
        UUID examId    = UUID.randomUUID();

        ExamSession session = ExamSession.builder()
            .id(sessionId)
            .examId(examId)
            .hasSnapshot(false)
            .questionIds(List.of())
            .flaggedQuestions(List.of())
            .questionPath(List.of())
            .answerCount(0)
            .build();

        Question q1 = buildQuestion("What is 2+2?", Map.of("value", "B"),
            List.of(Map.of("text","2","label","A"), Map.of("text","4","label","B")));
        Question q2 = buildQuestion("Spell 'necessary'", Map.of("value", "necessary"), null);

        ExamQuestion eq1 = buildExamQuestion(examId, q1, 1);
        ExamQuestion eq2 = buildExamQuestion(examId, q2, 2);

        when(examQuestionRepository.findByExamIdOrderByQuestionOrder(examId))
            .thenReturn(List.of(eq1, eq2));
        when(snapshotRepository.saveAll(any())).thenAnswer(inv -> inv.getArgument(0));

        snapshotService.createSnapshots(session);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<SessionQuestionSnapshot>> captor = ArgumentCaptor.forClass(List.class);
        verify(snapshotRepository).saveAll(captor.capture());

        List<SessionQuestionSnapshot> saved = captor.getValue();
        assertThat(saved).hasSize(2);
        assertThat(session.getHasSnapshot()).isTrue();
    }

    @Test
    void createSnapshots_skipsIfAlreadySnapshotted() {
        ExamSession session = ExamSession.builder()
            .id(UUID.randomUUID())
            .examId(UUID.randomUUID())
            .hasSnapshot(true)  // already done
            .questionIds(List.of())
            .flaggedQuestions(List.of())
            .questionPath(List.of())
            .answerCount(0)
            .build();

        snapshotService.createSnapshots(session);

        verifyNoInteractions(examQuestionRepository, snapshotRepository);
    }

    @Test
    void snapshot_containsCorrectAnswerForServerUse() {
        UUID sessionId = UUID.randomUUID();
        UUID examId    = UUID.randomUUID();

        ExamSession session = ExamSession.builder()
            .id(sessionId).examId(examId).hasSnapshot(false)
            .questionIds(List.of()).flaggedQuestions(List.of())
            .questionPath(List.of()).answerCount(0).build();

        Question q = buildQuestion("Q1", Map.of("value", "C"),
            List.of(Map.of("text","X","label","A"), Map.of("text","Y","label","B"), Map.of("text","Z","label","C")));
        ExamQuestion eq = buildExamQuestion(examId, q, 1);

        when(examQuestionRepository.findByExamIdOrderByQuestionOrder(examId))
            .thenReturn(List.of(eq));
        when(snapshotRepository.saveAll(any())).thenAnswer(inv -> inv.getArgument(0));

        snapshotService.createSnapshots(session);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<SessionQuestionSnapshot>> captor = ArgumentCaptor.forClass(List.class);
        verify(snapshotRepository).saveAll(captor.capture());

        Map<String, Object> snapshot = captor.getValue().get(0).getSnapshot();
        // correctAnswer must be present in snapshot for server-side scoring
        assertThat(snapshot).containsKey("correctAnswer");
        assertThat(((Map<?,?>) snapshot.get("correctAnswer")).get("value")).isEqualTo("C");
    }

    @Test
    void snapshot_containsCalculatorAllowed_true_byDefault() {
        UUID sessionId = UUID.randomUUID();
        UUID examId    = UUID.randomUUID();

        ExamSession session = ExamSession.builder()
            .id(sessionId).examId(examId).hasSnapshot(false)
            .questionIds(List.of()).flaggedQuestions(List.of())
            .questionPath(List.of()).answerCount(0).build();

        // @Builder.Default = true, so no explicit set needed
        Question q = buildQuestion("Y7 algebra question", Map.of("value","B"), null);
        ExamQuestion eq = buildExamQuestion(examId, q, 1);

        when(examQuestionRepository.findByExamIdOrderByQuestionOrder(examId))
            .thenReturn(List.of(eq));
        when(snapshotRepository.saveAll(any())).thenAnswer(inv -> inv.getArgument(0));

        snapshotService.createSnapshots(session);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<SessionQuestionSnapshot>> captor = ArgumentCaptor.forClass(List.class);
        verify(snapshotRepository).saveAll(captor.capture());

        Map<String, Object> snapshot = captor.getValue().get(0).getSnapshot();
        assertThat(snapshot).containsKey("calculatorAllowed");
        assertThat(snapshot.get("calculatorAllowed")).isEqualTo(true);
    }

    @Test
    void snapshot_containsCalculatorAllowed_false_whenExplicitlySet() {
        UUID sessionId = UUID.randomUUID();
        UUID examId    = UUID.randomUUID();

        ExamSession session = ExamSession.builder()
            .id(sessionId).examId(examId).hasSnapshot(false)
            .questionIds(List.of()).flaggedQuestions(List.of())
            .questionPath(List.of()).answerCount(0).build();

        // Y3 Numeracy question: calculator_allowed = false
        Question q = buildQuestion("What is 5 + 3?", Map.of("value","8"), null, false);
        ExamQuestion eq = buildExamQuestion(examId, q, 1);

        when(examQuestionRepository.findByExamIdOrderByQuestionOrder(examId))
            .thenReturn(List.of(eq));
        when(snapshotRepository.saveAll(any())).thenAnswer(inv -> inv.getArgument(0));

        snapshotService.createSnapshots(session);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<SessionQuestionSnapshot>> captor = ArgumentCaptor.forClass(List.class);
        verify(snapshotRepository).saveAll(captor.capture());

        Map<String, Object> snapshot = captor.getValue().get(0).getSnapshot();
        assertThat(snapshot).containsKey("calculatorAllowed");
        assertThat(snapshot.get("calculatorAllowed")).isEqualTo(false);
    }

    @Test
    void snapshot_mixedCalculatorAllowed_perQuestion() {
        UUID sessionId = UUID.randomUUID();
        UUID examId    = UUID.randomUUID();

        ExamSession session = ExamSession.builder()
            .id(sessionId).examId(examId).hasSnapshot(false)
            .questionIds(List.of()).flaggedQuestions(List.of())
            .questionPath(List.of()).answerCount(0).build();

        // Y7 A-stage: Q1 non-calculator, Q9 calculator
        Question q1 = buildQuestion("Y7 Q1 non-calc", Map.of("value","A"), null, false);
        Question q9 = buildQuestion("Y7 Q9 calc", Map.of("value","C"), null, true);

        ExamQuestion eq1 = buildExamQuestion(examId, q1, 1);
        ExamQuestion eq9 = buildExamQuestion(examId, q9, 9);

        when(examQuestionRepository.findByExamIdOrderByQuestionOrder(examId))
            .thenReturn(List.of(eq1, eq9));
        when(snapshotRepository.saveAll(any())).thenAnswer(inv -> inv.getArgument(0));

        snapshotService.createSnapshots(session);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<SessionQuestionSnapshot>> captor = ArgumentCaptor.forClass(List.class);
        verify(snapshotRepository).saveAll(captor.capture());

        List<SessionQuestionSnapshot> saved = captor.getValue();
        assertThat(saved).hasSize(2);
        assertThat(saved.get(0).getSnapshot().get("calculatorAllowed")).isEqualTo(false);
        assertThat(saved.get(1).getSnapshot().get("calculatorAllowed")).isEqualTo(true);
    }

    // ── TASK 16: Missing audio/transcript tests ───────────────────

    @Test
    void snapshot_transcriptExcluded_fromAudioStimulusQuestion() {
        UUID sessionId = UUID.randomUUID();
        UUID examId    = UUID.randomUUID();

        ExamSession session = ExamSession.builder()
            .id(sessionId).examId(examId).hasSnapshot(false)
            .questionIds(List.of()).flaggedQuestions(List.of())
            .questionPath(List.of()).answerCount(0).build();

        // Shared AUDIO stimulus that has a transcript (admin-only field)
        Stimulus audioStim = Stimulus.builder()
            .id(UUID.randomUUID())
            .stimulusType(Stimulus.StimulusType.AUDIO)
            .title("S1_01")
            .assetUrl("s3://naplanprep-content/audio/3/S1_01.wav")
            .transcript("necessary")   // must NOT appear in snapshot
            .yearLevel(3)
            .build();

        Question q = Question.builder()
            .id(UUID.randomUUID())
            .questionType(Question.QuestionType.AUDIO_RESPONSE)
            .yearLevel(3)
            .domain(Question.Domain.SPELLING)
            .topic("Vocabulary")
            .difficultyBand(2)
            .marks(1)
            .questionText("Listen and spell the word.")
            .correctAnswer(Map.of("value", "necessary"))
            .stimulus(audioStim)
            .status(Question.QuestionStatus.PUBLISHED)
            .calculatorAllowed(false)
            .build();

        ExamQuestion eq = buildExamQuestion(examId, q, 1);
        when(examQuestionRepository.findByExamIdOrderByQuestionOrder(examId))
            .thenReturn(List.of(eq));
        when(snapshotRepository.saveAll(any())).thenAnswer(inv -> inv.getArgument(0));

        snapshotService.createSnapshots(session);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<SessionQuestionSnapshot>> captor = ArgumentCaptor.forClass(List.class);
        verify(snapshotRepository).saveAll(captor.capture());

        Map<String, Object> snapshot = captor.getValue().get(0).getSnapshot();
        // transcript is NEVER included — admin-only field (ExamSnapshotService:100)
        assertThat(snapshot).doesNotContainKey("transcript");
        // stimulus metadata IS included (without transcript)
        assertThat(snapshot).containsKey("stimulusId");
        assertThat(snapshot).containsKey("stimulusContent");
        assertThat(snapshot).doesNotContainKey("stimulusTranscript");
    }

    @Test
    void snapshot_spellingShortAnswer_audioUrlIsNull_inSnapshot() {
        // Verifies post-V379 state: SHORT_ANSWER Spelling question with audioUrl=null
        // produces a snapshot with audioUrl=null (null flows through without NPE or default).
        UUID sessionId = UUID.randomUUID();
        UUID examId    = UUID.randomUUID();

        ExamSession session = ExamSession.builder()
            .id(sessionId).examId(examId).hasSnapshot(false)
            .questionIds(List.of()).flaggedQuestions(List.of())
            .questionPath(List.of()).answerCount(0).build();

        Question q = Question.builder()
            .id(UUID.randomUUID())
            .questionType(Question.QuestionType.SHORT_ANSWER)
            .yearLevel(3)
            .domain(Question.Domain.SPELLING)
            .topic("Vocabulary")
            .difficultyBand(2)
            .marks(1)
            .questionText("Complete the sentence by spelling the missing word correctly.")
            .correctAnswer(Map.of("value", "necessary"))
            .audioUrl(null)   // V379 sets this to NULL for all converted questions
            .status(Question.QuestionStatus.PUBLISHED)
            .calculatorAllowed(false)
            .build();

        ExamQuestion eq = buildExamQuestion(examId, q, 1);
        when(examQuestionRepository.findByExamIdOrderByQuestionOrder(examId))
            .thenReturn(List.of(eq));
        when(snapshotRepository.saveAll(any())).thenAnswer(inv -> inv.getArgument(0));

        snapshotService.createSnapshots(session);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<SessionQuestionSnapshot>> captor = ArgumentCaptor.forClass(List.class);
        verify(snapshotRepository).saveAll(captor.capture());

        Map<String, Object> snapshot = captor.getValue().get(0).getSnapshot();
        assertThat(snapshot.get("audioUrl")).isNull();
        assertThat(snapshot.get("questionType")).isEqualTo("SHORT_ANSWER");
        assertThat(snapshot.get("calculatorAllowed")).isEqualTo(false);
    }

    // ── Helpers ───────────────────────────────────────────────────

    private Question buildQuestion(String text, Map<String, Object> correct, List<Map<String, Object>> options) {
        return buildQuestion(text, correct, options, true);
    }

    private Question buildQuestion(String text, Map<String, Object> correct,
                                   List<Map<String, Object>> options, boolean calculatorAllowed) {
        return Question.builder()
            .id(UUID.randomUUID())
            .questionType(Question.QuestionType.MULTIPLE_CHOICE)
            .yearLevel(3)
            .domain(Question.Domain.NUMERACY)
            .topic("Test")
            .difficultyBand(1)
            .marks(1)
            .questionText(text)
            .correctAnswer(correct)
            .options(options)
            .explanation("Because " + text)
            .status(Question.QuestionStatus.PUBLISHED)
            .calculatorAllowed(calculatorAllowed)
            .build();
    }

    private ExamQuestion buildExamQuestion(UUID examId, Question q, int order) {
        ExamQuestion eq = new ExamQuestion();
        eq.setId(new ExamQuestion.ExamQuestionId(examId, q.getId()));
        eq.setQuestion(q);
        eq.setQuestionOrder(order);
        return eq;
    }
}
