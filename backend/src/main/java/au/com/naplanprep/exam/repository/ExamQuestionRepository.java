package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.ExamQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

public interface ExamQuestionRepository extends JpaRepository<ExamQuestion, ExamQuestion.ExamQuestionId> {

    @Query("SELECT eq FROM ExamQuestion eq JOIN FETCH eq.question WHERE eq.exam.id = :examId ORDER BY eq.questionOrder ASC")
    List<ExamQuestion> findByExamIdOrdered(@Param("examId") UUID examId);

    /** Alias used by ExamSnapshotService — same query, stable name for snapshot writes. */
    @Query("SELECT eq FROM ExamQuestion eq JOIN FETCH eq.question WHERE eq.exam.id = :examId ORDER BY eq.questionOrder ASC")
    List<ExamQuestion> findByExamIdOrderByQuestionOrder(@Param("examId") UUID examId);

    boolean existsByExam_IdAndQuestion_Id(UUID examId, UUID questionId);

    @Modifying
    @Query("DELETE FROM ExamQuestion eq WHERE eq.exam.id = :examId AND eq.question.id = :questionId")
    void deleteByExamIdAndQuestionId(@Param("examId") UUID examId, @Param("questionId") UUID questionId);

    /** Batch count: returns [examId, count] rows for all given exam IDs in one query. */
    @Query("SELECT eq.exam.id, COUNT(eq) FROM ExamQuestion eq WHERE eq.exam.id IN :examIds GROUP BY eq.exam.id")
    List<Object[]> countByExamIds(@Param("examIds") Collection<UUID> examIds);
}
