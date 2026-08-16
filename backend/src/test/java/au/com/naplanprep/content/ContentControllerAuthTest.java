package au.com.naplanprep.content;

import au.com.naplanprep.content.controller.ContentController;
import org.junit.jupiter.api.Test;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;

import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Regression test for P0-CRITICAL: GET /v1/content/questions must require admin/teacher
 * role. Before the fix this method had no @PreAuthorize, exposing correctAnswer/markingRubric
 * to any authenticated student.
 */
class ContentControllerAuthTest {

    @Test
    void searchQuestions_hasPreAuthorize() throws NoSuchMethodException {
        Method m = ContentController.class.getMethod(
            "searchQuestions",
            Integer.class,
            au.com.naplanprep.content.entity.Question.Domain.class,
            String.class,
            Integer.class,
            au.com.naplanprep.content.entity.Question.QuestionStatus.class,
            au.com.naplanprep.exam.entity.PackageType.class,
            Pageable.class
        );
        PreAuthorize ann = m.getAnnotation(PreAuthorize.class);
        assertNotNull(ann, "searchQuestions must have @PreAuthorize — without it, answer keys are exposed to students");
    }

    @Test
    void searchQuestions_preAuthorize_excludesStudent() throws NoSuchMethodException {
        Method m = ContentController.class.getMethod(
            "searchQuestions",
            Integer.class,
            au.com.naplanprep.content.entity.Question.Domain.class,
            String.class,
            Integer.class,
            au.com.naplanprep.content.entity.Question.QuestionStatus.class,
            au.com.naplanprep.exam.entity.PackageType.class,
            Pageable.class
        );
        PreAuthorize ann = m.getAnnotation(PreAuthorize.class);
        assertNotNull(ann);
        String expr = ann.value();
        assertFalse(expr.contains("STUDENT"), "STUDENT role must not appear in @PreAuthorize expression");
        assertTrue(expr.contains("PLATFORM_ADMIN"), "@PreAuthorize must include PLATFORM_ADMIN");
    }

    @Test
    void searchQuestions_preAuthorize_allowsAdminAndTeacher() throws NoSuchMethodException {
        Method m = ContentController.class.getMethod(
            "searchQuestions",
            Integer.class,
            au.com.naplanprep.content.entity.Question.Domain.class,
            String.class,
            Integer.class,
            au.com.naplanprep.content.entity.Question.QuestionStatus.class,
            au.com.naplanprep.exam.entity.PackageType.class,
            Pageable.class
        );
        String expr = m.getAnnotation(PreAuthorize.class).value();
        assertTrue(expr.contains("PLATFORM_ADMIN"), "must allow PLATFORM_ADMIN");
        assertTrue(expr.contains("TEACHER"), "must allow TEACHER");
        assertTrue(expr.contains("SCHOOL_ADMIN"), "must allow SCHOOL_ADMIN");
    }
}
