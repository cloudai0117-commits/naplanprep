-- V381: Add student_test_length to exams table (idempotent revision)
-- Separates the student-facing exam length (questions a student actually answers)
-- from the adaptive pool count (all questions across all branching testlets).
--
-- Idempotent: safe to re-run if a prior attempt left the column in partial state.
-- V381 previously failed on UAT because some domain/year rows weren't matched by
-- the UPDATE statements, leaving student_test_length = 0, which caused the
-- CHECK constraint to reject the table. This revision uses IF NOT EXISTS for the
-- column, populates nullable first, adds a fallback for unmatched rows, then
-- applies NOT NULL and the CHECK constraint only after all rows are valid.

ALTER TABLE exams ADD COLUMN IF NOT EXISTS student_test_length INTEGER;

-- WRITING: 1 prompt per exam, all year levels
UPDATE exams SET student_test_length = 1 WHERE domain = 'WRITING';

-- SPELLING: 5-testlet pool (43 Q); student traverses 3 testlets (25 Q)
UPDATE exams SET student_test_length = 25 WHERE domain = 'SPELLING';

-- GRAMMAR_PUNCTUATION: 8-testlet pool (72 Q, 9/testlet); student path = 3 × 9 = 27
UPDATE exams SET student_test_length = 27 WHERE domain = 'GRAMMAR_PUNCTUATION';

-- NUMERACY: 8-testlet adaptive pool; student path = 3 × N/testlet
UPDATE exams SET student_test_length = 36 WHERE domain = 'NUMERACY' AND year_level = 3;   -- 8×12=96 pool
UPDATE exams SET student_test_length = 42 WHERE domain = 'NUMERACY' AND year_level = 5;   -- 8×14=112 pool
UPDATE exams SET student_test_length = 48 WHERE domain = 'NUMERACY' AND year_level IN (7, 9); -- 8×16=128 pool

-- READING: 8-testlet adaptive pool; student path = 3 × N/testlet
UPDATE exams SET student_test_length = 39 WHERE domain = 'READING' AND year_level IN (3, 5); -- 8×13=104 pool
UPDATE exams SET student_test_length = 48 WHERE domain = 'READING' AND year_level IN (7, 9); -- 8×16=128 pool

-- Fallback: any exam not matched above gets a minimum non-zero value.
-- Prevents CHECK constraint failure for unexpected domain/year combinations.
-- V382 will overwrite these with correct values for any such rows.
UPDATE exams SET student_test_length = 1
WHERE student_test_length IS NULL OR student_test_length = 0;

-- Column is now non-null for all rows; enforce at schema level
ALTER TABLE exams ALTER COLUMN student_test_length SET NOT NULL;

-- Add CHECK constraint only if it does not already exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'chk_student_test_length_positive'
          AND conrelid = 'exams'::regclass
    ) THEN
        ALTER TABLE exams ADD CONSTRAINT chk_student_test_length_positive
            CHECK (student_test_length > 0);
    END IF;
END $$;
