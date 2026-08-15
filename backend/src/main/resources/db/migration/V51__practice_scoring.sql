-- ================================================================
-- V51 — Practice score bands
--
-- Replaces the fabricated naplan_band percentage buckets.
-- Labels are generic practice indicators, NOT official NAPLAN bands.
-- The naplan_band column on exam_results is preserved for backward
-- compatibility but its calculation now uses this table.
-- ================================================================

CREATE TABLE IF NOT EXISTS practice_score_bands (
    id          SERIAL PRIMARY KEY,
    year_level  INTEGER NOT NULL CHECK (year_level IN (3, 5, 7, 9)),
    domain      VARCHAR(50) NOT NULL,
    band        INTEGER NOT NULL CHECK (band BETWEEN 1 AND 10),
    label       VARCHAR(100) NOT NULL,
    min_percent NUMERIC(5,2) NOT NULL,
    max_percent NUMERIC(5,2) NOT NULL,
    UNIQUE (year_level, domain, band)
);

-- Seed generic practice score bands (same thresholds across year levels;
-- official NAPLAN thresholds differ by year level and can be loaded later
-- via the admin API once officially published mappings are available).
--
-- Labels are deliberately non-NAPLAN to avoid misrepresentation.
-- Administrators can update these via the admin API.

DO $$
DECLARE
    yr  INTEGER;
    dom VARCHAR;
BEGIN
    FOREACH yr IN ARRAY ARRAY[3, 5, 7, 9] LOOP
        FOREACH dom IN ARRAY ARRAY[
            'NUMERACY','READING','WRITING','SPELLING','GRAMMAR_PUNCTUATION'
        ] LOOP
            INSERT INTO practice_score_bands
                (year_level, domain, band, label, min_percent, max_percent)
            VALUES
                (yr, dom,  1, 'Foundation Level 1',    0.00,  9.99),
                (yr, dom,  2, 'Foundation Level 2',   10.00, 19.99),
                (yr, dom,  3, 'Developing Level 1',   20.00, 29.99),
                (yr, dom,  4, 'Developing Level 2',   30.00, 44.99),
                (yr, dom,  5, 'Meeting Standard 1',   45.00, 54.99),
                (yr, dom,  6, 'Meeting Standard 2',   55.00, 64.99),
                (yr, dom,  7, 'Exceeding Standard 1', 65.00, 74.99),
                (yr, dom,  8, 'Exceeding Standard 2', 75.00, 84.99),
                (yr, dom,  9, 'Advanced Level 1',     85.00, 92.99),
                (yr, dom, 10, 'Advanced Level 2',     93.00, 100.00)
            ON CONFLICT (year_level, domain, band) DO NOTHING;
        END LOOP;
    END LOOP;
END $$;

-- Exam-level scoring configuration (optional overrides per exam)
ALTER TABLE exams
    ADD COLUMN IF NOT EXISTS scoring_config JSONB;
-- scoring_config: {"weightByMarks": true, "passMark": 60, "showBand": true}
