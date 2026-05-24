-- V18: Regenerate test account passwords using pgcrypto (plaintext → BCrypt hash inline)
-- Eliminates hardcoded hash strings that may not match the app's BCryptPasswordEncoder(12).
-- gen_salt('bf', 12) produces a $2a$12$ salt; crypt() applies Blowfish — compatible with Spring BCrypt.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

UPDATE users
SET password              = crypt('Admin123!', gen_salt('bf', 12)),
    status                = 'ACTIVE',
    failed_login_attempts = 0,
    locked_until          = NULL
WHERE email IN (
    'admin@naplanprep.com.au',
    'student1@test.com',
    'student2@test.com',
    'parent1@test.com'
);
