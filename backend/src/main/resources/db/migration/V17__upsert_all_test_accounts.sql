-- V17: Robust upsert for all UAT test accounts
-- Uses ON CONFLICT DO UPDATE to guarantee correct passwords regardless of prior state.
-- Also resets account lockout from earlier failed login attempts during testing.
-- BCrypt cost-12 hash of 'Admin123!'

INSERT INTO users (id, email, password, role, status, failed_login_attempts, locked_until)
VALUES
    (uuid_generate_v4(), 'admin@naplanprep.com.au',
     '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq',
     'PLATFORM_ADMIN', 'ACTIVE', 0, NULL),
    (uuid_generate_v4(), 'student1@test.com',
     '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq',
     'STUDENT', 'ACTIVE', 0, NULL),
    (uuid_generate_v4(), 'student2@test.com',
     '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq',
     'STUDENT', 'ACTIVE', 0, NULL),
    (uuid_generate_v4(), 'parent1@test.com',
     '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq',
     'PARENT', 'ACTIVE', 0, NULL)
ON CONFLICT (email) DO UPDATE
    SET password              = EXCLUDED.password,
        status                = EXCLUDED.status,
        failed_login_attempts = 0,
        locked_until          = NULL;

-- Ensure admin profile exists
INSERT INTO user_profiles (id, user_id, first_name, last_name)
SELECT uuid_generate_v4(), id, 'Platform', 'Admin'
FROM users WHERE email = 'admin@naplanprep.com.au'
  AND NOT EXISTS (SELECT 1 FROM user_profiles WHERE user_id = users.id);

-- Ensure student2 profile exists
INSERT INTO user_profiles (id, user_id, first_name, last_name, year_level)
SELECT uuid_generate_v4(), id, 'Test', 'Student2', 5
FROM users WHERE email = 'student2@test.com'
  AND NOT EXISTS (SELECT 1 FROM user_profiles WHERE user_id = users.id);

-- Ensure parent1 profile exists
INSERT INTO user_profiles (id, user_id, first_name, last_name)
SELECT uuid_generate_v4(), id, 'Test', 'Parent1'
FROM users WHERE email = 'parent1@test.com'
  AND NOT EXISTS (SELECT 1 FROM user_profiles WHERE user_id = users.id);
