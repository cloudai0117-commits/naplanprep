-- V29: Reset exam sessions for test accounts and add more sample schools

-- Reset exam sessions so test accounts can take exams again
DELETE FROM exam_results WHERE session_id IN (
    SELECT es.id FROM exam_sessions es
    JOIN users u ON u.id = es.user_id
    WHERE u.email IN ('student1@test.com','student2@test.com','student3@test.com',
                      'free-student@test.com','standard-student@test.com','premium-student@test.com')
);
DELETE FROM exam_answers WHERE session_id IN (
    SELECT es.id FROM exam_sessions es
    JOIN users u ON u.id = es.user_id
    WHERE u.email IN ('student1@test.com','student2@test.com','student3@test.com',
                      'free-student@test.com','standard-student@test.com','premium-student@test.com')
);
DELETE FROM exam_sessions WHERE user_id IN (
    SELECT id FROM users WHERE email IN ('student1@test.com','student2@test.com','student3@test.com',
                                          'free-student@test.com','standard-student@test.com','premium-student@test.com')
);

-- Add more sample schools
INSERT INTO schools (id, name, state) VALUES
    (uuid_generate_v4(), 'Hobart College', 'TAS'),
    (uuid_generate_v4(), 'Canberra Grammar School', 'ACT'),
    (uuid_generate_v4(), 'Darwin High School', 'NT'),
    (uuid_generate_v4(), 'James Ruse Agricultural High School', 'NSW'),
    (uuid_generate_v4(), 'Scotch College Melbourne', 'VIC'),
    (uuid_generate_v4(), 'Knox Grammar School', 'NSW'),
    (uuid_generate_v4(), 'Shore School', 'NSW'),
    (uuid_generate_v4(), 'Geelong Grammar School', 'VIC'),
    (uuid_generate_v4(), 'Wesley College', 'VIC'),
    (uuid_generate_v4(), 'St Peters College', 'SA')
ON CONFLICT DO NOTHING;
