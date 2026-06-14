package au.com.naplanprep.subscription;

import au.com.naplanprep.admin.service.AdminService;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.exam.dto.AvailableExamResponse;
import au.com.naplanprep.exam.entity.Exam;
import au.com.naplanprep.exam.entity.ExamQuestion;
import au.com.naplanprep.exam.repository.ExamQuestionRepository;
import au.com.naplanprep.exam.repository.ExamRepository;
import au.com.naplanprep.exam.service.ExamService;
import au.com.naplanprep.subscription.entity.Plan;
import au.com.naplanprep.subscription.entity.Subscription;
import au.com.naplanprep.subscription.repository.PlanRepository;
import au.com.naplanprep.subscription.repository.SubscriptionRepository;
import au.com.naplanprep.subscription.service.SubscriptionService;
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

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Testcontainers
@ActiveProfiles("test")
@Transactional
class PlanUpgradeIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @Autowired private SubscriptionService subscriptionService;
    @Autowired private ExamService examService;
    @Autowired private AdminService adminService;
    @Autowired private UserRepository userRepository;
    @Autowired private PlanRepository planRepository;
    @Autowired private SubscriptionRepository subscriptionRepository;
    @Autowired private ExamRepository examRepository;
    @Autowired private ExamQuestionRepository examQuestionRepository;
    @Autowired private QuestionRepository questionRepository;

    private UUID studentId;
    private Plan standardPlan;
    private Plan premiumPlan;
    private Exam standardExam;
    private Exam premiumExam;

    @BeforeEach
    void setUp() {
        User student = new User();
        student.setEmail("upgrade-test-" + UUID.randomUUID() + "@test.com");
        student.setPassword("hashed");
        student.setRole(User.Role.STUDENT);
        student.setStatus(User.UserStatus.ACTIVE);
        studentId = userRepository.save(student).getId();

        standardPlan = planRepository.findBySlug("standard").orElseGet(() ->
            planRepository.save(Plan.builder()
                .name("Standard").slug("standard")
                .monthlyPrice(new BigDecimal("9.99")).active(true).build()));

        premiumPlan = planRepository.findBySlug("premium").orElseGet(() ->
            planRepository.save(Plan.builder()
                .name("Premium").slug("premium")
                .monthlyPrice(new BigDecimal("19.99")).active(true).build()));

        Question q = new Question();
        q.setQuestionType(Question.QuestionType.MULTIPLE_CHOICE);
        q.setYearLevel(5);
        q.setDomain(Question.Domain.NUMERACY);
        q.setTopic("Test Topic");
        q.setDifficultyBand(3);
        q.setQuestionText("What is 2+2?");
        q.setOptions(Map.of("options", List.of("3", "4", "5", "6")));
        q.setCorrectAnswer(Map.of("value", "4"));
        q.setStatus(Question.QuestionStatus.PUBLISHED);
        q = questionRepository.save(q);

        standardExam = examRepository.save(Exam.builder()
            .title("Standard Exam").yearLevel(5).domain(Question.Domain.NUMERACY)
            .packageTier(Exam.PackageTier.STANDARD).timeLimitSeconds(1800)
            .status(Exam.ExamStatus.PUBLISHED)
            .availableFrom(Instant.now().minusSeconds(3600))
            .availableUntil(Instant.now().plusSeconds(3600))
            .build());
        linkQuestion(standardExam, q);

        premiumExam = examRepository.save(Exam.builder()
            .title("Premium Exam").yearLevel(5).domain(Question.Domain.NUMERACY)
            .packageTier(Exam.PackageTier.PREMIUM).timeLimitSeconds(1800)
            .status(Exam.ExamStatus.PUBLISHED)
            .availableFrom(Instant.now().minusSeconds(3600))
            .availableUntil(Instant.now().plusSeconds(3600))
            .build());
        linkQuestion(premiumExam, q);
    }

    private void linkQuestion(Exam exam, Question q) {
        ExamQuestion eq = new ExamQuestion();
        eq.setId(new ExamQuestion.ExamQuestionId(exam.getId(), q.getId()));
        eq.setExam(exam);
        eq.setQuestion(q);
        eq.setQuestionOrder(1);
        examQuestionRepository.save(eq);
    }

    private Subscription activeSub(Plan plan, String stripeId) {
        return Subscription.builder()
            .userId(studentId).plan(plan)
            .status(Subscription.SubscriptionStatus.ACTIVE)
            .billingInterval(Subscription.BillingInterval.MONTHLY)
            .stripeSubscriptionId(stripeId)
            .currentPeriodStart(Instant.now())
            .currentPeriodEnd(Instant.now().plusSeconds(30L * 24 * 3600))
            .build();
    }

    // ── Tier entitlement ─────────────────────────────────────────────────────

    @Test
    void standardSubscriber_seesUpgradeRequiredForPremiumExam() {
        subscriptionRepository.save(activeSub(standardPlan, "sub_std_entitlement"));

        List<AvailableExamResponse> exams = examService.getAvailableExams(studentId);
        AvailableExamResponse pExam = exams.stream()
            .filter(e -> e.id().equals(premiumExam.getId())).findFirst().orElseThrow();
        assertEquals("UPGRADE_REQUIRED", pExam.availability());
    }

    @Test
    void standardSubscriber_canAccessStandardExam() {
        subscriptionRepository.save(activeSub(standardPlan, "sub_std_access"));

        List<AvailableExamResponse> exams = examService.getAvailableExams(studentId);
        AvailableExamResponse sExam = exams.stream()
            .filter(e -> e.id().equals(standardExam.getId())).findFirst().orElseThrow();
        assertEquals("AVAILABLE", sExam.availability());
    }

    // ── After upgrade to Premium ──────────────────────────────────────────────

    @Test
    void afterUpgrade_premiumExamBecomesAvailable() {
        // Old Standard subscription cancelled (simulates Stripe cancellation on upgrade)
        Subscription cancelled = Subscription.builder()
            .userId(studentId).plan(standardPlan)
            .status(Subscription.SubscriptionStatus.CANCELLED)
            .billingInterval(Subscription.BillingInterval.MONTHLY)
            .stripeSubscriptionId("sub_std_cancelled")
            .cancelledAt(Instant.now())
            .currentPeriodStart(Instant.now())
            .currentPeriodEnd(Instant.now().plusSeconds(30L * 24 * 3600))
            .build();
        subscriptionRepository.save(cancelled);
        // New Premium subscription created by Stripe webhook
        subscriptionRepository.save(activeSub(premiumPlan, "sub_prem_unlocked"));

        List<AvailableExamResponse> exams = examService.getAvailableExams(studentId);
        AvailableExamResponse pExam = exams.stream()
            .filter(e -> e.id().equals(premiumExam.getId())).findFirst().orElseThrow();
        assertEquals("AVAILABLE", pExam.availability());
    }

    @Test
    void afterUpgrade_standardExamRemainsAvailable() {
        subscriptionRepository.save(activeSub(premiumPlan, "sub_prem_both"));

        List<AvailableExamResponse> exams = examService.getAvailableExams(studentId);
        AvailableExamResponse sExam = exams.stream()
            .filter(e -> e.id().equals(standardExam.getId())).findFirst().orElseThrow();
        assertEquals("AVAILABLE", sExam.availability(),
            "Premium tier should also satisfy Standard exam requirement");
    }

    @Test
    void afterUpgrade_getCurrentSubscription_returnsPremiumPlan() {
        subscriptionRepository.save(activeSub(premiumPlan, "sub_prem_current"));

        Optional<Subscription> current = subscriptionService.getCurrentSubscription(studentId);
        assertTrue(current.isPresent());
        assertEquals("premium", current.get().getPlan().getSlug());
        assertEquals(Subscription.SubscriptionStatus.ACTIVE, current.get().getStatus());
    }

    // ── Admin visibility ──────────────────────────────────────────────────────

    @Test
    void adminSubscriptionList_showsPremiumPlanAfterUpgrade() {
        String uniqueSubId = "sub_prem_admin_" + UUID.randomUUID();
        subscriptionRepository.save(activeSub(premiumPlan, uniqueSubId));

        Page<Map<String, Object>> page = adminService.getSubscriptionList(Pageable.ofSize(200));
        boolean found = page.getContent().stream()
            .anyMatch(s -> studentId.equals(s.get("userId")) && "Premium".equals(s.get("planName")));
        assertTrue(found, "Admin subscription list must show the Premium plan for the upgraded student");
    }

    @Test
    void adminSubscriptionList_showsBothStandardAndPremiumDuringTransition() {
        subscriptionRepository.save(activeSub(standardPlan, "sub_std_transition"));
        subscriptionRepository.save(activeSub(premiumPlan, "sub_prem_transition"));

        Page<Map<String, Object>> page = adminService.getSubscriptionList(Pageable.ofSize(200));
        long countForUser = page.getContent().stream()
            .filter(s -> studentId.equals(s.get("userId"))).count();
        assertEquals(2, countForUser,
            "Admin list shows full subscription history — both Standard and Premium rows");
    }

    // ── Webhook handler (signature verification bypassed in test profile) ─────

    @Test
    void webhookHandler_createsNewPremiumSubscription() {
        long periodStart = Instant.now().getEpochSecond();
        long periodEnd = Instant.now().plusSeconds(30L * 24 * 3600).getEpochSecond();
        String stripeSubId = "sub_webhook_prem_" + UUID.randomUUID();

        String payload = """
            {
              "id": "evt_test_001",
              "object": "event",
              "type": "customer.subscription.created",
              "data": {
                "object": {
                  "id": "%s",
                  "object": "subscription",
                  "status": "active",
                  "metadata": { "userId": "%s", "planSlug": "premium" },
                  "items": {
                    "object": "list",
                    "data": [{
                      "id": "si_test",
                      "object": "subscription_item",
                      "price": { "id": "price_1TcoqgFzG9a7sokbHVjgHekE", "object": "price" }
                    }]
                  },
                  "current_period_start": %d,
                  "current_period_end": %d
                }
              }
            }
            """.formatted(stripeSubId, studentId, periodStart, periodEnd);

        // whsec_dummy in test profile → signature verification is skipped
        subscriptionService.handleWebhook(payload, "dummy-sig");

        Optional<Subscription> created = subscriptionRepository.findByStripeSubscriptionId(stripeSubId);
        assertTrue(created.isPresent(), "Subscription record should be created by webhook handler");
        assertEquals("premium", created.get().getPlan().getSlug());
        assertEquals(Subscription.SubscriptionStatus.ACTIVE, created.get().getStatus());
    }

    @Test
    void webhookHandler_updatesExistingSubscriptionPlanOnUpgrade() {
        // Start with Standard subscription already in DB
        subscriptionRepository.save(activeSub(standardPlan, "sub_existing_to_upgrade"));

        long periodStart = Instant.now().getEpochSecond();
        long periodEnd = Instant.now().plusSeconds(30L * 24 * 3600).getEpochSecond();

        // Stripe sends subscription.updated with Premium price ID
        String payload = """
            {
              "id": "evt_test_002",
              "object": "event",
              "type": "customer.subscription.updated",
              "data": {
                "object": {
                  "id": "sub_existing_to_upgrade",
                  "object": "subscription",
                  "status": "active",
                  "metadata": { "userId": "%s", "planSlug": "standard" },
                  "items": {
                    "object": "list",
                    "data": [{
                      "id": "si_test_updated",
                      "object": "subscription_item",
                      "price": { "id": "price_1TcoqgFzG9a7sokbHVjgHekE", "object": "price" }
                    }]
                  },
                  "current_period_start": %d,
                  "current_period_end": %d
                }
              }
            }
            """.formatted(studentId, periodStart, periodEnd);

        subscriptionService.handleWebhook(payload, "dummy-sig");

        Subscription updated = subscriptionRepository.findByStripeSubscriptionId("sub_existing_to_upgrade")
            .orElseThrow();
        assertEquals("premium", updated.getPlan().getSlug(),
            "Webhook should update the existing subscription's plan to Premium based on the new price ID");
    }
}
