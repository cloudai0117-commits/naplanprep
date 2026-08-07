package au.com.naplanprep.content;

import au.com.naplanprep.admin.service.AdminService;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.content.dto.QuestionRequest;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.content.service.ContentService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Testcontainers
@ActiveProfiles("test")
@Transactional
class QuestionAdminIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @Autowired private ContentService contentService;
    @Autowired private AdminService adminService;
    @Autowired private QuestionRepository questionRepository;
    @Autowired private UserRepository userRepository;

    private UUID creatorId;

    @BeforeEach
    void setUp() {
        // questions.created_by is a FK to users.id — must use a real persisted user
        User creator = new User();
        creator.setEmail("creator-" + UUID.randomUUID() + "@test.com");
        creator.setPassword("hashed");
        creator.setRole(User.Role.PLATFORM_ADMIN);
        creator.setStatus(User.UserStatus.ACTIVE);
        creatorId = userRepository.save(creator).getId();
    }

    private QuestionRequest req(int year, Question.Domain domain, String topic) {
        return new QuestionRequest(
            Question.QuestionType.MULTIPLE_CHOICE, year, domain, topic, 3,
            null, null,
            null, "Test question text?",
            Map.of("options", List.of("A", "B", "C", "D")),
            Map.of("value", "A"),
            "A is correct."
        );
    }

    // ── Search / Specification fix ────────────────────────────────────────────

    @Test
    void searchWithAllNullFilters_doesNotThrowAndReturnsPage() {
        // Verifies the Specification-based query handles null enum params (replaces
        // the JPQL query that crashed Hibernate when enum params were null).
        Page<Question> page = contentService.searchQuestions(null, null, null, null, null, null, Pageable.ofSize(20));
        assertNotNull(page);
    }

    // ── Create → visible in search ────────────────────────────────────────────

    @Test
    void createdQuestion_appearsInSearchByYearLevel() {
        Question q = contentService.createQuestion(req(5, Question.Domain.NUMERACY, "Fractions"), creatorId);

        Page<Question> results = contentService.searchQuestions(5, null, null, null, null, null, Pageable.ofSize(50));
        assertTrue(results.getContent().stream().anyMatch(r -> r.getId().equals(q.getId())));
    }

    @Test
    void createdQuestion_appearsInSearchByDomain_andExcludedFromOtherDomains() {
        Question q = contentService.createQuestion(req(7, Question.Domain.READING, "Comprehension"), creatorId);

        Page<Question> reading = contentService.searchQuestions(null, Question.Domain.READING, null, null, null, null, Pageable.ofSize(50));
        assertTrue(reading.getContent().stream().anyMatch(r -> r.getId().equals(q.getId())));

        Page<Question> spelling = contentService.searchQuestions(null, Question.Domain.SPELLING, null, null, null, null, Pageable.ofSize(50));
        assertFalse(spelling.getContent().stream().anyMatch(r -> r.getId().equals(q.getId())));
    }

    @Test
    void searchByTopic_isCaseInsensitive() {
        contentService.createQuestion(req(9, Question.Domain.NUMERACY, "Long Division"), creatorId);

        Page<Question> results = contentService.searchQuestions(null, null, "long division", null, null, null, Pageable.ofSize(50));
        assertTrue(results.getTotalElements() >= 1);
    }

    @Test
    void createdQuestion_filteredByStatus_appearsAsDraft() {
        Question q = contentService.createQuestion(req(3, Question.Domain.GRAMMAR_PUNCTUATION, "Punctuation"), creatorId);

        Page<Question> drafts = contentService.searchQuestions(null, null, null, null, Question.QuestionStatus.DRAFT, null, Pageable.ofSize(50));
        assertTrue(drafts.getContent().stream().anyMatch(r -> r.getId().equals(q.getId())));
    }

    // ── Admin content stats ───────────────────────────────────────────────────

    @Test
    void adminContentStats_draftCountIncrementsAfterCreate() {
        long before = questionRepository.countByStatus(Question.QuestionStatus.DRAFT);

        contentService.createQuestion(req(5, Question.Domain.SPELLING, "Vocabulary"), creatorId);

        Map<String, Object> stats = adminService.getContentStats();
        assertEquals(before + 1, (Long) stats.get("totalDraft"));
    }

    @Test
    void adminContentStats_publishedCountIncrementsAfterPublish() {
        Question q = contentService.createQuestion(req(7, Question.Domain.WRITING, "Structure"), creatorId);
        long before = questionRepository.countByStatus(Question.QuestionStatus.PUBLISHED);

        contentService.updateStatus(q.getId(), Question.QuestionStatus.PUBLISHED);

        Map<String, Object> stats = adminService.getContentStats();
        assertEquals(before + 1, (Long) stats.get("totalPublished"));
    }

    // ── Publish → appears in PUBLISHED filter ────────────────────────────────

    @Test
    void publishedQuestion_appearsInPublishedStatusFilter() {
        Question q = contentService.createQuestion(req(9, Question.Domain.NUMERACY, "Algebra"), creatorId);
        // Flush before updateStatus: @GeneratedValue(UUID) causes em.merge() (not persist()),
        // and a second merge before flush disrupts @CreationTimestamp. Force the INSERT now.
        questionRepository.flush();
        contentService.updateStatus(q.getId(), Question.QuestionStatus.PUBLISHED);

        Page<Question> published = contentService.searchQuestions(
            null, null, null, null, Question.QuestionStatus.PUBLISHED, null, Pageable.ofSize(200));
        assertTrue(published.getContent().stream().anyMatch(r -> r.getId().equals(q.getId())));
    }

    @Test
    void draftQuestion_doesNotAppearInPublishedFilter() {
        Question q = contentService.createQuestion(req(3, Question.Domain.READING, "Inference"), creatorId);

        Page<Question> published = contentService.searchQuestions(
            null, null, null, null, Question.QuestionStatus.PUBLISHED, null, Pageable.ofSize(200));
        assertFalse(published.getContent().stream().anyMatch(r -> r.getId().equals(q.getId())));
    }
}
