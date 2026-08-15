-- ================================================================
-- V47 — Data-driven branching / testlet transitions
--
-- Defines which testlet a student moves to after completing a given
-- testlet. Supports:
--   ALWAYS      — linear, unconditional
--   SCORE_ABOVE — percentage correct in source_testlet > threshold
--   SCORE_BELOW — percentage correct in source_testlet <= threshold
--
-- The branching engine evaluates all transitions for a source testlet,
-- ordered by priority (highest first), and follows the first condition
-- that matches. An ALWAYS rule with priority 0 acts as a fallback.
--
-- Example linear path:  T1 -> T2 -> T3  (all ALWAYS, priority 0)
-- Example branched path:
--   T1 -> T3 (SCORE_ABOVE 0.7, priority 10)
--   T1 -> T2 (ALWAYS, priority 0)
-- ================================================================

CREATE TABLE IF NOT EXISTS testlet_transitions (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exam_id        UUID NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    source_testlet UUID NOT NULL REFERENCES testlets(id) ON DELETE CASCADE,
    target_testlet UUID NOT NULL REFERENCES testlets(id) ON DELETE CASCADE,
    condition_type VARCHAR(30) NOT NULL DEFAULT 'ALWAYS',
    -- ALWAYS | SCORE_ABOVE | SCORE_BELOW
    condition_value JSONB,
    -- For SCORE_ABOVE/BELOW: {"threshold": 0.6}
    priority       INTEGER NOT NULL DEFAULT 0,
    -- Higher priority evaluated first; first match wins
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_no_self_loop   CHECK (source_testlet != target_testlet),
    CONSTRAINT chk_condition_type CHECK (condition_type IN ('ALWAYS','SCORE_ABOVE','SCORE_BELOW'))
);

CREATE INDEX IF NOT EXISTS idx_transitions_source ON testlet_transitions(source_testlet);
CREATE INDEX IF NOT EXISTS idx_transitions_exam   ON testlet_transitions(exam_id);
