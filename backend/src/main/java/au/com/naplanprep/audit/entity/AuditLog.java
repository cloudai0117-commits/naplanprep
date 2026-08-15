package au.com.naplanprep.audit.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;

@Entity
@Table(name = "audit_logs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuditLog {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private UUID userId;

    @Column(nullable = false, length = 100)
    private String action;

    @Column(length = 100)
    private String resourceType;

    @Column(length = 100)
    private String resourceId;

    @Column(length = 45)
    private String ipAddress;

    @Column(columnDefinition = "TEXT")
    private String userAgent;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private Map<String, Object> details;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    /** Standard audit event names. */
    public static final String EXAM_STARTED         = "EXAM_STARTED";
    public static final String EXAM_RESUMED         = "EXAM_RESUMED";
    public static final String ANSWER_SAVED         = "ANSWER_SAVED";
    public static final String TESTLET_TRANSITIONED = "TESTLET_TRANSITIONED";
    public static final String EXAM_SUBMITTED       = "EXAM_SUBMITTED";
    public static final String EXAM_TIMED_OUT       = "EXAM_TIMED_OUT";
    public static final String WRITING_SUBMITTED    = "WRITING_SUBMITTED";
}
