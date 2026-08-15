package au.com.naplanprep.exam.entity;

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
@Table(name = "exam_answers",
    uniqueConstraints = @UniqueConstraint(columnNames = {"session_id", "question_id"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExamAnswer {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private UUID sessionId;

    @Column(nullable = false)
    private UUID questionId;

    /**
     * The student's answer payload. Structure varies by question type:
     *   MULTIPLE_CHOICE:  {"value": "B"}
     *   MULTI_SELECT:     {"values": ["A", "C"]}
     *   SHORT_ANSWER:     {"value": "some text"}
     *   FILL_BLANK:       {"blanks": ["word1", "word2"]}
     *   REORDER:          {"order": [3, 1, 4, 2]}
     *   MATCHING:         {"pairs": [{"left":"1","right":"A"}, ...]}
     *   EXTENDED_WRITING: {"text": "full essay text", "wordCount": 250}
     */
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false, columnDefinition = "jsonb")
    private Map<String, Object> answer;

    /**
     * True/false for auto-marked types. Null for EXTENDED_WRITING
     * (requires human or AI-assisted review).
     */
    private Boolean correct;

    /** Student has flagged this question for review. */
    private Boolean flagged;

    /** Seconds the student spent on this question. Optional client-supplied metric. */
    private Integer timeTakenSeconds;

    @CreationTimestamp
    private Instant answeredAt;

    /** Tracks the most recent change to this answer (for audit trail and resume ordering). */
    @UpdateTimestamp
    private Instant updatedAt;
}
