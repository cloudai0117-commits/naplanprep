package au.com.naplanprep.exam.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "testlets",
    uniqueConstraints = @UniqueConstraint(columnNames = {"section_id", "testlet_order"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Testlet {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "section_id", nullable = false)
    private ExamSection section;

    /**
     * Shared stimulus (passage, audio, image) for this testlet.
     * All questions within this testlet share this stimulus.
     * Null for standalone question groups.
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "stimulus_id")
    private Stimulus stimulus;

    @Column(length = 200)
    private String title;

    @Column(nullable = false)
    private Integer testletOrder;

    /**
     * When true, the branching engine evaluates transition rules after
     * this testlet is completed. The next testlet is determined by the
     * student's performance, not a fixed order.
     */
    @Column(nullable = false)
    @Builder.Default
    private Boolean isBranchingNode = false;

    /**
     * When true, once the student moves past this testlet they cannot
     * return to it. Enforced server-side; overrides section setting.
     */
    @Column(nullable = false)
    @Builder.Default
    private Boolean navigationLocked = false;

    /**
     * Null = inherits from parent ExamSection.
     * Explicit value overrides the section-level calculator setting.
     */
    private Boolean calculatorAllowed;

    @Column(columnDefinition = "TEXT")
    private String instructions;

    @CreationTimestamp
    @Column(updatable = false)
    private Instant createdAt;
}
