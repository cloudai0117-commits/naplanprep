package au.com.naplanprep.subscription;

import au.com.naplanprep.admin.service.AdminService;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.exam.repository.ExamResultRepository;
import au.com.naplanprep.exam.repository.ExamSessionRepository;
import au.com.naplanprep.subscription.entity.Subscription;
import au.com.naplanprep.subscription.entity.Subscription.SubscriptionStatus;
import au.com.naplanprep.subscription.repository.SubscriptionRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * Unit tests verifying that the admin analytics API uses the correct ONE_TIME revenue model.
 * Asserts that:
 * - "mrr" / "Monthly Recurring Revenue" keys do NOT appear in any response
 * - Revenue is reported as totalRevenue (sum of one-time prices, not divided by 12)
 * - activePaidAccess is used instead of recurring subscriber count
 * - Labels are correct for AUD one-time purchases
 */
@ExtendWith(MockitoExtension.class)
class AdminAnalyticsTest {

    @Mock private UserRepository userRepository;
    @Mock private SubscriptionRepository subscriptionRepository;
    @Mock private QuestionRepository questionRepository;
    @Mock private ExamResultRepository examResultRepository;
    @Mock private ExamSessionRepository examSessionRepository;

    @InjectMocks
    private AdminService adminService;

    @BeforeEach
    void setUp() {
        // Provide safe defaults for all count calls
        lenient().when(userRepository.count()).thenReturn(10L);
        lenient().when(subscriptionRepository.countByStatus(SubscriptionStatus.ACTIVE)).thenReturn(3L);
        lenient().when(subscriptionRepository.countByStatus(SubscriptionStatus.TRIALING)).thenReturn(0L);
        lenient().when(subscriptionRepository.countByStatus(SubscriptionStatus.CANCELLED)).thenReturn(1L);
        lenient().when(subscriptionRepository.countByStatus(SubscriptionStatus.PAST_DUE)).thenReturn(0L);
        lenient().when(questionRepository.countByStatus(any())).thenReturn(0L);
        lenient().when(examSessionRepository.count()).thenReturn(0L);
        lenient().when(subscriptionRepository.calculateTotalRevenue()).thenReturn(BigDecimal.ZERO);
        lenient().when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(0L);
    }

    @Nested
    class DashboardRevenue {

        @Test
        void dashboard_does_not_contain_mrr_key() {
            when(subscriptionRepository.calculateTotalRevenue()).thenReturn(new BigDecimal("89.00"));
            when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(1L);

            Map<String, Object> dashboard = adminService.getDashboard();

            assertThat(dashboard).doesNotContainKey("mrr");
            assertThat(dashboard).doesNotContainKey("monthlyRecurringRevenue");
        }

        @Test
        void dashboard_contains_totalRevenue_key() {
            when(subscriptionRepository.calculateTotalRevenue()).thenReturn(new BigDecimal("89.00"));
            when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(1L);

            Map<String, Object> dashboard = adminService.getDashboard();

            assertThat(dashboard).containsKey("totalRevenue");
            assertThat(dashboard.get("totalRevenue")).isEqualTo(new BigDecimal("89.00"));
        }

        @Test
        void dashboard_contains_activePaidAccess_not_activeSubscribers() {
            when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(2L);

            Map<String, Object> dashboard = adminService.getDashboard();

            assertThat(dashboard).containsKey("activePaidAccess");
            assertThat(dashboard).doesNotContainKey("activeSubscribers");
            assertThat(dashboard.get("activePaidAccess")).isEqualTo(2L);
        }

        @Test
        void one_advanced_purchase_at_89_adds_to_total_revenue() {
            when(subscriptionRepository.calculateTotalRevenue()).thenReturn(new BigDecimal("89.00"));
            when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(1L);

            Map<String, Object> dashboard = adminService.getDashboard();

            assertThat((BigDecimal) dashboard.get("totalRevenue"))
                .isEqualByComparingTo(new BigDecimal("89.00"));
        }

        @Test
        void total_revenue_is_not_divided_by_12() {
            // For a one-time purchase of A$89.00, total revenue must be 89.00 — NOT 89.00/12 = 7.42
            BigDecimal oneTimePrice = new BigDecimal("89.00");
            when(subscriptionRepository.calculateTotalRevenue()).thenReturn(oneTimePrice);
            when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(1L);

            Map<String, Object> dashboard = adminService.getDashboard();

            BigDecimal reported = (BigDecimal) dashboard.get("totalRevenue");
            // Must NOT be the /12 equivalent
            assertThat(reported).isNotEqualByComparingTo(oneTimePrice.divide(BigDecimal.valueOf(12), 2, java.math.RoundingMode.HALF_UP));
            assertThat(reported).isEqualByComparingTo(oneTimePrice);
        }

        @Test
        void calculateTotalRevenue_is_called_not_calculateMRR() {
            when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(0L);

            adminService.getDashboard();

            verify(subscriptionRepository, times(1)).calculateTotalRevenue();
            // calculateMRR no longer exists on the repository — verified by compilation
        }
    }

    @Nested
    class SubscriptionAnalytics {

        @Test
        void analytics_does_not_contain_mrr_key() {
            when(subscriptionRepository.calculateTotalRevenue()).thenReturn(new BigDecimal("238.00"));
            when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(3L);

            Map<String, Object> analytics = adminService.getSubscriptionAnalytics();

            assertThat(analytics).doesNotContainKey("mrr");
            assertThat(analytics).doesNotContainKey("monthlyRecurringRevenue");
        }

        @Test
        void analytics_contains_totalRevenue_and_activePaidAccess() {
            when(subscriptionRepository.calculateTotalRevenue()).thenReturn(new BigDecimal("238.00"));
            when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(3L);

            Map<String, Object> analytics = adminService.getSubscriptionAnalytics();

            assertThat(analytics).containsKey("totalRevenue");
            assertThat(analytics).containsKey("activePaidAccess");
            assertThat(analytics.get("totalRevenue")).isEqualTo(new BigDecimal("238.00"));
            assertThat(analytics.get("activePaidAccess")).isEqualTo(3L);
        }

        @Test
        void ten_advanced_plus_five_premium_totals_correctly() {
            // 10 × A$89.00 + 5 × A$149.00 = A$890.00 + A$745.00 = A$1635.00
            when(subscriptionRepository.calculateTotalRevenue()).thenReturn(new BigDecimal("1635.00"));
            when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(15L);

            Map<String, Object> analytics = adminService.getSubscriptionAnalytics();

            assertThat((BigDecimal) analytics.get("totalRevenue"))
                .isEqualByComparingTo(new BigDecimal("1635.00"));
        }

        @Test
        void zero_revenue_when_no_active_paid_purchases() {
            when(subscriptionRepository.calculateTotalRevenue()).thenReturn(BigDecimal.ZERO);
            when(subscriptionRepository.countActivePaidEntitlements(any(Instant.class))).thenReturn(0L);

            Map<String, Object> analytics = adminService.getSubscriptionAnalytics();

            assertThat((BigDecimal) analytics.get("totalRevenue"))
                .isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(analytics.get("activePaidAccess")).isEqualTo(0L);
        }
    }
}
