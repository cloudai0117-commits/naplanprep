package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.TestletTransition;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface TestletTransitionRepository extends JpaRepository<TestletTransition, UUID> {

    /**
     * Load all outbound transitions from a testlet, ordered by priority descending.
     * The BranchingEngine evaluates the first matching condition.
     */
    List<TestletTransition> findBySourceTestletIdOrderByPriorityDesc(UUID sourceTestletId);

    List<TestletTransition> findByExamId(UUID examId);
}
