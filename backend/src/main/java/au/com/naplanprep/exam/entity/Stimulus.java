package au.com.naplanprep.exam.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "stimuli")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Stimulus {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StimulusType stimulusType;

    @Column(length = 200)
    private String title;

    /** Full text content for TEXT/WRITING_PROMPT stimuli. */
    @Column(columnDefinition = "TEXT")
    private String content;

    /** S3/CDN URL for IMAGE or AUDIO stimuli. */
    @Column(length = 500)
    private String assetUrl;

    /**
     * Word/transcript for AUDIO stimuli — used by authoring tools and
     * administrators only. NEVER exposed in student-facing API responses.
     */
    @Column(columnDefinition = "TEXT")
    private String transcript;

    /** Declared audio length in seconds; may be used for pacing analytics. */
    private Integer audioDurationSeconds;

    @Column(nullable = false)
    private Integer yearLevel;

    private String domain;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private StimulusStatus status = StimulusStatus.DRAFT;

    private UUID createdBy;

    @CreationTimestamp
    @Column(updatable = false)
    private Instant createdAt;

    @UpdateTimestamp
    private Instant updatedAt;

    public enum StimulusType {
        TEXT,           // reading passage, grammar extract
        IMAGE,          // diagram, chart, map
        AUDIO,          // Spelling dictation
        WRITING_PROMPT  // Writing domain prompt
    }

    public enum StimulusStatus {
        DRAFT, PUBLISHED, ARCHIVED
    }
}
