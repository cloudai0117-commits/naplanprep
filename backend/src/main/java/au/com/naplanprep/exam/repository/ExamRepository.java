package au.com.naplanprep.exam.repository;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.Exam;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

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

    /** All published exams — tag-based access control is applied in the service layer. */
    @Query("SELECT e FROM Exam e WHERE e.status = 'PUBLISHED' ORDER BY e.tag ASC, e.yearLevel ASC")
    List<Exam> findAllPublished();

    @Query("SELECT COUNT(es) FROM ExamSession es WHERE es.examId = :examId AND es.status = 'SUBMITTED'")
    long countAttemptsByExamId(@Param("examId") UUID examId);
}
