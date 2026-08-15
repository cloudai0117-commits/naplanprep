-- ================================================================
-- V52 — One-time purchase entitlement model
--
-- The business model is ONE-TIME PURCHASE valid for ONE YEAR.
-- This is NOT a recurring subscription.
-- The existing subscriptions table is extended to track:
--   purchase_type: ONE_TIME (new) or SUBSCRIPTION (legacy rows)
--   expires_at:    purchase date + 1 year (for ONE_TIME)
--   stripe_payment_intent_id: Stripe PaymentIntent for ONE_TIME purchases
--
-- Stripe integration changes from Mode.SUBSCRIPTION to Mode.PAYMENT.
-- ================================================================

ALTER TABLE subscriptions
    ADD COLUMN IF NOT EXISTS purchase_type            VARCHAR(20) NOT NULL DEFAULT 'SUBSCRIPTION',
    ADD COLUMN IF NOT EXISTS expires_at               TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS stripe_payment_intent_id VARCHAR(100);

-- Backfill: existing subscription rows retain SUBSCRIPTION type.
-- expires_at remains NULL for existing rows (checked via current_period_end).

CREATE INDEX IF NOT EXISTS idx_subscriptions_user_expires
    ON subscriptions(user_id, expires_at);

CREATE INDEX IF NOT EXISTS idx_subscriptions_payment_intent
    ON subscriptions(stripe_payment_intent_id)
    WHERE stripe_payment_intent_id IS NOT NULL;

COMMENT ON COLUMN subscriptions.purchase_type IS
    'ONE_TIME = one-year access from purchase date. SUBSCRIPTION = legacy recurring (deprecated).';
COMMENT ON COLUMN subscriptions.expires_at IS
    'For ONE_TIME purchases: purchase_date + 1 year. Null for legacy subscriptions.';
