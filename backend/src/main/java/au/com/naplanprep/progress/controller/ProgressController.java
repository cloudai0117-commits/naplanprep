package au.com.naplanprep.progress.controller;

import au.com.naplanprep.common.ApiResponse;
import au.com.naplanprep.progress.service.ProgressService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/v1/progress")
@RequiredArgsConstructor
public class ProgressController {

    private final ProgressService progressService;

    @GetMapping("/overview")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getOverview(
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.success(progressService.getOverview(userId)));
    }

    @GetMapping("/domains/{domain}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getDomainProgress(
        @PathVariable String domain,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.success(progressService.getDomainProgress(userId, domain)));
    }

    @GetMapping("/recommendations")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getRecommendations(
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.success(progressService.getRecommendations(userId)));
    }

    @GetMapping("/children/{childId}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getChildProgress(
        @PathVariable UUID childId,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID parentId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.success(progressService.getChildProgress(parentId, childId)));
    }
}
