package au.com.naplanprep.exam;

import au.com.naplanprep.exam.entity.Testlet;
import au.com.naplanprep.exam.entity.TestletTransition;
import au.com.naplanprep.exam.repository.TestletTransitionRepository;
import au.com.naplanprep.exam.service.BranchingEngine;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

/**
 * Tests the BranchingEngine condition evaluation for all three condition types.
 */
@ExtendWith(MockitoExtension.class)
class BranchingEngineTest {

    @Mock TestletTransitionRepository transitionRepository;

    @InjectMocks BranchingEngine engine;

    UUID sourceId   = UUID.randomUUID();
    UUID easyTarget = UUID.randomUUID();
    UUID hardTarget = UUID.randomUUID();
    UUID alwaysTarget = UUID.randomUUID();

    Testlet easyTestlet;
    Testlet hardTestlet;
    Testlet alwaysTestlet;

    @BeforeEach
    void setUp() {
        easyTestlet   = testlet(easyTarget);
        hardTestlet   = testlet(hardTarget);
        alwaysTestlet = testlet(alwaysTarget);
    }

    @Test
    void alwaysCondition_matchesRegardlessOfScore() {
        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(sourceId))
            .thenReturn(List.of(transition(alwaysTestlet, TestletTransition.ConditionType.ALWAYS, null, 1)));

        assertThat(engine.resolveNext(sourceId, 0.0)).contains(alwaysTarget);
        assertThat(engine.resolveNext(sourceId, 0.5)).contains(alwaysTarget);
        assertThat(engine.resolveNext(sourceId, 1.0)).contains(alwaysTarget);
    }

    @Test
    void scoreAbove_matchesWhenScoreExceedsThreshold() {
        TestletTransition above = transition(hardTestlet, TestletTransition.ConditionType.SCORE_ABOVE,
            Map.of("threshold", 0.6), 10);
        TestletTransition fallback = transition(easyTestlet, TestletTransition.ConditionType.ALWAYS, null, 1);

        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(sourceId))
            .thenReturn(List.of(above, fallback));

        // Score > 0.6 → hard path
        assertThat(engine.resolveNext(sourceId, 0.7)).contains(hardTarget);
        assertThat(engine.resolveNext(sourceId, 1.0)).contains(hardTarget);

        // Score == threshold → NOT above, falls through to ALWAYS
        assertThat(engine.resolveNext(sourceId, 0.6)).contains(easyTarget);

        // Score < threshold → falls through to ALWAYS (easy)
        assertThat(engine.resolveNext(sourceId, 0.3)).contains(easyTarget);
    }

    @Test
    void scoreBelow_matchesWhenScoreBelowThreshold() {
        TestletTransition below = transition(easyTestlet, TestletTransition.ConditionType.SCORE_BELOW,
            Map.of("threshold", 0.5), 10);
        TestletTransition fallback = transition(hardTestlet, TestletTransition.ConditionType.ALWAYS, null, 1);

        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(sourceId))
            .thenReturn(List.of(below, fallback));

        // Score < 0.5 → easy path
        assertThat(engine.resolveNext(sourceId, 0.3)).contains(easyTarget);

        // Score == threshold → NOT below, falls through to ALWAYS (hard)
        assertThat(engine.resolveNext(sourceId, 0.5)).contains(hardTarget);

        // Score > threshold → falls through to ALWAYS (hard)
        assertThat(engine.resolveNext(sourceId, 0.8)).contains(hardTarget);
    }

    @Test
    void noMatchingTransition_returnsEmpty() {
        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(sourceId))
            .thenReturn(List.of());

        assertThat(engine.resolveNext(sourceId, 0.5)).isEmpty();
    }

    @Test
    void priorityOrder_highestPriorityEvaluatedFirst() {
        // Both ALWAYS — should match the first (highest priority) one
        TestletTransition first  = transition(hardTestlet,   TestletTransition.ConditionType.ALWAYS, null, 20);
        TestletTransition second = transition(easyTestlet,   TestletTransition.ConditionType.ALWAYS, null, 10);

        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(sourceId))
            .thenReturn(List.of(first, second));

        // Repository returns in priority DESC order; engine picks first match
        assertThat(engine.resolveNext(sourceId, 0.5)).contains(hardTarget);
    }

    // ── Helpers ───────────────────────────────────────────────────

    private Testlet testlet(UUID id) {
        Testlet t = new Testlet();
        t.setId(id);
        return t;
    }

    private TestletTransition transition(Testlet target, TestletTransition.ConditionType type,
                                         Map<String, Object> condValue, int priority) {
        TestletTransition t = new TestletTransition();
        t.setId(UUID.randomUUID());
        t.setTargetTestlet(target);
        t.setConditionType(type);
        t.setConditionValue(condValue);
        t.setPriority(priority);
        return t;
    }
}
