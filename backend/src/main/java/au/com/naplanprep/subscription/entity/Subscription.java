package au.com.naplanprep.subscription.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "subscriptions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Subscription {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false)
    private UUID userId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "plan_id", nullable = false)
    private Plan plan;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private SubscriptionStatus status = SubscriptionStatus.ACTIVE;

    /**
     * ONE_TIME: single payment grants access for 1 year from purchase date.
     * SUBSCRIPTION is retained for any legacy rows only — new purchases MUST use ONE_TIME.
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "purchase_type", nullable = false)
    @Builder.Default
    private PurchaseType purchaseType = PurchaseType.ONE_TIME;

    /**
     * Retained for legacy subscription rows migrated from the old billing model.
     * New ONE_TIME purchases do not use this field — use expiresAt instead.
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private BillingInterval billingInterval = BillingInterval.MONTHLY;

    /** Legacy Stripe subscription ID (recurring billing). Null for ONE_TIME purchases. */
    private String stripeSubscriptionId;

    /** Stripe PaymentIntent ID for one-time purchase confirmation. */
    @Column(name = "stripe_payment_intent_id", length = 100)
    private String stripePaymentIntentId;

    private Instant currentPeriodStart;
    private Instant currentPeriodEnd;
    private Instant trialEnd;
    private Instant cancelledAt;

    /**
     * Access expiry date for ONE_TIME purchases.
     * Set to purchaseDate + 365 days at checkout completion.
     * Null for legacy subscription rows (use currentPeriodEnd for those).
     */
    @Column(name = "expires_at")
    private Instant expiresAt;

    @CreationTimestamp
    private Instant createdAt;

    @UpdateTimestamp
    private Instant updatedAt;

    // ─────────────────────────────────────────────────────────────

    public enum SubscriptionStatus {
        TRIALING, ACTIVE, PAST_DUE, CANCELLED, UNPAID
    }

    /**
     * BillingInterval is kept for backward compatibility with legacy rows.
     * New purchases are always ONE_TIME; this enum is no longer used for new records.
     */
    public enum BillingInterval {
        MONTHLY, ANNUAL
    }

    public enum PurchaseType {
        /** One-time payment; access valid until expiresAt. */
        ONE_TIME,
        /** Legacy recurring subscription; use currentPeriodEnd for entitlement check. */
        SUBSCRIPTION
    }

    // ─────────────────────────────────────────────────────────────
    // Entitlement check
    // ─────────────────────────────────────────────────────────────

    /**
     * Returns true if this subscription currently grants content access.
     * For ONE_TIME: checks status == ACTIVE and expiresAt has not passed.
     * For legacy SUBSCRIPTION: checks status == ACTIVE and currentPeriodEnd.
     */
    public boolean isEntitled() {
        if (status != SubscriptionStatus.ACTIVE) {
            return false;
        }
        if (purchaseType == PurchaseType.ONE_TIME) {
            return expiresAt != null && Instant.now().isBefore(expiresAt);
        }
        return currentPeriodEnd != null && Instant.now().isBefore(currentPeriodEnd);
    }
}
