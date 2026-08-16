package au.com.naplanprep.config;

import org.junit.jupiter.api.Test;
import org.yaml.snakeyaml.Yaml;

import java.io.InputStream;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Regression tests for production-safe config values.
 *
 * P2-003: Flyway repair-on-migrate must NOT be in base application.yml
 * P2-004: show-details must be 'when-authorized' in base config (not 'always')
 * P2-005: server.error.include-message must be 'never' in base config
 * P3-001: UAT must not disable validate-on-migrate
 * P3-002: UAT must not enable out-of-order migrations
 *
 * These tests parse the raw YAML files — they do NOT start a Spring context.
 */
class SecurityConfigPropertiesTest {

    @Test
    @SuppressWarnings("unchecked")
    void baseConfig_doesNotHave_repairOnMigrate() {
        Map<String, Object> yaml = loadYaml("/application.yml");
        Map<String, Object> flyway = (Map<String, Object>) ((Map<String, Object>) yaml.get("spring")).get("flyway");
        // repair-on-migrate must not be present or must not be true in the base config
        if (flyway != null && flyway.containsKey("repair-on-migrate")) {
            assertFalse(Boolean.TRUE.equals(flyway.get("repair-on-migrate")),
                "repair-on-migrate must not be true in base application.yml — it silences checksum errors in production");
        }
    }

    @Test
    @SuppressWarnings("unchecked")
    void baseConfig_errorIncludeMessage_isNever() {
        Map<String, Object> yaml = loadYaml("/application.yml");
        Map<String, Object> server = (Map<String, Object>) yaml.get("server");
        assertNotNull(server, "server section missing from application.yml");
        Map<String, Object> error = (Map<String, Object>) server.get("error");
        assertNotNull(error, "server.error section missing");
        assertEquals("never", error.get("include-message"),
            "server.error.include-message must be 'never' in base config to prevent error details reaching clients");
    }

    @Test
    @SuppressWarnings("unchecked")
    void baseConfig_healthShowDetails_isWhenAuthorized() {
        Map<String, Object> yaml = loadYaml("/application.yml");
        Map<String, Object> management = (Map<String, Object>) yaml.get("management");
        assertNotNull(management, "management section missing from application.yml");
        Map<String, Object> endpoint = (Map<String, Object>) management.get("endpoint");
        assertNotNull(endpoint, "management.endpoint section missing");
        Map<String, Object> health = (Map<String, Object>) endpoint.get("health");
        assertNotNull(health, "management.endpoint.health section missing");
        String showDetails = (String) health.get("show-details");
        assertNotEquals("always", showDetails,
            "management.endpoint.health.show-details must not be 'always' in base config — use 'when-authorized'");
    }

    @Test
    @SuppressWarnings("unchecked")
    void uatConfig_doesNotDisable_validateOnMigrate() {
        Map<String, Object> yaml = loadYaml("/application-uat.yml");
        Map<String, Object> spring = (Map<String, Object>) yaml.get("spring");
        if (spring == null) return;
        Map<String, Object> flyway = (Map<String, Object>) spring.get("flyway");
        if (flyway == null) return;
        // validate-on-migrate: false would be dangerous in UAT
        assertFalse(Boolean.FALSE.equals(flyway.get("validate-on-migrate")),
            "validate-on-migrate must not be explicitly set to false in UAT — migration checksum errors would be silenced");
    }

    @Test
    @SuppressWarnings("unchecked")
    void uatConfig_outOfOrder_isFalseOrAbsent() {
        Map<String, Object> yaml = loadYaml("/application-uat.yml");
        Map<String, Object> spring = (Map<String, Object>) yaml.get("spring");
        if (spring == null) return;
        Map<String, Object> flyway = (Map<String, Object>) spring.get("flyway");
        if (flyway == null) return;
        Object outOfOrder = flyway.get("out-of-order");
        if (outOfOrder != null) {
            assertFalse(Boolean.TRUE.equals(outOfOrder),
                "out-of-order must not be true in UAT — use production-like migration ordering");
        }
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> loadYaml(String classpathResource) {
        InputStream in = getClass().getResourceAsStream(classpathResource);
        assertNotNull(in, "Could not load " + classpathResource + " from classpath");
        return (Map<String, Object>) new Yaml().load(in);
    }
}
