package au.com.naplanprep.content.dto;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.PackageType;
import jakarta.validation.constraints.*;

import java.util.Map;

public record QuestionRequest(
    @NotNull(message = "Question type is required")
    Question.QuestionType questionType,

    @NotNull(message = "Year level is required")
    @Min(3) @Max(9)
    Integer yearLevel,

    @NotNull(message = "Domain is required")
    Question.Domain domain,

    @NotBlank(message = "Topic is required")
    String topic,

    @NotNull(message = "Difficulty band is required")
    @Min(1) @Max(10)
    Integer difficultyBand,

    PackageType packageType,

    Question.Difficulty difficulty,

    String stimulusText,

    @NotBlank(message = "Question text is required")
    String questionText,

    Map<String, Object> options,

    @NotNull(message = "Correct answer is required")
    Map<String, Object> correctAnswer,

    String explanation
) {}
