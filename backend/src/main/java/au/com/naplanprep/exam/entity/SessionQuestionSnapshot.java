package au.com.naplanprep.exam.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.io.Serializable;
import java.util.Map;
import java.util.UUID;

/**
 * Immutable snapshot of a question captured at exam session start.
 *
 * Every request to read questions during an active session reads from
 * this table, NOT from the live questions table. Admin edits made after
 * session start are completely isolated from the student's attempt.
 *
 * The snapshot JSONB contains:
 *   questionType, questionText, stimulusText, stimulusType,
 *   stimulusContent, stimulusAssetUrl, options,
 *   correctAnswer (used server-side only for grading — NEVER sent to client),
 *   explanation (withheld until after submission),
 *   marks, markingRubric, topic, domain, yearLevel, difficultyBand,
 *   cognitiveSkill, curriculumStrand, audioUrl
 */
@Entity
@Table(name = "session_question_snapshots")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SessionQuestionSnapshot {

    @EmbeddedId
    private SessionQuestionSnapshotId id;

    @Column(nullable = false)
    private Integer questionOrder;

    private UUID testletId;
    private UUID sectionId;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false, columnDefinition = "jsonb")
    private Map<String, Object> snapshot;

    @Embeddable
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class SessionQuestionSnapshotId implements Serializable {
        private UUID sessionId;
        private UUID questionId;
    }
}
