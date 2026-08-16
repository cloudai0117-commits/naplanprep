package au.com.naplanprep.common;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.Exam;
import au.com.naplanprep.exam.entity.PackageType;

import java.time.Instant;

import static org.junit.jupiter.api.Assertions.assertNotNull;

/**
 * Shared factory for creating Exam test fixtures with all required NOT NULL fields.
 *
 * Usage:
 *   Exam exam = TestExamFactory.publishedExam(Question.Domain.NUMERACY, 5, PackageType.FREE);
 *
 * Do NOT duplicate studentTestLength lookup logic in individual tests.
 * Always use studentTestLength(domain, yearLevel) or the exam builders here.
 */
public final class TestExamFactory {

    private TestExamFactory() {}

    /**
     * Returns the authoritative student test length for a given domain and year level.
     * Mirrors the values populated by V381 in the production database.
     *
     * Derived from migration structure (pool = 8 testlets × N/testlet; student path = 3 × N):
     *   NUMERACY:            Y3=36 (3×12), Y5=42 (3×14), Y7/Y9=48 (3×16)
     *   READING:             Y3/Y5=39 (3×13), Y7/Y9=48 (3×16)
     *   GRAMMAR_PUNCTUATION: all years=27 (3×9)
     *   SPELLING:            all years=25 (5-testlet pool; student path 7+9+9)
     *   WRITING:             all years=1
     */
    public static int studentTestLength(Question.Domain domain, int yearLevel) {
        return switch (domain) {
            case WRITING -> 1;
            case SPELLING -> 25;
            case GRAMMAR_PUNCTUATION -> 27;
            case NUMERACY -> switch (yearLevel) {
                case 3 -> 36;
                case 5 -> 42;
                default -> 48; // Y7, Y9
            };
            case READING -> (yearLevel <= 5) ? 39 : 48;
        };
    }

    /**
     * Builds a PUBLISHED exam fixture with all required NOT NULL fields set.
     * The student test length is derived from domain + yearLevel.
     */
    public static Exam publishedExam(Question.Domain domain, int yearLevel, PackageType packageType) {
        Exam exam = new Exam();
        exam.setTitle("Test " + domain + " Y" + yearLevel);
        exam.setDomain(domain);
        exam.setYearLevel(yearLevel);
        exam.setPackageType(packageType);
        exam.setTimeLimitSeconds(1800);
        exam.setStatus(Exam.ExamStatus.PUBLISHED);
        exam.setAvailableFrom(Instant.now().minusSeconds(3600));
        exam.setAvailableUntil(Instant.now().plusSeconds(3600));
        exam.setStudentTestLength(studentTestLength(domain, yearLevel));
        return exam;
    }

    /**
     * Returns an Exam.Builder pre-populated with domain, yearLevel, packageType, and
     * the correct studentTestLength.  Caller may override any field before .build().
     */
    public static Exam.ExamBuilder examBuilder(Question.Domain domain, int yearLevel, PackageType packageType) {
        return Exam.builder()
            .domain(domain)
            .yearLevel(yearLevel)
            .packageType(packageType)
            .timeLimitSeconds(1800)
            .status(Exam.ExamStatus.PUBLISHED)
            .availableFrom(Instant.now().minusSeconds(3600))
            .availableUntil(Instant.now().plusSeconds(3600))
            .studentTestLength(studentTestLength(domain, yearLevel));
    }

    /**
     * Asserts that an Exam has a non-null studentTestLength.
     * Call this in @BeforeEach after saving the exam to catch fixture regressions early.
     */
    public static void assertStudentTestLengthSet(Exam exam) {
        assertNotNull(exam.getStudentTestLength(),
            "Exam fixture '" + exam.getTitle() + "' has null studentTestLength — update the fixture.");
    }
}
