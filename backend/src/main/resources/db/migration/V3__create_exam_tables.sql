CREATE TABLE exam_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    exam_type VARCHAR(50) NOT NULL,
    year_level INTEGER NOT NULL,
    domain VARCHAR(50),
    question_ids JSONB NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'IN_PROGRESS',
    started_at TIMESTAMPTZ,
    submitted_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    time_limit_seconds INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE exam_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES exam_sessions(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES questions(id),
    answer JSONB NOT NULL,
    correct BOOLEAN,
    flagged BOOLEAN DEFAULT FALSE,
    time_taken_seconds INTEGER,
    answered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_session_question UNIQUE (session_id, question_id)
);

CREATE TABLE exam_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL UNIQUE REFERENCES exam_sessions(id),
    user_id UUID NOT NULL REFERENCES users(id),
    total_questions INTEGER NOT NULL,
    correct_answers INTEGER NOT NULL,
    score_percentage DOUBLE PRECISION NOT NULL,
    naplan_band INTEGER NOT NULL,
    domain_breakdown JSONB,
    topic_breakdown JSONB,
    calculated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_sessions_user_id ON exam_sessions(user_id);
CREATE INDEX idx_sessions_status ON exam_sessions(status);
CREATE INDEX idx_sessions_created_at ON exam_sessions(created_at);
CREATE INDEX idx_answers_session ON exam_answers(session_id);
CREATE INDEX idx_results_user ON exam_results(user_id);
CREATE INDEX idx_results_session ON exam_results(session_id);
