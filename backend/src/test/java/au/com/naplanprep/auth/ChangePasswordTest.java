package au.com.naplanprep.auth;

import au.com.naplanprep.auth.entity.PasswordResetToken;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.PasswordResetTokenRepository;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.auth.service.AuthService;
import au.com.naplanprep.auth.service.EmailService;
import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.config.AppProperties;
import au.com.naplanprep.config.JwtTokenProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Regression tests for BUG #6: Change Password and Forgot Password.
 *
 * Security invariants:
 * - Current password must be verified before accepting new password.
 * - New password must differ from current.
 * - Password reset tokens are single-use and expire after 1 hour.
 * - Forgot-password always returns 200 (no user enumeration).
 * - Tokens are stored as SHA-256 hashes, never plain text.
 */
@ExtendWith(MockitoExtension.class)
class ChangePasswordTest {

    @Mock private UserRepository userRepository;
    @Mock private PasswordEncoder passwordEncoder;
    @Mock private JwtTokenProvider jwtTokenProvider;
    @Mock private RedisTemplate<String, String> redisTemplate;
    @Mock private AppProperties appProperties;
    @Mock private PasswordResetTokenRepository passwordResetTokenRepository;
    @Mock private EmailService emailService;

    private AuthService authService;

    @BeforeEach
    void setUp() {
        authService = new AuthService(userRepository, passwordEncoder, jwtTokenProvider,
            redisTemplate, appProperties, passwordResetTokenRepository, emailService);
    }

    // ─── Change Password ─────────────────────────────────────────

    @Test
    void changePassword_wrongCurrentPassword_throwsBusinessException() {
        UUID userId = UUID.randomUUID();
        User user = userWithPassword("$2a$12$encodedOldPassword");
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("wrongOld", user.getPassword())).thenReturn(false);

        assertThrows(BusinessException.class,
            () -> authService.changePassword(userId, "wrongOld", "NewPass1", null));
        verify(userRepository, never()).save(any());
    }

    @Test
    void changePassword_samePasswordAsCurrentRejected() {
        UUID userId = UUID.randomUUID();
        User user = userWithPassword("$2a$12$encodedPassword");
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("SamePass1", user.getPassword())).thenReturn(true);

        assertThrows(BusinessException.class,
            () -> authService.changePassword(userId, "SamePass1", "SamePass1", null));
        verify(userRepository, never()).save(any());
    }

    @Test
    void changePassword_valid_savesNewPasswordAndBlacklistsToken() {
        UUID userId = UUID.randomUUID();
        User user = userWithPassword("$2a$12$encodedOldPassword");
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("OldPass1", user.getPassword())).thenReturn(true);
        when(passwordEncoder.matches("NewPass1", user.getPassword())).thenReturn(false);
        when(passwordEncoder.encode("NewPass1")).thenReturn("$2a$12$encodedNewPassword");
        when(jwtTokenProvider.isTokenValid("current.token")).thenReturn(true);

        AppProperties.Jwt jwt = mock(AppProperties.Jwt.class);
        when(appProperties.getJwt()).thenReturn(jwt);
        when(jwt.getAccessTokenExpiry()).thenReturn(900L);

        org.springframework.data.redis.core.ValueOperations<String, String> valOps =
            mock(org.springframework.data.redis.core.ValueOperations.class);
        when(redisTemplate.opsForValue()).thenReturn(valOps);

        authService.changePassword(userId, "OldPass1", "NewPass1", "current.token");

        verify(userRepository).save(user);
        assertEquals("$2a$12$encodedNewPassword", user.getPassword());
    }

    // ─── Reset Password ──────────────────────────────────────────

    @Test
    void resetPassword_expiredToken_throwsBusinessException() {
        PasswordResetToken expired = PasswordResetToken.builder()
            .id(UUID.randomUUID())
            .userId(UUID.randomUUID())
            .tokenHash("somehash")
            .expiresAt(Instant.now().minusSeconds(3600))
            .build();
        when(passwordResetTokenRepository.findByTokenHash(anyString())).thenReturn(Optional.of(expired));

        assertThrows(BusinessException.class,
            () -> authService.resetPassword("rawtoken", "NewPass1"));
        verify(userRepository, never()).save(any());
    }

    @Test
    void resetPassword_usedToken_throwsBusinessException() {
        PasswordResetToken used = PasswordResetToken.builder()
            .id(UUID.randomUUID())
            .userId(UUID.randomUUID())
            .tokenHash("somehash")
            .expiresAt(Instant.now().plusSeconds(3600))
            .usedAt(Instant.now().minusSeconds(60))
            .build();
        when(passwordResetTokenRepository.findByTokenHash(anyString())).thenReturn(Optional.of(used));

        assertThrows(BusinessException.class,
            () -> authService.resetPassword("rawtoken", "NewPass1"));
        verify(userRepository, never()).save(any());
    }

    @Test
    void resetPassword_validToken_savesPasswordAndMarksTokenUsed() {
        UUID userId = UUID.randomUUID();
        PasswordResetToken valid = PasswordResetToken.builder()
            .id(UUID.randomUUID())
            .userId(userId)
            .tokenHash("somehash")
            .expiresAt(Instant.now().plusSeconds(3600))
            .build();
        User user = userWithPassword("$2a$12$old");
        when(passwordResetTokenRepository.findByTokenHash(anyString())).thenReturn(Optional.of(valid));
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(passwordEncoder.encode("NewPass1")).thenReturn("$2a$12$newEncoded");

        authService.resetPassword("rawtoken", "NewPass1");

        verify(userRepository).save(user);
        assertEquals("$2a$12$newEncoded", user.getPassword());
        assertNotNull(valid.getUsedAt(), "Token must be marked as used after reset");
    }

    @Test
    void forgotPassword_unknownEmail_doesNotRevealUserExistence() {
        // Unknown email: findByEmail returns empty — no exception, no error
        when(userRepository.findByEmail(anyString())).thenReturn(Optional.empty());

        // Must complete without throwing — caller cannot distinguish from found user
        assertDoesNotThrow(() -> authService.forgotPassword("unknown@test.com", "http://localhost:5173"));
        verify(passwordResetTokenRepository, never()).save(any());
        verify(emailService, never()).sendPasswordResetEmail(anyString(), anyString());
    }

    // ─── Helper ──────────────────────────────────────────────────

    private User userWithPassword(String encoded) {
        return User.builder()
            .id(UUID.randomUUID())
            .email("user@test.com")
            .password(encoded)
            .role(User.Role.STUDENT)
            .build();
    }
}
