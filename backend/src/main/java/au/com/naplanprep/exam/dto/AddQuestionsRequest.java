package au.com.naplanprep.exam.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.util.List;
import java.util.UUID;

public record AddQuestionsRequest(
    @NotEmpty List<QuestionOrderItem> questions
) {
    public record QuestionOrderItem(
        @NotNull UUID questionId,
        @NotNull Integer order
    ) {}
}
