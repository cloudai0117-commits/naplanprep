-- V28: Ensure student2 (Year 5) has a STANDARD subscription for test scenarios.
-- The INSERT...SELECT in V27 may have silently failed on first deploy.
-- This migration uses explicit subqueries to ensure correctness.

DO $$
DECLARE
    v_user_id UUID;
    v_plan_id UUID;
BEGIN
    SELECT id INTO v_user_id FROM users WHERE email = 'student2@test.com' LIMIT 1;
    SELECT id INTO v_plan_id FROM plans WHERE slug = 'standard' LIMIT 1;

    IF v_user_id IS NOT NULL AND v_plan_id IS NOT NULL THEN
        INSERT INTO subscriptions (
            user_id,
            plan_id,
            stripe_subscription_id,
            status,
            billing_interval,
            current_period_start,
            current_period_end
        )
        VALUES (
            v_user_id,
            v_plan_id,
            'sub_test_standard_student2',
            'ACTIVE',
            'MONTHLY',
            NOW(),
            NOW() + INTERVAL '1 year'
        )
        ON CONFLICT (stripe_subscription_id) DO UPDATE
            SET status = 'ACTIVE',
                current_period_end = NOW() + INTERVAL '1 year',
                updated_at = NOW();
    END IF;
END
$$;
