-- ================================================================
-- V45 — Exam sections
-- A section represents a distinct part of an exam:
--   e.g. "Non-Calculator", "Calculator Allowed", "Reading Passage 1"
-- Sections can have independent time limits and navigation rules.
-- ================================================================

CREATE TABLE IF NOT EXISTS exam_sections (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exam_id             UUID NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    title               VARCHAR(200) NOT NULL,
    section_order       INTEGER NOT NULL CHECK (section_order >= 1),
    time_limit_seconds  INTEGER,           -- NULL = inherits exam-level limit
    calculator_allowed  BOOLEAN NOT NULL DEFAULT FALSE,
    navigation_locked   BOOLEAN NOT NULL DEFAULT FALSE,
    -- navigation_locked = true means student cannot return to this section
    -- once they have advanced past it
    domain              VARCHAR(50),       -- may differ from exam domain for COL exams
    instructions        TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (exam_id, section_order)
);

CREATE INDEX IF NOT EXISTS idx_sections_exam ON exam_sections(exam_id);
