-- Rename exams.tag → exams.package_type and update enum values
ALTER TABLE exams RENAME COLUMN tag TO package_type;
UPDATE exams SET package_type = 'FREE'    WHERE package_type = 'BASIC';
UPDATE exams SET package_type = 'PREMIUM' WHERE package_type = 'PRO';

-- Update user_tags values (column name stays 'tag')
UPDATE user_tags SET tag = 'FREE'    WHERE tag = 'BASIC';
UPDATE user_tags SET tag = 'PREMIUM' WHERE tag = 'PRO';

-- Add package_type and difficulty to questions
ALTER TABLE questions ADD COLUMN IF NOT EXISTS package_type VARCHAR(20) NOT NULL DEFAULT 'FREE';
ALTER TABLE questions ADD COLUMN IF NOT EXISTS difficulty   VARCHAR(20) NOT NULL DEFAULT 'EASY';

-- Rename plans to match FREE/ADVANCED/PREMIUM branding
UPDATE plans SET name = 'Free',    slug = 'free'    WHERE slug = 'basic';
UPDATE plans SET name = 'Advanced', slug = 'advanced' WHERE slug = 'advanced';
UPDATE plans SET name = 'Premium', slug = 'premium' WHERE slug = 'pro';
