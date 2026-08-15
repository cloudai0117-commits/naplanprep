package au.com.naplanprep.config;

import au.com.naplanprep.auth.entity.User;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.*;
import java.security.spec.*;
import java.util.Base64;
import java.util.Date;
import java.util.UUID;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtTokenProvider {

    private final AppProperties appProperties;
    private final ResourceLoader resourceLoader;
    private final Environment environment;

    private PrivateKey privateKey;
    private PublicKey publicKey;

    @PostConstruct
    public void init() {
        // Mode 1: PEM content from environment variables (Railway/cloud deployment).
        // JWT_PRIVATE_KEY and JWT_PUBLIC_KEY hold the full PEM text.
        // This is checked first so it wins over any app.jwt.*-key-path configuration
        // that may be set in Railway Variables (e.g. a stale APP_JWT_PRIVATE_KEY_PATH).
        String privKeyEnv = System.getenv("JWT_PRIVATE_KEY");
        String pubKeyEnv  = System.getenv("JWT_PUBLIC_KEY");
        log.info("JWT_PRIVATE_KEY configured = {}", privKeyEnv != null && !privKeyEnv.isBlank());
        log.info("JWT_PUBLIC_KEY configured = {}",  pubKeyEnv  != null && !pubKeyEnv.isBlank());

        if (privKeyEnv != null && !privKeyEnv.isBlank()
                && pubKeyEnv != null && !pubKeyEnv.isBlank()) {
            try {
                privateKey = loadPrivateKey(privKeyEnv);
                publicKey  = loadPublicKey(pubKeyEnv);
                log.info("JWT RSA keys loaded from environment variables (JWT_PRIVATE_KEY / JWT_PUBLIC_KEY)");
                return;
            } catch (Exception e) {
                throw new IllegalStateException(
                    "JWT_PRIVATE_KEY / JWT_PUBLIC_KEY are set but could not be parsed as RSA PEM. " +
                    "Verify that the values are PKCS#8 private key and X.509 public key PEM. " +
                    "Cause: " + e.getMessage(), e);
            }
        }

        // Mode 2: path/resource-based loading via app.jwt.private-key-path / public-key-path.
        // Used by local dev (classpath:keys/dev-private.pem) and test profile (classpath:jwt/test-*.pem).
        try {
            var props = appProperties.getJwt();
            privateKey = loadPrivateKey(props.getPrivateKeyPath());
            publicKey  = loadPublicKey(props.getPublicKeyPath());
        } catch (Exception e) {
            for (String profile : environment.getActiveProfiles()) {
                if ("uat".equals(profile) || "prod".equals(profile)) {
                    throw new IllegalStateException(
                        "JWT RSA keys are required in " + profile + " profile. " +
                        "Set JWT_PRIVATE_KEY and JWT_PUBLIC_KEY environment variables (preferred), " +
                        "or set app.jwt.private-key-path and app.jwt.public-key-path. " +
                        "Cause: " + e.getMessage(), e);
                }
            }
            log.warn("Could not load RSA keys from config, generating ephemeral keys for dev: {}", e.getMessage());
            generateEphemeralKeys();
        }
    }

    private void generateEphemeralKeys() {
        try {
            KeyPairGenerator gen = KeyPairGenerator.getInstance("RSA");
            gen.initialize(2048);
            KeyPair pair = gen.generateKeyPair();
            privateKey = pair.getPrivate();
            publicKey  = pair.getPublic();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Failed to generate RSA keys", e);
        }
    }

    private PrivateKey loadPrivateKey(String pathOrPem) throws Exception {
        byte[] keyBytes = readKeyContent(pathOrPem);
        String keyStr = new String(keyBytes, StandardCharsets.UTF_8)
            .replace("-----BEGIN PRIVATE KEY-----", "")
            .replace("-----END PRIVATE KEY-----", "")
            .replaceAll("\\s", "");
        byte[] decoded = Base64.getDecoder().decode(keyStr);
        return KeyFactory.getInstance("RSA").generatePrivate(new PKCS8EncodedKeySpec(decoded));
    }

    private PublicKey loadPublicKey(String pathOrPem) throws Exception {
        byte[] keyBytes = readKeyContent(pathOrPem);
        String keyStr = new String(keyBytes, StandardCharsets.UTF_8)
            .replace("-----BEGIN PUBLIC KEY-----", "")
            .replace("-----END PUBLIC KEY-----", "")
            .replaceAll("\\s", "");
        byte[] decoded = Base64.getDecoder().decode(keyStr);
        return KeyFactory.getInstance("RSA").generatePublic(new X509EncodedKeySpec(decoded));
    }

    private byte[] readKeyContent(String pathOrPem) throws Exception {
        // Inline PEM content passed directly (from env var or init() env-var mode)
        if (pathOrPem != null && pathOrPem.startsWith("-----BEGIN")) {
            return pathOrPem.getBytes(StandardCharsets.UTF_8);
        }
        // File/classpath resource path (classpath:..., file:..., etc.)
        var resource = resourceLoader.getResource(pathOrPem);
        return resource.getInputStream().readAllBytes();
    }

    public String generateAccessToken(User user) {
        return buildToken(user, appProperties.getJwt().getAccessTokenExpiry() * 1000L, "access");
    }

    public String generateRefreshToken(User user) {
        return buildToken(user, appProperties.getJwt().getRefreshTokenExpiry() * 1000L, "refresh");
    }

    private String buildToken(User user, long expiryMs, String type) {
        return Jwts.builder()
            .id(UUID.randomUUID().toString())
            .subject(user.getId().toString())
            .claim("email", user.getEmail())
            .claim("role", user.getRole().name())
            .claim("type", type)
            .issuedAt(new Date())
            .expiration(new Date(System.currentTimeMillis() + expiryMs))
            .signWith(privateKey, Jwts.SIG.RS256)
            .compact();
    }

    public Claims validateToken(String token) {
        return Jwts.parser()
            .verifyWith(publicKey)
            .build()
            .parseSignedClaims(token)
            .getPayload();
    }

    public boolean isTokenValid(String token) {
        try {
            validateToken(token);
            return true;
        } catch (JwtException e) {
            log.debug("Invalid JWT: {}", e.getMessage());
            return false;
        }
    }

    public String getSubject(String token) {
        return validateToken(token).getSubject();
    }
}
