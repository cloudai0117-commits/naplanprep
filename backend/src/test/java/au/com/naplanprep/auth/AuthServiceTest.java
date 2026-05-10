package au.com.naplanprep.auth;

import au.com.naplanprep.auth.dto.RegisterRequest;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.auth.service.AuthService;
import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.config.AppProperties;
import au.com.naplanprep.config.JwtTokenProvider;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock private UserRepository userRepository;
    @Mock private PasswordEncoder passwordEncoder;
    @Mock private JwtTokenProvider jwtTokenProvider;
    @Mock private RedisTemplate<String, String> redisTemplate;
    @Mock private AppProperties appProperties;

    @InjectMocks private AuthService authService;

    @Test
    void register_withExistingEmail_throwsBusinessException() {
        when(userRepository.existsByEmail(anyString())).thenReturn(true);

        RegisterRequest req = new RegisterRequest("John", "Doe", "john@test.com",
            "Password1!", User.Role.STUDENT, 5);

        assertThrows(BusinessException.class, () -> authService.register(req));
        verify(userRepository, never()).save(any());
    }

    @Test
    void register_withValidData_returnsAuthResponse() {
        when(userRepository.existsByEmail(anyString())).thenReturn(false);
        when(passwordEncoder.encode(anyString())).thenReturn("$2a$12$hashed");

        User savedUser = User.builder()
            .email("john@test.com")
            .password("$2a$12$hashed")
            .role(User.Role.STUDENT)
            .build();
        when(userRepository.save(any())).thenReturn(savedUser);
        when(jwtTokenProvider.generateAccessToken(any())).thenReturn("access-token");
        when(jwtTokenProvider.generateRefreshToken(any())).thenReturn("refresh-token");

        AppProperties.Jwt jwtProps = new AppProperties.Jwt();
        when(appProperties.getJwt()).thenReturn(jwtProps);

        RegisterRequest req = new RegisterRequest("John", "Doe", "john@test.com",
            "Password1!", User.Role.STUDENT, 5);

        var response = authService.register(req);

        assertNotNull(response);
        assertEquals("access-token", response.accessToken());
        assertEquals("Bearer", response.tokenType());
    }
}
