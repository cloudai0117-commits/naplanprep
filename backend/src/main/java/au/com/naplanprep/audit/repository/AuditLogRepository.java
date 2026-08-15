package au.com.naplanprep.audit.repository;

import au.com.naplanprep.audit.entity.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public interface AuditLogRepository extends JpaRepository<AuditLog, UUID> {

    Page<AuditLog> findByUserIdOrderByCreatedAtDesc(UUID userId, Pageable pageable);

    /** All events for a session, in chronological order. */
    List<AuditLog> findByResourceTypeAndResourceIdOrderByCreatedAtAsc(String resourceType, String resourceId);

    Page<AuditLog> findByActionAndCreatedAtAfter(String action, Instant after, Pageable pageable);
}
