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

    // ── Y9 Numeracy path tests (actual DB thresholds from V295) ──────────────────
    // Valid paths: A→B→C, A→B→E, A→D→C, A→D→F, A→C_EARLY→B_LATE
    // Thresholds: A: SCORE_BELOW 0.35 (C_EARLY), SCORE_ABOVE 0.65 (D), ALWAYS (B)
    //             B: SCORE_ABOVE 0.70 (E), ALWAYS (C)
    //             D: SCORE_ABOVE 0.70 (F), ALWAYS (C)
    //             C_EARLY: ALWAYS (B_LATE)
    //             C, E, F, B_LATE: no transitions → empty → pathComplete

    @Test
    void y9Num_fromA_lowScore_routesToC_EARLY() {
        UUID testletA      = UUID.fromString("f8044b83-592b-5fc9-9135-13fa2eef6fcb");
        UUID testletC_EARLY = UUID.fromString("55d43880-2ba2-5c60-8c40-2f78b4c6a490");
        UUID testletD      = UUID.fromString("026c3f65-6c73-523c-a543-2c4fd71dc62b");
        UUID testletB      = UUID.fromString("592636f1-6ee7-56d9-952a-8ffd673ca372");

        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(testletA))
            .thenReturn(List.of(
                transition(testlet(testletC_EARLY), TestletTransition.ConditionType.SCORE_BELOW, Map.of("threshold", 0.35), 30),
                transition(testlet(testletD),       TestletTransition.ConditionType.SCORE_ABOVE, Map.of("threshold", 0.65), 20),
                transition(testlet(testletB),       TestletTransition.ConditionType.ALWAYS, null, 0)
            ));

        // score < 0.35 → C_EARLY
        assertThat(engine.resolveNext(testletA, 0.00)).contains(testletC_EARLY);
        assertThat(engine.resolveNext(testletA, 0.20)).contains(testletC_EARLY);
        assertThat(engine.resolveNext(testletA, 0.34)).contains(testletC_EARLY);
        // boundary: 0.35 is NOT below 0.35, so falls through
        assertThat(engine.resolveNext(testletA, 0.35)).contains(testletB);
    }

    @Test
    void y9Num_fromA_midScore_routesToB() {
        UUID testletA       = UUID.fromString("f8044b83-592b-5fc9-9135-13fa2eef6fcb");
        UUID testletC_EARLY = UUID.fromString("55d43880-2ba2-5c60-8c40-2f78b4c6a490");
        UUID testletD       = UUID.fromString("026c3f65-6c73-523c-a543-2c4fd71dc62b");
        UUID testletB       = UUID.fromString("592636f1-6ee7-56d9-952a-8ffd673ca372");

        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(testletA))
            .thenReturn(List.of(
                transition(testlet(testletC_EARLY), TestletTransition.ConditionType.SCORE_BELOW, Map.of("threshold", 0.35), 30),
                transition(testlet(testletD),       TestletTransition.ConditionType.SCORE_ABOVE, Map.of("threshold", 0.65), 20),
                transition(testlet(testletB),       TestletTransition.ConditionType.ALWAYS, null, 0)
            ));

        // 0.35 ≤ score ≤ 0.65 → B
        assertThat(engine.resolveNext(testletA, 0.35)).contains(testletB);
        assertThat(engine.resolveNext(testletA, 0.50)).contains(testletB);
        assertThat(engine.resolveNext(testletA, 0.65)).contains(testletB);
        // boundary: 0.65 is NOT above 0.65
        assertThat(engine.resolveNext(testletA, 0.651)).contains(testletD);
    }

    @Test
    void y9Num_fromA_highScore_routesToD() {
        UUID testletA       = UUID.fromString("f8044b83-592b-5fc9-9135-13fa2eef6fcb");
        UUID testletC_EARLY = UUID.fromString("55d43880-2ba2-5c60-8c40-2f78b4c6a490");
        UUID testletD       = UUID.fromString("026c3f65-6c73-523c-a543-2c4fd71dc62b");
        UUID testletB       = UUID.fromString("592636f1-6ee7-56d9-952a-8ffd673ca372");

        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(testletA))
            .thenReturn(List.of(
                transition(testlet(testletC_EARLY), TestletTransition.ConditionType.SCORE_BELOW, Map.of("threshold", 0.35), 30),
                transition(testlet(testletD),       TestletTransition.ConditionType.SCORE_ABOVE, Map.of("threshold", 0.65), 20),
                transition(testlet(testletB),       TestletTransition.ConditionType.ALWAYS, null, 0)
            ));

        // score > 0.65 → D
        assertThat(engine.resolveNext(testletA, 0.70)).contains(testletD);
        assertThat(engine.resolveNext(testletA, 0.80)).contains(testletD);
        assertThat(engine.resolveNext(testletA, 1.00)).contains(testletD);
    }

    @Test
    void y9Num_fromB_routesToE_or_C() {
        UUID testletB = UUID.fromString("592636f1-6ee7-56d9-952a-8ffd673ca372");
        UUID testletE = UUID.fromString("eb908d15-1c34-5619-adec-1455d9d6e2a0");
        UUID testletC = UUID.fromString("8b998744-f963-5d7d-b911-e616a6f07d6a");

        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(testletB))
            .thenReturn(List.of(
                transition(testlet(testletE), TestletTransition.ConditionType.SCORE_ABOVE, Map.of("threshold", 0.7), 10),
                transition(testlet(testletC), TestletTransition.ConditionType.ALWAYS, null, 0)
            ));

        // path A→B→E
        assertThat(engine.resolveNext(testletB, 0.71)).contains(testletE);
        assertThat(engine.resolveNext(testletB, 1.00)).contains(testletE);
        // path A→B→C
        assertThat(engine.resolveNext(testletB, 0.70)).contains(testletC);
        assertThat(engine.resolveNext(testletB, 0.50)).contains(testletC);
        assertThat(engine.resolveNext(testletB, 0.00)).contains(testletC);
    }

    @Test
    void y9Num_fromD_routesToF_or_C() {
        UUID testletD = UUID.fromString("026c3f65-6c73-523c-a543-2c4fd71dc62b");
        UUID testletF = UUID.fromString("854e6d58-3adc-5de7-8c63-0c2bc6c8b3db");
        UUID testletC = UUID.fromString("8b998744-f963-5d7d-b911-e616a6f07d6a");

        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(testletD))
            .thenReturn(List.of(
                transition(testlet(testletF), TestletTransition.ConditionType.SCORE_ABOVE, Map.of("threshold", 0.7), 10),
                transition(testlet(testletC), TestletTransition.ConditionType.ALWAYS, null, 0)
            ));

        // path A→D→F
        assertThat(engine.resolveNext(testletD, 0.71)).contains(testletF);
        assertThat(engine.resolveNext(testletD, 1.00)).contains(testletF);
        // path A→D→C
        assertThat(engine.resolveNext(testletD, 0.70)).contains(testletC);
        assertThat(engine.resolveNext(testletD, 0.50)).contains(testletC);
    }

    @Test
    void y9Num_fromC_EARLY_alwaysRoutesToB_LATE() {
        UUID testletC_EARLY = UUID.fromString("55d43880-2ba2-5c60-8c40-2f78b4c6a490");
        UUID testletB_LATE  = UUID.fromString("65467866-6bad-576f-9345-38d4d27e905d");

        when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(testletC_EARLY))
            .thenReturn(List.of(
                transition(testlet(testletB_LATE), TestletTransition.ConditionType.ALWAYS, null, 0)
            ));

        // path A→C_EARLY→B_LATE regardless of score
        assertThat(engine.resolveNext(testletC_EARLY, 0.0)).contains(testletB_LATE);
        assertThat(engine.resolveNext(testletC_EARLY, 0.5)).contains(testletB_LATE);
        assertThat(engine.resolveNext(testletC_EARLY, 1.0)).contains(testletB_LATE);
    }

    @Test
    void y9Num_terminalTestlets_returnEmpty() {
        // C, E, F, B_LATE have no outgoing transitions → path ends → auto-submit
        UUID testletC      = UUID.fromString("8b998744-f963-5d7d-b911-e616a6f07d6a");
        UUID testletE      = UUID.fromString("eb908d15-1c34-5619-adec-1455d9d6e2a0");
        UUID testletF      = UUID.fromString("854e6d58-3adc-5de7-8c63-0c2bc6c8b3db");
        UUID testletB_LATE = UUID.fromString("65467866-6bad-576f-9345-38d4d27e905d");

        for (UUID terminal : List.of(testletC, testletE, testletF, testletB_LATE)) {
            when(transitionRepository.findBySourceTestletIdOrderByPriorityDesc(terminal))
                .thenReturn(List.of());
            assertThat(engine.resolveNext(terminal, 0.5))
                .as("Terminal testlet %s must return empty → pathComplete=true", terminal)
                .isEmpty();
        }
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
