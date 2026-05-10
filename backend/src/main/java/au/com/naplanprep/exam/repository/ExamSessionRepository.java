package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.ExamSession;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public interface ExamSessionRepository extends JpaRepository<ExamSession, UUID> {
    Page<ExamSession> findByUserIdOrderByCreatedAtDesc(UUID userId, Pageable pageable);
    List<ExamSession> findByStatusAndExpiresAtBefore(ExamSession.SessionStatus status, Instant time);
    long countByUserId(UUID userId);
}
