package au.com.naplanprep.exam.service.scoring;

import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class MultiSelectScoringStrategy implements ScoringStrategy {

    @Override
    public Boolean score(Map<String, Object> studentAnswer, Map<String, Object> correctAnswer, int marks) {
        Set<String> given = normalise(studentAnswer.get("values"));
        Set<String> expected = normalise(correctAnswer.get("values"));
        if (given == null || expected == null) {
            return false;
        }
        return given.equals(expected);
    }

    @SuppressWarnings("unchecked")
    private Set<String> normalise(Object raw) {
        if (!(raw instanceof Collection<?> col)) {
            return null;
        }
        return col.stream()
                .map(v -> v.toString().trim().toUpperCase())
                .collect(Collectors.toSet());
    }
}
