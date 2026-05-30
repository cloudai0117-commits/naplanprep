-- Reset exam sessions and results for test accounts so automated tests can re-run exams.
-- Must delete exam_results first (FK references exam_sessions with no CASCADE),
-- then exam_answers (FK has CASCADE but delete explicitly for clarity),
-- then exam_sessions.

DELETE FROM exam_results
WHERE user_id IN (
    SELECT id FROM users WHERE email IN ('student1@test.com', 'student2@test.com')
);

DELETE FROM exam_answers
WHERE session_id IN (
    SELECT es.id FROM exam_sessions es
    JOIN users u ON u.id = es.user_id
    WHERE u.email IN ('student1@test.com', 'student2@test.com')
);

DELETE FROM exam_sessions
WHERE user_id IN (
    SELECT id FROM users WHERE email IN ('student1@test.com', 'student2@test.com')
);
