package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.ExamAnswer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ExamAnswerRepository extends JpaRepository<ExamAnswer, UUID> {
    List<ExamAnswer> findBySessionId(UUID sessionId);
    Optional<ExamAnswer> findBySessionIdAndQuestionId(UUID sessionId, UUID questionId);
    long countBySessionId(UUID sessionId);
    long countBySessionIdAndCorrect(UUID sessionId, boolean correct);
}
