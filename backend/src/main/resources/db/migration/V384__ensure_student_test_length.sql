-- V384: Corrective migration — guarantee student_test_length is populated for all exams.
--
-- Root cause: V381 and V382 may have run only partially (or not at all) if the app
-- was deployed with a version that lacked ignore-migration-patterns: "*:Failed".
-- This migration is fully idempotent and safe to run in any state:
--   * Column does not exist → ADD COLUMN, then populate and enforce NOT NULL.
--   * Column exists but has NULL/zero rows → UPDATE those rows.
--   * Column exists and is fully populated → no-op.
--
-- Uses ADD COLUMN IF NOT EXISTS (no DEFAULT) so existing non-null values are preserved.

-- ── 1. Column creation ────────────────────────────────────────────────────────
ALTER TABLE exams ADD COLUMN IF NOT EXISTS student_test_length INTEGER;

-- ── 2. Authoritative values by domain + year_level ───────────────────────────
-- Only update rows that are NULL or zero; never overwrite a valid existing value.

UPDATE exams
SET student_test_length = 1
WHERE domain = 'WRITING'
  AND (student_test_length IS NULL OR student_test_length = 0);

UPDATE exams
SET student_test_length = 25
WHERE domain = 'SPELLING'
  AND (student_test_length IS NULL OR student_test_length = 0);

UPDATE exams
SET student_test_length = 27
WHERE domain = 'GRAMMAR_PUNCTUATION'
  AND (student_test_length IS NULL OR student_test_length = 0);

UPDATE exams
SET student_test_length = 36
WHERE domain = 'NUMERACY' AND year_level = 3
  AND (student_test_length IS NULL OR student_test_length = 0);

UPDATE exams
SET student_test_length = 42
WHERE domain = 'NUMERACY' AND year_level = 5
  AND (student_test_length IS NULL OR student_test_length = 0);

UPDATE exams
SET student_test_length = 48
WHERE domain = 'NUMERACY' AND year_level IN (7, 9)
  AND (student_test_length IS NULL OR student_test_length = 0);

UPDATE exams
SET student_test_length = 39
WHERE domain = 'READING' AND year_level IN (3, 5)
  AND (student_test_length IS NULL OR student_test_length = 0);

UPDATE exams
SET student_test_length = 48
WHERE domain = 'READING' AND year_level IN (7, 9)
  AND (student_test_length IS NULL OR student_test_length = 0);

-- ── 3. Catch-all safety net ──────────────────────────────────────────────────
-- Any remaining NULL or zero (e.g., draft exams with unusual year_level).
-- Minimum value of 1 satisfies the CHECK constraint without corrupting real data.
UPDATE exams
SET student_test_length = 1
WHERE student_test_length IS NULL OR student_test_length = 0;

-- ── 4. Enforce NOT NULL ───────────────────────────────────────────────────────
ALTER TABLE exams ALTER COLUMN student_test_length SET NOT NULL;

-- ── 5. Add positive-value CHECK constraint (idempotent) ──────────────────────
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
