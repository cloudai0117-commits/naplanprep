-- Performance indexes for exam engine at scale

-- Support findSeenQuestionIdsByUserId JOIN and answer lookups by question
CREATE INDEX IF NOT EXISTS idx_answers_question_id     ON exam_answers(question_id);

-- Support filtered history queries (user's sessions by status)
CREATE INDEX IF NOT EXISTS idx_sessions_user_status    ON exam_sessions(user_id, status);

-- Support background expiry sweeper: find IN_PROGRESS sessions past their deadline
CREATE INDEX IF NOT EXISTS idx_sessions_status_expires ON exam_sessions(status, expires_at);
