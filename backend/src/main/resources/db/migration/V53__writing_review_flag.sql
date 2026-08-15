-- ================================================================
-- V53 — Writing review flag on exam_results
--
-- When a session contains EXTENDED_WRITING questions the result
-- cannot be finalised until a human reviewer has assigned marks.
-- pending_review = TRUE signals that the result totals are
-- provisional and the session appears in the admin marking queue.
-- ================================================================

ALTER TABLE exam_results
    ADD COLUMN IF NOT EXISTS pending_review BOOLEAN NOT NULL DEFAULT FALSE;

CREATE INDEX IF NOT EXISTS idx_results_pending_review
    ON exam_results(pending_review)
    WHERE pending_review = TRUE;

-- Populate for existing writing-domain results so the flag is
-- consistent after migration.
UPDATE exam_results r
SET    pending_review = TRUE
FROM   exam_sessions s
WHERE  r.session_id = s.id
  AND  s.domain     = 'WRITING'
  AND  r.pending_review = FALSE;
