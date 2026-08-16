package au.com.naplanprep.config;

import au.com.naplanprep.auth.service.UserDetailsServiceImpl;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;
    private final UserDetailsServiceImpl userDetailsService;
    private final RedisTemplate<String, String> redisTemplate;

    @Override
    protected void doFilterInternal(
        @NonNull HttpServletRequest request,
        @NonNull HttpServletResponse response,
        @NonNull FilterChain filterChain
    ) throws ServletException, IOException {
        final String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);

        try {
            if (!jwtTokenProvider.isTokenValid(token)) {
                filterChain.doFilter(request, response);
                return;
            }

            // Redis blacklist check: if Redis is unavailable we allow the request
            // and accept the narrow risk that a recently-revoked token is valid for
            // the duration of the outage. JWT cryptographic validity is always checked
            // above; only the revocation layer is skipped. This is intentional — a
            // Redis outage must not convert to a platform-wide 401 storm.
            try {
                String blacklistKey = "blacklist:" + token;
                if (Boolean.TRUE.equals(redisTemplate.hasKey(blacklistKey))) {
                    filterChain.doFilter(request, response);
                    return;
                }
            } catch (Exception redisEx) {
                log.error("JWT_BLACKLIST_REDIS_ERROR — Redis unavailable; proceeding without blacklist check: {}",
                    redisEx.getMessage());
            }

            String userId = jwtTokenProvider.getSubject(token);

            if (SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = userDetailsService.loadUserById(userId);
                UsernamePasswordAuthenticationToken authToken =
                    new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        } catch (Exception e) {
            log.debug("JWT filter error: {}", e.getMessage());
        }

        filterChain.doFilter(request, response);
    }
}
