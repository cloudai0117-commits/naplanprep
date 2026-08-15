package au.com.naplanprep.common;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;

/**
 * Shared utility for generating Stripe-compatible webhook signature headers in tests.
 * Both PlanUpgradeIntegrationTest and SubscriptionFlowApiTest use this to produce
 * real HMAC-SHA256 signatures instead of bypassing verification.
 */
public final class StripeTestUtils {

    private StripeTestUtils() {}

    /**
     * Produces a Stripe-Signature header value for the given payload and secret.
     * Format: t=<timestamp>,v1=<hmac_hex>
     * Signing input: timestamp + "." + payload (UTF-8 bytes, HMAC-SHA256 with secret as UTF-8 bytes).
     */
    public static String stripeSignatureHeader(String payload, String secret, long timestamp)
            throws Exception {
        String signed = timestamp + "." + payload;
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] hash = mac.doFinal(signed.getBytes(StandardCharsets.UTF_8));
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) hex.append(String.format("%02x", b));
        return "t=" + timestamp + ",v1=" + hex;
    }
}
