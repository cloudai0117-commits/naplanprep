-- ================================================================
-- V48 — Add section and testlet references to exam_questions
-- Allows questions to be assigned to a specific section and testlet
-- within an exam. Both columns are nullable for backward compatibility:
-- existing exam_questions rows (from V40 seed) have no section/testlet.
-- ================================================================

ALTER TABLE exam_questions
    ADD COLUMN IF NOT EXISTS section_id UUID REFERENCES exam_sections(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS testlet_id UUID REFERENCES testlets(id)      ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_exam_questions_section  ON exam_questions(section_id);
CREATE INDEX IF NOT EXISTS idx_exam_questions_testlet  ON exam_questions(testlet_id);
