-- V21: Re-clear exam sessions for test users so smoke tests can run fresh after this deployment.
-- Mirrors V20 session cleanup. Exam results must be deleted first (no CASCADE from exam_sessions).

DELETE FROM exam_results
WHERE user_id IN (
    SELECT id FROM users WHERE email IN ('student1@test.com', 'student2@test.com', 'parent1@test.com')
);

DELETE FROM exam_sessions
WHERE user_id IN (
    SELECT id FROM users WHERE email IN ('student1@test.com', 'student2@test.com', 'parent1@test.com')
);
