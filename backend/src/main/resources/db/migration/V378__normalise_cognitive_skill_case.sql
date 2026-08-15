-- V378__normalise_cognitive_skill_case.sql
--
-- Some questions were seeded with mixed-case cognitive_skill values
-- (e.g. "Application", "Comprehension") that do not match the Java enum's
-- EnumType.STRING values (uppercase: APPLICATION, COMPREHENSION).
-- Normalise all to uppercase so Hibernate can deserialise them correctly.
--
-- Idempotent: WHERE clause matches only the affected rows.

BEGIN;

UPDATE questions SET cognitive_skill = UPPER(cognitive_skill)
WHERE cognitive_skill IN ('Application', 'Comprehension');

COMMIT;
