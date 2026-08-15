package au.com.naplanprep.exam.service.scoring;

import au.com.naplanprep.content.entity.Question.QuestionType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ScoringStrategyFactory {

    private final MultipleChoiceScoringStrategy multipleChoice;
    private final MultiSelectScoringStrategy multiSelect;
    private final ShortAnswerScoringStrategy shortAnswer;
    private final SpellingScoringStrategy spelling;
    private final WritingScoringStrategy writing;

    public ScoringStrategy forType(QuestionType type) {
        return switch (type) {
            case MULTIPLE_CHOICE   -> multipleChoice;
            case MULTI_SELECT      -> multiSelect;
            case SHORT_ANSWER,
                 FILL_BLANK        -> shortAnswer;
            case EXTENDED_WRITING  -> writing;
            // AUDIO_RESPONSE is retired; kept here so existing sessions scored
            // before V379 migration still grade without throwing.
            case AUDIO_RESPONSE    -> spelling;
            // Structured types (REORDER, MATCHING, DRAG_DROP, IMAGE_INTERACTION):
            // fall back to short-answer comparison until dedicated strategies are added.
            default                -> shortAnswer;
        };
    }
}
