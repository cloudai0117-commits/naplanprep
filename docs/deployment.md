# NAPLANPrep — Phase 1 Deployment Guide

Phase 1 hosts the platform on **Railway** (backend + database + Redis) and **Vercel** (frontend + admin panel).
This is ideal for validating the product before investing in Azure infrastructure.

---

## Prerequisites

- GitHub account with the repo created
- [Railway](https://railway.app) account (free tier is fine to start)
- [Vercel](https://vercel.com) account (free Hobby plan is fine)
- [Stripe](https://stripe.com) account (test mode)
- [GitHub CLI](https://cli.github.com) installed locally

---

## Step 1 — Run the Automated Setup Script

```bash
# On Mac/Linux (or WSL on Windows):
bash scripts/deploy-phase1.sh
```

This script will:
1. Install Railway CLI and Vercel CLI if missing
2. Prompt for your Railway token, Vercel token, GitHub repo, and Stripe TEST keys
3. Create Railway services for UAT and PROD
4. Link Vercel projects for frontend and admin
5. Set all required GitHub Secrets automatically

---

## Step 2 — Add GitHub Secrets Manually (if not using the script)

Go to: **GitHub → Your Repo → Settings → Secrets and variables → Actions**

### Phase 1 Required Secrets

| Secret | Where to find it |
|--------|-----------------|
| `RAILWAY_TOKEN` | railway.app → Account → Tokens |
| `VERCEL_TOKEN` | vercel.com → Settings → Tokens |
| `VERCEL_ORG_ID` | vercel.com → Settings → General → Team ID |
| `VERCEL_FRONTEND_PROJECT_ID` | Vercel dashboard → frontend project → Settings |
| `VERCEL_ADMIN_PROJECT_ID` | Vercel dashboard → admin project → Settings |
| `UAT_API_URL` | `https://<uat-service>.railway.app/v1` (after first Railway deploy) |
| `PROD_API_URL` | `https://<prod-service>.railway.app/v1` (after first Railway deploy) |
| `STRIPE_TEST_PUBLISHABLE_KEY` | Stripe dashboard → Developers → API keys |
| `STRIPE_TEST_SECRET_KEY` | Stripe dashboard → Developers → API keys |
| `STRIPE_TEST_WEBHOOK_SECRET` | Stripe dashboard → Webhooks → signing secret |
| `STRIPE_LIVE_PUBLISHABLE_KEY` | Stripe dashboard (live mode) |
| `STRIPE_LIVE_SECRET_KEY` | Stripe dashboard (live mode) |
| `STRIPE_LIVE_WEBHOOK_SECRET` | Stripe dashboard → Webhooks (live) |
| `SLACK_WEBHOOK` | Slack → Apps → Incoming Webhooks |

---

## Step 3 — Configure Railway Backend Environment Variables

In the Railway dashboard for each service, add:

```
SPRING_PROFILES_ACTIVE=uat          # or prod
SPRING_DATASOURCE_URL=<auto-set by Railway PostgreSQL plugin>
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=<set in Railway>
SPRING_DATA_REDIS_HOST=<auto-set by Railway Redis plugin>
APP_STRIPE_SECRET_KEY=sk_test_...   # sk_live_... for prod
APP_STRIPE_WEBHOOK_SECRET=whsec_... 
APP_JWT_PRIVATE_KEY_PATH=<base64-encoded or volume mount>
APP_CORS_ALLOWED_ORIGINS=https://uat.naplanprep.com.au
```

Add the **PostgreSQL** and **Redis** plugins directly in the Railway project dashboard.

---

## Step 4 — Configure Stripe Webhooks

1. Go to [Stripe Dashboard → Webhooks](https://dashboard.stripe.com/webhooks)
2. Click **Add endpoint**
3. Endpoint URL: `https://<your-railway-url>/v1/payments/webhook`
4. Select events:
   - `payment_intent.succeeded`
   - `payment_intent.payment_failed`
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
5. Copy the **Signing secret** → add as `STRIPE_TEST_WEBHOOK_SECRET` (or LIVE variant) in GitHub Secrets

---

## Step 5 — Deploy

### Deploy to UAT

Push to the `develop` branch:
```bash
git push origin develop
```

The `deploy-uat.yml` workflow runs automatically:
1. Deploys backend to Railway UAT
2. Deploys frontend and admin to Vercel (preview)
3. Runs smoke tests

### Deploy to Production

Either push to `main`:
```bash
git push origin main
```

Or manually trigger from GitHub → Actions → **Deploy — Production** → Run workflow (type `DEPLOY` to confirm).

---

## Running Locally with Docker

```bash
# One-shot setup (installs everything, seeds data):
bash scripts/setup-local.sh

# Or manually:
docker compose up -d
bash scripts/seed-data.sh
```

Access points:
- Student App: http://localhost:5173
- Admin Panel: http://localhost:5174
- Backend API: http://localhost:8080
- Swagger UI:  http://localhost:8080/swagger-ui.html

---

## Troubleshooting

### Backend fails to start
```bash
docker compose logs backend
# Check: JWT keys present? DB connection? Redis reachable?
```

### JWT key errors
```bash
# Regenerate keys:
bash scripts/generate-keys.sh
docker compose restart backend
```

### Stripe webhooks not received locally
Use Stripe CLI to forward webhooks:
```bash
stripe listen --forward-to localhost:8080/v1/payments/webhook
```

### Railway deploy hangs
Check the Railway dashboard for build logs. Common causes:
- Missing environment variable
- Database migration failure (check Flyway logs)
- Out-of-memory during build (upgrade Railway plan)

### Vercel build fails
Check build logs in the Vercel dashboard. Common cause:
- `VITE_API_URL` or `VITE_STRIPE_KEY` not set in GitHub Secrets
