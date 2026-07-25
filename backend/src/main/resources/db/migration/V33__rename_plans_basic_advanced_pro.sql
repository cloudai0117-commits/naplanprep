-- Rename plans to BASIC / ADVANCED / PRO
UPDATE plans SET name = 'Basic',    slug = 'basic'    WHERE slug = 'free';
UPDATE plans SET name = 'Advanced', slug = 'advanced' WHERE slug = 'standard';
UPDATE plans SET name = 'Pro',      slug = 'pro'      WHERE slug = 'premium';

-- Deactivate the Family plan (merged into Pro)
UPDATE plans SET active = FALSE WHERE slug = 'family';
