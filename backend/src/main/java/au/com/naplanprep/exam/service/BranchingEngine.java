package au.com.naplanprep.exam.service;

import au.com.naplanprep.exam.entity.TestletTransition;
import au.com.naplanprep.exam.repository.TestletTransitionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

/**
 * Evaluates outbound testlet transitions for a completed testlet.
 *
 * Transitions are evaluated in descending priority order. The first
 * condition that matches determines the next testlet. An ALWAYS transition
 * at the lowest priority acts as the default/fallback.
 *
 * Score semantics: scoreRatio is correctMarks / totalMarks for the testlet
 * (range 0.0–1.0). The threshold in conditionValue uses the same scale.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class BranchingEngine {

    private final TestletTransitionRepository transitionRepository;

    /**
     * @param sourceTestletId  ID of the testlet the student just completed
     * @param scoreRatio       ratio of marks scored in that testlet (0.0–1.0)
     * @return next testlet ID, or empty if the exam section/path ends here
     */
    public Optional<UUID> resolveNext(UUID sourceTestletId, double scoreRatio) {
        List<TestletTransition> transitions =
            transitionRepository.findBySourceTestletIdOrderByPriorityDesc(sourceTestletId);

        for (TestletTransition t : transitions) {
            if (matches(t, scoreRatio)) {
                log.debug("Branching: {} -> {} (condition={}, score={})",
                    sourceTestletId, t.getTargetTestlet().getId(), t.getConditionType(), scoreRatio);
                return Optional.of(t.getTargetTestlet().getId());
            }
        }
        log.debug("Branching: no matching transition from testlet {}, path ends", sourceTestletId);
        return Optional.empty();
    }

    private boolean matches(TestletTransition t, double scoreRatio) {
        return switch (t.getConditionType()) {
            case ALWAYS      -> true;
            case SCORE_ABOVE -> scoreRatio > threshold(t.getConditionValue());
            case SCORE_BELOW -> scoreRatio < threshold(t.getConditionValue());
        };
    }

    private double threshold(Map<String, Object> conditionValue) {
        if (conditionValue == null) {
            return 0.0;
        }
        Object v = conditionValue.get("threshold");
        if (v instanceof Number n) {
            return n.doubleValue();
        }
        return 0.0;
    }
}
