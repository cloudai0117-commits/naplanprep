-- V383: Fix exam_results.total_questions and score_percentage for adaptive exams.
--
-- Root cause: calculateAndSaveResult() used session.questionIds.size() (pool count, e.g. 128)
-- instead of exams.student_test_length (student test length, e.g. 48).
-- Result: Y9/Y7 Numeracy results stored total_questions=128, score halved vs true score.
--
-- This migration repairs all affected rows by joining back to the exam's authoritative
-- student_test_length. Rows already correct (total_questions = student_test_length) are untouched.
-- score_percentage is recalculated to match the corrected denominator.

UPDATE exam_results er
SET    total_questions  = e.student_test_length,
       score_percentage = CASE
                            WHEN e.student_test_length > 0
                            THEN ROUND(er.correct_answers::NUMERIC * 100.0 / e.student_test_length, 2)
                            ELSE 0
                          END
FROM   exam_sessions es
JOIN   exams e ON es.exam_id = e.id
WHERE  er.session_id   = es.id
  AND  e.student_test_length > 0
  AND  er.total_questions <> e.student_test_length;
