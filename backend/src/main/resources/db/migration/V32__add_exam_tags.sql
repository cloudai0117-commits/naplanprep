-- Add tag column to exams (replaces package_tier for access control)
ALTER TABLE exams ADD COLUMN IF NOT EXISTS tag VARCHAR(20) NOT NULL DEFAULT 'BASIC';

-- Map existing package_tier values to new tags
UPDATE exams SET tag = 'BASIC'    WHERE package_tier = 'FREE';
UPDATE exams SET tag = 'ADVANCED' WHERE package_tier = 'STANDARD';
UPDATE exams SET tag = 'PRO'      WHERE package_tier IN ('PREMIUM', 'FAMILY');

-- Create user_tags join table
CREATE TABLE IF NOT EXISTS user_tags (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    tag     VARCHAR(20) NOT NULL,
    PRIMARY KEY (user_id, tag)
);

-- Every existing user gets BASIC
INSERT INTO user_tags (user_id, tag)
SELECT id, 'BASIC' FROM users
ON CONFLICT DO NOTHING;

-- Users with active STANDARD subscriptions get ADVANCED tag
INSERT INTO user_tags (user_id, tag)
SELECT DISTINCT s.user_id, 'ADVANCED'
FROM subscriptions s
JOIN plans p ON s.plan_id = p.id
WHERE s.status IN ('ACTIVE', 'TRIALING')
  AND UPPER(p.name) IN ('STANDARD', 'ADVANCED', 'ADVANCE')
ON CONFLICT DO NOTHING;

-- Users with active PREMIUM/FAMILY subscriptions get PRO tag
INSERT INTO user_tags (user_id, tag)
SELECT DISTINCT s.user_id, 'PRO'
FROM subscriptions s
JOIN plans p ON s.plan_id = p.id
WHERE s.status IN ('ACTIVE', 'TRIALING')
  AND UPPER(p.name) IN ('PREMIUM', 'FAMILY', 'PRO')
ON CONFLICT DO NOTHING;
