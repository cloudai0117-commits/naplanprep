-- ================================================================
-- V42 — Schema corrections identified in architecture audit
-- ================================================================

-- 1. exam_answers: track when an answer was last modified
ALTER TABLE exam_answers ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;

-- 2. questions: content-generation required fields
ALTER TABLE questions
    ADD COLUMN IF NOT EXISTS marks             INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS cognitive_skill   VARCHAR(50),
    ADD COLUMN IF NOT EXISTS curriculum_strand VARCHAR(100),
    ADD COLUMN IF NOT EXISTS audio_url         VARCHAR(500);

-- 3. exam_results: direct reference to exam (avoids join through exam_sessions)
ALTER TABLE exam_results
    ADD COLUMN IF NOT EXISTS exam_id UUID REFERENCES exams(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_results_exam_id
    ON exam_results(exam_id);

CREATE INDEX IF NOT EXISTS idx_results_user_calculated
    ON exam_results(user_id, calculated_at DESC);

-- 4. Remove the dead package_tier column left over from V9
--    V32 added 'tag', V34 renamed it to 'package_type'.
--    The original V9 package_tier was never removed.
ALTER TABLE exams DROP COLUMN IF EXISTS package_tier;

-- 5. Prevent duplicate IN_PROGRESS sessions for the same user+exam.
--    The existing index only blocks duplicate SUBMITTED sessions (V11).
CREATE UNIQUE INDEX IF NOT EXISTS uq_user_exam_inprogress
    ON exam_sessions(user_id, exam_id)
    WHERE exam_id IS NOT NULL AND status = 'IN_PROGRESS';

-- 6. Performance indexes missing from V41
CREATE INDEX IF NOT EXISTS idx_answers_session_answered
    ON exam_answers(session_id, answered_at DESC);

CREATE INDEX IF NOT EXISTS idx_subscriptions_user_status
    ON subscriptions(user_id, status);

CREATE INDEX IF NOT EXISTS idx_user_tags_user_id
    ON user_tags(user_id);

-- 7. replace fake naplan_band on results with practice_indicator column
--    keeping naplan_band for backward compat with existing result rows
ALTER TABLE exam_results
    ADD COLUMN IF NOT EXISTS practice_label VARCHAR(50);
