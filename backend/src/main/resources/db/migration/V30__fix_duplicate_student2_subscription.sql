-- V30: Remove duplicate ACTIVE subscription for student2@test.com.
-- V27 inserted stripe_subscription_id='sub_test_student2_standard'
-- V28 inserted stripe_subscription_id='sub_test_standard_student2' (both ended up ACTIVE).
-- Keep only the V28 one (most recent) by deleting the V27 duplicate.

DELETE FROM subscriptions
WHERE stripe_subscription_id = 'sub_test_student2_standard'
  AND user_id = (SELECT id FROM users WHERE email = 'student2@test.com' LIMIT 1);
