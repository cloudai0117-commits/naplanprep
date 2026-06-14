package au.com.naplanprep.content.repository;

import au.com.naplanprep.content.entity.Question;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface QuestionRepository extends JpaRepository<Question, UUID>, JpaSpecificationExecutor<Question> {

    @Query("SELECT q FROM Question q WHERE q.yearLevel = :yearLevel AND q.domain = :domain " +
        "AND q.status = 'PUBLISHED' ORDER BY FUNCTION('RANDOM')")
    List<Question> findRandomByYearLevelAndDomain(
        @Param("yearLevel") Integer yearLevel,
        @Param("domain") Question.Domain domain,
        Pageable pageable
    );

    long countByStatus(Question.QuestionStatus status);

    @Query("SELECT q.yearLevel, q.domain, COUNT(q) FROM Question q WHERE q.status = 'PUBLISHED' " +
        "GROUP BY q.yearLevel, q.domain")
    List<Object[]> countPublishedByYearLevelAndDomain();
}
