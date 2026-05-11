package au.com.naplanprep.exam.entity;

import au.com.naplanprep.content.entity.Question;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "exams")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Exam {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private Integer yearLevel;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, columnDefinition = "domain_type")
    private Question.Domain domain;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, columnDefinition = "package_tier")
    @Builder.Default
    private PackageTier packageTier = PackageTier.FREE;

    @Column(nullable = false)
    private Integer timeLimitSeconds;

    private Instant availableFrom;
    private Instant availableUntil;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, columnDefinition = "exam_status")
    @Builder.Default
    private ExamStatus status = ExamStatus.DRAFT;

    private UUID createdBy;

    @CreationTimestamp
    private Instant createdAt;

    @UpdateTimestamp
    private Instant updatedAt;

    @OneToMany(mappedBy = "exam", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @OrderBy("questionOrder ASC")
    @Builder.Default
    private List<ExamQuestion> examQuestions = new ArrayList<>();

    public enum ExamStatus {
        DRAFT, PUBLISHED, ARCHIVED
    }

    public enum PackageTier {
        FREE, STANDARD, PREMIUM, FAMILY;

        /** Returns true if this tier satisfies the required minimum tier. */
        public boolean satisfies(PackageTier required) {
            return this.ordinal() >= required.ordinal();
        }

        /** All tiers that are accessible to a user holding this tier. */
        public List<PackageTier> accessibleTiers() {
            List<PackageTier> tiers = new ArrayList<>();
            for (PackageTier t : values()) {
                if (this.satisfies(t)) tiers.add(t);
            }
            return tiers;
        }
    }
}
