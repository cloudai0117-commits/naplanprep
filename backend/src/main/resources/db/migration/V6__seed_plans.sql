INSERT INTO plans (id, name, slug, monthly_price, annual_price, stripe_monthly_price_id, stripe_annual_price_id,
    max_children, daily_question_limit, annual_mock_exam_limit, adaptive_learning, parent_dashboard,
    detailed_analytics, active, description)
VALUES
    (uuid_generate_v4(), 'Free', 'free', 0.00, 0.00,
     NULL, NULL,
     1, 10, 1, FALSE, FALSE, FALSE, TRUE,
     '1 diagnostic per year level, 10 practice questions/day'),

    (uuid_generate_v4(), 'Standard', 'standard', 14.99, 129.00,
     'price_standard_monthly_placeholder', 'price_standard_annual_placeholder',
     1, -1, 12, FALSE, FALSE, FALSE, TRUE,
     'Full question bank, 12 mock exams/year, progress tracking'),

    (uuid_generate_v4(), 'Premium', 'premium', 24.99, 219.00,
     'price_premium_monthly_placeholder', 'price_premium_annual_placeholder',
     1, -1, -1, TRUE, TRUE, TRUE, TRUE,
     'Adaptive learning, unlimited mocks, parent dashboard, detailed analytics'),

    (uuid_generate_v4(), 'Family', 'family', 34.99, NULL,
     'price_family_monthly_placeholder', NULL,
     4, -1, -1, TRUE, TRUE, TRUE, TRUE,
     'Up to 4 children, all Premium features');
