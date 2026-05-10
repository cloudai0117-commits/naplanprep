CREATE TYPE question_type AS ENUM ('MULTIPLE_CHOICE', 'DRAG_DROP', 'SHORT_ANSWER', 'EXTENDED_WRITING');
CREATE TYPE domain_type AS ENUM ('READING', 'WRITING', 'SPELLING', 'GRAMMAR_PUNCTUATION', 'NUMERACY');
CREATE TYPE question_status AS ENUM ('DRAFT', 'REVIEW', 'PUBLISHED', 'ARCHIVED');

CREATE TABLE questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_type question_type NOT NULL,
    year_level INTEGER NOT NULL CHECK (year_level IN (3, 5, 7, 9)),
    domain domain_type NOT NULL,
    topic VARCHAR(200) NOT NULL,
    difficulty_band INTEGER NOT NULL CHECK (difficulty_band BETWEEN 1 AND 10),
    stimulus_text TEXT,
    question_text TEXT NOT NULL,
    options JSONB,
    correct_answer JSONB NOT NULL,
    explanation TEXT,
    status question_status NOT NULL DEFAULT 'DRAFT',
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_questions_year_level ON questions(year_level);
CREATE INDEX idx_questions_domain ON questions(domain);
CREATE INDEX idx_questions_status ON questions(status);
CREATE INDEX idx_questions_difficulty ON questions(difficulty_band);
CREATE INDEX idx_questions_year_domain ON questions(year_level, domain);
CREATE INDEX idx_questions_topic ON questions USING gin(to_tsvector('english', topic));

CREATE TRIGGER update_questions_updated_at BEFORE UPDATE ON questions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
