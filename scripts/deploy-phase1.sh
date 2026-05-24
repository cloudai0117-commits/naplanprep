#!/usr/bin/env bash
# Interactive setup script for Phase 1 deployment (Railway + Vercel + GitHub Secrets).
# Run once after creating your GitHub repository.
set -euo pipefail

echo "=== NAPLANPrep Phase 1 Deployment Setup ==="
echo "Sets up Railway (backend), Vercel (frontend + admin), and GitHub Secrets."
echo ""

command_exists() { command -v "$1" &>/dev/null; }

if ! command_exists railway; then
  echo "Installing Railway CLI..."
  npm install -g @railway/cli
  # Refresh PATH so the newly installed binary is found
  export PATH="$(npm bin -g 2>/dev/null || npm root -g | sed 's|/node_modules$|/bin|'):$PATH"
fi

if ! command_exists vercel; then
  echo "Installing Vercel CLI..."
  npm install -g vercel
  export PATH="$(npm bin -g 2>/dev/null || npm root -g | sed 's|/node_modules$|/bin|'):$PATH"
fi

if ! command_exists gh; then
  echo "ERROR: GitHub CLI (gh) is required."
  echo "Install: winget install GitHub.cli  then  gh auth login"
  exit 1
fi

echo "Please provide the following credentials."
echo "(All input is used only to set GitHub Secrets — nothing is stored locally.)"
echo ""
read -rp "Railway API token (railway.app → Account → Tokens): " RAILWAY_TOKEN
read -rp "Vercel token (vercel.com → Settings → Tokens):       " VERCEL_TOKEN
read -rp "GitHub repo (e.g. cloudai0117-commits/naplanprep):   " GITHUB_REPO
read -rp "Stripe TEST publishable key (pk_test_...):           " STRIPE_TEST_PK
read -rp "Stripe TEST secret key (sk_test_...):                " STRIPE_TEST_SK
read -rp "Stripe TEST webhook secret (whsec_...):              " STRIPE_TEST_WH

echo ""
echo "--- Setting up Railway project ---"
# RAILWAY_TOKEN env var is picked up automatically — no 'railway login' needed
export RAILWAY_TOKEN

railway init --name naplanprep-uat || echo "  (project init skipped — may already exist)"

echo "Creating Railway services..."
railway service create naplanprep-backend-uat 2>&1 || echo "  (service may already exist, continuing)"
railway service create naplanprep-backend-prod 2>&1 || echo "  (service may already exist, continuing)"

echo ""
echo "--- Setting up Vercel projects ---"
export VERCEL_TOKEN

cd frontend
vercel --token "$VERCEL_TOKEN" link --yes 2>&1 || true
FRONTEND_PROJECT_ID=$(node -e "const d=require('fs').readFileSync('.vercel/project.json','utf8');console.log(JSON.parse(d).projectId)" 2>/dev/null || echo "UNKNOWN")
cd ..

cd admin-panel
vercel --token "$VERCEL_TOKEN" link --yes 2>&1 || true
ADMIN_PROJECT_ID=$(node -e "const d=require('fs').readFileSync('.vercel/project.json','utf8');console.log(JSON.parse(d).projectId)" 2>/dev/null || echo "UNKNOWN")
cd ..

VERCEL_ORG_ID=$(node -e "const d=require('fs').readFileSync('frontend/.vercel/project.json','utf8');console.log(JSON.parse(d).orgId||'UNKNOWN')" 2>/dev/null || echo "UNKNOWN")

echo ""
echo "--- Setting GitHub Secrets ---"
gh secret set RAILWAY_TOKEN                --body "$RAILWAY_TOKEN"        --repo "$GITHUB_REPO"
gh secret set VERCEL_TOKEN                 --body "$VERCEL_TOKEN"         --repo "$GITHUB_REPO"
gh secret set VERCEL_ORG_ID               --body "$VERCEL_ORG_ID"        --repo "$GITHUB_REPO"
gh secret set VERCEL_FRONTEND_PROJECT_ID  --body "$FRONTEND_PROJECT_ID"  --repo "$GITHUB_REPO"
gh secret set VERCEL_ADMIN_PROJECT_ID     --body "$ADMIN_PROJECT_ID"     --repo "$GITHUB_REPO"
gh secret set STRIPE_TEST_PUBLISHABLE_KEY --body "$STRIPE_TEST_PK"       --repo "$GITHUB_REPO"
gh secret set STRIPE_TEST_SECRET_KEY      --body "$STRIPE_TEST_SK"       --repo "$GITHUB_REPO"
gh secret set STRIPE_TEST_WEBHOOK_SECRET  --body "$STRIPE_TEST_WH"       --repo "$GITHUB_REPO"

echo ""
echo "=== Phase 1 Setup Complete ==="
echo ""
echo "GitHub Secrets set:"
echo "  RAILWAY_TOKEN, VERCEL_TOKEN, VERCEL_ORG_ID"
echo "  VERCEL_FRONTEND_PROJECT_ID=$FRONTEND_PROJECT_ID"
echo "  VERCEL_ADMIN_PROJECT_ID=$ADMIN_PROJECT_ID"
echo "  STRIPE_TEST_* keys"
echo ""
echo "Next steps:"
echo "  1. Push to 'develop' to trigger UAT deployment"
echo "  2. After UAT is up, add this GitHub Secret:"
echo "       UAT_API_URL = https://<your-service>.railway.app/v1"
echo "  3. Update Stripe webhook endpoint to your real Railway URL:"
echo "       https://<your-railway-url>/v1/payments/webhook"
echo "  4. When ready for prod, add:"
echo "       PROD_API_URL, STRIPE_LIVE_PUBLISHABLE_KEY,"
echo "       STRIPE_LIVE_SECRET_KEY, STRIPE_LIVE_WEBHOOK_SECRET, SLACK_WEBHOOK"
echo "  5. Push to 'main' or use workflow_dispatch for Production deployment"
