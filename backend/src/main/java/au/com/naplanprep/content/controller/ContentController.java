package au.com.naplanprep.content.controller;

import au.com.naplanprep.common.ApiResponse;
import au.com.naplanprep.content.dto.QuestionRequest;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.content.service.ContentService;
import au.com.naplanprep.exam.entity.PackageType;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/v1/content")
@RequiredArgsConstructor
public class ContentController {

    private final ContentService contentService;

    @GetMapping("/questions")
    @PreAuthorize("hasRole('PLATFORM_ADMIN') or hasRole('TEACHER') or hasRole('SCHOOL_ADMIN')")
    public ResponseEntity<ApiResponse<Page<Question>>> searchQuestions(
        @RequestParam(required = false) Integer yearLevel,
        @RequestParam(required = false) Question.Domain domain,
        @RequestParam(required = false) String topic,
        @RequestParam(required = false) Integer difficultyBand,
        @RequestParam(required = false) Question.QuestionStatus status,
        @RequestParam(required = false) PackageType packageType,
        @PageableDefault(size = 20) Pageable pageable
    ) {
        Page<Question> page = contentService.searchQuestions(yearLevel, domain, topic, difficultyBand, status, packageType, pageable);
        return ResponseEntity.ok(ApiResponse.success(page, Map.of("totalElements", page.getTotalElements())));
    }

    @PostMapping("/questions")
    @PreAuthorize("hasRole('PLATFORM_ADMIN') or hasRole('TEACHER') or hasRole('SCHOOL_ADMIN')")
    public ResponseEntity<ApiResponse<Question>> createQuestion(
        @Valid @RequestBody QuestionRequest req,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.success(contentService.createQuestion(req, userId)));
    }

    @PutMapping("/questions/{id}")
    @PreAuthorize("hasRole('PLATFORM_ADMIN') or hasRole('TEACHER') or hasRole('SCHOOL_ADMIN')")
    public ResponseEntity<ApiResponse<Question>> updateQuestion(
        @PathVariable UUID id,
        @Valid @RequestBody QuestionRequest req
    ) {
        return ResponseEntity.ok(ApiResponse.success(contentService.updateQuestion(id, req)));
    }

    @PatchMapping("/questions/{id}/status")
    @PreAuthorize("hasRole('PLATFORM_ADMIN')")
    public ResponseEntity<ApiResponse<Question>> updateStatus(
        @PathVariable UUID id,
        @RequestBody Map<String, String> body
    ) {
        Question.QuestionStatus newStatus = Question.QuestionStatus.valueOf(body.get("status"));
        return ResponseEntity.ok(ApiResponse.success(contentService.updateStatus(id, newStatus)));
    }
}
