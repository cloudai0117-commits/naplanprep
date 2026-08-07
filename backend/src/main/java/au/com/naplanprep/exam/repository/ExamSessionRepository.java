package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.ExamSession;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ExamSessionRepository extends JpaRepository<ExamSession, UUID> {

    Page<ExamSession> findByUserIdOrderByCreatedAtDesc(UUID userId, Pageable pageable);

    List<ExamSession> findByStatusAndExpiresAtBefore(ExamSession.SessionStatus status, Instant time);

    long countByUserId(UUID userId);

    Page<ExamSession> findByExamIdAndStatus(UUID examId, ExamSession.SessionStatus status, Pageable pageable);

    /** Finds a student's completed session for a specific admin exam. */
    Optional<ExamSession> findByUserIdAndExamIdAndStatus(
        UUID userId, UUID examId, ExamSession.SessionStatus status);

    /** True if the student has already submitted this admin exam. */
    boolean existsByUserIdAndExamIdAndStatus(
        UUID userId, UUID examId, ExamSession.SessionStatus status);

    List<ExamSession> findByUserId(UUID userId);

    @Query("SELECT es FROM ExamSession es WHERE es.userId = :userId AND es.status IN :statuses ORDER BY es.createdAt DESC")
    Page<ExamSession> findByUserIdAndStatusIn(
        @Param("userId") UUID userId,
        @Param("statuses") List<ExamSession.SessionStatus> statuses,
        Pageable pageable);

    /** Batch lookup: all SUBMITTED sessions for a user across multiple exams — one query instead of N. */
    @Query("SELECT es FROM ExamSession es WHERE es.userId = :userId AND es.examId IN :examIds AND es.status = 'SUBMITTED'")
    List<ExamSession> findSubmittedByUserIdAndExamIds(
        @Param("userId") UUID userId,
        @Param("examIds") Collection<UUID> examIds);
}
