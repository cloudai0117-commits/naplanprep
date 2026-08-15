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

    Optional<Subscription> findByStripePaymentIntentId(String stripePaymentIntentId);

    Page<Subscription> findAllByOrderByCreatedAtDesc(Pageable pageable);
    long countByStatus(Subscription.SubscriptionStatus status);

    /** Total revenue from all active one-time purchases (plan.monthlyPrice stores the one-time price). */
    @Query("SELECT COALESCE(SUM(s.plan.monthlyPrice), 0) FROM Subscription s " +
        "WHERE s.purchaseType = 'ONE_TIME' AND s.status = 'ACTIVE'")
    BigDecimal calculateTotalRevenue();

    /** Count of active one-time purchases whose access has not yet expired. */
    @Query("SELECT COUNT(s) FROM Subscription s " +
        "WHERE s.purchaseType = 'ONE_TIME' AND s.status = 'ACTIVE' AND s.expiresAt > :now")
    long countActivePaidEntitlements(@Param("now") java.time.Instant now);
}
