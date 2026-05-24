-- V14: 12 NAPLAN exams — Year 3 (FREE), Year 5 (STANDARD), Year 7 (STANDARD), Year 9 (PREMIUM)
-- Each exam takes the first 10 matching published questions by creation order.

DO $$
DECLARE
  exam_id UUID;
  q_id    UUID;
  q_order INT;
BEGIN

  -- ──────────────────────────────────────────────
  -- YEAR 3 — NUMERACY (FREE, 30 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 3 Numeracy',
    'Practise key numeracy skills aligned to the Year 3 NAPLAN curriculum: place value, arithmetic, fractions, measurement, geometry and patterns.',
    3, 'NUMERACY', 'FREE', 1800,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 3 AND domain = 'NUMERACY' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 3 — READING (FREE, 30 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 3 Reading',
    'Develop Year 3 reading comprehension skills: understanding texts, vocabulary, inference, and identifying text features.',
    3, 'READING', 'FREE', 1800,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 3 AND domain = 'READING' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 3 — LANGUAGE CONVENTIONS (FREE, 25 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 3 Language Conventions',
    'Practise Year 3 spelling, grammar and punctuation skills aligned to the NAPLAN Language Conventions test.',
    3, 'GRAMMAR_PUNCTUATION', 'FREE', 1500,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 3 AND domain = 'GRAMMAR_PUNCTUATION' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 5 — NUMERACY (STANDARD, 40 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 5 Numeracy',
    'Challenge Year 5 students with NAPLAN-style numeracy questions covering fractions, decimals, percentages, algebra, area, statistics and probability.',
    5, 'NUMERACY', 'STANDARD', 2400,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 5 AND domain = 'NUMERACY' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 5 — READING (STANDARD, 40 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 5 Reading',
    'Build Year 5 reading skills: inference, figurative language, vocabulary in context, author purpose and text structure.',
    5, 'READING', 'STANDARD', 2400,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 5 AND domain = 'READING' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 5 — LANGUAGE CONVENTIONS (STANDARD, 35 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 5 Language Conventions',
    'Sharpen Year 5 spelling, grammar, punctuation and vocabulary skills with NAPLAN-aligned practice questions.',
    5, 'GRAMMAR_PUNCTUATION', 'STANDARD', 2100,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 5 AND domain = 'GRAMMAR_PUNCTUATION' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 7 — NUMERACY (STANDARD, 45 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 7 Numeracy',
    'Test Year 7 numeracy with NAPLAN-style questions on algebra, geometry, Pythagoras, ratios, probability and statistics.',
    7, 'NUMERACY', 'STANDARD', 2700,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 7 AND domain = 'NUMERACY' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 7 — READING (STANDARD, 45 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 7 Reading',
    'Extend Year 7 reading with NAPLAN-style inference, language analysis, vocabulary in context and identification of author purpose.',
    7, 'READING', 'STANDARD', 2700,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 7 AND domain = 'READING' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 7 — LANGUAGE CONVENTIONS (STANDARD, 40 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 7 Language Conventions',
    'Master Year 7 language conventions: complex spelling, punctuation, grammar structures and advanced vocabulary.',
    7, 'GRAMMAR_PUNCTUATION', 'STANDARD', 2400,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 7 AND domain = 'GRAMMAR_PUNCTUATION' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 9 — NUMERACY (PREMIUM, 50 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 9 Numeracy',
    'Challenge Year 9 students with advanced NAPLAN numeracy: quadratics, trigonometry, simultaneous equations, surds, compound interest and circle geometry.',
    9, 'NUMERACY', 'PREMIUM', 3000,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 9 AND domain = 'NUMERACY' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 9 — READING (PREMIUM, 50 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 9 Reading',
    'Develop Year 9 critical reading: argument analysis, authorial intent, inference, literary devices and extended comprehension.',
    9, 'READING', 'PREMIUM', 3000,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 9 AND domain = 'READING' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

  -- ──────────────────────────────────────────────
  -- YEAR 9 — LANGUAGE CONVENTIONS (PREMIUM, 45 min)
  -- ──────────────────────────────────────────────
  INSERT INTO exams (id, title, description, year_level, domain, package_tier, time_limit_seconds, available_from, available_until, status)
  VALUES (uuid_generate_v4(),
    'NAPLAN Year 9 Language Conventions',
    'Refine Year 9 language skills: advanced vocabulary, complex sentence structures, sophisticated punctuation and high-level spelling.',
    9, 'GRAMMAR_PUNCTUATION', 'PREMIUM', 2700,
    NOW() - INTERVAL '1 day', NOW() + INTERVAL '365 days', 'PUBLISHED')
  RETURNING id INTO exam_id;

  q_order := 1;
  FOR q_id IN (
    SELECT id FROM questions
    WHERE year_level = 9 AND domain = 'GRAMMAR_PUNCTUATION' AND status = 'PUBLISHED'
    ORDER BY created_at LIMIT 10
  ) LOOP
    INSERT INTO exam_questions (exam_id, question_id, question_order)
    VALUES (exam_id, q_id, q_order) ON CONFLICT DO NOTHING;
    q_order := q_order + 1;
  END LOOP;

END $$;
