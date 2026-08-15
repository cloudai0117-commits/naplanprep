package au.com.naplanprep.exam.service.scoring;

import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class ShortAnswerScoringStrategy implements ScoringStrategy {

    @Override
    public Boolean score(Map<String, Object> studentAnswer, Map<String, Object> correctAnswer, int marks) {
        Object given = studentAnswer.get("value");
        Object expected = correctAnswer.get("value");
        if (given == null || expected == null) {
            return false;
        }
        // Normalise: trim whitespace and compare case-insensitively.
        // Punctuation is preserved — content teams should specify the exact expected answer.
        return normalise(given.toString()).equals(normalise(expected.toString()));
    }

    private String normalise(String s) {
        return s.trim().toLowerCase().replaceAll("\\s+", " ");
    }
}
