package au.com.naplanprep.exam.service.scoring;

import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.Objects;

@Component
public class MultipleChoiceScoringStrategy implements ScoringStrategy {

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
