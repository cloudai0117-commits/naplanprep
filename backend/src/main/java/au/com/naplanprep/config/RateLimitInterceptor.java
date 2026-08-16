package au.com.naplanprep.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.time.Duration;

/**
 * Redis-backed rate limiter using a fixed-window counter (INCR + EXPIRE).
 *
 * State is shared across all application pods via Redis, so the limit is
 * enforced cluster-wide rather than per-instance.
 *
 * Client IP is read from {@code request.getRemoteAddr()}. When the app is
 * deployed behind a trusted reverse proxy (Railway UAT/prod), Spring's
 * {@code server.forward-headers-strategy=NATIVE} rewrites RemoteAddr from
 * X-Forwarded-For before this interceptor runs, giving the actual client IP.
 * Attacker-injected X-Forwarded-For headers that arrive before the proxy's
 * own entry are stripped by Tomcat's RemoteIpValve — the interceptor never
 * sees them.
 *
 * Redis failure: the interceptor falls through and allows the request,
 * logging an error. This trades a narrow availability window (requests allowed
 * during Redis outage) against a hard unavailability (all requests blocked).
 * The accepted risk is documented in P2-006 / P2-002.
 *
 * Endpoint groups:
 *   EXAM_START  — 10 starts per 10 minutes
 *   EXAM_OPS    — 200 ops per minute
 *   AUTH        — 20 attempts per minute
 *   WEBHOOK     — 100 requests per minute (abuse guard; Stripe signature is authoritative)
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RateLimitInterceptor implements HandlerInterceptor {

    private final StringRedisTemplate stringRedisTemplate;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        String ip = request.getRemoteAddr();
        String path = request.getRequestURI();
        String method = request.getMethod();

        BucketGroup group = classify(path, method);
        if (group == null) {
            return true;
        }

        try {
            long count = increment(group, ip);
            if (count > group.limit) {
                log.warn("RATE_LIMIT_EXCEEDED ip={} group={} path={} count={}", ip, group, path, count);
                response.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"Rate limit exceeded. Please wait before retrying.\"}");
                return false;
            }
        } catch (Exception e) {
            log.error("RATE_LIMIT_REDIS_ERROR — Redis unavailable, allowing request: {}", e.getMessage());
        }

        return true;
    }

    private BucketGroup classify(String path, String method) {
        if (path.startsWith("/v1/auth/")) return BucketGroup.AUTH;
        if ("/v1/subscriptions/webhooks/stripe".equals(path) && "POST".equals(method)) return BucketGroup.WEBHOOK;
        if ("POST".equals(method) && (path.matches(".*/exams/[^/]+/start") || path.matches(".*/exams/sessions"))) {
            return BucketGroup.EXAM_START;
        }
        if (path.contains("/exams/sessions/") && ("POST".equals(method) || "PUT".equals(method))) {
            return BucketGroup.EXAM_OPS;
        }
        return null;
    }

    /**
     * Atomically increments the fixed-window counter for this group+IP and returns the new count.
     * The window key changes every {@code windowSeconds}, so old counters expire naturally.
     */
    private long increment(BucketGroup group, String ip) {
        long windowId = System.currentTimeMillis() / (group.windowSeconds * 1000L);
        String key = "ratelimit:" + group.name() + ":" + ip + ":" + windowId;

        Long count = stringRedisTemplate.opsForValue().increment(key);
        if (count == null) count = 1L;
        if (count == 1L) {
            // First hit in this window — set TTL so the key is cleaned up automatically.
            // TTL is window + 1 s to avoid a race where the key expires at the exact window boundary.
            stringRedisTemplate.expire(key, Duration.ofSeconds(group.windowSeconds + 1));
        }
        return count;
    }

    private enum BucketGroup {
        EXAM_START(10,  600),   // 10 per 10 min
        EXAM_OPS  (200, 60),    // 200 per minute
        AUTH      (20,  60),    // 20 per minute
        WEBHOOK   (100, 60);    // 100 per minute

        final long limit;
        final long windowSeconds;

        BucketGroup(long limit, long windowSeconds) {
            this.limit = limit;
            this.windowSeconds = windowSeconds;
        }
    }
}
