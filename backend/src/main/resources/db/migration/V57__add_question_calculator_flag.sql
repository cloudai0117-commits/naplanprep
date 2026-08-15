-- P0-2: Add per-question calculator control for Y7/Y9 Numeracy A-stage.
-- Within the Y7/Y9 Numeracy A testlet, questions 1-8 are non-calculator and
-- questions 9-16 are calculator-allowed — both live in the same testlet, so
-- testlet.calculator_allowed cannot represent this split alone.
-- This column is the authoritative source: FALSE means no calculator regardless
-- of testlet or section setting.

ALTER TABLE questions
    ADD COLUMN calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE;

-- Y3 and Y5 Numeracy: no calculator per NAPLAN specification.
-- Existing question rows are all Y3 Numeracy (V54-V56); backfill to FALSE.
-- Y7/Y9 content migrations will explicitly set calculator_allowed per question.
UPDATE questions
SET    calculator_allowed = FALSE
WHERE  domain = 'NUMERACY'
  AND  year_level IN (3, 5);
