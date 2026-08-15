package au.com.naplanprep.admin.service;

import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.exam.repository.ExamResultRepository;
import au.com.naplanprep.exam.repository.ExamSessionRepository;
import au.com.naplanprep.subscription.repository.SubscriptionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final UserRepository userRepository;
    private final SubscriptionRepository subscriptionRepository;
    private final QuestionRepository questionRepository;
    private final ExamResultRepository examResultRepository;
    private final ExamSessionRepository examSessionRepository;

    public Map<String, Object> getDashboard() {
        long totalUsers = userRepository.count();
        long activeSubscribers = subscriptionRepository.countByStatus(
            au.com.naplanprep.subscription.entity.Subscription.SubscriptionStatus.ACTIVE);
        long trialUsers = subscriptionRepository.countByStatus(
            au.com.naplanprep.subscription.entity.Subscription.SubscriptionStatus.TRIALING);
        long publishedQuestions = questionRepository.countByStatus(
            au.com.naplanprep.content.entity.Question.QuestionStatus.PUBLISHED);
        long draftQuestions = questionRepository.countByStatus(
            au.com.naplanprep.content.entity.Question.QuestionStatus.DRAFT);
        var totalRevenue = subscriptionRepository.calculateTotalRevenue();
        long activePaidEntitlements = subscriptionRepository.countActivePaidEntitlements(Instant.now());

        Map<String, Object> dashboard = new LinkedHashMap<>();
        dashboard.put("totalUsers", totalUsers);
        dashboard.put("activePaidAccess", activePaidEntitlements);
        dashboard.put("trialUsers", trialUsers);
        dashboard.put("totalRevenue", totalRevenue != null ? totalRevenue : 0);
        dashboard.put("publishedQuestions", publishedQuestions);
        dashboard.put("draftQuestions", draftQuestions);
        dashboard.put("totalExams", examSessionRepository.count());
        return dashboard;
    }

    public Page<User> getUsers(String search, Pageable pageable) {
        return userRepository.searchUsers(search, pageable);
    }

    public User getUserById(UUID id) {
        return userRepository.findByIdWithProfile(id)
            .orElseThrow(() -> new ResourceNotFoundException("User", id.toString()));
    }

    @Transactional
    public User updateUserStatus(UUID id, User.UserStatus newStatus) {
        User user = userRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("User", id.toString()));
        user.setStatus(newStatus);
        return userRepository.save(user);
    }

    public Page<Map<String, Object>> getSubscriptionList(Pageable pageable) {
        return subscriptionRepository.findAllByOrderByCreatedAtDesc(pageable).map(sub -> {
            Map<String, Object> dto = new LinkedHashMap<>();
            dto.put("id", sub.getId());
            dto.put("userId", sub.getUserId());
            dto.put("planName", sub.getPlan().getName());
            dto.put("planSlug", sub.getPlan().getSlug());
            dto.put("status", sub.getStatus());
            dto.put("purchaseType", sub.getPurchaseType());
            dto.put("billingInterval", sub.getBillingInterval());
            dto.put("monthlyPrice", sub.getPlan().getMonthlyPrice());
            dto.put("annualPrice", sub.getPlan().getAnnualPrice());
            dto.put("stripeSubscriptionId", sub.getStripeSubscriptionId());
            dto.put("expiresAt", sub.getExpiresAt());
            dto.put("currentPeriodEnd", sub.getCurrentPeriodEnd());
            dto.put("trialEnd", sub.getTrialEnd());
            dto.put("cancelledAt", sub.getCancelledAt());
            dto.put("createdAt", sub.getCreatedAt());
            userRepository.findByIdWithProfile(sub.getUserId()).ifPresent(user -> {
                dto.put("userEmail", user.getEmail());
                var profile = user.getProfile();
                if (profile != null) {
                    String name = (profile.getFirstName() != null ? profile.getFirstName() : "") +
                                  (profile.getLastName() != null ? " " + profile.getLastName() : "");
                    dto.put("userName", name.trim());
                }
            });
            return dto;
        });
    }

    public Map<String, Object> getSubscriptionAnalytics() {
        var totalRevenue = subscriptionRepository.calculateTotalRevenue();
        long activePaidAccess = subscriptionRepository.countActivePaidEntitlements(Instant.now());
        long active = subscriptionRepository.countByStatus(
            au.com.naplanprep.subscription.entity.Subscription.SubscriptionStatus.ACTIVE);
        long cancelled = subscriptionRepository.countByStatus(
            au.com.naplanprep.subscription.entity.Subscription.SubscriptionStatus.CANCELLED);
        long pastDue = subscriptionRepository.countByStatus(
            au.com.naplanprep.subscription.entity.Subscription.SubscriptionStatus.PAST_DUE);

        double churnRate = (active + cancelled) > 0
            ? (cancelled * 100.0) / (active + cancelled) : 0;

        Map<String, Object> analytics = new LinkedHashMap<>();
        analytics.put("totalRevenue", totalRevenue != null ? totalRevenue : 0);
        analytics.put("activePaidAccess", activePaidAccess);
        analytics.put("activeSubscriptions", active);
        analytics.put("cancelledSubscriptions", cancelled);
        analytics.put("pastDueSubscriptions", pastDue);
        analytics.put("churnRate", Math.round(churnRate * 10.0) / 10.0);
        return analytics;
    }

    public Map<String, Object> getContentStats() {
        var breakdown = questionRepository.countPublishedByYearLevelAndDomain();
        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("breakdown", breakdown);
        stats.put("totalPublished", questionRepository.countByStatus(
            au.com.naplanprep.content.entity.Question.QuestionStatus.PUBLISHED));
        stats.put("totalDraft", questionRepository.countByStatus(
            au.com.naplanprep.content.entity.Question.QuestionStatus.DRAFT));
        stats.put("totalReview", questionRepository.countByStatus(
            au.com.naplanprep.content.entity.Question.QuestionStatus.REVIEW));
        return stats;
    }
}
