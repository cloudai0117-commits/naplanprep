package au.com.naplanprep.content.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
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

    @Column(columnDefinition = "TEXT")
    private String stimulusText;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String questionText;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private Map<String, Object> options;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false, columnDefinition = "jsonb")
    private Map<String, Object> correctAnswer;

    @Column(columnDefinition = "TEXT")
    private String explanation;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private QuestionStatus status = QuestionStatus.DRAFT;

    private UUID createdBy;

    @CreationTimestamp
    private Instant createdAt;

    @UpdateTimestamp
    private Instant updatedAt;

    public enum QuestionType {
        MULTIPLE_CHOICE, DRAG_DROP, SHORT_ANSWER, EXTENDED_WRITING
    }

    public enum Domain {
        READING, WRITING, SPELLING, GRAMMAR_PUNCTUATION, NUMERACY
    }

    public enum QuestionStatus {
        DRAFT, REVIEW, PUBLISHED, ARCHIVED
    }
}
