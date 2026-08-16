package au.com.naplanprep.config;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for RateLimitInterceptor.
 *
 * P2-001: client IP is taken from RemoteAddr (not X-Forwarded-For header).
 *         With server.forward-headers-strategy=NATIVE, Tomcat's RemoteIpValve
 *         sets RemoteAddr to the real client IP before this interceptor runs.
 *
 * P2-002: rate limit state is shared via Redis, not an in-memory map.
 *
 * P3-003: POST /v1/subscriptions/webhooks/stripe is rate-limited.
 */
@ExtendWith(MockitoExtension.class)
class RateLimitInterceptorTest {

    @Mock private StringRedisTemplate stringRedisTemplate;
    @Mock private ValueOperations<String, String> valueOps;

    private RateLimitInterceptor interceptor;

    @BeforeEach
    void setUp() {
        interceptor = new RateLimitInterceptor(stringRedisTemplate);
    }

    // ─── P2-001: IP spoofing — X-Forwarded-For header is NOT trusted ─────────

    @Test
    void rateLimitKey_usesRemoteAddr_notXForwardedFor() throws Exception {
        when(stringRedisTemplate.opsForValue()).thenReturn(valueOps);
        when(valueOps.increment(anyString())).thenReturn(1L);

        MockHttpServletRequest request = authRequest();
        request.setRemoteAddr("203.0.113.5");
        request.addHeader("X-Forwarded-For", "1.2.3.4");  // attacker-injected

        interceptor.preHandle(request, new MockHttpServletResponse(), new Object());

        // Key must use RemoteAddr (203.0.113.5), not the spoofed XFF value (1.2.3.4).
        verify(valueOps).increment(argThat(key -> key.contains("203.0.113.5") && !key.contains("1.2.3.4")));
    }

    @Test
    void multipleXffValues_rateLimitKeyUsesRemoteAddr() throws Exception {
        when(stringRedisTemplate.opsForValue()).thenReturn(valueOps);
        when(valueOps.increment(anyString())).thenReturn(1L);

        MockHttpServletRequest request = authRequest();
        request.setRemoteAddr("10.0.0.1");
        request.addHeader("X-Forwarded-For", "evil.com, proxy1, proxy2");

        interceptor.preHandle(request, new MockHttpServletResponse(), new Object());

        verify(valueOps).increment(argThat(key -> key.contains("10.0.0.1")));
        verify(valueOps, never()).increment(argThat(key -> key.contains("evil.com")));
    }

    // ─── P2-002: Redis-backed state ──────────────────────────────────────────

    @Test
    void withinLimit_allowsRequest() throws Exception {
        when(stringRedisTemplate.opsForValue()).thenReturn(valueOps);
        when(valueOps.increment(anyString())).thenReturn(1L);

        boolean allowed = interceptor.preHandle(authRequest(), new MockHttpServletResponse(), new Object());

        assertTrue(allowed);
        verify(valueOps).increment(anyString());
    }

    @Test
    void overLimit_rejectsRequest() throws Exception {
        when(stringRedisTemplate.opsForValue()).thenReturn(valueOps);
        when(valueOps.increment(anyString())).thenReturn(21L);  // AUTH limit is 20

        MockHttpServletResponse response = new MockHttpServletResponse();
        boolean allowed = interceptor.preHandle(authRequest(), response, new Object());

        assertFalse(allowed);
        assertEquals(429, response.getStatus());
    }

    @Test
    void redisUnavailable_allowsRequestAndLogsError() throws Exception {
        // Redis failure must not block all requests — availability preferred over hard block.
        when(stringRedisTemplate.opsForValue()).thenThrow(new RuntimeException("Redis connection refused"));

        boolean allowed = interceptor.preHandle(authRequest(), new MockHttpServletResponse(), new Object());

        assertTrue(allowed);
    }

    @Test
    void nonRateLimitedPath_noRedisInteraction() throws Exception {
        MockHttpServletRequest req = new MockHttpServletRequest("GET", "/actuator/health");
        req.setRemoteAddr("1.1.1.1");

        boolean allowed = interceptor.preHandle(req, new MockHttpServletResponse(), new Object());

        assertTrue(allowed);
        verifyNoInteractions(stringRedisTemplate);
    }

    // ─── P3-003: Stripe webhook rate limiting ─────────────────────────────────

    @Test
    void webhookEndpoint_isRateLimited() throws Exception {
        when(stringRedisTemplate.opsForValue()).thenReturn(valueOps);
        when(valueOps.increment(anyString())).thenReturn(101L);  // WEBHOOK limit is 100

        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/v1/subscriptions/webhooks/stripe");
        request.setRemoteAddr("203.0.113.10");
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean allowed = interceptor.preHandle(request, response, new Object());

        assertFalse(allowed);
        assertEquals(429, response.getStatus());
    }

    @Test
    void webhookEndpoint_withinLimit_isAllowed() throws Exception {
        when(stringRedisTemplate.opsForValue()).thenReturn(valueOps);
        when(valueOps.increment(anyString())).thenReturn(50L);

        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/v1/subscriptions/webhooks/stripe");
        request.setRemoteAddr("203.0.113.10");

        boolean allowed = interceptor.preHandle(request, new MockHttpServletResponse(), new Object());

        assertTrue(allowed);
    }

    @Test
    void webhookEndpoint_redisKey_containsWebhookGroup() throws Exception {
        when(stringRedisTemplate.opsForValue()).thenReturn(valueOps);
        when(valueOps.increment(anyString())).thenReturn(1L);

        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/v1/subscriptions/webhooks/stripe");
        request.setRemoteAddr("1.2.3.4");

        interceptor.preHandle(request, new MockHttpServletResponse(), new Object());

        verify(valueOps).increment(argThat(key -> key.startsWith("ratelimit:WEBHOOK:")));
    }

    // ─── helper ───────────────────────────────────────────────────────────────

    private MockHttpServletRequest authRequest() {
        MockHttpServletRequest req = new MockHttpServletRequest("POST", "/v1/auth/login");
        req.setRemoteAddr("192.168.1.1");
        return req;
    }
}
