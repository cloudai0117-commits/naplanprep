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
        var mrr = subscriptionRepository.calculateMRR();

        return Map.of(
            "totalUsers", totalUsers,
            "activeSubscribers", activeSubscribers,
            "trialUsers", trialUsers,
            "mrr", mrr != null ? mrr : 0,
            "publishedQuestions", publishedQuestions,
            "draftQuestions", draftQuestions,
            "totalExams", examSessionRepository.count()
        );
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

    public Map<String, Object> getSubscriptionAnalytics() {
        var mrr = subscriptionRepository.calculateMRR();
        long active = subscriptionRepository.countByStatus(
            au.com.naplanprep.subscription.entity.Subscription.SubscriptionStatus.ACTIVE);
        long cancelled = subscriptionRepository.countByStatus(
            au.com.naplanprep.subscription.entity.Subscription.SubscriptionStatus.CANCELLED);
        long pastDue = subscriptionRepository.countByStatus(
            au.com.naplanprep.subscription.entity.Subscription.SubscriptionStatus.PAST_DUE);

        double churnRate = (active + cancelled) > 0
            ? (cancelled * 100.0) / (active + cancelled) : 0;

        return Map.of(
            "mrr", mrr != null ? mrr : 0,
            "activeSubscriptions", active,
            "cancelledSubscriptions", cancelled,
            "pastDueSubscriptions", pastDue,
            "churnRate", Math.round(churnRate * 10.0) / 10.0
        );
    }

    public Map<String, Object> getContentStats() {
        var breakdown = questionRepository.countPublishedByYearLevelAndDomain();
        return Map.of(
            "breakdown", breakdown,
            "totalPublished", questionRepository.countByStatus(
                au.com.naplanprep.content.entity.Question.QuestionStatus.PUBLISHED),
            "totalDraft", questionRepository.countByStatus(
                au.com.naplanprep.content.entity.Question.QuestionStatus.DRAFT),
            "totalReview", questionRepository.countByStatus(
                au.com.naplanprep.content.entity.Question.QuestionStatus.REVIEW)
        );
    }
}
