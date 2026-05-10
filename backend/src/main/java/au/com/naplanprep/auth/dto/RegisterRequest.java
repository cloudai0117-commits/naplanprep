package au.com.naplanprep.auth.dto;

import au.com.naplanprep.auth.entity.User;
import jakarta.validation.constraints.*;

public record RegisterRequest(
    @NotBlank(message = "First name is required")
    @Size(min = 2, max = 50, message = "First name must be 2-50 characters")
    String firstName,

    @Size(max = 50, message = "Last name must be at most 50 characters")
    String lastName,

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    String email,

    @NotBlank(message = "Password is required")
    @Size(min = 8, message = "Password must be at least 8 characters")
    @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).*$",
        message = "Password must contain uppercase, lowercase and a number")
    String password,

    User.Role role,

    @Min(value = 3, message = "Year level must be 3, 5, 7, or 9")
    @Max(value = 9, message = "Year level must be 3, 5, 7, or 9")
    Integer yearLevel
) {
    public User.Role resolvedRole() {
        return role != null ? role : User.Role.STUDENT;
    }
}
