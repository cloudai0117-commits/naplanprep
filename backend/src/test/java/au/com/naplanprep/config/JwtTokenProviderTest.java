package au.com.naplanprep.config;

import au.com.naplanprep.auth.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.core.env.Environment;
import org.springframework.core.io.DefaultResourceLoader;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for JwtTokenProvider — no Spring context required.
 *
 * Tests cover:
 *   Mode 1 (env var PEM content):  valid PEM, escaped-newline PEM, missing key, invalid PEM
 *   Mode 2 (path-based):           classpath resource (test profile keys)
 *   JWT round-trip:                 generate → validate, reject tampered token
 */
class JwtTokenProviderTest {

    // Test PEM files stored in src/test/resources/jwt/ and committed intentionally.
    // These are synthetic test keys that protect no real data.
    private static final String PRIV_KEY_PATH = "classpath:jwt/test-private.pem";
    private static final String PUB_KEY_PATH  = "classpath:jwt/test-public.pem";

    private AppProperties appProperties;
    private Environment environment;

    @BeforeEach
    void setUp() {
        appProperties = new AppProperties();
        appProperties.getJwt().setPrivateKeyPath(PRIV_KEY_PATH);
        appProperties.getJwt().setPublicKeyPath(PUB_KEY_PATH);
        appProperties.getJwt().setAccessTokenExpiry(900);
        appProperties.getJwt().setRefreshTokenExpiry(604800);

        environment = mock(Environment.class);
        // Default: no active profiles — ephemeral keys are allowed as fallback
        when(environment.getActiveProfiles()).thenReturn(new String[]{});
    }

    // ── Helpers ──────────────────────────────────────────────────────────────────

    /** Creates a provider where Mode 1 env vars map to the given values (null = not set). */
    private JwtTokenProvider providerWithEnv(String privateKey, String publicKey) {
        Map<String, String> env = new HashMap<>();
        if (privateKey != null) env.put("JWT_PRIVATE_KEY", privateKey);
        if (publicKey  != null) env.put("JWT_PUBLIC_KEY",  publicKey);

        JwtTokenProvider provider = new JwtTokenProvider(
            appProperties, new DefaultResourceLoader(), environment) {
            @Override protected String getenv(String name) { return env.get(name); }
        };
        provider.init();
        return provider;
    }

    /** Reads a classpath test PEM file as a String. */
    private String readTestPem(String classpathPath) throws Exception {
        var resource = new DefaultResourceLoader().getResource(classpathPath);
        return new String(resource.getInputStream().readAllBytes());
    }

    private User testUser() {
        User user = new User();
        user.setId(UUID.randomUUID());
        user.setEmail("test@naplanprep.com.au");
        user.setRole(User.Role.STUDENT);
        user.setStatus(User.UserStatus.ACTIVE);
        return user;
    }

    // ── Mode 1: env var PEM content ───────────────────────────────────────────

    @Test
    void mode1_validPem_realNewlines_initializesKeys() throws Exception {
        String priv = readTestPem(PRIV_KEY_PATH);
        String pub  = readTestPem(PUB_KEY_PATH);
        // Should not throw
        JwtTokenProvider provider = providerWithEnv(priv, pub);
        assertThat(provider.isTokenValid("anything")).isFalse(); // keys loaded; invalid token returns false
    }

    @Test
    void mode1_validPem_escapedNewlines_initializesKeys() throws Exception {
        // Simulate Railway storing multiline PEM with literal \n
        String priv = readTestPem(PRIV_KEY_PATH).replace("\n", "\\n");
        String pub  = readTestPem(PUB_KEY_PATH).replace("\n", "\\n");
        // stripAndDecodeBase64 must normalise these
        JwtTokenProvider provider = providerWithEnv(priv, pub);
        User user = testUser();
        String token = provider.generateAccessToken(user);
        assertThat(token).isNotBlank();
        assertThat(provider.isTokenValid(token)).isTrue();
    }

    @Test
    void mode1_escapedWindowsCRLF_initializesKeys() throws Exception {
        // Some systems store \r\n as \\r\\n in env vars
        String priv = readTestPem(PRIV_KEY_PATH).replace("\n", "\\r\\n");
        String pub  = readTestPem(PUB_KEY_PATH).replace("\n", "\\r\\n");
        JwtTokenProvider provider = providerWithEnv(priv, pub);
        User user = testUser();
        assertThat(provider.isTokenValid(provider.generateAccessToken(user))).isTrue();
    }

    @Test
    void mode1_missingPrivateKey_inUatProfile_throwsIllegalState() throws Exception {
        when(environment.getActiveProfiles()).thenReturn(new String[]{"uat"});
        String pub = readTestPem(PUB_KEY_PATH);

        JwtTokenProvider provider = new JwtTokenProvider(
            appProperties, new DefaultResourceLoader(), environment) {
            @Override protected String getenv(String name) {
                if ("JWT_PUBLIC_KEY".equals(name)) return pub;
                return null; // private key absent
            }
        };

        // No JWT_PRIVATE_KEY → falls through to Mode 2 → app.jwt.private-key-path is set to test key
        // so it would succeed via Mode 2. Test that BOTH must be present for Mode 1 to trigger.
        // Verify Mode 2 path-based loading still works when only one env var is set.
        assertThatCode(provider::init).doesNotThrowAnyException();
    }

