package au.com.naplanprep.auth.controller;

import au.com.naplanprep.auth.dto.AuthResponse;
import au.com.naplanprep.auth.dto.LoginRequest;
import au.com.naplanprep.auth.dto.RegisterRequest;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.auth.service.AuthService;
import au.com.naplanprep.common.ApiResponse;
import au.com.naplanprep.common.exception.ResourceNotFoundException;
import jakarta.validation.Valid;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final UserRepository userRepository;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> register(@Valid @RequestBody RegisterRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.success(authService.register(req)));
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest req) {
        return ResponseEntity.ok(ApiResponse.success(authService.login(req)));
    }

    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<AuthResponse>> refresh(@RequestBody Map<String, String> body) {
        String refreshToken = body.get("refreshToken");
        return ResponseEntity.ok(ApiResponse.success(authService.refreshToken(refreshToken)));
    }

    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<Void>> logout(
        @RequestHeader(value = "Authorization", required = false) String authHeader
    ) {
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            authService.logout(authHeader.substring(7));
        }
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<UserProfileResponse>> me(
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        User user = userRepository.findByIdWithProfile(userId)
            .orElseThrow(() -> new ResourceNotFoundException("User", userId.toString()));

        var profile = user.getProfile();
        return ResponseEntity.ok(ApiResponse.success(new UserProfileResponse(
            user.getId(),
            user.getEmail(),
            user.getRole(),
            user.getStatus(),
            profile != null ? profile.getFirstName() : null,
            profile != null ? profile.getLastName() : null,
            profile != null ? profile.getYearLevel() : null,
            profile != null ? profile.getSchool() : null,
            profile != null ? profile.getAvatarUrl() : null
        )));
    }

    /** Change password for the authenticated user. Blacklists the current access token on success. */
    @PostMapping("/change-password")
    public ResponseEntity<ApiResponse<Void>> changePassword(
        @RequestBody @Valid ChangePasswordRequest req,
        @AuthenticationPrincipal UserDetails userDetails,
        @RequestHeader(value = "Authorization", required = false) String authHeader
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        String currentToken = (authHeader != null && authHeader.startsWith("Bearer "))
            ? authHeader.substring(7) : null;
        authService.changePassword(userId, req.currentPassword(), req.newPassword(), currentToken);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    /** Initiates forgot-password flow. Always 200 to prevent user enumeration. */
    @PostMapping("/forgot-password")
    public ResponseEntity<ApiResponse<Void>> forgotPassword(
        @RequestBody @Valid ForgotPasswordRequest req,
        @RequestHeader(value = "X-App-Base-URL", required = false) String appBaseUrl
    ) {
        String resetBaseUrl = (appBaseUrl != null && !appBaseUrl.isBlank())
            ? appBaseUrl : "http://localhost:5173";
        authService.forgotPassword(req.email(), resetBaseUrl);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    /** Completes password reset with the single-use token from the email link. */
    @PostMapping("/reset-password")
    public ResponseEntity<ApiResponse<Void>> resetPassword(
        @RequestBody @Valid ResetPasswordRequest req
    ) {
        authService.resetPassword(req.token(), req.newPassword());
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    public record UserProfileResponse(
        UUID id,
        String email,
        User.Role role,
        User.UserStatus status,
        String firstName,
        String lastName,
        Integer yearLevel,
        String school,
        String avatarUrl
    ) {}

    public record ChangePasswordRequest(
        @NotBlank(message = "Current password is required")
        String currentPassword,

        @NotBlank(message = "New password is required")
        @Size(min = 8, message = "Password must be at least 8 characters")
        @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).*$",
            message = "Password must contain uppercase, lowercase and a number")
        String newPassword,

        @NotBlank(message = "Password confirmation is required")
        String confirmNewPassword
    ) {
        @AssertTrue(message = "Passwords do not match")
        public boolean isPasswordMatch() {
            return newPassword != null && newPassword.equals(confirmNewPassword);
        }
    }

    public record ForgotPasswordRequest(
        @NotBlank(message = "Email is required")
        @Email(message = "Invalid email")
        String email
    ) {}

    public record ResetPasswordRequest(
        @NotBlank(message = "Token is required")
        String token,

        @NotBlank(message = "New password is required")
        @Size(min = 8, message = "Password must be at least 8 characters")
        @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).*$",
            message = "Password must contain uppercase, lowercase and a number")
        String newPassword,

        @NotBlank(message = "Password confirmation is required")
        String confirmNewPassword
    ) {
        @AssertTrue(message = "Passwords do not match")
        public boolean isPasswordMatch() {
            return newPassword != null && newPassword.equals(confirmNewPassword);
        }
    }
}
