package au.com.naplanprep.exam.service.scoring;

import java.util.Map;

/**
 * Evaluates one student answer against the correct answer from a session snapshot.
 *
 * Implementations must be stateless — one singleton per question type is safe to
 * inject into any service without synchronisation concerns.
 *
 * Return contract:
 *   true  — student answer matches the correct answer (full marks awarded)
 *   false — student answer does not match
 *   null  — question cannot be auto-marked (EXTENDED_WRITING); session set to PENDING_REVIEW
 */
public interface ScoringStrategy {

    /**
     * @param studentAnswer  the answer payload from exam_answers.answer JSONB
     * @param correctAnswer  the correct answer from the session snapshot (never exposed to students)
     * @param marks          the question's mark value (informational; strategy awards full or zero)
     * @return true/false/null per contract above
     */
    Boolean score(Map<String, Object> studentAnswer, Map<String, Object> correctAnswer, int marks);
}
