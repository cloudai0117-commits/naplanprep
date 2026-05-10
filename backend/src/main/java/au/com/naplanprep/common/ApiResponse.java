package au.com.naplanprep.common;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.List;
import java.util.Map;

@JsonInclude(JsonInclude.Include.NON_NULL)
public record ApiResponse<T>(
    String status,
    T data,
    List<String> errors,
    Map<String, Object> meta
) {
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>("success", data, null, null);
    }

    public static <T> ApiResponse<T> success(T data, Map<String, Object> meta) {
        return new ApiResponse<>("success", data, null, meta);
    }

    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>("error", null, List.of(message), null);
    }

    public static <T> ApiResponse<T> error(List<String> errors) {
        return new ApiResponse<>("error", null, errors, null);
    }
}
