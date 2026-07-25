package au.com.naplanprep.subscription.repository;

import au.com.naplanprep.subscription.entity.Subscription;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface SubscriptionRepository extends JpaRepository<Subscription, UUID> {

    /** Returns the most recent active/trialing subscription for a user.
     *  Uses findFirst to handle edge cases where duplicate rows exist. */
    Optional<Subscription> findFirstByUserIdAndStatusInOrderByCreatedAtDesc(UUID userId, List<Subscription.SubscriptionStatus> statuses);

    List<Subscription> findAllByUserIdAndStatusIn(UUID userId, List<Subscription.SubscriptionStatus> statuses);

    Optional<Subscription> findByStripeSubscriptionId(String stripeSubscriptionId);
    Page<Subscription> findAllByOrderByCreatedAtDesc(Pageable pageable);
    long countByStatus(Subscription.SubscriptionStatus status);

    @Query("SELECT COALESCE(SUM(CASE WHEN s.billingInterval = 'MONTHLY' THEN s.plan.monthlyPrice " +
        "ELSE s.plan.annualPrice / 12 END), 0) FROM Subscription s WHERE s.status = 'ACTIVE'")
    BigDecimal calculateMRR();
}
