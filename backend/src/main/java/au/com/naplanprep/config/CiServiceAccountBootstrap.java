package au.com.naplanprep.config;

import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Bootstraps a dedicated CI service account for GitHub Actions DB integrity checks.
 *
 * Active only in the "uat" profile. Reads CI_SERVICE_EMAIL and CI_SERVICE_PASSWORD
 * from the process environment (Railway Variables). Creates the account if absent,
 * or refreshes the password hash if it already exists (supports password rotation
 * by simply changing the env var and redeploying).
 *
 * The account is PLATFORM_ADMIN so it satisfies anyRequest().authenticated() for
 * /actuator/health/dbIntegrity. The password is never stored in source control;
 * only the BCrypt hash computed at runtime is persisted in the database.
 *
 * If env vars are absent the bootstrap is silently skipped. If the database save
 * fails the exception is caught and logged (non-fatal — CI will surface the error
 * at the authentication step).
 */
@Slf4j
@Component
@Profile("uat")
@RequiredArgsConstructor
public class CiServiceAccountBootstrap implements ApplicationRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        String email = System.getenv("CI_SERVICE_EMAIL");
        String password = System.getenv("CI_SERVICE_PASSWORD");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            log.info("CI_SERVICE_EMAIL or CI_SERVICE_PASSWORD not configured — CI service account bootstrap skipped");
            return;
        }

        try {
            String normalizedEmail = email.toLowerCase().trim();
            String hashedPassword = passwordEncoder.encode(password);

            User ciUser = userRepository.findByEmail(normalizedEmail)
                .map(existing -> {
                    existing.setPassword(hashedPassword);
                    existing.setStatus(User.UserStatus.ACTIVE);
                    existing.setFailedLoginAttempts(0);
                    existing.setLockedUntil(null);
                    return existing;
                })
                .orElseGet(() -> User.builder()
                    .email(normalizedEmail)
                    .password(hashedPassword)
                    .role(User.Role.PLATFORM_ADMIN)
                    .status(User.UserStatus.ACTIVE)
                    .build());

            userRepository.save(ciUser);
            log.info("CI service account ready: {}", normalizedEmail);
        } catch (Exception e) {
            log.warn("CI service account bootstrap failed — CI integrity gate will fail at login: {}", e.getMessage());
        }
    }
}
