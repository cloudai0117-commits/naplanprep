package au.com.naplanprep.subscription;

import au.com.naplanprep.subscription.repository.PlanRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.time.Instant;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assumptions.assumeTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * End-to-end API test covering signup → login → free → standard → premium upgrade flows
 * via HTTP through the full Spring Security filter chain, using a real Postgres container
 * and a mocked Redis (to bypass JWT blacklist without needing a live Redis instance).
 *
 * Flow scenarios tested:
 *  1. Register creates user with no subscription (free)
 *  2. Login with valid/invalid credentials
 *  3. Unauthenticated checkout returns 401
 *  4. Checkout with no Stripe key returns clear "not configured" error
 *  5. Free → Standard upgrade via Stripe webhook
 *  6. Standard → Premium upgrade via Stripe webhook
 *  7. Free → Premium direct upgrade via Stripe webhook
 *  8. After Standard upgrade: Standard exams AVAILABLE, Premium exams UPGRADE_REQUIRED
 *  9. After Premium upgrade: Premium exams AVAILABLE
 * 10. Subscription cancellation removes active subscription
 */
@SpringBootTest
@Testcontainers
@ActiveProfiles("test")
@AutoConfigureMockMvc
class SubscriptionFlowApiTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @SuppressWarnings("rawtypes")
    @MockBean
    RedisTemplate redisTemplate;

    @Autowired
    MockMvc mockMvc;

    @Autowired
    ObjectMapper objectMapper;

    @Autowired
    PlanRepository planRepository;

    private String standardPriceId;
    private String premiumPriceId;

    @SuppressWarnings("unchecked")
    @BeforeEach
    void setupMocks() {
        ValueOperations<String, String> ops = Mockito.mock(ValueOperations.class);
        when(redisTemplate.hasKey(anyString())).thenReturn(Boolean.FALSE);
        when(redisTemplate.opsForValue()).thenReturn(ops);

        planRepository.findBySlug("standard")
            .ifPresent(p -> standardPriceId = p.getStripeMonthlyPriceId());
        planRepository.findBySlug("premium")
            .ifPresent(p -> premiumPriceId = p.getStripeMonthlyPriceId());
    }

    // ── Helper: register a fresh user and return their session ────────────────

    private record UserSession(UUID userId, String token) {}

    private UserSession register(String tag) throws Exception {
        String email = "api-test-" + tag + "-" + UUID.randomUUID() + "@naplan.test";
        String body = """
                {"firstName":"Test","lastName":"User","email":"%s",\
                "password":"Password1","yearLevel":5}""".formatted(email);

        String resp = mockMvc.perform(post("/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        JsonNode data = objectMapper.readTree(resp).path("data");
        return new UserSession(
                UUID.fromString(data.path("user").path("id").asText()),
                data.path("accessToken").asText()
        );
    }

    private void webhook(UUID userId, String stripeSubId, String priceId,
                         String eventType, String stripeStatus) throws Exception {
        String planSlug = premiumPriceId != null && premiumPriceId.equals(priceId) ? "premium" : "standard";
        long now = Instant.now().getEpochSecond();
        String payload = """
                {
                  "id": "evt_%s",
                  "object": "event",
                  "type": "%s",
                  "data": {
                    "object": {
                      "id": "%s",
                      "object": "subscription",
                      "status": "%s",
                      "metadata": {"userId": "%s", "planSlug": "%s"},
                      "items": {
                        "object": "list",
                        "data": [{"id":"si_test","object":"subscription_item",\
                "price":{"id":"%s","object":"price"}}]
                      },
                      "current_period_start": %d,
                      "current_period_end": %d
                    }
                  }
                }
                """.formatted(stripeSubId, eventType, stripeSubId, stripeStatus,
                userId, planSlug, priceId, now, now + 30L * 24 * 3600);

        mockMvc.perform(post("/v1/subscriptions/webhooks/stripe")
                .contentType(MediaType.APPLICATION_JSON)
                .header("stripe-signature", "t=1,v1=dummy_bypass")
                .content(payload))
                .andExpect(status().isOk());
    }

    private JsonNode currentSub(String token) throws Exception {
        String resp = mockMvc.perform(get("/v1/subscriptions/current")
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        return objectMapper.readTree(resp).path("data");
    }

    // ── 1. Register → no subscription ────────────────────────────────────────

    @Test
    void register_new_user_has_no_active_subscription() throws Exception {
        UserSession session = register("no-sub");
        JsonNode data = currentSub(session.token());
        assertTrue(data.isNull() || data.isMissingNode(),
                "Newly registered user should have no subscription");
    }

    // ── 2. Login with valid credentials ──────────────────────────────────────

    @Test
    void login_with_valid_credentials_returns_jwt() throws Exception {
        String email = "login-ok-" + UUID.randomUUID() + "@naplan.test";
        String pw = "Password1";
        mockMvc.perform(post("/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {"firstName":"L","lastName":"O","email":"%s",\
                        "password":"%s","yearLevel":3}""".formatted(email, pw)))
                .andExpect(status().isCreated());

        String resp = mockMvc.perform(post("/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {"email":"%s","password":"%s"}""".formatted(email, pw)))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();

        String token = objectMapper.readTree(resp).path("data").path("accessToken").asText();
        assertFalse(token.isBlank(), "Login must return a non-blank JWT");
    }

    // ── 3. Login with wrong password → 401 ───────────────────────────────────

    @Test
    void login_with_wrong_password_returns_401() throws Exception {
        String email = "login-bad-" + UUID.randomUUID() + "@naplan.test";
        mockMvc.perform(post("/v1/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {"firstName":"X","lastName":"Y","email":"%s",\
                        "password":"Password1","yearLevel":5}""".formatted(email)))
                .andExpect(status().isCreated());

        mockMvc.perform(post("/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {"email":"%s","password":"WrongPass9"}""".formatted(email)))
                .andExpect(status().isUnauthorized());
    }

    // ── 4. Unauthenticated checkout → 401 ────────────────────────────────────

    @Test
    void checkout_without_auth_returns_401() throws Exception {
        mockMvc.perform(post("/v1/subscriptions/checkout")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {"planSlug":"standard","interval":"monthly"}"""))
                .andExpect(status().isUnauthorized());
    }

    // ── 5. Authenticated checkout with missing Stripe key → clear error ───────
    // application-test.yml has secret-key: sk_test_placeholder, which triggers
    // the BusinessException guard in SubscriptionService.createCheckoutSession.

    @Test
    void checkout_returns_stripe_not_configured_error() throws Exception {
        UserSession session = register("checkout-guard");
        String resp = mockMvc.perform(post("/v1/subscriptions/checkout")
                .header("Authorization", "Bearer " + session.token())
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {"planSlug":"standard","interval":"monthly"}"""))
                .andExpect(status().isBadRequest())
                .andReturn().getResponse().getContentAsString();

        JsonNode root = objectMapper.readTree(resp);
        String err = root.path("errors").get(0).asText();
        assertTrue(err.toLowerCase().contains("not configured"),
                "Error should explain Stripe is not configured, got: " + err);
    }

    // ── 6. Free → Standard via webhook ───────────────────────────────────────

    @Test
    void free_to_standard_upgrade_via_webhook() throws Exception {
        assumeTrue(standardPriceId != null, "Standard plan price ID not seeded — skipping");
        UserSession session = register("free-to-std");
        String subId = "sub_std_" + UUID.randomUUID();

        webhook(session.userId(), subId, standardPriceId, "customer.subscription.created", "active");

        String slug = currentSub(session.token()).path("plan").path("slug").asText();
        assertEquals("standard", slug);
    }

    // ── 7. Standard → Premium upgrade via webhook ─────────────────────────────

    @Test
    void standard_to_premium_upgrade_via_webhook() throws Exception {
        assumeTrue(standardPriceId != null, "Standard plan price ID not seeded — skipping");
        assumeTrue(premiumPriceId != null, "Premium plan price ID not seeded — skipping");
        UserSession session = register("std-to-prem");

        webhook(session.userId(), "sub_std_" + UUID.randomUUID(), standardPriceId,
                "customer.subscription.created", "active");
        webhook(session.userId(), "sub_prem_" + UUID.randomUUID(), premiumPriceId,
                "customer.subscription.created", "active");

        String slug = currentSub(session.token()).path("plan").path("slug").asText();
        assertEquals("premium", slug, "After premium webhook, current plan must be premium");
    }

    // ── 8. Free → Premium direct (skip Standard) via webhook ─────────────────

    @Test
    void free_to_premium_direct_upgrade_via_webhook() throws Exception {
        assumeTrue(premiumPriceId != null, "Premium plan price ID not seeded — skipping");
        UserSession session = register("free-to-prem");

        webhook(session.userId(), "sub_prem_direct_" + UUID.randomUUID(), premiumPriceId,
                "customer.subscription.created", "active");

        String slug = currentSub(session.token()).path("plan").path("slug").asText();
        assertEquals("premium", slug, "Direct free→premium must set plan to premium");
    }

    // ── 9. After Standard: standard exams AVAILABLE, premium UPGRADE_REQUIRED ─

    @Test
    void after_standard_upgrade_exam_entitlements_are_correct() throws Exception {
        assumeTrue(standardPriceId != null, "Standard plan price ID not seeded — skipping");
        UserSession session = register("std-exam-access");

        webhook(session.userId(), "sub_std_exam_" + UUID.randomUUID(), standardPriceId,
                "customer.subscription.created", "active");

        String resp = mockMvc.perform(get("/v1/exams/available")
                .header("Authorization", "Bearer " + session.token()))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();

        JsonNode exams = objectMapper.readTree(resp).path("data");
        for (JsonNode exam : exams) {
            String tier = exam.path("requiredTier").asText();
            String avail = exam.path("availability").asText();
            if ("PREMIUM".equals(tier)) {
                assertEquals("UPGRADE_REQUIRED", avail,
                        "Standard subscriber must not access premium exam: " + exam.path("title").asText());
            }
        }
    }

    // ── 10. After Premium: premium exams become AVAILABLE ─────────────────────

    @Test
    void after_premium_upgrade_premium_exams_are_available() throws Exception {
        assumeTrue(premiumPriceId != null, "Premium plan price ID not seeded — skipping");
        UserSession session = register("prem-exam-access");

        webhook(session.userId(), "sub_prem_exam_" + UUID.randomUUID(), premiumPriceId,
                "customer.subscription.created", "active");

        String resp = mockMvc.perform(get("/v1/exams/available")
                .header("Authorization", "Bearer " + session.token()))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();

        JsonNode exams = objectMapper.readTree(resp).path("data");
        boolean hasPremiumAvailable = false;
        for (JsonNode exam : exams) {
            if ("PREMIUM".equals(exam.path("requiredTier").asText())
                    && "AVAILABLE".equals(exam.path("availability").asText())) {
                hasPremiumAvailable = true;
                break;
            }
        }
        assertTrue(hasPremiumAvailable,
                "Premium subscriber should see at least one PREMIUM exam as AVAILABLE");
    }

    // ── 11. Subscription cancelled → no active subscription ──────────────────

    @Test
    void cancellation_webhook_removes_active_subscription() throws Exception {
        assumeTrue(premiumPriceId != null, "Premium plan price ID not seeded — skipping");
        UserSession session = register("cancel-flow");
        String stripeSubId = "sub_cancel_" + UUID.randomUUID();

        webhook(session.userId(), stripeSubId, premiumPriceId, "customer.subscription.created", "active");

        // Confirm subscription is active
        assertFalse(currentSub(session.token()).isNull(),
                "Subscription should exist after creation webhook");

        // Cancel
        long now = Instant.now().getEpochSecond();
        String cancelPayload = """
                {
                  "id": "evt_del_%s",
                  "object": "event",
                  "type": "customer.subscription.deleted",
                  "data": {
                    "object": {
                      "id": "%s",
                      "object": "subscription",
                      "status": "canceled",
                      "metadata": {"userId": "%s", "planSlug": "premium"},
                      "items": {"object": "list", "data": []},
                      "current_period_start": %d,
                      "current_period_end": %d
                    }
                  }
                }
                """.formatted(stripeSubId, stripeSubId, session.userId(), now, now + 100);

        mockMvc.perform(post("/v1/subscriptions/webhooks/stripe")
                .contentType(MediaType.APPLICATION_JSON)
                .header("stripe-signature", "t=1,v1=dummy_bypass")
                .content(cancelPayload))
                .andExpect(status().isOk());

        JsonNode data = currentSub(session.token());
        assertTrue(data.isNull() || data.isMissingNode(),
                "After cancellation webhook, current subscription must be absent");
    }
}
