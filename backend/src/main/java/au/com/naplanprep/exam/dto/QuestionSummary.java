package au.com.naplanprep.exam.dto;

import au.com.naplanprep.content.entity.Question;

import java.util.Map;
import java.util.UUID;

public record QuestionSummary(
    UUID id,
    int questionOrder,
    Question.QuestionType questionType,
    String questionText,
    String stimulusText,
    Map<String, Object> options,
    String topic,
    Integer difficultyBand
) {}
