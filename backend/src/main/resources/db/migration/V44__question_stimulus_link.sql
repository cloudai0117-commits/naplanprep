-- ================================================================
-- V44 — Link questions to shared stimuli + writing rubric support
-- ================================================================

-- Foreign key from question to its shared stimulus.
-- NULL = standalone question with no shared stimulus.
-- Keeps existing stimulus_text for short inline hints; full passages go to stimuli.
ALTER TABLE questions
    ADD COLUMN IF NOT EXISTS stimulus_id    UUID REFERENCES stimuli(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS marking_rubric JSONB;
    -- marking_rubric: for EXTENDED_WRITING questions only.
    -- Structure: {"criteria":[{"name":"Audience","maxMarks":6},...],"totalMarks":50}

CREATE INDEX IF NOT EXISTS idx_questions_stimulus ON questions(stimulus_id);
