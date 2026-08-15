package au.com.naplanprep.exam.entity;

import au.com.naplanprep.content.entity.Question;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "exam_sessions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExamSession {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    // ── Identity ──────────────────────────────────────────────────
    @Column(nullable = false)
    private UUID userId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ExamType examType;

    @Column(nullable = false)
    private Integer yearLevel;

    @Enumerated(EnumType.STRING)
    private Question.Domain domain;

    /** Null for ad-hoc practice sessions; set for admin-created exams. */
    @Column(name = "exam_id")
    private UUID examId;

    // ── Question list ─────────────────────────────────────────────
    /**
     * Ordered list of question UUIDs for this session.
     * For admin exams: sourced from exam_questions at start.
     * For practice sessions: assembled from random question pool.
     * Immutable after session creation.
     */
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false, columnDefinition = "jsonb")
    @Builder.Default
    private List<UUID> questionIds = new ArrayList<>();

    // ── Timer ─────────────────────────────────────────────────────
    private Integer timeLimitSeconds;
    private Instant startedAt;
    private Instant expiresAt;
    private Instant submittedAt;

    // ── Status ────────────────────────────────────────────────────
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private SessionStatus status = SessionStatus.IN_PROGRESS;

    // ── Navigation state (server-authoritative) ───────────────────
    /**
     * Current section the student is in.
     * Null for flat sessions without a section hierarchy.
     */
    private UUID currentSectionId;

    /**
     * Current testlet the student is in.
     * Null for flat sessions without testlets.
     */
    private UUID currentTestletId;

    /** 1-based order of the question the student last visited. */
    private Integer currentQuestionOrder;

    /**
     * Ordered list of testlet UUIDs the student will traverse.
     * For linear exams: all testlet IDs in order, set at session start.
     * For branching exams: grows as transitions are resolved.
     */
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    @Builder.Default
    private List<UUID> questionPath = new ArrayList<>();

    /**
     * Seed used to deterministically reproduce randomised question order
     * on session resume. Ensures the same order is returned on reconnect.
     */
    private Long randomisationSeed;

    /**
     * Question UUIDs the student has flagged for review.
     * Updated via the flag-question endpoint.
     */
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    @Builder.Default
    private List<UUID> flaggedQuestions = new ArrayList<>();

    /** Cached count of saved answers for progress display. */
    @Column(nullable = false)
    @Builder.Default
    private Integer answerCount = 0;

    /**
     * True once session_question_snapshots rows have been written.
     * Guards against partially-written snapshots on server crash at start.
     */
    @Column(nullable = false)
    @Builder.Default
    private Boolean hasSnapshot = false;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    // ── Enums ─────────────────────────────────────────────────────

    public enum ExamType {
        PRACTICE, MOCK, DIAGNOSTIC
    }

    public enum SessionStatus {
        IN_PROGRESS, SUBMITTED, TIMED_OUT, ABANDONED
    }
}
