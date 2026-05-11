CREATE TABLE exam_questions (
    exam_id        UUID    NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    question_id    UUID    NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    question_order INTEGER NOT NULL CHECK (question_order >= 1),
    PRIMARY KEY (exam_id, question_id)
);

CREATE INDEX idx_exam_questions_exam  ON exam_questions(exam_id);
CREATE INDEX idx_exam_questions_order ON exam_questions(exam_id, question_order);
