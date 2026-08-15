package au.com.naplanprep.audit.service;

import au.com.naplanprep.audit.entity.AuditLog;
import au.com.naplanprep.audit.repository.AuditLogRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.UUID;

/**
 * Writes audit events to the audit_logs table asynchronously.
 *
 * All methods are @Async — callers do not block waiting for the write.
 * Failures are logged but never propagate; a failed audit write must
 * never abort an exam operation.
 *
 * Event names are defined as constants on AuditLog (EXAM_STARTED, etc.).
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AuditLogService {

    private final AuditLogRepository auditLogRepository;

    @Async
    public void log(String action, UUID userId, UUID sessionId, String detail) {
        try {
            AuditLog entry = AuditLog.builder()
                .action(action)
                .userId(userId)
                .resourceType(sessionId != null ? "SESSION" : null)
                .resourceId(sessionId != null ? sessionId.toString() : null)
                .details(detail != null ? Map.of("detail", detail) : null)
                .build();
            auditLogRepository.save(entry);
        } catch (Exception e) {
            log.error("Audit log write failed for action={} userId={} sessionId={}: {}",
                action, userId, sessionId, e.getMessage(), e);
        }
    }

    @Async
    public void log(String action, UUID userId, UUID sessionId) {
        log(action, userId, sessionId, null);
    }

    @Async
    public void log(String action, UUID userId) {
        log(action, userId, null, null);
    }
}
