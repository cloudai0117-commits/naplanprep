package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.Stimulus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface StimulusRepository extends JpaRepository<Stimulus, UUID> {

    Page<Stimulus> findByDomainAndYearLevel(String domain, Integer yearLevel, Pageable pageable);

    Page<Stimulus> findByStatus(Stimulus.StimulusStatus status, Pageable pageable);

    List<Stimulus> findByStimulusTypeAndStatus(Stimulus.StimulusType type, Stimulus.StimulusStatus status);
}
