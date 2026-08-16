# Stripe Migration Runbook
## NAPLANPrep — Railway/Vercel Stripe Config → Azure Production

**Version:** 1.0  
**Date:** 2026-08-16  
**Status:** APPROVED FOR IMPLEMENTATION

> **DANGER ANNOTATION:** All commands marked `DANGER — PRODUCTION` affect live Stripe configuration, live payments, or live services. These must only be executed by an authorised engineer with a second engineer as witness. Stripe configuration errors can result in real payment failures.

---

## 1. Overview

### What Changes in This Migration

| Item | Before (Railway/Vercel) | After (Azure) |
|---|---|---|
| Backend webhook URL | `https://railway-backend.up.railway.app/v1/subscriptions/webhooks/stripe` | `https://api.naplanprep.com.au/v1/subscriptions/webhooks/stripe` |
| Webhook secret | Railway environment variable | Azure Key Vault → Container App |
| Stripe secret key | Railway environment variable | Azure Key Vault → Container App |
| Stripe price IDs | Railway environment variables | Azure Key Vault → Container App |
| Frontend publishable key | Vercel environment variable | Azure Static Web Apps environment variable |

### What Does NOT Change

- Stripe account (same account — test and live)
- Existing Stripe Products and their IDs
- Existing Stripe Prices and their IDs
- Existing customer subscriptions in Stripe
- Existing subscription records in PostgreSQL
- Business logic in `SubscriptionService`
- Entitlement rules

---

## 2. Prerequisite: Understand Current Stripe Environment

### 2.1 Confirm Stripe Account Access

```bash
# READ-ONLY — verify Stripe API key is live (not test)
curl -s https://api.stripe.com/v1/account \
  -u "sk_live_<current-key>:" \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('id'), d.get('email'))"
# Expected: acct_... cloudai0117@gmail.com (or business email)
```

### 2.2 List Active Stripe Prices

```bash
# READ-ONLY — list prices to capture IDs (needed for Key Vault)
curl -s https://api.stripe.com/v1/prices?active=true \
  -u "sk_live_<key>:" \
  | python3 -m json.tool | grep '"id"'
# Record: price_... for Advanced tier and Pro tier
```

### 2.3 List Existing Webhook Endpoints in Stripe

```bash
# READ-ONLY — see all registered webhook endpoints
curl -s https://api.stripe.com/v1/webhook_endpoints \
  -u "sk_live_<key>:" \
  | python3 -m json.tool
# Record: endpoint IDs, URLs, enabled events
```

---

## 3. Phase 1 — Test Mode Migration (Staging Validation)

**Run this against Stripe TEST mode first.** This validates the entire end-to-end flow without touching real payments.

### 3.1 Create Test Webhook Endpoint in Stripe

Do this through the Stripe Dashboard (recommended) or via API:

```bash
# SAFE — create test webhook endpoint pointing to Azure UAT
curl -s -X POST https://api.stripe.com/v1/webhook_endpoints \
  -u "sk_test_<test-key>:" \
  -d url="https://uat-api.naplanprep.com.au/v1/subscriptions/webhooks/stripe" \
  -d "enabled_events[]=checkout.session.completed" \
  -d "enabled_events[]=invoice.payment_succeeded" \
  -d "enabled_events[]=invoice.payment_failed" \
  -d "enabled_events[]=customer.subscription.deleted" \
  -d "enabled_events[]=customer.subscription.updated" \
  | python3 -m json.tool
# Record: id (whep_...) and secret (whsec_...)
```

### 3.2 Store Test Credentials in UAT Key Vault

```bash
# SAFE — store test Stripe credentials for UAT
az keyvault secret set \
  --vault-name npp-uat-kv \
  --name stripe-secret-key \
  --value "sk_test_..."

az keyvault secret set \
  --vault-name npp-uat-kv \
  --name stripe-webhook-secret \
  --value "whsec_..." # from step 3.1

az keyvault secret set \
  --vault-name npp-uat-kv \
  --name stripe-advanced-price-id \
  --value "price_test_..."

az keyvault secret set \
  --vault-name npp-uat-kv \
  --name stripe-pro-price-id \
  --value "price_test_..."
```

