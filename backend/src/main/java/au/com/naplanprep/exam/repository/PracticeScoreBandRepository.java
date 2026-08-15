package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.PracticeScoreBand;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.Optional;

public interface PracticeScoreBandRepository extends JpaRepository<PracticeScoreBand, Integer> {

    /**
     * Lookup the practice band for a given year level, domain, and score percentage.
     * Returns the band whose range [minPercent, maxPercent] contains scorePercent.
     */
    @Query("""
        SELECT b FROM PracticeScoreBand b
        WHERE b.yearLevel = :yearLevel
          AND b.domain = :domain
          AND :scorePercent >= b.minPercent
          AND :scorePercent <= b.maxPercent
        """)
    Optional<PracticeScoreBand> findBand(
        @Param("yearLevel") Integer yearLevel,
        @Param("domain") String domain,
        @Param("scorePercent") BigDecimal scorePercent);
}
