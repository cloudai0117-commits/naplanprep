-- Reset exam sessions for test accounts before regression run.
-- Runs after Stripe price config (V25). Same pattern as V24 and V21.

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
