package au.com.naplanprep.school.repository;

import au.com.naplanprep.school.entity.School;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface SchoolRepository extends JpaRepository<School, UUID> {
    List<School> findAllByOrderByNameAsc();
    List<School> findByNameContainingIgnoreCaseOrderByNameAsc(String name);
}
