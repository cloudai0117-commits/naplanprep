-- ================================================================
-- V50 — Session navigation state
-- Stores the student's current position within the assessment.
-- All navigation state is server-authoritative.
-- ================================================================

ALTER TABLE exam_sessions
    ADD COLUMN IF NOT EXISTS current_section_id     UUID,
    ADD COLUMN IF NOT EXISTS current_testlet_id     UUID,
    ADD COLUMN IF NOT EXISTS current_question_order INTEGER,
    ADD COLUMN IF NOT EXISTS question_path          JSONB DEFAULT '[]',
    -- Ordered array of testlet UUIDs the student will traverse.
    -- For linear exams: determined at start.
    -- For branching: grows as transitions are resolved.
    ADD COLUMN IF NOT EXISTS randomisation_seed     BIGINT,
    -- Stored so question order is deterministic on resume.
    ADD COLUMN IF NOT EXISTS flagged_questions      JSONB DEFAULT '[]',
    -- Array of question UUIDs the student has flagged for review.
    ADD COLUMN IF NOT EXISTS answer_count           INTEGER NOT NULL DEFAULT 0,
    -- Cached count of saved answers; updated on each submitAnswer.
    ADD COLUMN IF NOT EXISTS has_snapshot           BOOLEAN NOT NULL DEFAULT FALSE;
    -- True once session_question_snapshots have been written.
    -- Guards against partial snapshot writes on crash.
