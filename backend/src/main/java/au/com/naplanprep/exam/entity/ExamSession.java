package au.com.naplanprep.exam.entity;

import au.com.naplanprep.content.entity.Question;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
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

    @Column(nullable = false)
    private UUID userId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ExamType examType;

    @Column(nullable = false)
    private Integer yearLevel;

    @Enumerated(EnumType.STRING)
    private Question.Domain domain;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false, columnDefinition = "jsonb")
    private List<UUID> questionIds;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private SessionStatus status = SessionStatus.IN_PROGRESS;

    private Instant startedAt;
    private Instant submittedAt;
    private Instant expiresAt;

    private Integer timeLimitSeconds;

    @CreationTimestamp
    private Instant createdAt;

    public enum ExamType {
        PRACTICE, MOCK, DIAGNOSTIC
    }

    public enum SessionStatus {
        IN_PROGRESS, SUBMITTED, TIMED_OUT, ABANDONED
    }
}