### 3.3 End-to-End Test on Azure UAT

```bash
# SAFE — use Stripe CLI to send test events to UAT
stripe trigger checkout.session.completed \
  --webhook-endpoint="https://uat-api.naplanprep.com.au/v1/subscriptions/webhooks/stripe"

# Expected in UAT logs:
# Webhook received: checkout.session.completed
# Subscription created for user ...
```

Manually verify in UAT database:

```bash
psql "$UAT_DB_URL" -c "
SELECT id, user_id, tier, status, stripe_subscription_id
FROM subscriptions
ORDER BY created_at DESC LIMIT 5;
"
```

### 3.4 Test Payment Flow via Stripe Test Cards

1. Login to UAT frontend (`https://uat.naplanprep.com.au.au`)
2. Navigate to subscription page
3. Select Advanced or Pro plan
4. Use Stripe test card: `4242 4242 4242 4242`, any future expiry, any CVC
5. Complete checkout
6. Verify subscription record created in UAT database
7. Verify entitlement granted (user can access premium exam content)

**Must pass before proceeding to Phase 2.**

---

## 4. Phase 2 — Production Cutover Preparation

### 4.1 Store Live Stripe Credentials in Production Key Vault

```bash
# SAFE — store live Stripe API keys (do NOT log these)
az keyvault secret set \
  --vault-name npp-prod-kv \
  --name stripe-secret-key \
  --value "sk_live_..."

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name stripe-publishable-key \
  --value "pk_live_..."

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name stripe-advanced-price-id \
  --value "price_live_..." # from section 2.2

az keyvault secret set \
  --vault-name npp-prod-kv \
  --name stripe-pro-price-id \
  --value "price_live_..." # from section 2.2
```

### 4.2 Create Production Webhook Endpoint in Stripe

**Do not remove the Railway webhook endpoint yet.** Create the Azure endpoint first so both run in parallel during the transition.

```bash
# SAFE — create new production webhook endpoint for Azure
curl -s -X POST https://api.stripe.com/v1/webhook_endpoints \
  -u "sk_live_<key>:" \
  -d url="https://api.naplanprep.com.au/v1/subscriptions/webhooks/stripe" \
  -d "enabled_events[]=checkout.session.completed" \
  -d "enabled_events[]=invoice.payment_succeeded" \
  -d "enabled_events[]=invoice.payment_failed" \
  -d "enabled_events[]=customer.subscription.deleted" \
  -d "enabled_events[]=customer.subscription.updated" \
  | python3 -m json.tool
# Record: id (whep_...) and secret (whsec_...) — CRITICAL
```

> The `whsec_...` value is shown only once in the API response. Store it immediately in Key Vault.

### 4.3 Store Webhook Secret in Production Key Vault

```bash
# SAFE — store IMMEDIATELY after step 4.2
az keyvault secret set \
  --vault-name npp-prod-kv \
  --name stripe-webhook-secret \
  --value "whsec_..." # from step 4.2 response
```

### 4.4 Verify Both Webhooks Active in Stripe

```bash
# READ-ONLY — confirm both endpoints exist
curl -s https://api.stripe.com/v1/webhook_endpoints \
  -u "sk_live_<key>:" \
  | python3 -m json.tool | grep '"url"'
# Expected:
# "url": "https://railway-backend.up.railway.app/v1/subscriptions/webhooks/stripe"
# "url": "https://api.naplanprep.com.au/v1/subscriptions/webhooks/stripe"
```

Running both endpoints in parallel means that during the transition, each Stripe event is delivered to both backends. This is safe because:
- `SubscriptionService` is idempotent — processing the same event twice has no effect
- The Railway backend is on the old database; the Azure backend is on the new database
- After the database migration cutover, Railway will be unreachable (or will connect to old data)
- Within 24 hours of removing the Railway endpoint, Stripe stops delivering to it

