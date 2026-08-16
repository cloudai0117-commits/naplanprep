package au.com.naplanprep.config;

import au.com.naplanprep.auth.service.UserDetailsServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for JwtAuthenticationFilter.
 *
 * P2-006: Redis unavailability must not block authenticated requests.
 * JWT cryptographic validation remains enforced in all cases.
 */
@ExtendWith(MockitoExtension.class)
class JwtAuthenticationFilterTest {

    @Mock private JwtTokenProvider jwtTokenProvider;
    @Mock private UserDetailsServiceImpl userDetailsService;
    @Mock private RedisTemplate<String, String> redisTemplate;

    private JwtAuthenticationFilter filter;

    @BeforeEach
    void setUp() {
        filter = new JwtAuthenticationFilter(jwtTokenProvider, userDetailsService, redisTemplate);
        SecurityContextHolder.clearContext();
    }

    @Test
    void validToken_redisAvailable_notBlacklisted_setsAuthentication() throws Exception {
        String token = "valid.jwt.token";
        UserDetails user = testUser();
        when(jwtTokenProvider.isTokenValid(token)).thenReturn(true);
        when(redisTemplate.hasKey("blacklist:" + token)).thenReturn(false);
        when(jwtTokenProvider.getSubject(token)).thenReturn("user-id-1");
        when(userDetailsService.loadUserById("user-id-1")).thenReturn(user);

        MockHttpServletRequest request = requestWithToken(token);
        filter.doFilterInternal(request, new MockHttpServletResponse(), new MockFilterChain());

        assertNotNull(SecurityContextHolder.getContext().getAuthentication());
        assertEquals("user@test.com", SecurityContextHolder.getContext().getAuthentication().getName());
    }

    @Test
    void validToken_redisAvailable_blacklisted_doesNotSetAuthentication() throws Exception {
        String token = "blacklisted.jwt.token";
        when(jwtTokenProvider.isTokenValid(token)).thenReturn(true);
        when(redisTemplate.hasKey("blacklist:" + token)).thenReturn(true);

        MockHttpServletRequest request = requestWithToken(token);
        filter.doFilterInternal(request, new MockHttpServletResponse(), new MockFilterChain());

        assertNull(SecurityContextHolder.getContext().getAuthentication());
    }

    @Test
    void validToken_redisUnavailable_setsAuthentication() throws Exception {
        // P2-006 key requirement: Redis outage must not cause 401 for all users.
        // JWT is cryptographically valid — the revocation-risk window is accepted.
        String token = "valid.jwt.token.redis.down";
        UserDetails user = testUser();
        when(jwtTokenProvider.isTokenValid(token)).thenReturn(true);
        when(redisTemplate.hasKey(anyString())).thenThrow(new RuntimeException("Redis connection refused"));
        when(jwtTokenProvider.getSubject(token)).thenReturn("user-id-1");
        when(userDetailsService.loadUserById("user-id-1")).thenReturn(user);

        MockHttpServletRequest request = requestWithToken(token);
        filter.doFilterInternal(request, new MockHttpServletResponse(), new MockFilterChain());

        // Authentication still set — JWT validity was confirmed before Redis call.
        assertNotNull(SecurityContextHolder.getContext().getAuthentication());
    }

    @Test
    void invalidToken_redisUnavailable_doesNotSetAuthentication() throws Exception {
        // JWT signature/expiry check fails BEFORE Redis — Redis outage doesn't bypass this.
        String token = "tampered.jwt.token";
        when(jwtTokenProvider.isTokenValid(token)).thenReturn(false);

        MockHttpServletRequest request = requestWithToken(token);
        filter.doFilterInternal(request, new MockHttpServletResponse(), new MockFilterChain());

        assertNull(SecurityContextHolder.getContext().getAuthentication());
        verifyNoInteractions(redisTemplate);  // Redis never consulted for invalid JWT
    }

    // ─── helpers ──────────────────────────────────────────────────────────────

    private MockHttpServletRequest requestWithToken(String token) {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/v1/exams");
        request.addHeader("Authorization", "Bearer " + token);
        return request;
    }

    private UserDetails testUser() {
        return new User("user@test.com", "pwd", List.of(new SimpleGrantedAuthority("ROLE_STUDENT")));
    }
}
