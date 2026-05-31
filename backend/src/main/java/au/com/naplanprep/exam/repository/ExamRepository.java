package au.com.naplanprep.exam.repository;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.Exam;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public interface ExamRepository extends JpaRepository<Exam, UUID> {

    @Query("SELECT e FROM Exam e WHERE " +
           "(:status IS NULL OR e.status = :status) AND " +
           "(:yearLevel IS NULL OR e.yearLevel = :yearLevel) AND " +
           "(:domain IS NULL OR e.domain = :domain)")
    Page<Exam> findWithFilters(
        @Param("status") Exam.ExamStatus status,
        @Param("yearLevel") Integer yearLevel,
        @Param("domain") Question.Domain domain,
        Pageable pageable
    );

    @Query("SELECT e FROM Exam e WHERE " +
           "e.status = 'PUBLISHED' AND " +
           "e.packageTier IN :tiers AND " +
           "(e.availableFrom IS NULL OR e.availableFrom <= :now) AND " +
           "(e.availableUntil IS NULL OR e.availableUntil >= :now)")
    List<Exam> findAvailable(
        @Param("tiers") List<Exam.PackageTier> tiers,
        @Param("now") Instant now
    );

    /** All published exams visible to the student's tier (for availability display). */
    @Query("SELECT e FROM Exam e WHERE e.status = 'PUBLISHED' AND e.packageTier IN :tiers")
    List<Exam> findAllPublishedForTiers(@Param("tiers") List<Exam.PackageTier> tiers);

    /** All published exams regardless of tier — used for dashboard availability display including locked exams. */
    @Query("SELECT e FROM Exam e WHERE e.status = 'PUBLISHED' ORDER BY e.packageTier ASC, e.yearLevel ASC")
    List<Exam> findAllPublished();

    @Query("SELECT COUNT(es) FROM ExamSession es WHERE es.examId = :examId AND es.status = 'SUBMITTED'")
    long countAttemptsByExamId(@Param("examId") UUID examId);
}
