package au.com.naplanprep.auth.service;

import au.com.naplanprep.auth.dto.AuthResponse;
import au.com.naplanprep.auth.dto.LoginRequest;
import au.com.naplanprep.auth.dto.RegisterRequest;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.entity.UserProfile;
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

import java.time.Duration;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final RedisTemplate<String, String> redisTemplate;
    private final AppProperties appProperties;

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
        if (Boolean.TRUE.equals(redisTemplate.hasKey(blacklistKey))) {
            throw new BusinessException("Refresh token already used");
        }

        redisTemplate.opsForValue().set(blacklistKey, "1",
            Duration.ofSeconds(appProperties.getJwt().getRefreshTokenExpiry()));

        String userId = claims.getSubject();
        User user = userRepository.findById(java.util.UUID.fromString(userId))
            .orElseThrow(() -> new BusinessException("User not found"));

        return buildAuthResponse(user);
    }

    public void logout(String token) {
        if (token != null && jwtTokenProvider.isTokenValid(token)) {
            redisTemplate.opsForValue().set("blacklist:" + token, "1",
                Duration.ofSeconds(appProperties.getJwt().getAccessTokenExpiry()));
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
