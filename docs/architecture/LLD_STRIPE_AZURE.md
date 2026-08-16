# LLD — Stripe Payment Architecture on Azure
## NAPLANPrep — Stripe Integration Design for Azure Production

**Version:** 1.0  
**Date:** 2026-08-16  
**Status:** APPROVED FOR IMPLEMENTATION

---

## 1. Overview

NAPLANPrep uses Stripe for subscription billing. The application supports two subscription tiers (Advanced and Pro), each with corresponding Stripe Products and Prices. The Spring Boot backend (`SubscriptionService`, `PaymentController`) integrates with the Stripe Java SDK.

This document describes the Stripe architecture for the Azure production environment, covering secret management, webhook configuration, environment promotion, and resilience design.

---

## 2. Stripe Products and Prices

### Current Configuration (Do Not Modify Without Change Control)

| Tier | Stripe Product | Stripe Price ID | Billing |
|---|---|---|---|
| Advanced | NAPLAN Advanced | `${STRIPE_ADVANCED_PRICE_ID}` | Recurring (monthly or annual) |
| Pro | NAPLAN Pro | `${STRIPE_PRO_PRICE_ID}` | Recurring (monthly or annual) |

The price IDs are stored in Azure Key Vault and injected as environment variables. They must **never** be hardcoded in source code or configuration files.

### Entitlement Rules (Do Not Modify — Governed by V54–V379 Migrations)

Entitlement assignment (`subscriptions.tier`) is set by `SubscriptionService` based on the Stripe Price ID received in the webhook. The mapping is:

```
STRIPE_ADVANCED_PRICE_ID → tier = ADVANCED
STRIPE_PRO_PRICE_ID → tier = PRO
```

Entitlement rules are defined in the business logic and the Flyway data migrations. They are not part of this architecture document.

---

## 3. Secret Management

### All Stripe Credentials in Azure Key Vault

```
npp-prod-kv (Azure Key Vault)
  ├── stripe-secret-key          → sk_live_...
  ├── stripe-publishable-key     → pk_live_...
  ├── stripe-webhook-secret      → whsec_...
  ├── stripe-advanced-price-id   → price_...
  └── stripe-pro-price-id        → price_...
```

### Container App Secret References

| Env Var | Key Vault Secret | Purpose |
|---|---|---|
| `STRIPE_SECRET_KEY` | `stripe-secret-key` | Stripe API calls (checkout, customers, subscriptions) |
| `STRIPE_PUBLISHABLE_KEY` | `stripe-publishable-key` | Frontend Stripe.js initialization |
| `STRIPE_WEBHOOK_SECRET` | `stripe-webhook-secret` | Webhook signature verification |
| `STRIPE_ADVANCED_PRICE_ID` | `stripe-advanced-price-id` | Entitlement mapping |
| `STRIPE_PRO_PRICE_ID` | `stripe-pro-price-id` | Entitlement mapping |

### Access Control

The Container App's system-assigned managed identity has `Key Vault Secrets User` role on `npp-prod-kv`. No service principal passwords are used.

```
Container App (npp-prod-api)
  → System-Assigned Managed Identity
  → Role: Key Vault Secrets User
  → Scope: npp-prod-kv
  → Can read: stripe-*, db-*, redis-*, jwt-*
  → Cannot write, delete, or list other secrets
```

---

## 4. Webhook Architecture

### Webhook Flow

```
Stripe
  │  POST /v1/subscriptions/webhooks/stripe
  │  Stripe-Signature: t=...,v1=...
  ▼
Azure Front Door Premium (WAF)
  → Rate limit: 100 req/min/IP (P3-003 fix)
  → WAF inspection
  ▼
Container App (npp-prod-api)
  ├── RateLimitInterceptor (WEBHOOK bucket: 100/min/IP)
  ├── SubscriptionController.handleWebhook()
  │   └── Webhook.constructEvent(payload, sig, STRIPE_WEBHOOK_SECRET)
  │       ├── Signature valid → process event
  │       └── Signature invalid → return 400
  └── SubscriptionService.processEvent(event)
      ├── checkout.session.completed → create/activate subscription
      ├── invoice.payment_succeeded → renew subscription
      ├── invoice.payment_failed → mark subscription past_due
      └── customer.subscription.deleted → cancel subscription
```

### Stripe Webhook Signature Verification

