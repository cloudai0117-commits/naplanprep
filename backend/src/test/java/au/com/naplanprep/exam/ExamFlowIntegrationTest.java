package au.com.naplanprep.exam;

import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.exam.dto.ExamResultDetailResponse;
import au.com.naplanprep.exam.entity.Exam;
import au.com.naplanprep.exam.entity.ExamQuestion;
import au.com.naplanprep.exam.entity.PackageType;
import au.com.naplanprep.exam.entity.ExamSession;
import au.com.naplanprep.exam.repository.*;
import au.com.naplanprep.exam.service.ExamService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import au.com.naplanprep.common.exception.BusinessException;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Testcontainers
@ActiveProfiles("test")
@Transactional
class ExamFlowIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @Autowired private ExamService examService;
    @Autowired private ExamRepository examRepository;
    @Autowired private ExamQuestionRepository examQuestionRepository;
    @Autowired private ExamSessionRepository sessionRepository;
    @Autowired private ExamAnswerRepository answerRepository;
    @Autowired private QuestionRepository questionRepository;
    @Autowired private UserRepository userRepository;

    private UUID userId;
    private Exam exam;
    private Question question;

    @BeforeEach
    void setUp() {
        User user = new User();
        user.setEmail("test-" + UUID.randomUUID() + "@example.com");
        user.setPassword("hashed-password");
        user.setRole(User.Role.STUDENT);
        user.setStatus(User.UserStatus.ACTIVE);
        user = userRepository.save(user);
        userId = user.getId();

        question = new Question();
        question.setQuestionText("What is 3 × 4?");
        question.setQuestionType(Question.QuestionType.MULTIPLE_CHOICE);
        question.setDomain(Question.Domain.NUMERACY);
        question.setTopic("Multiplication");
        question.setYearLevel(5);
        question.setDifficultyBand(1);
        question.setStatus(Question.QuestionStatus.PUBLISHED);
        question.setOptions(Map.of("options", java.util.List.of("10", "11", "12", "13")));
        question.setCorrectAnswer(Map.of("value", "12"));
        question = questionRepository.save(question);

        exam = new Exam();
        exam.setTitle("Integration Test Exam");
        exam.setYearLevel(5);
        exam.setDomain(Question.Domain.NUMERACY);
        exam.setPackageType(PackageType.FREE);
        exam.setTimeLimitSeconds(1800);
        exam.setStatus(Exam.ExamStatus.PUBLISHED);
        exam.setAvailableFrom(Instant.now().minusSeconds(3600));
        exam.setAvailableUntil(Instant.now().plusSeconds(3600));
        exam = examRepository.save(exam);

        ExamQuestion eq = new ExamQuestion();
        eq.setId(new ExamQuestion.ExamQuestionId(exam.getId(), question.getId()));
        eq.setExam(exam);
        eq.setQuestion(question);
        eq.setQuestionOrder(1);
        examQuestionRepository.save(eq);
    }

    @Test
    void fullExamFlow_startAnswerSubmit_producesDetailedResult() {
        Map<String, Object> startResult = examService.startAdminExam(exam.getId(), userId);

        assertNotNull(startResult);
        assertEquals(exam.getId(), startResult.get("examId"));
        UUID sessionId = (UUID) startResult.get("sessionId");
        assertNotNull(sessionId);

        ExamSession session = sessionRepository.findById(sessionId).orElseThrow();
        assertEquals(ExamSession.SessionStatus.IN_PROGRESS, session.getStatus());
        assertEquals(exam.getId(), session.getExamId());

        examService.submitAnswer(sessionId, userId, question.getId(), Map.of("value", "12"), false, null);

        ExamResultDetailResponse result = examService.submitExam(sessionId, userId);

        assertNotNull(result);
        assertEquals(sessionId, result.sessionId());
        assertEquals(exam.getId(), result.examId());
        assertEquals(1, result.totalQuestions());
        assertEquals(1, result.correctAnswers());
        assertEquals(100.0, result.percentage(), 0.01);
        assertFalse(result.questions().isEmpty());
        assertTrue(result.questions().get(0).correct());
    }

    @Test
    void secondAttempt_afterSubmit_throwsConflict() {
        examService.startAdminExam(exam.getId(), userId);

        ExamSession session = sessionRepository.findByUserIdAndExamIdAndStatus(
            userId, exam.getId(), ExamSession.SessionStatus.IN_PROGRESS).orElseThrow();
        examService.submitExam(session.getId(), userId);

        BusinessException ex = assertThrows(BusinessException.class,
            () -> examService.startAdminExam(exam.getId(), userId));

        assertTrue(ex.getMessage().contains("already completed"));
    }

    @Test
    void getSessionQuestions_returnsOrderedList() {
        Map<String, Object> startResult = examService.startAdminExam(exam.getId(), userId);
        UUID sessionId = (UUID) startResult.get("sessionId");

        var questions = examService.getSessionQuestions(sessionId, userId);

        assertEquals(1, questions.size());
        assertEquals(question.getId(), questions.get(0).id());
        assertEquals(1, questions.get(0).questionOrder());
    }
}
