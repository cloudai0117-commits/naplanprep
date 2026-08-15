-- ================================================================
-- V43 — Shared stimulus table
-- Supports passages (Reading), audio (Spelling), images (Numeracy/all),
-- and writing prompts (Writing).
-- A single stimulus can be linked to multiple questions (one-to-many).
-- ================================================================

CREATE TABLE IF NOT EXISTS stimuli (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stimulus_type VARCHAR(20) NOT NULL,   -- TEXT | IMAGE | AUDIO | WRITING_PROMPT
    title         VARCHAR(200),
    content       TEXT,                   -- text passage or alt-text
    asset_url     VARCHAR(500),           -- S3/CDN for image or audio
    transcript    TEXT,                   -- admin/authoring only; NEVER sent to student
    audio_duration_seconds INTEGER,       -- Spelling: declared audio length
    year_level    INTEGER CHECK (year_level IN (3, 5, 7, 9)),
    domain        VARCHAR(50),
    status        VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    created_by    UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_stimuli_year_domain ON stimuli(year_level, domain);
CREATE INDEX IF NOT EXISTS idx_stimuli_type ON stimuli(stimulus_type);
CREATE INDEX IF NOT EXISTS idx_stimuli_status ON stimuli(status);

CREATE TRIGGER update_stimuli_updated_at BEFORE UPDATE ON stimuli
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
