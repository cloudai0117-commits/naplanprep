package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.Testlet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface TestletRepository extends JpaRepository<Testlet, UUID> {

    List<Testlet> findBySectionIdOrderByTestletOrder(UUID sectionId);

    /** Load all testlets for an exam (across all sections) ordered for display. */
    @Query("""
        SELECT t FROM Testlet t
        JOIN t.section s
        WHERE s.exam.id = :examId
        ORDER BY s.sectionOrder, t.testletOrder
        """)
    List<Testlet> findByExamIdOrdered(@Param("examId") UUID examId);

    /** First testlet in the first section — used as session entry point. */
    @Query("""
        SELECT t FROM Testlet t
        JOIN t.section s
        WHERE s.exam.id = :examId
        ORDER BY s.sectionOrder ASC, t.testletOrder ASC
        LIMIT 1
        """)
    java.util.Optional<Testlet> findFirstByExamId(@Param("examId") UUID examId);
}
