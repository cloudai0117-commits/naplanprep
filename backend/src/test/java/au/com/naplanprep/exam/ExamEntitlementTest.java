package au.com.naplanprep.exam;

import au.com.naplanprep.exam.entity.Exam;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import static org.junit.jupiter.api.Assertions.*;

class ExamEntitlementTest {

    @Test
    void free_tier_can_only_access_free_exams() {
        assertTrue(Exam.PackageTier.FREE.satisfies(Exam.PackageTier.FREE));
        assertFalse(Exam.PackageTier.FREE.satisfies(Exam.PackageTier.STANDARD));
        assertFalse(Exam.PackageTier.FREE.satisfies(Exam.PackageTier.PREMIUM));
        assertFalse(Exam.PackageTier.FREE.satisfies(Exam.PackageTier.FAMILY));
    }

    @Test
    void standard_tier_can_access_free_and_standard_exams() {
        assertTrue(Exam.PackageTier.STANDARD.satisfies(Exam.PackageTier.FREE));
        assertTrue(Exam.PackageTier.STANDARD.satisfies(Exam.PackageTier.STANDARD));
        assertFalse(Exam.PackageTier.STANDARD.satisfies(Exam.PackageTier.PREMIUM));
        assertFalse(Exam.PackageTier.STANDARD.satisfies(Exam.PackageTier.FAMILY));
    }

    @Test
    void premium_tier_can_access_free_standard_premium_exams() {
        assertTrue(Exam.PackageTier.PREMIUM.satisfies(Exam.PackageTier.FREE));
        assertTrue(Exam.PackageTier.PREMIUM.satisfies(Exam.PackageTier.STANDARD));
        assertTrue(Exam.PackageTier.PREMIUM.satisfies(Exam.PackageTier.PREMIUM));
        assertFalse(Exam.PackageTier.PREMIUM.satisfies(Exam.PackageTier.FAMILY));
    }

    @Test
    void family_tier_can_access_all_exams() {
        for (Exam.PackageTier required : Exam.PackageTier.values()) {
            assertTrue(Exam.PackageTier.FAMILY.satisfies(required),
                "FAMILY should satisfy " + required);
        }
    }

    @ParameterizedTest
    @CsvSource({
        "FREE,    FREE,    true",
        "FREE,    STANDARD,false",
        "STANDARD,STANDARD,true",
        "STANDARD,PREMIUM, false",
        "PREMIUM, PREMIUM, true",
        "PREMIUM, FAMILY,  false",
        "FAMILY,  FAMILY,  true",
    })
    void tier_hierarchy_is_correct(String userTier, String requiredTier, boolean expected) {
        Exam.PackageTier user = Exam.PackageTier.valueOf(userTier.trim());
        Exam.PackageTier required = Exam.PackageTier.valueOf(requiredTier.trim());
        assertEquals(expected, user.satisfies(required));
    }

    @Test
    void accessible_tiers_for_free_contains_only_free() {
        var tiers = Exam.PackageTier.FREE.accessibleTiers();
        assertEquals(1, tiers.size());
        assertTrue(tiers.contains(Exam.PackageTier.FREE));
    }

    @Test
    void accessible_tiers_for_premium_contains_free_standard_premium() {
        var tiers = Exam.PackageTier.PREMIUM.accessibleTiers();
        assertEquals(3, tiers.size());
        assertTrue(tiers.contains(Exam.PackageTier.FREE));
        assertTrue(tiers.contains(Exam.PackageTier.STANDARD));
        assertTrue(tiers.contains(Exam.PackageTier.PREMIUM));
        assertFalse(tiers.contains(Exam.PackageTier.FAMILY));
    }
}
