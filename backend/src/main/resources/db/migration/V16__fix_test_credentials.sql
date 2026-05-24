-- V16: Force-update all UAT test account passwords to Admin123!
-- BCrypt cost-12 hash of 'Admin123!'
-- Required because V15 used ON CONFLICT DO NOTHING (skipping pre-existing rows)
-- and V8 may have run with a stale hash on some UAT instances.

UPDATE users
SET password = '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq',
    status   = 'ACTIVE'
WHERE email IN (
    'admin@naplanprep.com.au',
    'student1@test.com',
    'student2@test.com',
    'parent1@test.com'
);

-- Ensure student2 and parent1 exist (in case V15 skipped them too)
INSERT INTO users (id, email, password, role, status)
VALUES
    (uuid_generate_v4(), 'student2@test.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq', 'STUDENT', 'ACTIVE'),
    (uuid_generate_v4(), 'parent1@test.com',  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq', 'PARENT',  'ACTIVE')
ON CONFLICT (email) DO NOTHING;

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
