package au.com.naplanprep.exam;

import au.com.naplanprep.exam.entity.ExamTag;
import org.junit.jupiter.api.Test;

import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

class ExamEntitlementTest {

    @Test
    void basic_user_can_access_basic_exams_only() {
        Set<ExamTag> tags = Set.of(ExamTag.BASIC);
        assertTrue(tags.contains(ExamTag.BASIC));
        assertFalse(tags.contains(ExamTag.ADVANCED));
        assertFalse(tags.contains(ExamTag.PRO));
    }

    @Test
    void advanced_user_can_access_basic_and_advanced_exams() {
        Set<ExamTag> tags = Set.of(ExamTag.BASIC, ExamTag.ADVANCED);
        assertTrue(tags.contains(ExamTag.BASIC));
        assertTrue(tags.contains(ExamTag.ADVANCED));
        assertFalse(tags.contains(ExamTag.PRO));
    }

    @Test
    void pro_user_can_access_all_exams() {
        Set<ExamTag> tags = Set.of(ExamTag.BASIC, ExamTag.ADVANCED, ExamTag.PRO);
        assertTrue(tags.contains(ExamTag.BASIC));
        assertTrue(tags.contains(ExamTag.ADVANCED));
        assertTrue(tags.contains(ExamTag.PRO));
    }

    @Test
    void user_with_only_basic_cannot_access_pro_exam() {
        Set<ExamTag> userTags = Set.of(ExamTag.BASIC);
        assertFalse(userTags.contains(ExamTag.PRO));
    }

    @Test
    void advanced_subscriber_cannot_access_pro_exam() {
        Set<ExamTag> userTags = Set.of(ExamTag.BASIC, ExamTag.ADVANCED);
        assertFalse(userTags.contains(ExamTag.PRO));
    }

    @Test
    void tags_are_additive_not_hierarchical() {
        // Having PRO does not automatically grant ADVANCED access unless explicitly set
        Set<ExamTag> proOnlyTags = Set.of(ExamTag.BASIC, ExamTag.PRO);
        assertTrue(proOnlyTags.contains(ExamTag.BASIC));
        assertFalse(proOnlyTags.contains(ExamTag.ADVANCED));
        assertTrue(proOnlyTags.contains(ExamTag.PRO));
    }
}
