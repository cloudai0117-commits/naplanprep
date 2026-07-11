package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.ExamAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ExamAnswerRepository extends JpaRepository<ExamAnswer, UUID> {
    List<ExamAnswer> findBySessionId(UUID sessionId);
    Optional<ExamAnswer> findBySessionIdAndQuestionId(UUID sessionId, UUID questionId);
    long countBySessionId(UUID sessionId);
    long countBySessionIdAndCorrect(UUID sessionId, boolean correct);

    /** Returns all distinct question IDs the user has ever answered, for question rotation. */
    @Query(value = "SELECT DISTINCT ea.question_id FROM exam_answers ea " +
        "JOIN exam_sessions es ON ea.session_id = es.id WHERE es.user_id = :userId",
        nativeQuery = true)
    List<UUID> findSeenQuestionIdsByUserId(@Param("userId") UUID userId);
}
