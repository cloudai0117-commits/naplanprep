package au.com.naplanprep.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Fails fast on startup if any required Stripe configuration is missing.
 * Active only in UAT and prod profiles — dev/test allow empty values for local work.
 */
@Slf4j
@Component
@Profile({"uat", "prod"})
@RequiredArgsConstructor
public class StripeConfigValidator implements InitializingBean {

    private final AppProperties appProperties;

    @Override
    public void afterPropertiesSet() {
        AppProperties.Stripe stripe = appProperties.getStripe();

        List<String> missing = new ArrayList<>();
        if (isBlankOrDummy(stripe.getSecretKey()))       missing.add("STRIPE_SECRET_KEY");
        if (isBlankOrDummy(stripe.getPublishableKey()))  missing.add("STRIPE_PUBLISHABLE_KEY");
        if (isBlankOrDummy(stripe.getWebhookSecret()))   missing.add("STRIPE_WEBHOOK_SECRET");
        if (isBlankOrDummy(stripe.getAdvancedPriceId())) missing.add("STRIPE_ADVANCED_PRICE_ID");
        if (isBlankOrDummy(stripe.getProPriceId()))      missing.add("STRIPE_PRO_PRICE_ID");

        if (!missing.isEmpty()) {
            String msg = "STARTUP FAILED — Required Stripe environment variables are not configured: "
                + String.join(", ", missing)
                + ". Set these in the Railway dashboard (Variables tab) or Azure Application Settings.";
            log.error(msg);
            throw new IllegalStateException(msg);
        }

        log.info("STRIPE_CONFIG_VALID — all required Stripe environment variables are present.");
    }

    private boolean isBlankOrDummy(String value) {
        if (value == null || value.isBlank()) return true;
        String lower = value.toLowerCase();
        return lower.contains("dummy") || lower.contains("placeholder") || lower.contains("example");
    }
}
