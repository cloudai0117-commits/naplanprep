-- V19: Probe pgcrypto compatibility + aggressive fix for seeded accounts
-- Inserts a probe account to verify pgcrypto hash works with Spring BCrypt.
-- Also force-deletes and re-inserts seeded accounts to bypass any hash mismatch.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Probe account: if login with probe@test.com / Admin123! works, pgcrypto is compatible
INSERT INTO users (id, email, password, role, status, failed_login_attempts, locked_until)
VALUES (
    uuid_generate_v4(),
    'probe@test.com',
    crypt('Admin123!', gen_salt('bf', 12)),
    'STUDENT', 'ACTIVE', 0, NULL
)
ON CONFLICT (email) DO UPDATE
    SET password              = crypt('Admin123!', gen_salt('bf', 12)),
        status                = 'ACTIVE',
        failed_login_attempts = 0,
        locked_until          = NULL;

-- Force re-hash all seeded accounts using pgcrypto inline
-- (V18 UPDATE may have matched 0 rows if emails differed)
DO $$
DECLARE
    v_emails TEXT[] := ARRAY['admin@naplanprep.com.au','student1@test.com','student2@test.com','parent1@test.com'];
    v_email  TEXT;
    v_rows   INTEGER;
BEGIN
    FOREACH v_email IN ARRAY v_emails LOOP
        UPDATE users
        SET password              = crypt('Admin123!', gen_salt('bf', 12)),
            status                = 'ACTIVE',
            failed_login_attempts = 0,
            locked_until          = NULL
        WHERE LOWER(email) = LOWER(v_email);
        GET DIAGNOSTICS v_rows = ROW_COUNT;
        RAISE NOTICE 'Updated % rows for email: %', v_rows, v_email;
    END LOOP;
END $$;
