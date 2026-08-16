package au.com.naplanprep.exam;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.dto.AvailableExamResponse;
import au.com.naplanprep.exam.entity.PackageType;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Verifies that AvailableExamResponse carries studentTestLength (not pool count).
 *
 * Authoritative student path lengths derived from migration structure:
 *   NUMERACY:            Y3=36 (8×12), Y5=42 (8×14), Y7/Y9=48 (8×16)
 *   READING:             Y3/Y5=39 (8×13), Y7/Y9=48 (8×16)
 *   GRAMMAR_PUNCTUATION: all years=27 (8×9)
 *   SPELLING:            all years=25 (5-testlet pool, student path 7+9+9)
 *   WRITING:             all years=1
 */
class StudentTestLengthTest {

    private AvailableExamResponse response(int studentTestLength, Question.Domain domain, int yearLevel) {
        return new AvailableExamResponse(
            UUID.randomUUID(), "Test", "Desc",
            domain, yearLevel, 3600,
            null, null,
            studentTestLength,
            PackageType.FREE, "AVAILABLE", false, null
        );
    }

    @Test
    void numeracy_y3_student_test_length_is_36() {
        assertEquals(36, response(36, Question.Domain.NUMERACY, 3).studentTestLength());
    }

    @Test
    void numeracy_y5_student_test_length_is_42() {
        assertEquals(42, response(42, Question.Domain.NUMERACY, 5).studentTestLength());
    }

    @Test
    void numeracy_y7_student_test_length_is_48() {
        assertEquals(48, response(48, Question.Domain.NUMERACY, 7).studentTestLength());
    }

    @Test
    void numeracy_y9_student_test_length_is_48() {
        assertEquals(48, response(48, Question.Domain.NUMERACY, 9).studentTestLength());
    }

    @Test
    void reading_y3_student_test_length_is_39() {
        assertEquals(39, response(39, Question.Domain.READING, 3).studentTestLength());
    }

    @Test
    void reading_y5_student_test_length_is_39() {
        assertEquals(39, response(39, Question.Domain.READING, 5).studentTestLength());
    }

    @Test
    void reading_y7_student_test_length_is_48() {
        assertEquals(48, response(48, Question.Domain.READING, 7).studentTestLength());
    }

    @Test
    void reading_y9_student_test_length_is_48() {
        assertEquals(48, response(48, Question.Domain.READING, 9).studentTestLength());
    }

    @Test
    void grammar_all_years_student_test_length_is_27() {
        for (int y : new int[]{3, 5, 7, 9}) {
            assertEquals(27, response(27, Question.Domain.GRAMMAR_PUNCTUATION, y).studentTestLength(),
                "Expected 27 for Y" + y + " GRAMMAR_PUNCTUATION");
        }
    }

    @Test
    void spelling_all_years_student_test_length_is_25() {
        for (int y : new int[]{3, 5, 7, 9}) {
            assertEquals(25, response(25, Question.Domain.SPELLING, y).studentTestLength(),
                "Expected 25 for Y" + y + " SPELLING");
        }
    }

    @Test
    void writing_all_years_student_test_length_is_1() {
        for (int y : new int[]{3, 5, 7, 9}) {
            assertEquals(1, response(1, Question.Domain.WRITING, y).studentTestLength(),
                "Expected 1 for Y" + y + " WRITING");
        }
    }

    @Test
    void student_test_length_field_exists_on_response_record() {
        AvailableExamResponse r = response(48, Question.Domain.NUMERACY, 9);
        assertEquals(48, r.studentTestLength());
    }
}
