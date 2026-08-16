-- V382: Idempotent repair for student_test_length column and data
--
-- This migration is safe to run even if V381 ran successfully, partially,
-- or not at all. It uses ADD COLUMN IF NOT EXISTS and re-applies all UPDATE
-- statements unconditionally to guarantee correct values in every environment.
--
-- Root cause addressed:
--   V381 could fail if any exam row was left with student_test_length = 0
--   when the CHECK constraint was added (e.g., draft exams with unusual year
--   levels, or a partially applied migration on server restart).
-- This migration does not rely on V381 having completed cleanly.

-- ─── 1. Column creation (no-op if already exists from V381) ─────────────────
ALTER TABLE exams ADD COLUMN IF NOT EXISTS student_test_length INTEGER;

-- ─── 2. Set authoritative values for every known domain/year combination ─────

-- WRITING: 1 prompt per exam, all year levels
UPDATE exams SET student_test_length = 1 WHERE domain = 'WRITING';

-- SPELLING: 5-testlet pool (43 Q); student traverses 3 testlets = 25 Q
UPDATE exams SET student_test_length = 25 WHERE domain = 'SPELLING';

-- GRAMMAR_PUNCTUATION: 8-testlet pool (72 Q, 9/testlet); student path = 3 × 9 = 27
UPDATE exams SET student_test_length = 27 WHERE domain = 'GRAMMAR_PUNCTUATION';

-- NUMERACY: 8-testlet adaptive pool; student path = 3 × N/testlet
UPDATE exams SET student_test_length = 36 WHERE domain = 'NUMERACY' AND year_level = 3;
UPDATE exams SET student_test_length = 42 WHERE domain = 'NUMERACY' AND year_level = 5;
UPDATE exams SET student_test_length = 48 WHERE domain = 'NUMERACY' AND year_level IN (7, 9);

-- READING: 8-testlet adaptive pool; student path = 3 × N/testlet
UPDATE exams SET student_test_length = 39 WHERE domain = 'READING' AND year_level IN (3, 5);
UPDATE exams SET student_test_length = 48 WHERE domain = 'READING' AND year_level IN (7, 9);

-- ─── 3. Catch-all: any remaining NULL or zero rows (edge-case draft exams) ───
-- Draft/archived exams with unusual year levels that do not match any UPDATE
-- above would be left with NULL or 0 without this safety net.
UPDATE exams SET student_test_length = 1
WHERE student_test_length IS NULL OR student_test_length = 0;

-- ─── 4. Enforce NOT NULL (safe if already set from V381) ────────────────────
ALTER TABLE exams ALTER COLUMN student_test_length SET NOT NULL;

-- ─── 5. Add positive-value CHECK constraint if not already present ───────────
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'chk_student_test_length_positive'
      AND conrelid = 'exams'::regclass
  ) THEN
    ALTER TABLE exams
      ADD CONSTRAINT chk_student_test_length_positive CHECK (student_test_length > 0);
  END IF;
END $$;
