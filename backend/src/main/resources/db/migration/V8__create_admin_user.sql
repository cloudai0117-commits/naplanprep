-- Admin user: admin@naplanprep.com.au / Admin123!
-- Password hash is BCrypt cost 12 of 'Admin123!'
INSERT INTO users (id, email, password, role, status)
VALUES (
    uuid_generate_v4(),
    'admin@naplanprep.com.au',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/Lewfv0XoQCGP/Gmlq',
    'PLATFORM_ADMIN',
    'ACTIVE'
);

INSERT INTO user_profiles (id, user_id, first_name, last_name)
SELECT uuid_generate_v4(), id, 'Platform', 'Admin'
FROM users WHERE email = 'admin@naplanprep.com.au';
