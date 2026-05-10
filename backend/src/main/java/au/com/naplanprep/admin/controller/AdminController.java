package au.com.naplanprep.admin.controller;

import au.com.naplanprep.admin.service.AdminService;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.common.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/v1/admin")
@PreAuthorize("hasRole('PLATFORM_ADMIN')")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;

    @GetMapping("/dashboard")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getDashboard() {
        return ResponseEntity.ok(ApiResponse.success(adminService.getDashboard()));
    }

    @GetMapping("/users")
    public ResponseEntity<ApiResponse<Page<User>>> getUsers(
        @RequestParam(required = false) String search,
        @PageableDefault(size = 20) Pageable pageable
    ) {
        Page<User> users = adminService.getUsers(search, pageable);
        return ResponseEntity.ok(ApiResponse.success(users, Map.of("totalElements", users.getTotalElements())));
    }

    @GetMapping("/users/{id}")
    public ResponseEntity<ApiResponse<User>> getUserById(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(adminService.getUserById(id)));
    }

    @PutMapping("/users/{id}/status")
    public ResponseEntity<ApiResponse<User>> updateUserStatus(
        @PathVariable UUID id,
        @RequestBody Map<String, String> body
    ) {
        User.UserStatus newStatus = User.UserStatus.valueOf(body.get("status"));
        return ResponseEntity.ok(ApiResponse.success(adminService.updateUserStatus(id, newStatus)));
    }

    @GetMapping("/subscriptions/analytics")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getSubscriptionAnalytics() {
        return ResponseEntity.ok(ApiResponse.success(adminService.getSubscriptionAnalytics()));
    }

    @GetMapping("/content/stats")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getContentStats() {
        return ResponseEntity.ok(ApiResponse.success(adminService.getContentStats()));
    }
}
