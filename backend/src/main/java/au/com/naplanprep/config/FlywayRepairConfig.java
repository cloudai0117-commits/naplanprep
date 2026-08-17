package au.com.naplanprep.config;

import org.flywaydb.core.Flyway;
import org.springframework.boot.autoconfigure.flyway.FlywayMigrationStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

/**
 * In UAT, V381 previously executed partially and was recorded as FAILED in
 * flyway_schema_history. Flyway 9.x Community does not support bypassing failed
 * migrations via ignoreMigrationPatterns — "Failed" is not a valid pattern state.
 *
 * This strategy runs flyway.repair() before migrate() so that any FAILED
 * migration entries are cleared, allowing V381 to re-run with its idempotent
 * revision. After the first successful run, repair() is a no-op.
 */
@Profile("uat")
@Configuration
public class FlywayRepairConfig {

    @Bean
    public FlywayMigrationStrategy repairThenMigrate() {
        return (Flyway flyway) -> {
            flyway.repair();
            flyway.migrate();
        };
    }
}
