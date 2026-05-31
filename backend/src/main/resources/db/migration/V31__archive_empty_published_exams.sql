-- Archive PUBLISHED exams that have no questions assigned.
-- These are leftover test artefacts from UI-ADM-14 runs where the publish
-- succeeded but the cleanup ARCHIVE call failed (due to the Hibernate enum bug),
-- leaving 0-question PUBLISHED exams visible to students.
UPDATE exams
SET status     = 'ARCHIVED',
    updated_at = NOW()
WHERE status = 'PUBLISHED'
  AND id NOT IN (SELECT DISTINCT exam_id FROM exam_questions);
