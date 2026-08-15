package au.com.naplanprep.exam.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

/**
 * Practice score band configuration.
 *
 * Maps a percentage score range to a human-readable performance label
 * for a specific year level and domain. These labels are practice
 * indicators ONLY — they are explicitly NOT official NAPLAN bands.
 *
 * Labels and thresholds can be updated by administrators via the admin API.
 * Official NAPLAN band mappings may be loaded here once legitimately
 * published by ACARA.
 */
@Entity
@Table(name = "practice_score_bands",
    uniqueConstraints = @UniqueConstraint(columnNames = {"year_level", "domain", "band"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PracticeScoreBand {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private Integer yearLevel;

    @Column(nullable = false)
    private String domain;

    @Column(nullable = false)
    private Integer band;

    @Column(nullable = false, length = 100)
    private String label;

    @Column(nullable = false, precision = 5, scale = 2)
    private BigDecimal minPercent;

    @Column(nullable = false, precision = 5, scale = 2)
    private BigDecimal maxPercent;
}
