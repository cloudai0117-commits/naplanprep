package au.com.naplanprep.exam;

import au.com.naplanprep.exam.service.scoring.*;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Unit tests for every ScoringStrategy implementation.
 * No Spring context needed — pure unit tests.
 */
class ScoringStrategyTest {

    final MultipleChoiceScoringStrategy mc = new MultipleChoiceScoringStrategy();
    final MultiSelectScoringStrategy    ms = new MultiSelectScoringStrategy();
    final ShortAnswerScoringStrategy    sa = new ShortAnswerScoringStrategy();
    final SpellingScoringStrategy       sp = new SpellingScoringStrategy();
    final WritingScoringStrategy        wr = new WritingScoringStrategy();

    // ── Multiple Choice ───────────────────────────────────────────

    @Test void mc_correctAnswer() {
        assertThat(mc.score(Map.of("value", "B"), Map.of("value", "B"), 1)).isTrue();
    }

    @Test void mc_caseInsensitive() {
        assertThat(mc.score(Map.of("value", "b"), Map.of("value", "B"), 1)).isTrue();
    }

    @Test void mc_wrongAnswer() {
        assertThat(mc.score(Map.of("value", "A"), Map.of("value", "B"), 1)).isFalse();
    }

    @Test void mc_nullGiven() {
        assertThat(mc.score(Map.of(), Map.of("value", "B"), 1)).isFalse();
    }

    @Test void mc_trailingWhitespace() {
        assertThat(mc.score(Map.of("value", " C "), Map.of("value", "C"), 1)).isTrue();
    }

    // ── Multi-Select ──────────────────────────────────────────────

    @Test void ms_exactMatch() {
        assertThat(ms.score(
            Map.of("values", List.of("A", "C")),
            Map.of("values", List.of("C", "A")), 1)).isTrue();
    }

    @Test void ms_missingOneOption() {
        assertThat(ms.score(
            Map.of("values", List.of("A")),
            Map.of("values", List.of("A", "C")), 1)).isFalse();
    }

    @Test void ms_extraOption() {
        assertThat(ms.score(
            Map.of("values", List.of("A", "B", "C")),
            Map.of("values", List.of("A", "C")), 1)).isFalse();
    }

    @Test void ms_caseInsensitive() {
        assertThat(ms.score(
            Map.of("values", List.of("a", "c")),
            Map.of("values", List.of("A", "C")), 1)).isTrue();
    }

    // ── Short Answer ──────────────────────────────────────────────

    @Test void sa_exactMatch() {
        assertThat(sa.score(Map.of("value", "Paris"), Map.of("value", "Paris"), 1)).isTrue();
    }

    @Test void sa_caseInsensitive() {
        assertThat(sa.score(Map.of("value", "paris"), Map.of("value", "Paris"), 1)).isTrue();
    }

    @Test void sa_collapseInternalSpaces() {
        assertThat(sa.score(Map.of("value", "the  cat"), Map.of("value", "the cat"), 1)).isTrue();
    }

    @Test void sa_wrongAnswer() {
        assertThat(sa.score(Map.of("value", "London"), Map.of("value", "Paris"), 1)).isFalse();
    }

    // ── Spelling ──────────────────────────────────────────────────

    @Test void sp_exactMatch() {
        assertThat(sp.score(Map.of("value", "necessary"), Map.of("value", "necessary"), 1)).isTrue();
    }

    @Test void sp_caseInsensitive() {
        assertThat(sp.score(Map.of("value", "Necessary"), Map.of("value", "necessary"), 1)).isTrue();
    }

    @Test void sp_spacingPreserved_everyday_vs_every_day() {
        // "everyday" (adjective) vs "every day" (phrase) — spelling must be exact
        assertThat(sp.score(Map.of("value", "every day"), Map.of("value", "everyday"), 1)).isFalse();
    }

    @Test void sp_misspelled() {
        assertThat(sp.score(Map.of("value", "neccessary"), Map.of("value", "necessary"), 1)).isFalse();
    }

    // ── Writing (EXTENDED_WRITING) ────────────────────────────────

    @Test void wr_alwaysReturnsNull() {
        assertThat(wr.score(Map.of("text", "My essay..."), Map.of(), 50)).isNull();
    }

    @Test void wr_nullAnswerAlsoReturnsNull() {
        assertThat(wr.score(Map.of(), Map.of(), 50)).isNull();
    }
}
