-- ================================================================
-- V49 — Session question snapshots (immutability)
--
-- When a student starts an exam, a snapshot of every question's content
-- is stored here. Subsequent reads during the session use the snapshot,
-- not the live questions table. Admin edits to questions/stimuli/answers
-- after session start have NO effect on the active session.
--
-- The snapshot JSONB captures everything needed to:
--   1. Render the question to the student
--   2. Grade the student's answer
--   3. Show the result review after submission
-- ================================================================

CREATE TABLE IF NOT EXISTS session_question_snapshots (
    session_id     UUID NOT NULL REFERENCES exam_sessions(id) ON DELETE CASCADE,
    question_id    UUID NOT NULL,
    question_order INTEGER NOT NULL,
    testlet_id     UUID,   -- null for flat (non-testlet) sessions
    section_id     UUID,   -- null for flat sessions
    snapshot       JSONB NOT NULL,
    -- Snapshot includes: questionType, questionText, stimulusText, stimulusType,
    --   stimulusContent, stimulusAssetUrl, options, correctAnswer, explanation,
    --   marks, markingRubric, topic, domain, yearLevel, difficultyBand
    -- Note: correctAnswer IS stored in the snapshot (needed for grading)
    -- but MUST NEVER be sent to the student client.
    PRIMARY KEY (session_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_snapshots_session
    ON session_question_snapshots(session_id);

CREATE INDEX IF NOT EXISTS idx_snapshots_session_order
    ON session_question_snapshots(session_id, question_order);

CREATE INDEX IF NOT EXISTS idx_snapshots_session_testlet
    ON session_question_snapshots(session_id, testlet_id);
