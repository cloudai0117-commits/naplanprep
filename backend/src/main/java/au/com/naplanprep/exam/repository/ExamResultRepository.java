package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.ExamResult;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ExamResultRepository extends JpaRepository<ExamResult, UUID> {
    Optional<ExamResult> findBySessionId(UUID sessionId);
    Page<ExamResult> findByUserIdOrderByCalculatedAtDesc(UUID userId, Pageable pageable);
    List<ExamResult> findByUserIdOrderByCalculatedAtDesc(UUID userId);

    @Query("SELECT AVG(r.scorePercentage) FROM ExamResult r WHERE r.userId = :userId")
    Double findAvgScoreByUserId(@Param("userId") UUID userId);

    @Query("SELECT COUNT(r) FROM ExamResult r WHERE r.userId = :userId")
    long countByUserId(@Param("userId") UUID userId);

}
