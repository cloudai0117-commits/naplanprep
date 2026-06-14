package au.com.naplanprep.subscription.controller;

import au.com.naplanprep.common.ApiResponse;
import au.com.naplanprep.subscription.entity.Plan;
import au.com.naplanprep.subscription.entity.Subscription;
import au.com.naplanprep.subscription.service.SubscriptionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/v1/subscriptions")
@RequiredArgsConstructor
public class SubscriptionController {

    private final SubscriptionService subscriptionService;

    @GetMapping("/plans")
    public ResponseEntity<ApiResponse<List<Plan>>> getPlans() {
        return ResponseEntity.ok(ApiResponse.success(subscriptionService.getPlans()));
    }

    @PostMapping("/checkout")
    public ResponseEntity<ApiResponse<Map<String, String>>> createCheckout(
        @RequestBody Map<String, String> body,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        String url = subscriptionService.createCheckoutSession(
            userId,
            body.get("planSlug"),
            body.get("interval"),
            body.get("successUrl"),
            body.get("cancelUrl")
        );
        return ResponseEntity.ok(ApiResponse.success(Map.of("checkoutUrl", url)));
    }

    @GetMapping("/current")
    public ResponseEntity<ApiResponse<Optional<Subscription>>> getCurrent(
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.success(subscriptionService.getCurrentSubscription(userId)));
    }

    @PostMapping("/portal")
    public ResponseEntity<ApiResponse<Map<String, String>>> createPortal(
        @RequestBody(required = false) Map<String, String> body,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        String returnUrl = body != null ? body.get("returnUrl") : null;
        String url = subscriptionService.createPortalSession(userId, returnUrl);
        return ResponseEntity.ok(ApiResponse.success(Map.of("portalUrl", url)));
    }

    @PostMapping("/verify-checkout")
    public ResponseEntity<ApiResponse<Optional<Subscription>>> verifyCheckout(
        @RequestBody Map<String, String> body,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        subscriptionService.syncFromCheckoutSession(userId, body.get("sessionId"));
        return ResponseEntity.ok(ApiResponse.success(subscriptionService.getCurrentSubscription(userId)));
    }

    @PostMapping("/cancel")
    public ResponseEntity<ApiResponse<Void>> cancel(
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        subscriptionService.cancelSubscription(userId);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @PostMapping("/webhooks/stripe")
    public ResponseEntity<Void> handleWebhook(
        @RequestBody String payload,
        @RequestHeader("stripe-signature") String sigHeader
    ) {
        subscriptionService.handleWebhook(payload, sigHeader);
        return ResponseEntity.ok().build();
    }
}
