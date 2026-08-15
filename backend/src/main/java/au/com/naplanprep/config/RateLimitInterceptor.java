package au.com.naplanprep.config;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Bucket4j in-memory rate limiter applied to exam and auth endpoints.
 *
 * Limits are per IP address. Each endpoint group has its own bucket capacity
 * so that answer-save (high frequency) does not exhaust the exam-start budget.
 *
 * For production at scale, replace the in-memory store with a Redis-backed
 * ProxyManager (Bucket4j-Redis or Caffeine+Redis) to share state across pods.
 *
 * Endpoint groups:
 *   EXAM_START   — 10 starts per 10 minutes (prevents session flooding)
 *   EXAM_OPS     — 200 ops per minute (answer saves, flags, testlet transitions)
 *   AUTH         — 20 attempts per minute (login/register brute-force guard)
 */
@Slf4j
@Component
public class RateLimitInterceptor implements HandlerInterceptor {

    // ── Buckets keyed by "group:ip" ───────────────────────────────
    private final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        String ip   = extractClientIp(request);
        String path = request.getRequestURI();
        String method = request.getMethod();

        BucketGroup group = classify(path, method);
        if (group == null) {
            return true; // not a rate-limited endpoint
        }

        Bucket bucket = buckets.computeIfAbsent(group.name() + ":" + ip, k -> newBucket(group));

        if (bucket.tryConsume(1)) {
            return true;
        }

        log.warn("Rate limit exceeded: ip={} group={} path={}", ip, group, path);
        response.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
        response.setContentType("application/json");
        response.getWriter().write("{\"error\":\"Rate limit exceeded. Please wait before retrying.\"}");
        return false;
    }

    private BucketGroup classify(String path, String method) {
        // Auth endpoints: /v1/auth/**
        if (path.startsWith("/v1/auth/")) return BucketGroup.AUTH;
        // Exam start: POST /v1/exams/{id}/start or POST /v1/exams/sessions
        if ("POST".equals(method) && (path.matches(".*/exams/[^/]+/start") || path.matches(".*/exams/sessions"))) {
            return BucketGroup.EXAM_START;
        }
        // Exam operations: POST/PUT on session sub-resources (answer, submit, flag, testlet)
        if (path.contains("/exams/sessions/") && ("POST".equals(method) || "PUT".equals(method))) {
            return BucketGroup.EXAM_OPS;
        }
        return null;
    }

    private Bucket newBucket(BucketGroup group) {
        return switch (group) {
            case EXAM_START -> Bucket.builder()
                .addLimit(Bandwidth.classic(10, Refill.intervally(10, Duration.ofMinutes(10))))
                .build();
            case EXAM_OPS -> Bucket.builder()
                .addLimit(Bandwidth.classic(200, Refill.intervally(200, Duration.ofMinutes(1))))
                .build();
            case AUTH -> Bucket.builder()
                .addLimit(Bandwidth.classic(20, Refill.intervally(20, Duration.ofMinutes(1))))
                .build();
        };
    }

    private String extractClientIp(HttpServletRequest request) {
        String xff = request.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isBlank()) {
            return xff.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    private enum BucketGroup {
        EXAM_START, EXAM_OPS, AUTH
    }
}
