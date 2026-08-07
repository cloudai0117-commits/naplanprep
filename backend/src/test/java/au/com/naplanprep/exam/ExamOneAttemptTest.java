package au.com.naplanprep.exam;

import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.exam.dto.QuestionSummary;
import au.com.naplanprep.exam.entity.Exam;
import au.com.naplanprep.exam.entity.ExamQuestion;
import au.com.naplanprep.exam.entity.ExamSession;
import au.com.naplanprep.exam.entity.PackageType;
import au.com.naplanprep.exam.repository.*;
import au.com.naplanprep.exam.service.ExamService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import au.com.naplanprep.common.exception.BusinessException;
import org.springframework.security.access.AccessDeniedException;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ExamOneAttemptTest {

    @Mock private ExamSessionRepository sessionRepository;
    @Mock private ExamAnswerRepository answerRepository;
    @Mock private ExamResultRepository resultRepository;
    @Mock private ExamRepository examRepository;
    @Mock private ExamQuestionRepository examQuestionRepository;
    @Mock private QuestionRepository questionRepository;
    @Mock private UserRepository userRepository;

    @InjectMocks private ExamService examService;

    private UUID examId;
    private UUID userId;
    private Exam publishedExam;

    @BeforeEach
    void setUp() {
        examId = UUID.randomUUID();
        userId = UUID.randomUUID();

        publishedExam = new Exam();
        publishedExam.setId(examId);
        publishedExam.setTitle("Year 5 Numeracy");
        publishedExam.setStatus(Exam.ExamStatus.PUBLISHED);
        publishedExam.setDomain(Question.Domain.NUMERACY);
        publishedExam.setYearLevel(5);
        publishedExam.setPackageType(PackageType.FREE);
        publishedExam.setTimeLimitSeconds(1800);
        publishedExam.setAvailableFrom(Instant.now().minusSeconds(86400));
        publishedExam.setAvailableUntil(Instant.now().plusSeconds(86400));
    }

    @Test
    void startAdminExam_whenAlreadySubmitted_throwsConflict() {
        when(examRepository.findById(examId)).thenReturn(Optional.of(publishedExam));
        when(userRepository.findById(userId)).thenReturn(Optional.empty()); // falls back to {FREE}
        when(sessionRepository.existsByUserIdAndExamIdAndStatus(
            userId, examId, ExamSession.SessionStatus.SUBMITTED)).thenReturn(true);

        BusinessException ex = assertThrows(BusinessException.class,
            () -> examService.startAdminExam(examId, userId));

        assertTrue(ex.getMessage().contains("already completed"));
        verify(sessionRepository, never()).save(any());
    }

    @Test
    void startAdminExam_firstAttempt_createsSession() {
        when(examRepository.findById(examId)).thenReturn(Optional.of(publishedExam));
        when(userRepository.findById(userId)).thenReturn(Optional.empty()); // falls back to {FREE}
        when(sessionRepository.existsByUserIdAndExamIdAndStatus(
            userId, examId, ExamSession.SessionStatus.SUBMITTED)).thenReturn(false);

        Question q = new Question();
        q.setId(UUID.randomUUID());
        q.setQuestionText("What is 2+2?");
        q.setQuestionType(Question.QuestionType.MULTIPLE_CHOICE);
        q.setDomain(Question.Domain.NUMERACY);
        q.setTopic("Arithmetic");
        q.setDifficultyBand(1);

        ExamQuestion eq = new ExamQuestion();
        eq.setId(new ExamQuestion.ExamQuestionId(examId, q.getId()));
        eq.setQuestion(q);
        eq.setQuestionOrder(1);
        when(examQuestionRepository.findByExamIdOrdered(examId)).thenReturn(List.of(eq));

        ExamSession savedSession = new ExamSession();
        savedSession.setId(UUID.randomUUID());
        savedSession.setUserId(userId);
        savedSession.setExamId(examId);
        savedSession.setStatus(ExamSession.SessionStatus.IN_PROGRESS);
        savedSession.setStartedAt(Instant.now());
        savedSession.setExpiresAt(Instant.now().plusSeconds(1800));
        savedSession.setTimeLimitSeconds(1800);
        savedSession.setQuestionIds(List.of(q.getId()));
        when(sessionRepository.save(any())).thenReturn(savedSession);

        var result = examService.startAdminExam(examId, userId);

        assertNotNull(result);
        assertEquals(examId, result.get("examId"));
        assertEquals("Year 5 Numeracy", result.get("examTitle"));
        List<QuestionSummary> questions = (List<QuestionSummary>) result.get("questions");
        assertEquals(1, questions.size());
        verify(sessionRepository).save(any());
    }

    @Test
    void startAdminExam_wrongTier_throwsForbidden() {
        publishedExam.setPackageType(PackageType.PREMIUM); // user has only FREE → access denied
        when(examRepository.findById(examId)).thenReturn(Optional.of(publishedExam));
        when(userRepository.findById(userId)).thenReturn(Optional.empty()); // falls back to {FREE}

        AccessDeniedException ex = assertThrows(AccessDeniedException.class,
            () -> examService.startAdminExam(examId, userId));

        assertTrue(ex.getMessage().contains("Upgrade"));
    }

    @Test
    void startAdminExam_notPublished_throwsBusinessException() {
        publishedExam.setStatus(Exam.ExamStatus.DRAFT);
        when(examRepository.findById(examId)).thenReturn(Optional.of(publishedExam));

        assertThrows(au.com.naplanprep.common.exception.BusinessException.class,
            () -> examService.startAdminExam(examId, userId));
    }
}
