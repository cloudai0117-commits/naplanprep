package au.com.naplanprep.subscription.service;

import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.config.AppProperties;
import au.com.naplanprep.exam.entity.PackageType;
import au.com.naplanprep.subscription.entity.Plan;
import au.com.naplanprep.subscription.entity.Subscription;
import au.com.naplanprep.subscription.repository.PlanRepository;
import au.com.naplanprep.subscription.repository.SubscriptionRepository;
import com.stripe.Stripe;
import com.stripe.exception.SignatureVerificationException;
import com.stripe.exception.StripeException;
import com.stripe.model.Event;
import com.stripe.model.checkout.Session;
import com.stripe.net.ApiResource;
import com.stripe.net.Webhook;
import com.stripe.param.CustomerCreateParams;
import com.stripe.param.checkout.SessionCreateParams;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
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
        String key = appProperties.getStripe().getSecretKey();
        if (key == null || key.isBlank()) {
            log.warn("STRIPE_NOT_CONFIGURED — STRIPE_SECRET_KEY is not set. "
                + "Payment features will be unavailable until the environment variable is configured.");
            return;
        }
        Stripe.apiKey = key;
        log.info("STRIPE_INITIALIZED — Stripe API client configured.");
    }

    // ─────────────────────────────────────────────────────────────
    // Checkout
    // ─────────────────────────────────────────────────────────────

    /**
     * Creates a one-time payment checkout session (Mode.PAYMENT, NOT Mode.SUBSCRIPTION).
     * Packages grant 1-year access from purchase date.
     * Price IDs are read from STRIPE_ADVANCED_PRICE_ID / STRIPE_PRO_PRICE_ID env vars via AppProperties.
     */
    @Transactional
    public String createCheckoutSession(UUID userId, String planSlug, String interval,
                                        String successUrl, String cancelUrl) {
        AppProperties.Stripe stripeConfig = appProperties.getStripe();
        String secretKey = stripeConfig.getSecretKey();
        if (secretKey == null || secretKey.isBlank()) {
            throw new BusinessException(
                "Payment unavailable: STRIPE_SECRET_KEY is not configured in this environment.");
        }

        Plan plan = planRepository.findBySlug(planSlug)
            .orElseThrow(() -> new ResourceNotFoundException("Plan", planSlug));

        User user = userRepository.findByIdWithProfile(userId)
            .orElseThrow(() -> new ResourceNotFoundException("User", userId.toString()));

        String priceId = resolvePriceId(planSlug, stripeConfig);
        if (priceId == null || priceId.isBlank()) {
            throw new BusinessException(
                "Payment unavailable: price ID not configured for plan '" + planSlug
                + "'. Set STRIPE_" + planSlug.toUpperCase() + "_PRICE_ID in the environment.");
        }
        log.info("PLAN_RESOLVED userId={} planSlug={} priceId=price_***", userId, planSlug);

        try {
            String customerId = ensureStripeCustomer(user);

            String resolvedSuccessUrl = successUrl != null ? successUrl
                : appProperties.getFrontendUrl() + "/dashboard?checkout=success&session_id={CHECKOUT_SESSION_ID}";
            String resolvedCancelUrl = cancelUrl != null ? cancelUrl
                : appProperties.getFrontendUrl() + "/pricing";

            var params = SessionCreateParams.builder()
                .setMode(SessionCreateParams.Mode.PAYMENT)
                .setCustomer(customerId)
                .setSuccessUrl(resolvedSuccessUrl)
                .setCancelUrl(resolvedCancelUrl)
                .addLineItem(SessionCreateParams.LineItem.builder()
                    .setPrice(priceId)
                    .setQuantity(1L)
                    .build())
                // Metadata on the Checkout Session — read by handleCheckoutCompleted via stripeSession.getMetadata()
                .putMetadata("userId", userId.toString())
                .putMetadata("planSlug", planSlug)
                // Also on PaymentIntent for any PaymentIntent-level webhook events
                .setPaymentIntentData(SessionCreateParams.PaymentIntentData.builder()
                    .putMetadata("userId", userId.toString())
                    .putMetadata("planSlug", planSlug)
                    .build())
                .build();

            Session session = Session.create(params);
            log.info("CHECKOUT_CREATED userId={} planSlug={} sessionId={} mode=PAYMENT",
                userId, planSlug, session.getId());
            return session.getUrl();

        } catch (StripeException e) {
            log.error("CHECKOUT_STRIPE_ERROR userId={} planSlug={} error={}", userId, planSlug, e.getMessage());
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
            log.error("Stripe portal error: {}", e.getMessage());
            throw new BusinessException("Failed to create portal session");
        }
    }

    public List<Plan> getPlans() {
        return planRepository.findByActiveTrueOrderByMonthlyPriceAsc();
    }

    public Optional<Subscription> getCurrentSubscription(UUID userId) {
        return subscriptionRepository.findFirstByUserIdAndStatusInOrderByCreatedAtDesc(userId,
            List.of(Subscription.SubscriptionStatus.ACTIVE, Subscription.SubscriptionStatus.TRIALING));
    }

    /**
     * Cancels a subscription.
     * For legacy recurring subscriptions: cancels via Stripe API.
     * For ONE_TIME purchases: there is no Stripe subscription to cancel — marks as CANCELLED locally only.
     */
    @Transactional
    public void cancelSubscription(UUID userId) {
        Subscription sub = subscriptionRepository.findFirstByUserIdAndStatusInOrderByCreatedAtDesc(userId,
            List.of(Subscription.SubscriptionStatus.ACTIVE, Subscription.SubscriptionStatus.TRIALING))
            .orElseThrow(() -> new BusinessException("No active subscription found"));

        if (sub.getPurchaseType() == Subscription.PurchaseType.ONE_TIME) {
            // ONE_TIME purchases have no Stripe Subscription object — cancel locally
            sub.setStatus(Subscription.SubscriptionStatus.CANCELLED);
            sub.setCancelledAt(Instant.now());
            subscriptionRepository.save(sub);
            syncUserTagsFromSubscriptions(userId);
            log.info("ONE_TIME subscription cancelled locally userId={} subId={}", userId, sub.getId());
            return;
        }

        // Legacy recurring subscription — cancel via Stripe
        if (sub.getStripeSubscriptionId() == null) {
            throw new BusinessException("No Stripe subscription ID found — cannot cancel");
        }

        try {
            com.stripe.model.Subscription stripeSub =
                com.stripe.model.Subscription.retrieve(sub.getStripeSubscriptionId());
            stripeSub.cancel();
        } catch (StripeException e) {
            log.error("Stripe cancel error userId={} error={}", userId, e.getMessage());
            throw new BusinessException("Failed to cancel subscription");
        }

        sub.setStatus(Subscription.SubscriptionStatus.CANCELLED);
        sub.setCancelledAt(Instant.now());
        subscriptionRepository.save(sub);
        syncUserTagsFromSubscriptions(userId);
    }

    // ─────────────────────────────────────────────────────────────
    // Webhook — PAYMENT model (ONE_TIME purchases)
    // ─────────────────────────────────────────────────────────────

    /**
     * Receives and dispatches a Stripe webhook event.
     *
     * TRANSACTION BOUNDARY: @Transactional here ensures that subscription creation and tag sync
     * are in the same DB transaction. If tag sync fails, the subscription row is also rolled back,
     * preventing partial entitlement state.
     *
     * SIGNATURE ERRORS: BusinessException("Invalid webhook signature") propagates to 400 response.
     * This is correct — Stripe should not retry invalid-signature events.
     *
     * PROCESSING ERRORS: Caught internally and logged. Controller returns 200 so Stripe does
     * not retry for transient processing failures. The idempotency guard prevents duplicate
     * entitlements on any retry that does succeed.
     */
    @Transactional
    public void handleWebhook(String payload, String sigHeader) {
        Event event = parseAndValidate(payload, sigHeader);

        log.info("WEBHOOK_RECEIVED eventType={} eventId={}", event.getType(), event.getId());

        try {
            switch (event.getType()) {
                // ONE_TIME purchase — synchronous card payment
                case "checkout.session.completed"          -> handleCheckoutCompleted(event);
                // ONE_TIME purchase — async payment (bank debit, BECS, SEPA etc.)
                case "checkout.session.async_payment_succeeded" -> handleCheckoutCompleted(event);
                // Async payment failed — log only; no entitlement action needed
                case "checkout.session.async_payment_failed"    -> handleAsyncPaymentFailed(event);
                // Legacy recurring subscription events — retained for pre-existing rows
                case "customer.subscription.created",
                     "customer.subscription.updated"      -> handleSubscriptionUpsert(event);
                case "customer.subscription.deleted"       -> handleSubscriptionDeleted(event);
                case "invoice.payment_failed"              -> handlePaymentFailed(event);
                default -> log.debug("WEBHOOK_IGNORED eventType={} eventId={}",
                    event.getType(), event.getId());
            }
        } catch (Exception e) {
            // Log the error but do not rethrow — return 200 so Stripe does not retry indefinitely.
            // The idempotency guard on stripe_payment_intent_id handles any eventual retry.
            log.error("WEBHOOK_PROCESSING_ERROR eventType={} eventId={} error={}",
                event.getType(), event.getId(), e.getMessage(), e);
        }
    }

    /**
     * Validates the Stripe signature and parses the event.
     * Throws BusinessException (→ 400) on invalid signature.
     */
    private Event parseAndValidate(String payload, String sigHeader) {
        String webhookSecret = appProperties.getStripe().getWebhookSecret();
        boolean skipVerification = webhookSecret == null
            || webhookSecret.isBlank()
            || webhookSecret.contains("placeholder")
            || webhookSecret.contains("dummy");
        try {
            if (skipVerification) {
                log.warn("WEBHOOK_SIGNATURE_SKIP — webhook secret not configured; "
                    + "signature validation disabled. Set app.stripe.webhook-secret in production.");
                return ApiResource.GSON.fromJson(payload, Event.class);
            }
            log.debug("WEBHOOK_SIGNATURE_VALID");
            return Webhook.constructEvent(payload, sigHeader, webhookSecret);
        } catch (SignatureVerificationException e) {
            log.warn("WEBHOOK_SIGNATURE_INVALID sigHeader={} error={}", sigHeader, e.getMessage());
            throw new BusinessException("Invalid webhook signature");
        } catch (Exception e) {
            log.error("WEBHOOK_PARSE_ERROR error={}", e.getMessage());
            throw new BusinessException("Invalid webhook payload");
        }
    }

    /**
     * Handles checkout.session.completed and checkout.session.async_payment_succeeded.
     *
     * CRITICAL: Only creates entitlement when payment_status == "paid".
     * - Card payments: payment_status is "paid" when checkout.session.completed fires. ✅
     * - 3DS (4000 0025 6000 0002): payment_status is "paid" after authentication. ✅
     * - Declined (4000 0000 0000 9995): Stripe does NOT fire completed event. ✅
     * - Async methods: payment_status is "unpaid" on session.completed; entitlement is deferred
     *   until checkout.session.async_payment_succeeded fires with payment_status == "paid". ✅
     */
    private void handleCheckoutCompleted(Event event) {
        var sessionOpt = event.getDataObjectDeserializer().getObject();
        if (sessionOpt.isEmpty()) {
            log.warn("CHECKOUT_COMPLETED_DESERIALIZE_EMPTY eventId={}", event.getId());
            return;
        }
        Session stripeSession = (Session) sessionOpt.get();

        // Only process PAYMENT mode sessions (one-time); ignore any legacy subscription checkouts
        if (!"payment".equals(stripeSession.getMode())) {
            log.debug("CHECKOUT_COMPLETED_MODE_SKIP mode={} sessionId={}",
                stripeSession.getMode(), stripeSession.getId());
            return;
        }

        // CRITICAL: Only grant entitlement once payment is confirmed.
        // "paid" = payment completed. "unpaid" = async method still pending.
        if (!"paid".equals(stripeSession.getPaymentStatus())) {
            log.info("CHECKOUT_COMPLETED_NOT_PAID payment_status={} sessionId={} — awaiting payment",
                stripeSession.getPaymentStatus(), stripeSession.getId());
            return;
        }

        String userId = stripeSession.getMetadata() != null
            ? stripeSession.getMetadata().get("userId") : null;
        String planSlug = stripeSession.getMetadata() != null
            ? stripeSession.getMetadata().get("planSlug") : null;

        if (userId == null || planSlug == null) {
            log.error("CHECKOUT_COMPLETED_MISSING_METADATA sessionId={} userId={} planSlug={}",
                stripeSession.getId(), userId, planSlug);
            return;
        }

        Plan plan = planRepository.findBySlug(planSlug).orElse(null);
        if (plan == null) {
            log.error("CHECKOUT_COMPLETED_UNKNOWN_PLAN planSlug={} sessionId={}",
                planSlug, stripeSession.getId());
            return;
        }

        UUID uid = UUID.fromString(userId);
        String paymentIntentId = stripeSession.getPaymentIntent();

        // Idempotency guard: prevent duplicate entitlement on webhook replay
        if (paymentIntentId != null) {
            boolean alreadyProcessed = subscriptionRepository
                .findByStripePaymentIntentId(paymentIntentId).isPresent();
            if (alreadyProcessed) {
                log.info("ENTITLEMENT_ALREADY_EXISTS paymentIntentId={} userId={} — skipping",
                    paymentIntentId, userId);
                return;
            }
        }

        Instant now = Instant.now();
        Subscription sub = Subscription.builder()
            .userId(uid)
            .plan(plan)
            .purchaseType(Subscription.PurchaseType.ONE_TIME)
            .status(Subscription.SubscriptionStatus.ACTIVE)
            .stripePaymentIntentId(paymentIntentId)
            .currentPeriodStart(now)
            .expiresAt(now.plusSeconds(365L * 24 * 60 * 60))
            .build();

        subscriptionRepository.save(sub);
        syncUserTagsFromSubscriptions(uid);

        log.info("ENTITLEMENT_CREATED userId={} planSlug={} subId={} expiresAt={} paymentIntentId={}",
            uid, planSlug, sub.getId(), sub.getExpiresAt(), paymentIntentId);
    }

    private void handleAsyncPaymentFailed(Event event) {
        var sessionOpt = event.getDataObjectDeserializer().getObject();
        if (sessionOpt.isEmpty()) return;
        Session stripeSession = (Session) sessionOpt.get();
        String userId = stripeSession.getMetadata() != null
            ? stripeSession.getMetadata().get("userId") : null;
        log.warn("ASYNC_PAYMENT_FAILED sessionId={} userId={} — no entitlement created",
            stripeSession.getId(), userId);
    }

    // ─────────────────────────────────────────────────────────────
    // Proactive sync — called on success redirect
    // ─────────────────────────────────────────────────────────────

    /**
     * Proactively fetches the Stripe checkout session and syncs the subscription
     * to the local DB. Called on the success redirect so the plan badge updates
     * immediately without waiting for the async webhook to arrive.
     *
     * CRITICAL: Only creates entitlement when payment_status == "paid" — same rule
     * as the webhook handler. Do not grant access from a redirect URL alone.
     */
    @Transactional
    public void syncFromCheckoutSession(UUID userId, String sessionId) {
        String secretKey = appProperties.getStripe().getSecretKey();
        if (secretKey == null || secretKey.isBlank() || secretKey.contains("placeholder")
                || secretKey.contains("dummy") || sessionId == null || sessionId.isBlank()) {
            return;
        }
        try {
            Session session = Session.retrieve(sessionId);

            if (!"complete".equals(session.getStatus())) {
                log.warn("SYNC_SESSION_NOT_COMPLETE sessionId={} status={}", sessionId, session.getStatus());
                return;
            }

            // CRITICAL: check payment_status — "complete" status alone is insufficient for PAYMENT mode
            if (!"paid".equals(session.getPaymentStatus())) {
                log.info("SYNC_SESSION_NOT_PAID sessionId={} payment_status={} — awaiting payment",
                    sessionId, session.getPaymentStatus());
                return;
            }

            if ("payment".equals(session.getMode())) {
                String paymentIntentId = session.getPaymentIntent();
                boolean already = paymentIntentId != null
                    && subscriptionRepository.findByStripePaymentIntentId(paymentIntentId).isPresent();
                if (!already) {
                    String planSlug = session.getMetadata() != null ? session.getMetadata().get("planSlug") : null;
                    Plan plan = planSlug != null ? planRepository.findBySlug(planSlug).orElse(null) : null;
                    if (plan != null) {
                        Instant now = Instant.now();
                        Subscription sub = Subscription.builder()
                            .userId(userId)
                            .plan(plan)
                            .purchaseType(Subscription.PurchaseType.ONE_TIME)
                            .status(Subscription.SubscriptionStatus.ACTIVE)
                            .stripePaymentIntentId(paymentIntentId)
                            .currentPeriodStart(now)
                            .expiresAt(now.plusSeconds(365L * 24 * 60 * 60))
                            .build();
                        subscriptionRepository.save(sub);
                        syncUserTagsFromSubscriptions(userId);
                        log.info("ENTITLEMENT_CREATED_VIA_SYNC userId={} planSlug={} sessionId={}",
                            userId, planSlug, sessionId);
                    }
                } else {
                    log.info("ENTITLEMENT_ALREADY_EXISTS_SYNC userId={} sessionId={}", userId, sessionId);
                }
            } else {
                // Legacy recurring subscription sync
                String stripeSubId = session.getSubscription();
                if (stripeSubId != null) {
                    com.stripe.model.Subscription stripeSub =
                        com.stripe.model.Subscription.retrieve(stripeSubId);
                    processStripeSubscription(userId, stripeSub);
                }
            }
            log.info("SYNC_CHECKOUT_COMPLETE sessionId={} userId={}", sessionId, userId);
        } catch (Exception e) {
            log.warn("SYNC_CHECKOUT_ERROR sessionId={} userId={} error={}", sessionId, userId, e.getMessage());
            // Best-effort sync — swallow errors so the controller always returns 200
        }
    }

    // ─────────────────────────────────────────────────────────────
    // Legacy recurring subscription handlers
    // ─────────────────────────────────────────────────────────────

    private void handleSubscriptionUpsert(Event event) {
        var stripeSubOpt = event.getDataObjectDeserializer().getObject();
        if (stripeSubOpt.isEmpty()) return;

        com.stripe.model.Subscription stripeSub = (com.stripe.model.Subscription) stripeSubOpt.get();
        String userId = stripeSub.getMetadata().get("userId");

        if (userId == null) {
            log.warn("SUBSCRIPTION_UPSERT_MISSING_USER_ID stripeSubId={}", stripeSub.getId());
            return;
        }

        processStripeSubscription(UUID.fromString(userId), stripeSub);
    }

    private void processStripeSubscription(UUID userId, com.stripe.model.Subscription stripeSub) {
        String planSlug = stripeSub.getMetadata() != null ? stripeSub.getMetadata().get("planSlug") : null;

        Plan plan = null;
        Subscription.BillingInterval billingInterval = Subscription.BillingInterval.MONTHLY;
        if (stripeSub.getItems() != null && !stripeSub.getItems().getData().isEmpty()) {
            String priceId = stripeSub.getItems().getData().get(0).getPrice().getId();
            Optional<Plan> byMonthly = planRepository.findByStripeMonthlyPriceId(priceId);
            if (byMonthly.isPresent()) {
                plan = byMonthly.get();
            } else {
                Optional<Plan> byAnnual = planRepository.findByStripeAnnualPriceId(priceId);
                if (byAnnual.isPresent()) {
                    plan = byAnnual.get();
                    billingInterval = Subscription.BillingInterval.ANNUAL;
                }
            }
        }

        if (plan == null && planSlug != null) {
            plan = planRepository.findBySlug(planSlug).orElse(null);
        }

        if (plan == null) {
            log.warn("SUBSCRIPTION_PLAN_NOT_FOUND stripeSubId={} planSlug={}", stripeSub.getId(), planSlug);
            return;
        }

        Subscription.SubscriptionStatus status = mapStripeStatus(stripeSub.getStatus());

        Optional<Subscription> existing = subscriptionRepository.findByStripeSubscriptionId(stripeSub.getId());
        Subscription sub;
        if (existing.isPresent()) {
            sub = existing.get();
        } else {
            sub = Subscription.builder()
                .userId(userId)
                .plan(plan)
                .stripeSubscriptionId(stripeSub.getId())
                .purchaseType(Subscription.PurchaseType.SUBSCRIPTION)
                .build();
        }

        sub.setStatus(status);
        sub.setPlan(plan);
        sub.setBillingInterval(billingInterval);
        sub.setCurrentPeriodStart(Instant.ofEpochSecond(stripeSub.getCurrentPeriodStart()));
        sub.setCurrentPeriodEnd(Instant.ofEpochSecond(stripeSub.getCurrentPeriodEnd()));
        if (stripeSub.getTrialEnd() != null) {
            sub.setTrialEnd(Instant.ofEpochSecond(stripeSub.getTrialEnd()));
        }

        subscriptionRepository.save(sub);
        syncUserTagsFromSubscriptions(userId);
    }

    private void handleSubscriptionDeleted(Event event) {
        var stripeSubOpt = event.getDataObjectDeserializer().getObject();
        if (stripeSubOpt.isEmpty()) return;
        com.stripe.model.Subscription stripeSub = (com.stripe.model.Subscription) stripeSubOpt.get();
        subscriptionRepository.findByStripeSubscriptionId(stripeSub.getId()).ifPresent(sub -> {
            sub.setStatus(Subscription.SubscriptionStatus.CANCELLED);
            sub.setCancelledAt(Instant.now());
            subscriptionRepository.save(sub);
            syncUserTagsFromSubscriptions(sub.getUserId());
            log.info("SUBSCRIPTION_CANCELLED stripeSubId={} userId={}", stripeSub.getId(), sub.getUserId());
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
            log.warn("PAYMENT_FAILED stripeSubId={} userId={}", stripeSubId, sub.getUserId());
        });
    }

    // ─────────────────────────────────────────────────────────────
    // Tag sync — cumulative tier model
    // ─────────────────────────────────────────────────────────────

    /**
     * Recomputes and persists the user's package tag set from all active entitled subscriptions.
     * Always includes FREE. PREMIUM plan includes FREE+ADVANCED+PREMIUM (cumulative).
     *
     * Called within the same @Transactional boundary as the subscription save (handleWebhook
     * is @Transactional) so both the subscription row and the user_tags update commit together.
     */
    private void syncUserTagsFromSubscriptions(UUID userId) {
        userRepository.findById(userId).ifPresent(user -> {
            Set<PackageType> tags = new HashSet<>();
            tags.add(PackageType.FREE);

            subscriptionRepository.findAllByUserIdAndStatusIn(userId,
                List.of(Subscription.SubscriptionStatus.ACTIVE, Subscription.SubscriptionStatus.TRIALING))
                .stream()
                .filter(Subscription::isEntitled)
                .forEach(sub -> tags.addAll(resolvePlanToPackageTiers(sub.getPlan())));

            user.setTags(tags);
            userRepository.save(user);
            log.info("TAGS_SYNCED userId={} tags={}", userId, tags);
        });
    }

    /**
     * Returns all package tiers the plan grants access to.
     * Tiers are cumulative: PREMIUM includes ADVANCED and FREE.
     * Plan slugs after V33 migration: basic, advanced, pro (family deactivated).
     *
     * FREEZE: Do not change these mappings without updating ENTITLEMENT_ACCEPTANCE_REPORT.md.
     *   basic / free → {FREE}          → 5 exams
     *   advanced     → {FREE, ADVANCED} → 30 exams
     *   pro / premium→ {FREE, ADVANCED, PREMIUM} → 80 exams
     */
    private Set<PackageType> resolvePlanToPackageTiers(Plan plan) {
        return switch (plan.getSlug().toLowerCase()) {
            case "premium", "pro" -> Set.of(PackageType.FREE, PackageType.ADVANCED, PackageType.PREMIUM);
            case "advanced"       -> Set.of(PackageType.FREE, PackageType.ADVANCED);
            case "free", "basic"  -> Set.of(PackageType.FREE);
            default               -> {
                log.warn("PLAN_SLUG_UNMAPPED slug={} — defaulting to FREE only", plan.getSlug());
                yield Set.of(PackageType.FREE);
            }
        };
    }

    // ─────────────────────────────────────────────────────────────
    // Helpers
    // ─────────────────────────────────────────────────────────────

    private String resolvePriceId(String planSlug, AppProperties.Stripe config) {
        return switch (planSlug.toLowerCase()) {
            case "advanced"          -> config.getAdvancedPriceId();
            case "pro", "premium"    -> config.getProPriceId();
            default                  -> null;
        };
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
            case "active"   -> Subscription.SubscriptionStatus.ACTIVE;
            case "past_due" -> Subscription.SubscriptionStatus.PAST_DUE;
            case "unpaid"   -> Subscription.SubscriptionStatus.UNPAID;
            default         -> Subscription.SubscriptionStatus.CANCELLED;
        };
    }
}
