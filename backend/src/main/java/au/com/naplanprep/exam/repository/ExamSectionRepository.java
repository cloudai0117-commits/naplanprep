package au.com.naplanprep.exam.repository;

import au.com.naplanprep.exam.entity.ExamSection;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ExamSectionRepository extends JpaRepository<ExamSection, UUID> {

    List<ExamSection> findByExamIdOrderBySectionOrder(UUID examId);

    boolean existsByExamId(UUID examId);
}
