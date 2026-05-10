package au.com.naplanprep.exam.dto;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.ExamSession;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record StartExamRequest(
    @NotNull(message = "Exam type is required")
    ExamSession.ExamType examType,

    @NotNull(message = "Year level is required")
    @Min(3) @Max(9)
    Integer yearLevel,

    Question.Domain domain,

    @Min(5) @Max(60)
    Integer questionCount
) {
    public int resolvedQuestionCount() {
        if (questionCount != null) return questionCount;
        return switch (examType) {
            case DIAGNOSTIC -> 10;
            case PRACTICE -> 20;
            case MOCK -> 40;
        };
    }
}
