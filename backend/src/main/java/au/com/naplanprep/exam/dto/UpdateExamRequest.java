package au.com.naplanprep.exam.dto;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.ExamTag;
import jakarta.validation.constraints.*;

import java.time.Instant;

public record UpdateExamRequest(
    @NotBlank @Size(max = 200) String title,
    String description,
    @NotNull @Min(3) @Max(9) Integer yearLevel,
    @NotNull Question.Domain domain,
    @NotNull ExamTag tag,
    @NotNull @Min(60) Integer timeLimitSeconds,
    Instant availableFrom,
    Instant availableUntil
) {}
