package au.com.naplanprep.exam;

import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.entity.Exam;
import au.com.naplanprep.exam.entity.ExamTag;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

import static org.junit.jupiter.api.Assertions.*;

class ExamTimeWindowTest {

    private Exam buildExam(Instant from, Instant until) {
        Exam e = new Exam();
        e.setStatus(Exam.ExamStatus.PUBLISHED);
        e.setDomain(Question.Domain.NUMERACY);
        e.setTag(ExamTag.BASIC);
        e.setAvailableFrom(from);
        e.setAvailableUntil(until);
        return e;
    }

    @Test
    void exam_with_no_window_is_always_available() {
        Exam exam = buildExam(null, null);
        assertTrue(isWithinWindow(exam, Instant.now()));
    }

    @Test
    void exam_not_yet_open_is_not_available() {
        Instant future = Instant.now().plus(1, ChronoUnit.DAYS);
        Exam exam = buildExam(future, null);
        assertFalse(isWithinWindow(exam, Instant.now()));
    }

    @Test
    void exam_past_closing_time_is_not_available() {
        Instant past = Instant.now().minus(1, ChronoUnit.DAYS);
        Exam exam = buildExam(null, past);
        assertFalse(isWithinWindow(exam, Instant.now()));
    }

    @Test
    void exam_within_window_is_available() {
        Instant from  = Instant.now().minus(1, ChronoUnit.DAYS);
        Instant until = Instant.now().plus(1, ChronoUnit.DAYS);
        Exam exam = buildExam(from, until);
        assertTrue(isWithinWindow(exam, Instant.now()));
    }

    @Test
    void exam_opening_now_is_available() {
        Instant justOpened = Instant.now().minus(1, ChronoUnit.SECONDS);
        Exam exam = buildExam(justOpened, null);
        assertTrue(isWithinWindow(exam, Instant.now()));
    }

    @Test
    void exam_closing_now_is_not_available() {
        Instant justClosed = Instant.now().minus(1, ChronoUnit.SECONDS);
        Exam exam = buildExam(null, justClosed);
        assertFalse(isWithinWindow(exam, Instant.now()));
    }

    /** Mirrors the time-window logic in ExamService. */
    private boolean isWithinWindow(Exam exam, Instant now) {
        if (exam.getAvailableFrom() != null && now.isBefore(exam.getAvailableFrom())) return false;
        if (exam.getAvailableUntil() != null && now.isAfter(exam.getAvailableUntil())) return false;
        return true;
    }
}
