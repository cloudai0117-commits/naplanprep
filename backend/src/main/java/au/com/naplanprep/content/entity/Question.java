package au.com.naplanprep.content.entity;

import au.com.naplanprep.exam.entity.PackageType;
import au.com.naplanprep.exam.entity.Stimulus;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Entity
@Table(name = "questions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private QuestionType questionType;

    @Column(nullable = false)
    private Integer yearLevel;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Domain domain;

    @Column(nullable = false)
    private String topic;

    @Column(nullable = false)
    private Integer difficultyBand;

    @Enumerated(EnumType.STRING)
    @Column(name = "package_type", nullable = false)
    @Builder.Default
    private PackageType packageType = PackageType.FREE;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private Difficulty difficulty = Difficulty.EASY;

    /** Number of marks this question is worth. Default 1. */
    @Column(nullable = false)
    @Builder.Default
    private Integer marks = 1;

    /**
     * NAPLAN/curriculum cognitive skill classification.
     * Used for diagnostic breakdowns in results.
     */
    @Enumerated(EnumType.STRING)
    private CognitiveSkill cognitiveSkill;

    /** Curriculum strand/outcome (e.g., "Number and Algebra", "Literacy"). */
    @Column(length = 100)
    private String curriculumStrand;

    /**
     * Inline stimulus text for short stimuli where a full Stimulus
     * entity is not warranted. For shared passages, use stimulusId.
     */
    @Column(columnDefinition = "TEXT")
    private String stimulusText;

    /** Classifies the inline stimulusText. Null for standalone questions. */
    @Column(length = 20)
    private String stimulusType;

    /** Link to a shared Stimulus (passage, audio, image). */
    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "stimulus_id")
    private Stimulus stimulus;

    /** S3/CDN URL for AUDIO questions (Spelling domain). */
    @Column(length = 500)
    private String audioUrl;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String questionText;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private List<Map<String, Object>> options;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false, columnDefinition = "jsonb")
    private Map<String, Object> correctAnswer;

    @Column(columnDefinition = "TEXT")
    private String explanation;

    /**
     * Per-question calculator permission. Overrides testlet/section setting.
     * FALSE: calculator must be hidden regardless of testlet.calculator_allowed.
     * TRUE (default): defer to testlet/section setting.
     * Set explicitly to FALSE for Y3/Y5 Numeracy and Y7/Y9 A-stage questions 1-8.
     */
    @Column(name = "calculator_allowed", nullable = false)
    @Builder.Default
    private Boolean calculatorAllowed = true;

    /**
     * Scoring rubric for EXTENDED_WRITING questions.
     * Example: {"criteria":[{"name":"Audience","maxMarks":6}],"totalMarks":50}
     * Null for all other question types.
     */
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private Map<String, Object> markingRubric;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private QuestionStatus status = QuestionStatus.DRAFT;

    private UUID createdBy;

    @CreationTimestamp
    @Column(updatable = false)
    private Instant createdAt;

    @UpdateTimestamp
    private Instant updatedAt;

    // ─────────────────────────────────────────────────────────────
    // Enums
    // ─────────────────────────────────────────────────────────────

    public enum QuestionType {
        MULTIPLE_CHOICE,   // single answer from labelled options
        MULTI_SELECT,      // multiple correct options
        SHORT_ANSWER,      // typed text, auto-graded by normalised comparison
        FILL_BLANK,        // one or more blanks within a sentence
        REORDER,           // drag items into correct sequence
        MATCHING,          // match left-column to right-column items
        DRAG_DROP,         // generic positional drag-and-drop
        AUDIO_RESPONSE,    // reserved for future spoken-response items
        EXTENDED_WRITING,  // long-form writing; NOT auto-marked
        IMAGE_INTERACTION  // click/mark regions on an image
    }

    public enum Domain {
        READING, WRITING, SPELLING, GRAMMAR_PUNCTUATION, NUMERACY
    }

    public enum Difficulty {
        EASY, MEDIUM, HARD
    }

    public enum QuestionStatus {
        DRAFT, REVIEW, PUBLISHED, ARCHIVED
    }

    public enum CognitiveSkill {
        RECALL,           // retrieval of learned facts
        COMPREHENSION,    // understanding and interpretation
        ANALYSIS,         // breaking down and examining
        APPLICATION,      // applying knowledge to new contexts
        REASONING         // logical reasoning and inference
    }
}
