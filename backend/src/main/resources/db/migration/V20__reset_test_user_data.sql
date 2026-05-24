-- V20: Reset UAT test user profiles, subscriptions, and exam sessions for clean test runs
-- Ensures test accounts have predictable data regardless of prior test execution.

-- Fix user profiles (user_profiles has no updated_at column)
UPDATE user_profiles
SET first_name = 'Test',
    last_name  = 'Student1',
    year_level = 3
WHERE user_id = (SELECT id FROM users WHERE email = 'student1@test.com');

UPDATE user_profiles
SET first_name = 'Test',
    last_name  = 'Student2',
    year_level = 5
WHERE user_id = (SELECT id FROM users WHERE email = 'student2@test.com');

UPDATE user_profiles
SET first_name = 'Test',
    last_name  = 'Parent1'
WHERE user_id = (SELECT id FROM users WHERE email = 'parent1@test.com');

-- Cancel any active subscriptions for test students (subscriptions has updated_at via trigger)
UPDATE subscriptions
SET status = 'CANCELLED'
WHERE user_id IN (
    SELECT id FROM users WHERE email IN ('student1@test.com', 'student2@test.com', 'parent1@test.com')
)
AND status IN ('ACTIVE', 'TRIALING');

-- Delete exam sessions for test users (must delete results first — no CASCADE on exam_results)
DELETE FROM exam_results
WHERE session_id IN (
    SELECT id FROM exam_sessions
    WHERE user_id IN (
        SELECT id FROM users WHERE email IN ('student1@test.com', 'student2@test.com')
    )
);

DELETE FROM exam_sessions
WHERE user_id IN (
    SELECT id FROM users WHERE email IN ('student1@test.com', 'student2@test.com')
);
