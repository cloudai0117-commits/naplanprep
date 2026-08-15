package au.com.naplanprep.exam.entity;

import au.com.naplanprep.content.entity.Question;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "exam_sections",
    uniqueConstraints = @UniqueConstraint(columnNames = {"exam_id", "section_order"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExamSection {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exam_id", nullable = false)
    private Exam exam;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(nullable = false)
    private Integer sectionOrder;

    /** Null = inherits the exam-level time limit. */
    private Integer timeLimitSeconds;

    @Column(nullable = false)
    @Builder.Default
    private Boolean calculatorAllowed = false;

    /**
     * When true, once the student moves past this section they cannot
     * return to it. Enforced server-side.
     */
    @Column(nullable = false)
    @Builder.Default
    private Boolean navigationLocked = false;

    /** Optional domain override (e.g., for Conventions of Language sections). */
    @Enumerated(EnumType.STRING)
    private Question.Domain domain;

    @Column(columnDefinition = "TEXT")
    private String instructions;

    @OneToMany(mappedBy = "section", cascade = CascadeType.ALL,
               orphanRemoval = true, fetch = FetchType.LAZY)
    @OrderBy("testletOrder ASC")
    @Builder.Default
    private List<Testlet> testlets = new ArrayList<>();

    @CreationTimestamp
    @Column(updatable = false)
    private Instant createdAt;
}