The existing `SubscriptionService` implementation verifies Stripe's `Stripe-Signature` header using `Webhook.constructEvent()`. This is the correct approach:

```java
// Existing implementation (do not modify)
Webhook.constructEvent(payload, sigHeader, stripeWebhookSecret)
```

This protects against:
- Replay attacks (Stripe includes a timestamp, verified within tolerance)
- Forged webhooks (HMAC-SHA256 signature using webhook secret)

### Dev Mode Signature Skip (P1 Fix — Preserved)

```java
// From SubscriptionService — environment-gated skip for local dev
if (Arrays.asList(environment.getActiveProfiles()).contains("dev")) {
    // skip signature verification for local dev only
}
```

This is gated on the `dev` Spring profile. Production uses `SPRING_PROFILES_ACTIVE=prod` — the skip is never active in production.

### Webhook URL Configuration in Stripe

| Environment | Webhook URL | Profile |
|---|---|---|
| Development | `http://localhost:8080/v1/subscriptions/webhooks/stripe` (via Stripe CLI) | `dev` |
| UAT | `https://uat-api.naplanprep.com.au/v1/subscriptions/webhooks/stripe` | `uat` |
| Production | `https://api.naplanprep.com.au/v1/subscriptions/webhooks/stripe` | `prod` |

Each environment has its own Stripe webhook endpoint registered in the Stripe Dashboard with a separate webhook secret.

---

## 5. Events Handled

| Stripe Event | Handler Action |
|---|---|
| `checkout.session.completed` | Create subscription record; assign entitlement tier |
| `invoice.payment_succeeded` | Renew subscription; extend access period |
| `invoice.payment_failed` | Mark subscription `PAST_DUE`; trigger dunning email |
| `customer.subscription.deleted` | Cancel subscription; revoke entitlement |
| `customer.subscription.updated` | Update tier if price changed (plan upgrade/downgrade) |

Events not in this list are acknowledged (return 200) but not processed.

### Idempotency

Stripe may deliver the same event more than once. The `SubscriptionService` must be idempotent for each event type:

```java
// Existing pattern — check existing state before writing
Optional<Subscription> existing = subscriptionRepository
    .findByStripeSubscriptionId(subscriptionId);
if (existing.isPresent() && existing.get().getStatus() == ACTIVE) {
    return; // already processed — idempotent return
}
```

Verify this pattern is implemented for each event handler before going live.

---

## 6. Rate Limiting on Webhook Endpoint (P3-003)

The `RateLimitInterceptor` includes a `WEBHOOK` bucket:

```java
WEBHOOK(100, 60) // 100 requests per 60-second window, per IP
```

Stripe sends webhooks from known IP ranges. The rate limit (100/min) is set well above the expected Stripe delivery rate (typically 1–5/min in normal operation) but provides protection against malicious replay flood attacks from other IPs.

If the rate limit is hit by legitimate Stripe traffic (e.g., during a payment spike):
1. Stripe will retry with exponential backoff
2. The 429 response is returned before signature verification
3. Stripe will succeed on retry once the window resets (60 seconds)
4. No subscription data is lost — Stripe retries for 24+ hours

---

## 7. Payment Flow Architecture

### New Subscription (Checkout Flow)

```
Student Browser
  → POST /v1/subscriptions/checkout/session (with JWT auth)
  → SubscriptionService.createCheckoutSession()
  → Stripe API: checkout.sessions.create()
  ← Stripe returns { url: "https://checkout.stripe.com/..." }
  ← Backend returns { checkoutUrl }
  → Browser redirects to Stripe Checkout
  → Student completes payment on Stripe
  → Stripe redirects to https://naplanprep.com.au/payment/success
  → Stripe delivers webhook: checkout.session.completed
  → SubscriptionService creates subscription record in PostgreSQL
  → Student's next API call has entitlement (subscription in DB)
```

### Plan Upgrade/Downgrade Flow

```
Student (with existing subscription)
  → PUT /v1/subscriptions/upgrade (with JWT auth)
  → SubscriptionService.upgradePlan()
  → Stripe API: subscriptions.update() with new price_id
  ← Stripe returns updated subscription
  → SubscriptionService updates subscription tier in PostgreSQL
  → Stripe delivers webhook: customer.subscription.updated
  → (Idempotent check: already updated)
```

---

## 8. Azure Front Door WAF Rules for Stripe

