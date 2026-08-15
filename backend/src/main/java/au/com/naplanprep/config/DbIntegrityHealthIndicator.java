package au.com.naplanprep.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Validates the canonical exam content invariants on every actuator health check.
 * Returns DOWN (HTTP 503) if any invariant fails — this causes Railway to mark
 * the deployment as failed when the CI smoke test polls /actuator/health.
 *
 * Invariants (frozen content set):
 *   PUBLISHED = 320  (80 per year × 4 years)
 *   Per year  = 80   (16 per domain × 5 domains)
 *   FREE      = 20, ADVANCED = 100, PREMIUM = 200
 *   Year/domain = 16 each (1 FREE + 5 ADV + 10 PREM)
 *   Published exams without questions = 0
 */
@Slf4j
@Component("dbIntegrity")
@RequiredArgsConstructor
public class DbIntegrityHealthIndicator implements HealthIndicator {

    private final JdbcTemplate jdbc;

    @Override
    public Health health() {
        Map<String, Object> details = new LinkedHashMap<>();
        boolean ok = true;

        try {
            // ── 1. Total published ────────────────────────────────────────────
            long totalPublished = count("SELECT COUNT(*) FROM exams WHERE status = 'PUBLISHED'");
            details.put("published_total", totalPublished);
            if (totalPublished != 320) {
                details.put("published_total_FAIL", "expected 320, got " + totalPublished);
                ok = false;
            }

            // ── 2. Per year ───────────────────────────────────────────────────
            for (int yr : new int[]{3, 5, 7, 9}) {
                long c = count("SELECT COUNT(*) FROM exams WHERE status='PUBLISHED' AND year_level=?", yr);
                details.put("year_" + yr, c);
                if (c != 80) {
                    details.put("year_" + yr + "_FAIL", "expected 80, got " + c);
                    ok = false;
                }
            }

            // ── 3. Per package ────────────────────────────────────────────────
            long free     = count("SELECT COUNT(*) FROM exams WHERE status='PUBLISHED' AND package_type='FREE'");
            long advanced = count("SELECT COUNT(*) FROM exams WHERE status='PUBLISHED' AND package_type='ADVANCED'");
            long premium  = count("SELECT COUNT(*) FROM exams WHERE status='PUBLISHED' AND package_type='PREMIUM'");
            details.put("package_FREE", free);
            details.put("package_ADVANCED", advanced);
            details.put("package_PREMIUM", premium);
            if (free != 20)    { details.put("package_FREE_FAIL",     "expected 20, got " + free);     ok = false; }
            if (advanced != 100){ details.put("package_ADVANCED_FAIL","expected 100, got " + advanced); ok = false; }
            if (premium != 200) { details.put("package_PREMIUM_FAIL", "expected 200, got " + premium);  ok = false; }

            // ── 4. Per year/domain (each must be 16) ─────────────────────────
            long badYearDomain = count(
                "SELECT COUNT(*) FROM (" +
                "  SELECT year_level, domain, COUNT(*) AS c " +
                "  FROM exams WHERE status='PUBLISHED' " +
                "  GROUP BY year_level, domain " +
                "  HAVING COUNT(*) != 16" +
                ") sub");
            details.put("year_domain_pairs_wrong_count", badYearDomain);
            if (badYearDomain > 0) {
                details.put("year_domain_FAIL", badYearDomain + " year/domain pairs do not have exactly 16 exams");
                ok = false;
            }

            // ── 5. Published exams without questions ──────────────────────────
            long emptyPublished = count(
                "SELECT COUNT(*) FROM exams e " +
                "WHERE e.status='PUBLISHED' " +
                "AND NOT EXISTS (SELECT 1 FROM exam_questions eq WHERE eq.exam_id = e.id)");
            details.put("published_without_questions", emptyPublished);
            if (emptyPublished > 0) {
                details.put("published_without_questions_FAIL", emptyPublished + " published exams have no questions");
                ok = false;
            }

            // ── 6. Zero AUDIO_RESPONSE in Spelling domain ─────────────────────
            long audioResponseSpelling = count(
                "SELECT COUNT(*) FROM questions WHERE question_type='AUDIO_RESPONSE' AND domain='SPELLING'");
            details.put("audio_response_spelling", audioResponseSpelling);
            if (audioResponseSpelling > 0) {
                details.put("audio_response_FAIL", audioResponseSpelling + " AUDIO_RESPONSE questions remain in Spelling");
                ok = false;
            }

        } catch (Exception e) {
            log.error("DB integrity check failed with exception", e);
            return Health.down(e).withDetails(details).build();
        }

        if (ok) {
            log.info("DB integrity check PASSED — 320 published exams, all invariants met");
            return Health.up().withDetails(details).build();
        } else {
            log.error("DB integrity check FAILED — {}", details);
            return Health.down().withDetails(details).build();
        }
    }

    private long count(String sql, Object... args) {
        Long result = jdbc.queryForObject(sql, Long.class, args);
        return result == null ? 0L : result;
    }
}
