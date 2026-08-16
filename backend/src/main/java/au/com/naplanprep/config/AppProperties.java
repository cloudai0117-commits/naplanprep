package au.com.naplanprep.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.List;

@Data
@Component
@ConfigurationProperties(prefix = "app")
public class AppProperties {

    private Jwt jwt = new Jwt();
    private Stripe stripe = new Stripe();
    private Cors cors = new Cors();
    private String frontendUrl;
    private String baseUrl = "http://localhost:5173";
    private RateLimit rateLimit = new RateLimit();

    @Data
    public static class Jwt {
        private String privateKeyPath;
        private String publicKeyPath;
        private long accessTokenExpiry = 900;
        private long refreshTokenExpiry = 604800;
    }

    @Data
    public static class Stripe {
        private String secretKey;
        private String webhookSecret;
        private String publishableKey;
        private String advancedPriceId;
        private String proPriceId;
    }

    @Data
    public static class Cors {
        private List<String> allowedOrigins;
    }

    @Data
    public static class RateLimit {
        private int authAttempts = 5;
        private int authLockoutMinutes = 15;
    }
}