Azure Front Door Premium WAF is configured in Prevention mode. No custom WAF rule blocks Stripe's IPs — the WAF inspects payloads but allows them through (Stripe signature verification at the application layer provides authenticity).

### Recommended WAF Custom Rule

To allow Stripe webhook payloads (which may contain JSON with unusual characters) to pass WAF inspection:

```json
{
  "name": "AllowStripeWebhook",
  "priority": 100,
  "ruleType": "MatchRule",
  "action": "Allow",
  "matchConditions": [
    {
      "matchVariable": "RequestUri",
      "operator": "EndsWith",
      "matchValue": ["/v1/subscriptions/webhooks/stripe"]
    }
  ]
}
```

This prevents the WAF from blocking legitimate Stripe webhook payloads that might trigger WAF rules (e.g., regex patterns in JSON bodies).

---

## 9. Resilience Design

### Stripe API Timeout Configuration

The Stripe Java SDK is configured with a request timeout:

```yaml
# application-prod.yml
app:
  stripe:
    connect-timeout: 5000    # 5 seconds
    read-timeout: 10000      # 10 seconds
```

If not already configurable via properties, initialize the `StripeClient` with explicit timeouts:

```java
// Recommended Stripe client initialization
Stripe.setConnectionTimeout(5_000);
Stripe.setReadTimeout(10_000);
```

### Idempotency Keys for Stripe API Calls

Use Stripe's idempotency key feature for checkout session creation and subscription updates to prevent duplicate charges on retry:

```java
// Example: Stripe API call with idempotency key
RequestOptions options = RequestOptions.builder()
    .setIdempotencyKey("checkout-" + userId + "-" + System.currentTimeMillis())
    .build();
Session session = Session.create(params, options);
```

### Webhook Retry Behaviour

Stripe retries failed webhook deliveries:
- Immediate retry
- Then with exponential backoff over 24 hours
- After 24 hours with no 2xx response, marks the event as failed

NAPLANPrep's webhook endpoint should always return:
- `200 OK` for successfully processed events
- `200 OK` for already-processed events (idempotent)
- `400 Bad Request` for invalid signatures (Stripe will not retry 4xx)
- `500 Internal Server Error` for transient errors (Stripe will retry)

> **Do not return 500 for events the application cannot handle** — return 200 and log a warning. Returning 500 for unknown events causes Stripe to retry indefinitely.

---

## 10. Monitoring

### Key Metrics

| Signal | Where | Alert Threshold |
|---|---|---|
| Webhook 400 rate | Application Insights | > 5% of webhook calls |
| Webhook 500 rate | Application Insights | > 1% of webhook calls |
| Payment success rate | Stripe Dashboard | < 95% |
| Subscription creation lag | Application Insights custom metric | > 30 seconds after checkout |
| Stripe API latency | Application Insights | > 5 seconds p99 |

### Stripe Dashboard

The Stripe Dashboard (dashboard.stripe.com) provides:
- Webhook delivery history and retry status
- Payment event log
- Customer and subscription state
- Failed payment list (dunning candidates)

A Stripe Radar alert should be configured to notify the team of unusual payment patterns.

### Application Insights Queries

```kusto
-- Webhook event types received
customEvents
| where name == "stripe_webhook_received"
| summarize count() by tostring(customDimensions["eventType"])
| order by count_ desc

-- Payment processing time
customMetrics
| where name == "stripe_checkout_session_create_ms"
| summarize p50=percentile(value, 50), p99=percentile(value, 99) by bin(timestamp, 5m)
| render timechart

-- Failed webhook signature verifications
traces
| where message contains "Webhook signature verification failed"
| order by timestamp desc
```

---

## 11. application-prod.yml Stripe Section

```yaml
app:
  stripe:
    secret-key: ${STRIPE_SECRET_KEY}
    publishable-key: ${STRIPE_PUBLISHABLE_KEY}
    webhook-secret: ${STRIPE_WEBHOOK_SECRET}
    advanced-price-id: ${STRIPE_ADVANCED_PRICE_ID}
    pro-price-id: ${STRIPE_PRO_PRICE_ID}
```

All values sourced from Azure Key Vault via Container App secret references. No Stripe credential ever appears in a YAML file committed to source control.

---

*This document governs the Stripe payment architecture for the Azure production deployment of NAPLANPrep. Changes to entitlement rules, Stripe price IDs, or webhook event handlers require a change control record.*
