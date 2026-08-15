package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.SessionQuestionSnapshot;
import au.com.naplanprep.exam.entity.SessionQuestionSnapshot.SessionQuestionSnapshotId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface SessionQuestionSnapshotRepository
        extends JpaRepository<SessionQuestionSnapshot, SessionQuestionSnapshotId> {

    List<SessionQuestionSnapshot> findByIdSessionIdOrderByQuestionOrder(UUID sessionId);

    /** Single question snapshot — used for answer verification and review. */
    Optional<SessionQuestionSnapshot> findByIdSessionIdAndIdQuestionId(UUID sessionId, UUID questionId);

    /** All snapshots for a given testlet within a session. */
    List<SessionQuestionSnapshot> findByIdSessionIdAndTestletIdOrderByQuestionOrder(
            UUID sessionId, UUID testletId);

    /** Count how many snapshots exist for a session — used to verify snapshot completeness. */
    @Query("SELECT COUNT(s) FROM SessionQuestionSnapshot s WHERE s.id.sessionId = :sessionId")
    long countBySessionId(@Param("sessionId") UUID sessionId);

    boolean existsByIdSessionId(UUID sessionId);
}
