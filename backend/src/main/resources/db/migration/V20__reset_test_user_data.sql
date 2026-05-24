-- V20: Reset UAT test user profiles, subscriptions, and exam sessions for clean test runs
-- Ensures test accounts have predictable data regardless of prior test execution.

-- Fix user profiles to correct test data
UPDATE user_profiles
SET first_name  = 'Test',
    last_name   = 'Student1',
    year_level  = 3,
    updated_at  = NOW()
WHERE user_id = (SELECT id FROM users WHERE email = 'student1@test.com');

UPDATE user_profiles
SET first_name  = 'Test',
    last_name   = 'Student2',
    year_level  = 5,
    updated_at  = NOW()
WHERE user_id = (SELECT id FROM users WHERE email = 'student2@test.com');

UPDATE user_profiles
SET first_name  = 'Test',
    last_name   = 'Parent1',
    updated_at  = NOW()
WHERE user_id = (SELECT id FROM users WHERE email = 'parent1@test.com');

-- Cancel any active subscriptions for test students so they start on FREE tier
UPDATE subscriptions
SET status     = 'CANCELLED',
    updated_at = NOW()
WHERE user_id IN (
    SELECT id FROM users WHERE email IN ('student1@test.com', 'student2@test.com', 'parent1@test.com')
)
AND status IN ('ACTIVE', 'TRIALING');

-- Delete exam sessions for test users so no exam is marked "already attempted"
DELETE FROM exam_sessions
WHERE user_id IN (
    SELECT id FROM users WHERE email IN ('student1@test.com', 'student2@test.com')
);
