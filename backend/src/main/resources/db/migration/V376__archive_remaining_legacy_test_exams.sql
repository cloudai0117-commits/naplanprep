-- V376__archive_remaining_legacy_test_exams.sql
--
-- Archives the remaining 24 legacy test exams that were not caught by V375
-- because they have some questions (from V12/V14 test seed migrations):
--
--   12 × "Grade N Domain – Free Exam 1"  (8 questions each, V12/V14 origin)
--   12 × "NAPLAN Year N Domain"           (10 questions each, V14 origin)
--
-- All 24 have zero references in exam_sessions, exam_results, or
-- user-facing subscription entitlement. None is a canonical production exam.
--
-- Canonical production exams all follow the title pattern:
--   "Year <N> <Domain> — [Free|Advanced|Premium] Practice Exam <NN>"
-- These legacy exams do NOT match that pattern and are safe to archive.
--
-- Idempotent: WHERE status = 'PUBLISHED' ensures re-running has no effect.

BEGIN;

UPDATE exams
SET    status = 'ARCHIVED'
WHERE  status = 'PUBLISHED'
  AND  (title LIKE 'Grade%' OR title LIKE 'NAPLAN%');

COMMIT;
