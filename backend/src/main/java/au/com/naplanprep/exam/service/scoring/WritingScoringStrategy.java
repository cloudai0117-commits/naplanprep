package au.com.naplanprep.exam.service.scoring;

import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * Extended writing cannot be auto-marked against a model answer.
 * Returns null to signal PENDING_REVIEW — the session will not be counted as fully scored
 * until a human reviewer assigns marks via the admin marking interface.
 */
@Component
public class WritingScoringStrategy implements ScoringStrategy {

    @Override
    public Boolean score(Map<String, Object> studentAnswer, Map<String, Object> correctAnswer, int marks) {
        return null;
    }
}