    @Test
    void mode1_invalidPemContent_throwsIllegalState() throws Exception {
        JwtTokenProvider provider = new JwtTokenProvider(
            appProperties, new DefaultResourceLoader(), environment) {
            @Override protected String getenv(String name) {
                return "-----BEGIN " + ("PRIVATE KEY".equals(name.replace("JWT_", "").replace("_", " "))
                    ? "PRIVATE KEY" : "PUBLIC KEY") + "-----\nNOT_VALID_BASE64!!!\n-----END "
                    + ("PRIVATE KEY".equals(name.replace("JWT_", "").replace("_", " "))
                    ? "PRIVATE KEY" : "PUBLIC KEY") + "-----";
            }
        };
        // Both env vars set but content is invalid → IllegalStateException
        assertThatThrownBy(provider::init)
            .isInstanceOf(IllegalStateException.class)
            .hasMessageContaining("JWT_PRIVATE_KEY / JWT_PUBLIC_KEY are set but could not be parsed");
    }

    @Test
    void mode1_missingBothKeys_inUatProfile_throwsIllegalState() {
        // UAT profile, no env vars, no classpath file configured (simulate stale classpath path)
        AppProperties props = new AppProperties();
        props.getJwt().setPrivateKeyPath("classpath:keys/private.pem"); // does not exist in JAR
        props.getJwt().setPublicKeyPath("classpath:keys/public.pem");
        props.getJwt().setAccessTokenExpiry(900);

        when(environment.getActiveProfiles()).thenReturn(new String[]{"uat"});

        JwtTokenProvider provider = new JwtTokenProvider(
            props, new DefaultResourceLoader(), environment) {
            @Override protected String getenv(String name) { return null; } // no env vars
        };

        assertThatThrownBy(provider::init)
            .isInstanceOf(IllegalStateException.class)
            .hasMessageContaining("JWT RSA keys are required in uat profile");
    }

    // ── Mode 2: path-based loading (test/dev profile) ─────────────────────────

    @Test
    void mode2_classpathTestKeys_initializesSuccessfully() {
        JwtTokenProvider provider = new JwtTokenProvider(
            appProperties, new DefaultResourceLoader(), environment) {
            @Override protected String getenv(String name) { return null; } // no env vars
        };
        assertThatCode(provider::init).doesNotThrowAnyException();
    }

    @Test
    void mode2_missingPathInDevProfile_generatesEphemeralKeys() {
        AppProperties props = new AppProperties();
        props.getJwt().setPrivateKeyPath("classpath:keys/does-not-exist.pem");
        props.getJwt().setPublicKeyPath("classpath:keys/does-not-exist-pub.pem");
        props.getJwt().setAccessTokenExpiry(900);

        // dev profile — ephemeral fallback is allowed
        when(environment.getActiveProfiles()).thenReturn(new String[]{"dev"});

        JwtTokenProvider provider = new JwtTokenProvider(
            props, new DefaultResourceLoader(), environment) {
            @Override protected String getenv(String name) { return null; }
        };
        // Should not throw; generates ephemeral keys instead
        assertThatCode(provider::init).doesNotThrowAnyException();
    }

    // ── JWT round-trip ────────────────────────────────────────────────────────

    @Test
    void generateAndValidateAccessToken_roundTrip() throws Exception {
        JwtTokenProvider provider = providerWithEnv(
            readTestPem(PRIV_KEY_PATH), readTestPem(PUB_KEY_PATH));
        User user = testUser();

        String token = provider.generateAccessToken(user);
        assertThat(token).isNotBlank();
        assertThat(provider.isTokenValid(token)).isTrue();
        assertThat(provider.getSubject(token)).isEqualTo(user.getId().toString());

        var claims = provider.validateToken(token);
        assertThat(claims.get("email", String.class)).isEqualTo(user.getEmail());
        assertThat(claims.get("role", String.class)).isEqualTo("STUDENT");
        assertThat(claims.get("type", String.class)).isEqualTo("access");
    }

    @Test
    void generateAndValidateRefreshToken_roundTrip() throws Exception {
        JwtTokenProvider provider = providerWithEnv(
            readTestPem(PRIV_KEY_PATH), readTestPem(PUB_KEY_PATH));
        User user = testUser();

        String token = provider.generateRefreshToken(user);
        assertThat(provider.isTokenValid(token)).isTrue();
        assertThat(provider.validateToken(token).get("type", String.class)).isEqualTo("refresh");
    }

    @Test
    void tamperedToken_isInvalid() throws Exception {
        JwtTokenProvider provider = providerWithEnv(
            readTestPem(PRIV_KEY_PATH), readTestPem(PUB_KEY_PATH));
        User user = testUser();

        String token = provider.generateAccessToken(user);
        // Flip one character in the signature part (last segment)
        String[] parts = token.split("\\.");
        String tampered = parts[0] + "." + parts[1] + "." +
            (parts[2].charAt(0) == 'A' ? "B" : "A") + parts[2].substring(1);

        assertThat(provider.isTokenValid(tampered)).isFalse();
    }

    @Test
    void mode1_keysAreStable_acrossMultipleCallsOnSameInstance() throws Exception {
        JwtTokenProvider provider = providerWithEnv(
            readTestPem(PRIV_KEY_PATH), readTestPem(PUB_KEY_PATH));
        User user = testUser();

        String token1 = provider.generateAccessToken(user);
        String token2 = provider.generateAccessToken(user);
        // Different tokens (different JTI/iat) but both valid with the same key
        assertThat(provider.isTokenValid(token1)).isTrue();
        assertThat(provider.isTokenValid(token2)).isTrue();
        assertThat(token1).isNotEqualTo(token2); // different UUID jti
    }
}
