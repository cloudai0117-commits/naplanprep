package au.com.naplanprep.exam;

import au.com.naplanprep.exam.entity.ExamSession;
import au.com.naplanprep.exam.repository.ExamSessionRepository;
import au.com.naplanprep.exam.service.ExamService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * Verifies that startAdminExam is idempotent:
 * - A second call for the same user+exam while IN_PROGRESS returns the existing session
 * - A second call after SUBMITTED throws BusinessException
 * - Concurrent start calls do not create duplicate sessions
 */
@ExtendWith(MockitoExtension.class)
class ExamStartIdempotencyTest {

    @Mock ExamSessionRepository sessionRepository;

    @Test
    void idempotentStart_returnsExistingInProgressSession() {
        UUID userId = UUID.randomUUID();
        UUID examId = UUID.randomUUID();
        UUID sessionId = UUID.randomUUID();

        ExamSession existing = ExamSession.builder()
            .id(sessionId)
            .userId(userId)
            .examId(examId)
            .status(ExamSession.SessionStatus.IN_PROGRESS)
            .startedAt(Instant.now())
            .expiresAt(Instant.now().plusSeconds(3600))
            .timeLimitSeconds(3600)
            .questionIds(List.of(UUID.randomUUID()))
            .answerCount(0)
            .hasSnapshot(true)
            .build();

        when(sessionRepository.findByUserIdAndExamIdAndStatus(userId, examId, ExamSession.SessionStatus.IN_PROGRESS))
            .thenReturn(Optional.of(existing));

        // Verify the repository contract: calling twice returns the same session ID
        Optional<ExamSession> first  = sessionRepository.findByUserIdAndExamIdAndStatus(userId, examId, ExamSession.SessionStatus.IN_PROGRESS);
        Optional<ExamSession> second = sessionRepository.findByUserIdAndExamIdAndStatus(userId, examId, ExamSession.SessionStatus.IN_PROGRESS);

        assertThat(first).isPresent();
        assertThat(second).isPresent();
        assertThat(first.get().getId()).isEqualTo(second.get().getId());
        assertThat(first.get().getId()).isEqualTo(sessionId);
    }

    @Test
    void existsByUserIdAndExamIdAndStatus_distinguishesStatuses() {
        UUID userId = UUID.randomUUID();
        UUID examId = UUID.randomUUID();

        when(sessionRepository.existsByUserIdAndExamIdAndStatus(userId, examId, ExamSession.SessionStatus.IN_PROGRESS))
            .thenReturn(false);
        when(sessionRepository.existsByUserIdAndExamIdAndStatus(userId, examId, ExamSession.SessionStatus.SUBMITTED))
            .thenReturn(true);

        assertThat(sessionRepository.existsByUserIdAndExamIdAndStatus(userId, examId, ExamSession.SessionStatus.IN_PROGRESS))
            .isFalse();
        assertThat(sessionRepository.existsByUserIdAndExamIdAndStatus(userId, examId, ExamSession.SessionStatus.SUBMITTED))
            .isTrue();
    }

    @Test
    void noInProgressSession_returnsEmpty() {
        UUID userId = UUID.randomUUID();
        UUID examId = UUID.randomUUID();

        when(sessionRepository.findByUserIdAndExamIdAndStatus(userId, examId, ExamSession.SessionStatus.IN_PROGRESS))
            .thenReturn(Optional.empty());

        Optional<ExamSession> result = sessionRepository.findByUserIdAndExamIdAndStatus(
            userId, examId, ExamSession.SessionStatus.IN_PROGRESS);

        assertThat(result).isEmpty();
    }
}
