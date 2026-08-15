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
        try {
            var props = appProperties.getJwt();
            privateKey = loadPrivateKey(props.getPrivateKeyPath());
            publicKey = loadPublicKey(props.getPublicKeyPath());
        } catch (Exception e) {
            for (String profile : environment.getActiveProfiles()) {
                if ("uat".equals(profile) || "prod".equals(profile)) {
                    throw new IllegalStateException(
                        "JWT RSA keys are required in " + profile + " profile. " +
                        "Set app.jwt.private-key-path and app.jwt.public-key-path. " +
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
            publicKey = pair.getPublic();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Failed to generate RSA keys", e);
        }
    }

    private PrivateKey loadPrivateKey(String path) throws Exception {
        byte[] keyBytes = readKeyFile(path);
        String keyStr = new String(keyBytes)
            .replace("-----BEGIN PRIVATE KEY-----", "")
            .replace("-----END PRIVATE KEY-----", "")
            .replaceAll("\\s", "");
        byte[] decoded = Base64.getDecoder().decode(keyStr);
        KeyFactory kf = KeyFactory.getInstance("RSA");
        return kf.generatePrivate(new PKCS8EncodedKeySpec(decoded));
    }

    private PublicKey loadPublicKey(String path) throws Exception {
        byte[] keyBytes = readKeyFile(path);
        String keyStr = new String(keyBytes)
            .replace("-----BEGIN PUBLIC KEY-----", "")
            .replace("-----END PUBLIC KEY-----", "")
            .replaceAll("\\s", "");
        byte[] decoded = Base64.getDecoder().decode(keyStr);
        KeyFactory kf = KeyFactory.getInstance("RSA");
        return kf.generatePublic(new X509EncodedKeySpec(decoded));
    }

    private byte[] readKeyFile(String path) throws Exception {
        var resource = resourceLoader.getResource(path);
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