---

## 5. Phase 3 — Production Cutover (During Migration Window)

This phase executes **during the database migration window** (see `AZURE_DATABASE_MIGRATION.md`).

### 5.1 Verify Azure Container App Has Stripe Env Vars

```bash
# READ-ONLY — verify env vars are configured
az containerapp show \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --query "properties.template.containers[0].env[?name=='STRIPE_SECRET_KEY'].secretRef" \
  --output tsv
# Expected: stripe-secret-key (or similar Key Vault ref)
```

### 5.2 Test Stripe Connectivity from Production Container App

After the Container App is deployed with `SPRING_PROFILES_ACTIVE=prod`:

```bash
# READ-ONLY — verify Stripe API is reachable from Azure
# (Look for this in startup logs)
az containerapp logs show \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --tail 50 | grep -i stripe
# Expected: no Stripe connection errors
```

### 5.3 Test Stripe Webhook Delivery to Azure

Send a test event from Stripe Dashboard:
1. Stripe Dashboard → Developers → Webhooks
2. Select the Azure endpoint: `https://api.naplanprep.com.au/...`
3. Click "Send test webhook" → select `checkout.session.completed`
4. Verify in Container App logs: `Webhook received: checkout.session.completed`
5. Verify response: `200 OK`

```bash
# READ-ONLY — check webhook delivery in logs
az containerapp logs show \
  --name npp-prod-api \
  --resource-group npp-prod-rg-app \
  --tail 100 | grep -i webhook
```

### 5.4 Verify Rate Limiting on Webhook Endpoint

```bash
# SAFE — test rate limit (100/min)
for i in {1..5}; do
  curl -s -o /dev/null -w "Request $i: HTTP %{http_code}\n" \
    -X POST https://api.naplanprep.com.au/v1/subscriptions/webhooks/stripe \
    -H "Content-Type: application/json" \
    -d '{"invalid":"payload"}'
done
# Expected: HTTP 400 (invalid signature) — NOT 429 at 5 requests
# Rate limit only triggers above 100 requests/minute
```

---

## 6. Phase 4 — Decommission Railway Webhook

Wait 7 days after successful production cutover before removing the Railway webhook endpoint. This ensures:
1. No in-flight events are lost
2. The Azure backend is confirmed stable
3. The Railway backend is no longer deployed

### 6.1 Verify Railway Backend Is No Longer Receiving Traffic

Confirm in the Stripe Dashboard that 100% of successful webhook deliveries are going to the Azure endpoint, not Railway.

### 6.2 Remove Railway Webhook Endpoint

```bash
# Record the Railway webhook endpoint ID from step 2.3
RAILWAY_WEBHOOK_ID="whep_..."

# DANGER — PRODUCTION — removes Railway webhook endpoint from Stripe
# Stripe will stop delivering events to Railway backend
curl -s -X DELETE https://api.stripe.com/v1/webhook_endpoints/$RAILWAY_WEBHOOK_ID \
  -u "sk_live_<key>:"
# Expected: {"id": "whep_...", "deleted": true}
```

### 6.3 Verify Only Azure Endpoint Remains

```bash
# READ-ONLY — confirm only one endpoint remains
curl -s https://api.stripe.com/v1/webhook_endpoints \
  -u "sk_live_<key>:" \
  | python3 -m json.tool | grep '"url"'
# Expected: only https://api.naplanprep.com.au/... remains
```

---

## 7. Vercel Frontend Publishable Key Update

The student frontend uses `STRIPE_PUBLISHABLE_KEY` to initialize Stripe.js. After migrating from Vercel to Azure Static Web Apps, the publishable key is set as a Static Web App environment variable (not in Key Vault — publishable keys are safe to expose to browsers).

