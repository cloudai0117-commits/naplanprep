DO $$
DECLARE
    exam1_id UUID := uuid_generate_v4();
    exam2_id UUID := uuid_generate_v4();
    exam3_id UUID := uuid_generate_v4();
    ord      INTEGER;
    qid      UUID;
BEGIN
    -- ─────────────────────────────────────────────────────────────
    -- Exam 1: Year 5 Numeracy — Problem Solving  (STANDARD tier)
    -- ─────────────────────────────────────────────────────────────
    INSERT INTO exams (id, title, description, year_level, domain,
                       package_tier, time_limit_seconds,
                       available_from, available_until, status)
    VALUES (exam1_id,
            'Year 5 Numeracy Assessment',
            'A comprehensive numeracy assessment for Year 5 students covering fractions, percentages, area, and problem solving.',
            5, 'NUMERACY', 'STANDARD', 2700,
            NOW() - INTERVAL '1 day',
            NOW() + INTERVAL '60 days',
            'PUBLISHED');

    ord := 1;
    FOR qid IN
        SELECT id FROM questions
        WHERE year_level = 5 AND domain = 'NUMERACY' AND status = 'PUBLISHED'
        ORDER BY created_at
        LIMIT 10
    LOOP
        INSERT INTO exam_questions (exam_id, question_id, question_order)
        VALUES (exam1_id, qid, ord)
        ON CONFLICT DO NOTHING;
        ord := ord + 1;
    END LOOP;

    -- ─────────────────────────────────────────────────────────────
    -- Exam 2: Year 5 Numeracy — Mixed Challenge  (PREMIUM tier)
    -- ─────────────────────────────────────────────────────────────
    INSERT INTO exams (id, title, description, year_level, domain,
                       package_tier, time_limit_seconds,
                       available_from, available_until, status)
    VALUES (exam2_id,
            'Year 5 Numeracy — Advanced Challenge',
            'An advanced numeracy challenge for Year 5 students. Tests higher-order problem solving and mathematical reasoning.',
            5, 'NUMERACY', 'PREMIUM', 3600,
            NOW() - INTERVAL '1 day',
            NOW() + INTERVAL '60 days',
            'PUBLISHED');

    ord := 1;
    FOR qid IN
        SELECT id FROM questions
        WHERE year_level = 5 AND domain = 'NUMERACY' AND status = 'PUBLISHED'
        ORDER BY difficulty_band DESC, created_at
        LIMIT 10
    LOOP
        INSERT INTO exam_questions (exam_id, question_id, question_order)
        VALUES (exam2_id, qid, ord)
        ON CONFLICT DO NOTHING;
        ord := ord + 1;
    END LOOP;

    -- ─────────────────────────────────────────────────────────────
    -- Exam 3: Year 3 Reading Practice  (FREE tier)
    -- ─────────────────────────────────────────────────────────────
    INSERT INTO exams (id, title, description, year_level, domain,
                       package_tier, time_limit_seconds,
                       available_from, available_until, status)
    VALUES (exam3_id,
            'Year 3 Reading Practice',
            'A reading comprehension and language practice exam for Year 3 students. Perfect for building confidence.',
            3, 'READING', 'FREE', 1800,
            NOW() - INTERVAL '1 day',
            NOW() + INTERVAL '60 days',
            'PUBLISHED');

    ord := 1;
    FOR qid IN
        SELECT id FROM questions
        WHERE year_level = 3 AND domain = 'READING' AND status = 'PUBLISHED'
        ORDER BY created_at
        LIMIT 10
    LOOP
        INSERT INTO exam_questions (exam_id, question_id, question_order)
        VALUES (exam3_id, qid, ord)
        ON CONFLICT DO NOTHING;
        ord := ord + 1;
    END LOOP;

END $$;
