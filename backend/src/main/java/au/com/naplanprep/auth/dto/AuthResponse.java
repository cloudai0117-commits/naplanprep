package au.com.naplanprep.auth.dto;

import au.com.naplanprep.auth.entity.User;

import java.util.UUID;

public record AuthResponse(
    String accessToken,
    String refreshToken,
    String tokenType,
    long expiresIn,
    UserInfo user
) {
    public record UserInfo(
        UUID id,
        String email,
        String firstName,
        String lastName,
        User.Role role,
        Integer yearLevel
    ) {}
}
