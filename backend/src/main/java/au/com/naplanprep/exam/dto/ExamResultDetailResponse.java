package au.com.naplanprep.exam.dto;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public record ExamResultDetailResponse(
    UUID sessionId,
    UUID examId,
    String examTitle,
    Instant startedAt,
    Instant submittedAt,
    Long timeTakenSeconds,
    int totalQuestions,
    int correctAnswers,
    double percentage,
    int band,
    Map<String, TopicScore> domainScores,
    List<QuestionReview> questions
) {
    public record TopicScore(int correct, int total, double percentage) {}

    public record QuestionReview(
        int questionOrder,
        UUID questionId,
        String questionText,
        String stimulusText,
        List<Map<String, Object>> options,
        String studentAnswer,
        String correctAnswer,
        boolean correct,
        String explanation,
        Integer timeTakenSeconds
    ) {}
}
