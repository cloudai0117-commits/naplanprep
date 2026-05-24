-- V15: UAT test accounts — all passwords are Admin123!
-- BCrypt cost-12 hash of 'Admin123!'
INSERT INTO users (id, email, password, role, status) VALUES
  (uuid_generate_v4(), 'student1@test.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq', 'STUDENT', 'ACTIVE'),
  (uuid_generate_v4(), 'student2@test.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq', 'STUDENT', 'ACTIVE'),
  (uuid_generate_v4(), 'parent1@test.com',  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq', 'PARENT',  'ACTIVE')
ON CONFLICT (email) DO NOTHING;

INSERT INTO user_profiles (id, user_id, first_name, last_name, year_level)
SELECT uuid_generate_v4(), id, 'Test', 'Student1', 3
FROM users WHERE email = 'student1@test.com'
  AND NOT EXISTS (SELECT 1 FROM user_profiles WHERE user_id = users.id);

INSERT INTO user_profiles (id, user_id, first_name, last_name, year_level)
SELECT uuid_generate_v4(), id, 'Test', 'Student2', 5
FROM users WHERE email = 'student2@test.com'
  AND NOT EXISTS (SELECT 1 FROM user_profiles WHERE user_id = users.id);

INSERT INTO user_profiles (id, user_id, first_name, last_name)
SELECT uuid_generate_v4(), id, 'Test', 'Parent1'
FROM users WHERE email = 'parent1@test.com'
  AND NOT EXISTS (SELECT 1 FROM user_profiles WHERE user_id = users.id);
