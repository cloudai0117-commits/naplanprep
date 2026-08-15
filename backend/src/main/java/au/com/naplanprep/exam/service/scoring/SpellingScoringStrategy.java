package au.com.naplanprep.exam.service.scoring;

import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * Scores Spelling domain questions where the student types the word they heard in an audio clip.
 * Comparison is case-insensitive and strips leading/trailing whitespace only.
 * Internal spaces are preserved to correctly reject e.g. "every day" vs "everyday".
 */
@Component
public class SpellingScoringStrategy implements ScoringStrategy {

    @Override
    public Boolean score(Map<String, Object> studentAnswer, Map<String, Object> correctAnswer, int marks) {
        Object given = studentAnswer.get("value");
        Object expected = correctAnswer.get("value");
        if (given == null || expected == null) {
            return false;
        }
        return given.toString().trim().equalsIgnoreCase(expected.toString().trim());
    }
}
