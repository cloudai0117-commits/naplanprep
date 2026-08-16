-- V381: Add student_test_length to exams table
-- Separates the student-facing exam length (questions a student actually answers)
-- from the adaptive pool count (all questions across all branching testlets).

ALTER TABLE exams ADD COLUMN student_test_length INTEGER NOT NULL DEFAULT 0;

-- WRITING: 1 prompt per exam, all year levels
UPDATE exams SET student_test_length = 1 WHERE domain = 'WRITING';

-- SPELLING: 5-testlet pool (43 Q); student traverses 3 testlets (25 Q)
UPDATE exams SET student_test_length = 25 WHERE domain = 'SPELLING';

-- GRAMMAR_PUNCTUATION: 8-testlet pool (72 Q, 9/testlet); student path = 3 × 9 = 27
UPDATE exams SET student_test_length = 27 WHERE domain = 'GRAMMAR_PUNCTUATION';

-- NUMERACY: 8-testlet adaptive pool; student path = 3 × N/testlet
UPDATE exams SET student_test_length = 36 WHERE domain = 'NUMERACY' AND year_level = 3;  -- 8×12=96 pool
UPDATE exams SET student_test_length = 42 WHERE domain = 'NUMERACY' AND year_level = 5;  -- 8×14=112 pool
UPDATE exams SET student_test_length = 48 WHERE domain = 'NUMERACY' AND year_level IN (7, 9);  -- 8×16=128 pool

-- READING: 8-testlet adaptive pool; student path = 3 × N/testlet
UPDATE exams SET student_test_length = 39 WHERE domain = 'READING' AND year_level IN (3, 5);  -- 8×13=104 pool
UPDATE exams SET student_test_length = 48 WHERE domain = 'READING' AND year_level IN (7, 9);  -- 8×16=128 pool

ALTER TABLE exams ADD CONSTRAINT chk_student_test_length_positive CHECK (student_test_length > 0);
