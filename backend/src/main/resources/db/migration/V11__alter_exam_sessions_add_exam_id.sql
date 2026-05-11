ALTER TABLE exam_sessions
    ADD COLUMN exam_id UUID REFERENCES exams(id) ON DELETE SET NULL;

CREATE INDEX idx_sessions_exam_id ON exam_sessions(exam_id);

-- One completed attempt per student per admin exam (enforced at DB level)
CREATE UNIQUE INDEX uq_user_exam_submitted
    ON exam_sessions(user_id, exam_id)
    WHERE exam_id IS NOT NULL AND status = 'SUBMITTED';
