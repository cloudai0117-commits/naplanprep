-- V375__archive_legacy_empty_exam_shells.sql
--
-- Archives two categories of obsolete published exams that must not appear
-- in student-facing exam catalogs:
--
-- Category A (308 rows): "Grade N" prefix shells seeded by V35 as placeholder
--   scaffolding before the canonical "Year N" content migrations (V54–V374)
--   existed. V36a–V36d, which were meant to populate them, were skipped by
--   Flyway due to letter-suffix naming. All 308 have zero exam_questions and
--   zero references in exam_sessions, exam_results, or testlet_transitions.
--
-- Category B (3 rows): Early "Year N" test exams from V13/V14 with fewer than
--   20 questions, occupying year/domain/package cells that also contain the
--   canonical V54–V374 content exams. These were never intended for production.
--
-- Idempotent: WHERE status = 'PUBLISHED' ensures re-running has no effect.
-- No hard-coded UUIDs: criteria are deterministic title patterns + empty check.

BEGIN;

-- Category A: archive all "Grade N" shells with no exam_questions
UPDATE exams
SET    status = 'ARCHIVED'
WHERE  status = 'PUBLISHED'
  AND  title  LIKE 'Grade%'
  AND  id NOT IN (SELECT DISTINCT exam_id FROM exam_questions);

-- Category B: archive known legacy test exams (< 20 questions, pre-V54 seeds)
UPDATE exams
SET    status = 'ARCHIVED'
WHERE  status = 'PUBLISHED'
  AND  title IN (
         'Year 3 Reading Practice',
         'Year 5 Numeracy Assessment',
         'Year 5 Numeracy — Advanced Challenge'
       );

COMMIT;
