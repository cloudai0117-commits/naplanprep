package au.com.naplanprep.auth.service;

import au.com.naplanprep.auth.dto.AuthResponse;
import au.com.naplanprep.auth.dto.LoginRequest;
import au.com.naplanprep.auth.dto.RegisterRequest;
import au.com.naplanprep.auth.entity.PasswordResetToken;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.entity.UserProfile;
import au.com.naplanprep.auth.repository.PasswordResetTokenRepository;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.config.AppProperties;
import au.com.naplanprep.config.JwtTokenProvider;
import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final RedisTemplate<String, String> redisTemplate;
    private final AppProperties appProperties;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final EmailService emailService;

    @Transactional
    public AuthResponse register(RegisterRequest req) {
        if (userRepository.existsByEmail(req.email())) {
            throw new BusinessException("Email already registered");
        }

        User user = User.builder()
            .email(req.email().toLowerCase())
            .password(passwordEncoder.encode(req.password()))
            .role(req.resolvedRole())
            .build();

        UserProfile profile = UserProfile.builder()
            .user(user)
            .firstName(req.firstName())
            .lastName(req.lastName())
            .yearLevel(req.yearLevel())
            .school(req.school())
            .build();

        user.setProfile(profile);
        userRepository.save(user);

        return buildAuthResponse(user);
    }

    @Transactional
    public AuthResponse login(LoginRequest req) {
        User user = userRepository.findByEmail(req.email().toLowerCase())
            .orElseThrow(() -> new BadCredentialsException("Invalid credentials"));

        if (user.isLocked()) {
            throw new BusinessException("Account temporarily locked. Try again later.");
        }

        if (!passwordEncoder.matches(req.password(), user.getPassword())) {
            handleFailedLogin(user);
            throw new BadCredentialsException("Invalid credentials");
        }

        user.setFailedLoginAttempts(0);
        user.setLockedUntil(null);
        userRepository.save(user);

        return buildAuthResponse(user);
    }

    @Transactional
    public AuthResponse refreshToken(String refreshToken) {
        if (!jwtTokenProvider.isTokenValid(refreshToken)) {
            throw new BusinessException("Invalid refresh token");
        }

        Claims claims = jwtTokenProvider.validateToken(refreshToken);
        if (!"refresh".equals(claims.get("type"))) {
            throw new BusinessException("Not a refresh token");
        }

        String blacklistKey = "blacklist:" + refreshToken;
        try {
            if (Boolean.TRUE.equals(redisTemplate.hasKey(blacklistKey))) {
                throw new BusinessException("Refresh token already used");
            }
            redisTemplate.opsForValue().set(blacklistKey, "1",
                Duration.ofSeconds(appProperties.getJwt().getRefreshTokenExpiry()));
        } catch (BusinessException e) {
            throw e;
        } catch (Exception redisEx) {
            log.warn("Redis unavailable for token blacklist check — skipping: {}", redisEx.getMessage());
        }

        String userId = claims.getSubject();
        User user = userRepository.findById(java.util.UUID.fromString(userId))
            .orElseThrow(() -> new BusinessException("User not found"));

        return buildAuthResponse(user);
    }

    public void logout(String token) {
        if (token != null && jwtTokenProvider.isTokenValid(token)) {
            try {
                redisTemplate.opsForValue().set("blacklist:" + token, "1",
                    Duration.ofSeconds(appProperties.getJwt().getAccessTokenExpiry()));
            } catch (Exception redisEx) {
                log.warn("Redis unavailable for logout blacklist — token not blacklisted: {}", redisEx.getMessage());
            }
        }
    }

    /**
     * Change password for an authenticated user.
     * Verifies current password before accepting the new one.
     * Blacklists the current access token on success so the session cannot be reused.
     */
    @Transactional
    public void changePassword(UUID userId, String currentPassword, String newPassword, String currentToken) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new BusinessException("User not found"));

        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            throw new BusinessException("Current password is incorrect");
        }
        if (passwordEncoder.matches(newPassword, user.getPassword())) {
            throw new BusinessException("New password must differ from current password");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        if (currentToken != null && jwtTokenProvider.isTokenValid(currentToken)) {
            try {
                redisTemplate.opsForValue().set("blacklist:" + currentToken, "1",
                    Duration.ofSeconds(appProperties.getJwt().getAccessTokenExpiry()));
            } catch (Exception redisEx) {
                log.warn("Redis unavailable — current token not blacklisted after password change");
            }
        }

        log.info("PASSWORD_CHANGED — userId={}", userId);
    }

    /**
     * Initiates the forgot-password flow.
     * Always returns without error — never reveals whether the email is registered.
     */
    @Transactional
    public void forgotPassword(String email, String resetBaseUrl) {
        String normalizedEmail = email.toLowerCase().trim();
        userRepository.findByEmail(normalizedEmail).ifPresent(user -> {
            passwordResetTokenRepository.invalidateAllForUser(user.getId(), Instant.now());

            byte[] bytes = new byte[32];
            new SecureRandom().nextBytes(bytes);
            String rawToken = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);

            passwordResetTokenRepository.save(PasswordResetToken.builder()
                .userId(user.getId())
                .tokenHash(sha256Hex(rawToken))
                .expiresAt(Instant.now().plus(Duration.ofHours(1)))
                .build());

            String resetUrl = resetBaseUrl + "/reset-password?token=" + rawToken;
            emailService.sendPasswordResetEmail(normalizedEmail, resetUrl);
            log.debug("PASSWORD_RESET_INITIATED — userId={}", user.getId());
        });
    }

    /**
     * Completes password reset using the single-use token from the reset email.
     */
    @Transactional
    public void resetPassword(String rawToken, String newPassword) {
        String tokenHash = sha256Hex(rawToken);
        PasswordResetToken prt = passwordResetTokenRepository.findByTokenHash(tokenHash)
            .orElseThrow(() -> new BusinessException("Invalid or expired reset link"));

        if (prt.isUsed()) {
            throw new BusinessException("Reset link has already been used");
        }
        if (prt.isExpired()) {
            throw new BusinessException("Reset link has expired. Please request a new one.");
        }

        User user = userRepository.findById(prt.getUserId())
            .orElseThrow(() -> new BusinessException("User not found"));

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        prt.setUsedAt(Instant.now());
        passwordResetTokenRepository.save(prt);

        log.info("PASSWORD_RESET_COMPLETED — userId={}", user.getId());
    }

    private static String sha256Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(64);
            for (byte b : digest) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 unavailable", e);
        }
    }

    private void handleFailedLogin(User user) {
        int attempts = user.getFailedLoginAttempts() == null ? 0 : user.getFailedLoginAttempts();
        attempts++;
        user.setFailedLoginAttempts(attempts);

        if (attempts >= appProperties.getRateLimit().getAuthAttempts()) {
            user.setLockedUntil(
                Instant.now().plus(Duration.ofMinutes(appProperties.getRateLimit().getAuthLockoutMinutes())));
            log.warn("Account locked after {} failed attempts: {}", attempts, user.getEmail());
        }

        userRepository.save(user);
    }

    private AuthResponse buildAuthResponse(User user) {
        String accessToken = jwtTokenProvider.generateAccessToken(user);
        String refreshToken = jwtTokenProvider.generateRefreshToken(user);

        var profile = user.getProfile();
        return new AuthResponse(
            accessToken,
            refreshToken,
            "Bearer",
            appProperties.getJwt().getAccessTokenExpiry(),
            new AuthResponse.UserInfo(
                user.getId(),
                user.getEmail(),
                profile != null ? profile.getFirstName() : null,
                profile != null ? profile.getLastName() : null,
                user.getRole(),
                profile != null ? profile.getYearLevel() : null
            )
        );
    }
}
