package au.com.naplanprep.exam.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;

/**
 * Data-driven branching rule.
 *
 * The branching engine loads all transitions for a given source testlet,
 * sorts by priority (descending), and follows the first matching condition.
 *
 * Linear exams: one ALWAYS transition per testlet (priority 0).
 * Branched exams: multiple transitions with SCORE_ABOVE / SCORE_BELOW
 *                 conditions at higher priority, with an ALWAYS fallback.
 *
 * Example NAPLAN-style branching from Testlet A:
 *   priority 10, SCORE_ABOVE 0.65 → Testlet D (harder path)
 *   priority  0, ALWAYS           → Testlet B (standard path)
 */
@Entity
@Table(name = "testlet_transitions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TestletTransition {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exam_id", nullable = false)
    private Exam exam;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "source_testlet", nullable = false)
    private Testlet sourceTestlet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "target_testlet", nullable = false)
    private Testlet targetTestlet;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private ConditionType conditionType = ConditionType.ALWAYS;

    /**
     * Condition parameters as JSON.
     * ALWAYS → null
     * SCORE_ABOVE / SCORE_BELOW → {"threshold": 0.60}
     */
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private Map<String, Object> conditionValue;

    /** Higher priority evaluated first; first match wins. */
    @Column(nullable = false)
    @Builder.Default
    private Integer priority = 0;

    @CreationTimestamp
    @Column(updatable = false)
    private Instant createdAt;

    public enum ConditionType {
        ALWAYS,
        SCORE_ABOVE,
        SCORE_BELOW
    }
}
