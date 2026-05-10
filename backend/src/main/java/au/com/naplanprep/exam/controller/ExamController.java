package au.com.naplanprep.exam.controller;

import au.com.naplanprep.common.ApiResponse;
import au.com.naplanprep.exam.dto.StartExamRequest;
import au.com.naplanprep.exam.entity.ExamAnswer;
import au.com.naplanprep.exam.entity.ExamResult;
import au.com.naplanprep.exam.entity.ExamSession;
import au.com.naplanprep.exam.service.ExamService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/v1/exams")
@RequiredArgsConstructor
public class ExamController {

    private final ExamService examService;

    @PostMapping("/sessions")
    public ResponseEntity<ApiResponse<ExamSession>> startExam(
        @Valid @RequestBody StartExamRequest req,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.success(examService.startExam(userId, req)));
    }

    @GetMapping("/sessions/{id}")
    public ResponseEntity<ApiResponse<ExamSession>> getSession(
        @PathVariable UUID id,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.success(examService.getSession(id, userId)));
    }

    @PostMapping("/sessions/{id}/answer")
    public ResponseEntity<ApiResponse<ExamAnswer>> submitAnswer(
        @PathVariable UUID id,
        @RequestBody Map<String, Object> body,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        UUID questionId = UUID.fromString(body.get("questionId").toString());
        @SuppressWarnings("unchecked")
        Map<String, Object> answer = (Map<String, Object>) body.get("answer");
        Boolean flagged = body.containsKey("flagged") ? (Boolean) body.get("flagged") : null;
        return ResponseEntity.ok(ApiResponse.success(examService.submitAnswer(id, userId, questionId, answer, flagged)));
    }

    @PostMapping("/sessions/{id}/submit")
    public ResponseEntity<ApiResponse<ExamResult>> submitExam(
        @PathVariable UUID id,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.success(examService.submitExam(id, userId)));
    }

    @GetMapping("/results/{sessionId}")
    public ResponseEntity<ApiResponse<ExamResult>> getResult(
        @PathVariable UUID sessionId,
        @AuthenticationPrincipal UserDetails userDetails
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.success(examService.getResult(sessionId, userId)));
    }

    @GetMapping("/history")
    public ResponseEntity<ApiResponse<Page<ExamSession>>> getHistory(
        @AuthenticationPrincipal UserDetails userDetails,
        @PageableDefault(size = 20) Pageable pageable
    ) {
        UUID userId = UUID.fromString(userDetails.getUsername());
        Page<ExamSession> history = examService.getHistory(userId, pageable);
        return ResponseEntity.ok(ApiResponse.success(history, Map.of("totalElements", history.getTotalElements())));
    }
}
