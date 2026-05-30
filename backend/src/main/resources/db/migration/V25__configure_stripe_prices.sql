-- Configure real Stripe test price IDs for payment checkout
-- Auto-generated via setup-stripe workflow 2026-05-30

UPDATE plans SET
    stripe_monthly_price_id = 'price_1TcoqfFzG9a7sokb8UNUqruF',
    stripe_annual_price_id  = 'price_1TcoqgFzG9a7sokb3IzR3PwF'
WHERE slug = 'standard';

UPDATE plans SET
    stripe_monthly_price_id = 'price_1TcoqgFzG9a7sokbHVjgHekE',
    stripe_annual_price_id  = 'price_1TcoqhFzG9a7sokbekAUYQga'
WHERE slug = 'premium';
