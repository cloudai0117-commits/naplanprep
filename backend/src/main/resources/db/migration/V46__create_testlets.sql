-- ================================================================
-- V46 — Testlets
-- A testlet is a group of questions within a section, optionally
-- linked to a shared stimulus (passage/audio/image).
-- Testlets are the unit of branching/tailoring.
-- ================================================================

CREATE TABLE IF NOT EXISTS testlets (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    section_id        UUID NOT NULL REFERENCES exam_sections(id) ON DELETE CASCADE,
    stimulus_id       UUID REFERENCES stimuli(id) ON DELETE SET NULL,
    title             VARCHAR(200),
    testlet_order     INTEGER NOT NULL CHECK (testlet_order >= 1),
    is_branching_node BOOLEAN NOT NULL DEFAULT FALSE,
    -- When true, the branching engine evaluates transitions after this testlet
    navigation_locked BOOLEAN NOT NULL DEFAULT FALSE,
    -- When true, once a student leaves this testlet they cannot return
    calculator_allowed BOOLEAN,
    -- NULL = inherits from section; explicit value overrides section setting
    instructions      TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (section_id, testlet_order)
);

CREATE INDEX IF NOT EXISTS idx_testlets_section  ON testlets(section_id);
CREATE INDEX IF NOT EXISTS idx_testlets_stimulus ON testlets(stimulus_id);
