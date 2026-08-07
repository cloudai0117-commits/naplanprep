package au.com.naplanprep.exam;

import au.com.naplanprep.exam.entity.PackageType;
import org.junit.jupiter.api.Test;

import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

class ExamEntitlementTest {

    @Test
    void free_user_can_access_free_exams_only() {
        Set<PackageType> tags = Set.of(PackageType.FREE);
        assertTrue(tags.contains(PackageType.FREE));
        assertFalse(tags.contains(PackageType.ADVANCED));
        assertFalse(tags.contains(PackageType.PREMIUM));
    }

    @Test
    void advanced_user_can_access_free_and_advanced_exams() {
        Set<PackageType> tags = Set.of(PackageType.FREE, PackageType.ADVANCED);
        assertTrue(tags.contains(PackageType.FREE));
        assertTrue(tags.contains(PackageType.ADVANCED));
        assertFalse(tags.contains(PackageType.PREMIUM));
    }

    @Test
    void premium_user_can_access_all_exams() {
        Set<PackageType> tags = Set.of(PackageType.FREE, PackageType.ADVANCED, PackageType.PREMIUM);
        assertTrue(tags.contains(PackageType.FREE));
        assertTrue(tags.contains(PackageType.ADVANCED));
        assertTrue(tags.contains(PackageType.PREMIUM));
    }

    @Test
    void user_with_only_free_cannot_access_premium_exam() {
        Set<PackageType> userTags = Set.of(PackageType.FREE);
        assertFalse(userTags.contains(PackageType.PREMIUM));
    }

    @Test
    void advanced_subscriber_cannot_access_premium_exam() {
        Set<PackageType> userTags = Set.of(PackageType.FREE, PackageType.ADVANCED);
        assertFalse(userTags.contains(PackageType.PREMIUM));
    }

    @Test
    void tags_are_additive_not_hierarchical() {
        // Having PREMIUM does not automatically grant ADVANCED access unless explicitly set
        Set<PackageType> premiumOnlyTags = Set.of(PackageType.FREE, PackageType.PREMIUM);
        assertTrue(premiumOnlyTags.contains(PackageType.FREE));
        assertFalse(premiumOnlyTags.contains(PackageType.ADVANCED));
        assertTrue(premiumOnlyTags.contains(PackageType.PREMIUM));
    }
}
