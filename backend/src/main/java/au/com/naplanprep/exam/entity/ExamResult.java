package au.com.naplanprep.exam.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;

@Entity
@Table(name = "exam_results")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExamResult {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private UUID sessionId;

    @Column(nullable = false)
    private UUID userId;

    /** Direct reference for analytics queries — avoids join through exam_sessions. */
    private UUID examId;

    @Column(nullable = false)
    private Integer totalQuestions;

    /** Sum of marks across answered questions (not simply count). */
    @Column(nullable = false)
    private Integer correctAnswers;

    /** Weighted score: sum(marks where correct) / sum(all marks) * 100 */
    @Column(nullable = false)
    private Double scorePercentage;

    /**
     * Practice performance indicator (1–10).
     * This is a PRACTICE SCORE BAND based on practice_score_bands config.
     * It is NOT an official NAPLAN band score.
     * Stored in the naplan_band column for backward compat with existing rows.
     */
    @Column(name = "naplan_band", nullable = false)
    private Integer practiceBand;

    /**
     * Human-readable practice label from practice_score_bands.
     * Example: "Meeting Standard 2"
     * NEVER labelled as an official NAPLAN result in client responses.
     */
    @Column(name = "practice_label", length = 50)
    private String practiceLabel;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private Map<String, Object> domainBreakdown;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private Map<String, Object> topicBreakdown;

    /**
     * True when the session contains EXTENDED_WRITING questions whose
     * marks cannot be auto-calculated. The result totals are provisional
     * until a human reviewer assigns marks via the admin marking interface.
     *
     * Clients must NOT display a finalised score when this is true.
     */
    @Column(nullable = false)
    @Builder.Default
    private Boolean pendingReview = false;

    @CreationTimestamp
    private Instant calculatedAt;
}
