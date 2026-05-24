package au.com.naplanprep.subscription.service;

import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.config.AppProperties;
import au.com.naplanprep.subscription.entity.Plan;
import au.com.naplanprep.subscription.entity.Subscription;
import au.com.naplanprep.subscription.repository.PlanRepository;
import au.com.naplanprep.subscription.repository.SubscriptionRepository;
import com.stripe.Stripe;
import com.stripe.exception.SignatureVerificationException;
import com.stripe.exception.StripeException;
import com.stripe.model.Event;
import com.stripe.model.checkout.Session;
import com.stripe.net.Webhook;
import com.stripe.param.CustomerCreateParams;
import com.stripe.param.checkout.SessionCreateParams;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class SubscriptionService {

    private final PlanRepository planRepository;
    private final SubscriptionRepository subscriptionRepository;
    private final UserRepository userRepository;
    private final AppProperties appProperties;

    @PostConstruct
    public void init() {
        Stripe.apiKey = appProperties.getStripe().getSecretKey();
    }

    public List<Plan> getPlans() {
        return planRepository.findByActiveTrueOrderByMonthlyPriceAsc();
    }

    @Transactional
    public String createCheckoutSession(UUID userId, String planSlug, String interval, String successUrl, String cancelUrl) {
        Plan plan = planRepository.findBySlug(planSlug)
            .orElseThrow(() -> new ResourceNotFoundException("Plan", planSlug));

        User user = userRepository.findByIdWithProfile(userId)
            .orElseThrow(() -> new ResourceNotFoundException("User", userId.toString()));

        String priceId = "annual".equals(interval) ? plan.getStripeAnnualPriceId() : plan.getStripeMonthlyPriceId();
        if (priceId == null || priceId.contains("placeholder")) {
            throw new BusinessException("Payment not configured for this plan. Please contact support.");
        }

        try {
            String customerId = ensureStripeCustomer(user);

            var params = SessionCreateParams.builder()
                .setMode(SessionCreateParams.Mode.SUBSCRIPTION)
                .setCustomer(customerId)
                .setSuccessUrl(successUrl != null ? successUrl : appProperties.getFrontendUrl() + "/dashboard?checkout=success")
                .setCancelUrl(cancelUrl != null ? cancelUrl : appProperties.getFrontendUrl() + "/pricing")
                .addLineItem(SessionCreateParams.LineItem.builder()
                    .setPrice(priceId)
                    .setQuantity(1L)
                    .build())
                .setSubscriptionData(SessionCreateParams.SubscriptionData.builder()
                    .setTrialPeriodDays("premium".equals(planSlug) ? 7L : null)
                    .putMetadata("userId", userId.toString())
                    .putMetadata("planSlug", planSlug)
                    .build())
                .build();

            Session session = Session.create(params);
            return session.getUrl();
        } catch (StripeException e) {
            log.error("Stripe checkout error", e);
            throw new BusinessException("Failed to create checkout session: " + e.getMessage());
        }
    }

    @Transactional
    public String createPortalSession(UUID userId, String returnUrl) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new ResourceNotFoundException("User", userId.toString()));

        if (user.getStripeCustomerId() == null) {
            throw new BusinessException("No billing account found");
        }

        try {
            var params = com.stripe.param.billingportal.SessionCreateParams.builder()
                .setCustomer(user.getStripeCustomerId())
                .setReturnUrl(returnUrl != null ? returnUrl : appProperties.getFrontendUrl() + "/settings")
                .build();

            com.stripe.model.billingportal.Session session =
                com.stripe.model.billingportal.Session.create(params);
            return session.getUrl();
        } catch (StripeException e) {
            log.error("Stripe portal error", e);
            throw new BusinessException("Failed to create portal session");
        }
    }

    public Optional<Subscription> getCurrentSubscription(UUID userId) {
        return subscriptionRepository.findByUserIdAndStatusIn(userId,
            List.of(Subscription.SubscriptionStatus.ACTIVE, Subscription.SubscriptionStatus.TRIALING));
    }

    @Transactional
    public void cancelSubscription(UUID userId) {
        Subscription sub = subscriptionRepository.findByUserIdAndStatusIn(userId,
            List.of(Subscription.SubscriptionStatus.ACTIVE, Subscription.SubscriptionStatus.TRIALING))
            .orElseThrow(() -> new BusinessException("No active subscription found"));

        try {
            com.stripe.model.Subscription stripeSub =
                com.stripe.model.Subscription.retrieve(sub.getStripeSubscriptionId());
            stripeSub.cancel();
        } catch (StripeException e) {
            log.error("Stripe cancel error", e);
            throw new BusinessException("Failed to cancel subscription");
        }

        sub.setStatus(Subscription.SubscriptionStatus.CANCELLED);
        sub.setCancelledAt(Instant.now());
        subscriptionRepository.save(sub);
    }

    @Transactional
    public void handleWebhook(String payload, String sigHeader) {
        Event event;
        try {
            event = Webhook.constructEvent(payload, sigHeader, appProperties.getStripe().getWebhookSecret());
        } catch (SignatureVerificationException e) {
            throw new BusinessException("Invalid webhook signature");
        }

        log.info("Stripe webhook: {}", event.getType());

        switch (event.getType()) {
            case "customer.subscription.created", "customer.subscription.updated" -> handleSubscriptionUpsert(event);
            case "customer.subscription.deleted" -> handleSubscriptionDeleted(event);
            case "invoice.payment_failed" -> handlePaymentFailed(event);
            default -> log.debug("Unhandled webhook event: {}", event.getType());
        }
    }

    private void handleSubscriptionUpsert(Event event) {
        var stripeSubOpt = event.getDataObjectDeserializer().getObject();
        if (stripeSubOpt.isEmpty()) return;

        com.stripe.model.Subscription stripeSub = (com.stripe.model.Subscription) stripeSubOpt.get();
        String userId = stripeSub.getMetadata().get("userId");
        String planSlug = stripeSub.getMetadata().get("planSlug");

        if (userId == null || planSlug == null) {
            log.warn("Missing metadata in subscription: {}", stripeSub.getId());
            return;
        }

        Plan plan = planRepository.findBySlug(planSlug).orElse(null);
        if (plan == null) return;

        UUID userUUID = UUID.fromString(userId);
        Subscription.SubscriptionStatus status = mapStripeStatus(stripeSub.getStatus());

        Optional<Subscription> existing = subscriptionRepository.findByStripeSubscriptionId(stripeSub.getId());
        Subscription sub;
        if (existing.isPresent()) {
            sub = existing.get();
        } else {
            sub = Subscription.builder()
                .userId(userUUID)
                .plan(plan)
                .stripeSubscriptionId(stripeSub.getId())
                .build();
        }

        sub.setStatus(status);
        sub.setPlan(plan);
        sub.setCurrentPeriodStart(Instant.ofEpochSecond(stripeSub.getCurrentPeriodStart()));
        sub.setCurrentPeriodEnd(Instant.ofEpochSecond(stripeSub.getCurrentPeriodEnd()));
        if (stripeSub.getTrialEnd() != null) {
            sub.setTrialEnd(Instant.ofEpochSecond(stripeSub.getTrialEnd()));
        }

        subscriptionRepository.save(sub);
    }

    private void handleSubscriptionDeleted(Event event) {
        var stripeSubOpt = event.getDataObjectDeserializer().getObject();
        if (stripeSubOpt.isEmpty()) return;
        com.stripe.model.Subscription stripeSub = (com.stripe.model.Subscription) stripeSubOpt.get();
        subscriptionRepository.findByStripeSubscriptionId(stripeSub.getId()).ifPresent(sub -> {
            sub.setStatus(Subscription.SubscriptionStatus.CANCELLED);
            sub.setCancelledAt(Instant.now());
            subscriptionRepository.save(sub);
        });
    }

    private void handlePaymentFailed(Event event) {
        var invoiceOpt = event.getDataObjectDeserializer().getObject();
        if (invoiceOpt.isEmpty()) return;
        com.stripe.model.Invoice invoice = (com.stripe.model.Invoice) invoiceOpt.get();
        String stripeSubId = invoice.getSubscription();
        if (stripeSubId == null) return;

        subscriptionRepository.findByStripeSubscriptionId(stripeSubId).ifPresent(sub -> {
            sub.setStatus(Subscription.SubscriptionStatus.PAST_DUE);
            subscriptionRepository.save(sub);
            log.warn("Payment failed for subscription: {}, user: {}", stripeSubId, sub.getUserId());
        });
    }

    private String ensureStripeCustomer(User user) throws StripeException {
        if (user.getStripeCustomerId() != null) {
            return user.getStripeCustomerId();
        }

        var profile = user.getProfile();
        String name = profile != null
            ? (profile.getFirstName() + " " + (profile.getLastName() != null ? profile.getLastName() : "")).trim()
            : user.getEmail();

        var params = CustomerCreateParams.builder()
            .setEmail(user.getEmail())
            .setName(name)
            .putMetadata("userId", user.getId().toString())
            .build();

        com.stripe.model.Customer customer = com.stripe.model.Customer.create(params);
        user.setStripeCustomerId(customer.getId());
        userRepository.save(user);
        return customer.getId();
    }

    private Subscription.SubscriptionStatus mapStripeStatus(String stripeStatus) {
        return switch (stripeStatus) {
            case "trialing" -> Subscription.SubscriptionStatus.TRIALING;
            case "active" -> Subscription.SubscriptionStatus.ACTIVE;
            case "past_due" -> Subscription.SubscriptionStatus.PAST_DUE;
            case "unpaid" -> Subscription.SubscriptionStatus.UNPAID;
            default -> Subscription.SubscriptionStatus.CANCELLED;
        };
    }
}
