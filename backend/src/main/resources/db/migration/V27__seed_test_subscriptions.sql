-- Seed STANDARD subscription for student2 so year-level exam tests work correctly.
-- student2@test.com = 8248c5e6-254b-4fec-8344-df77a974e0d2 (Year 5)
-- Standard plan = 104d8f77-6460-4d81-9b86-e79dc49e379f

INSERT INTO subscriptions (id, user_id, plan_id, stripe_subscription_id, status, current_period_start, current_period_end, created_at, updated_at)
SELECT
    uuid_generate_v4(),
    u.id,
    p.id,
    'sub_test_student2_standard',
    'ACTIVE',
    NOW(),
    NOW() + INTERVAL '1 year',
    NOW(),
    NOW()
FROM users u, plans p
WHERE u.email = 'student2@test.com'
  AND p.slug = 'standard'
ON CONFLICT (stripe_subscription_id) DO NOTHING;
