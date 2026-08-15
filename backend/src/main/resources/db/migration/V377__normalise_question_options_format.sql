-- V377__normalise_question_options_format.sql
--
-- 140 questions seeded by early Batch 1 migrations (pre-V58) store options
-- as a wrapped JSON object:  {"options": ["A stick", "A ball", ...]}
-- with correctAnswer as the full option text: {"value": "A ball"}
--
-- All 18,839 Batch 2 questions use the canonical array format:
--   [{"text": "A stick", "label": "A"}, {"text": "A ball", "label": "B"}, ...]
-- with correctAnswer as the option label: {"value": "B"}
--
-- This migration converts the 140 old-format rows to the canonical array
-- format so the Question entity mapping (List<Map<String,Object>>) works
-- uniformly across all questions.
--
-- Safety:
--   - Only touches rows where jsonb_typeof(options) = 'object' AND options ? 'options'
--   - Verified: all 140 rows have correctAnswer text that matches an option text
--   - Idempotent: after migration, no rows match the WHERE clause

BEGIN;

WITH old_format AS (
    SELECT
        id,
        options -> 'options'     AS opts_array,
        correct_answer ->> 'value' AS correct_text
    FROM questions
    WHERE jsonb_typeof(options) = 'object'
      AND options ? 'options'
)
UPDATE questions q
SET
    -- Convert ["A stick","A ball",...] to [{"text":"A stick","label":"A"},...]
    options = (
        SELECT jsonb_agg(
            jsonb_build_object(
                'text',  elem.value,
                'label', CHR(65 + (elem.ordinality - 1)::int)
            )
            ORDER BY elem.ordinality
        )
        FROM jsonb_array_elements_text(of.opts_array) WITH ORDINALITY AS elem(value, ordinality)
    ),
    -- Convert {"value":"A ball"} to {"value":"A"} (the label for that option)
    correct_answer = jsonb_build_object('value', (
        SELECT CHR(65 + (elem.ordinality - 1)::int)
        FROM jsonb_array_elements_text(of.opts_array) WITH ORDINALITY AS elem(value, ordinality)
        WHERE elem.value = of.correct_text
        LIMIT 1
    ))
FROM old_format of
WHERE q.id = of.id;

COMMIT;