```bash
# SAFE — update Static Web App configuration
az staticwebapp appsettings set \
  --name npp-prod-swa-student \
  --resource-group npp-prod-rg-app \
  --setting-names "VITE_STRIPE_PUBLISHABLE_KEY=pk_live_..."
```

> The publishable key is safe to expose in frontend JavaScript bundles. Only the secret key requires Key Vault protection.

---

## 8. Stripe Rollback Procedure

If the Azure backend has Stripe integration issues after cutover:

### Option A — Keep Both Webhooks (Prefer)

If both webhooks (Railway + Azure) are still active during the parallel period:
1. Stop traffic to the Azure Container App
2. Railway backend continues receiving webhooks
3. Investigate and fix the Azure issue
4. Re-enable Azure traffic when fixed

### Option B — Remove Azure Webhook (Last Resort)

```bash
# DANGER — PRODUCTION — removes Azure webhook endpoint
# Only execute if Azure endpoint is causing duplicate processing or data corruption
AZURE_WEBHOOK_ID="whep_..."

curl -s -X DELETE https://api.stripe.com/v1/webhook_endpoints/$AZURE_WEBHOOK_ID \
  -u "sk_live_<key>:"
```

After this:
- Stripe delivers only to Railway
- Railway points to the old database (Railway PostgreSQL)
- Azure PostgreSQL will be out of sync for the period Azure was live

**This is a complex rollback scenario.** If Azure was live for > 1 hour and took real payments, consult with the engineering lead before executing Option B.

---

## 9. Post-Migration Verification Checklist

| Check | Method | Expected | Status |
|---|---|---|---|
| Stripe API connectivity | Container App startup logs | No connection errors | |
| Webhook delivery 200 rate | Stripe Dashboard | 100% | |
| Test checkout completed | Manual E2E test | Subscription created | |
| Subscription record in DB | psql query | Row with ACTIVE status | |
| Entitlement granted | Frontend access check | Premium content accessible | |
| Rate limit active | Manual test (< 100 req) | 400 (not 429) | |
| Railway webhook removed (Day 7) | Stripe Dashboard | Only Azure URL listed | |

---

## 10. Stripe Event Failure Recovery

If the Azure backend misses a webhook event (e.g., during maintenance window):

```bash
# READ-ONLY — view failed events in Stripe
curl -s "https://api.stripe.com/v1/webhook_endpoints/$AZURE_WEBHOOK_ID/attempt_numbers" \
  -u "sk_live_<key>:"

# SAFE — resend failed events from Stripe Dashboard
# Stripe Dashboard → Developers → Webhooks → [endpoint] → Failed events → Resend
```

For critical events (payment succeeded but subscription not activated):

```bash
# READ-ONLY — query Stripe for subscription status
curl -s "https://api.stripe.com/v1/subscriptions/<stripe-sub-id>" \
  -u "sk_live_<key>:" \
  | python3 -m json.tool

# SAFE — manually reconcile in application database (only if event recovery fails)
# This is an emergency procedure and requires a change control record
```

---

## 11. Stripe Credential Rotation Schedule

| Credential | Rotation Frequency | Procedure |
|---|---|---|
| Webhook secret | On compromise suspicion | Create new webhook endpoint, update Key Vault, remove old |
| Secret key | Annually or on compromise | Rotate in Stripe Dashboard → Developers → API keys |
| Publishable key | Does not need rotation | Public key — safe to expose |

### Webhook Secret Rotation

1. Create new webhook endpoint in Stripe (new `whsec_...`)
2. Store new `whsec_` in Key Vault as new version of `stripe-webhook-secret`
3. Deploy new Container App revision (picks up new Key Vault version)
4. Verify new endpoint receives events
5. Delete old webhook endpoint

**Never rotate the webhook secret and delete the old endpoint simultaneously** — there is a gap where in-flight events are signed with the old secret.

---

*This runbook covers only the Stripe infrastructure migration. Business logic, entitlement rules, and subscription tier definitions are not part of this runbook and must not be modified during migration.*
