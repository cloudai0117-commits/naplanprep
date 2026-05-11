package au.com.naplanprep.exam.controller;

import au.com.naplanprep.common.ApiResponse;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.exam.dto.*;
import au.com.naplanprep.exam.entity.Exam;
import au.com.naplanprep.exam.service.AdminExamService;
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
@RequestMapping("/v1/admin/exams")
@PreAuthorize("hasRole('PLATFORM_ADMIN')")
@RequiredArgsConstructor
public class AdminExamController {

    private final AdminExamService adminExamService;

    @PostMapping
    public ResponseEntity<ApiResponse<Exam>> createExam(
        @Valid @RequestBody CreateExamRequest req,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID adminId = UUID.fromString(principal.getUsername());
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.success(adminExamService.createExam(req, adminId)));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<Page<Map<String, Object>>>> listExams(
        @RequestParam(required = false) Exam.ExamStatus status,
        @RequestParam(required = false) Integer yearLevel,
        @RequestParam(required = false) Question.Domain domain,
        @PageableDefault(size = 20, sort = "createdAt") Pageable pageable
    ) {
        Page<Map<String, Object>> page = adminExamService.listExams(status, yearLevel, domain, pageable);
        return ResponseEntity.ok(ApiResponse.success(page, Map.of("totalElements", page.getTotalElements())));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getExam(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(adminExamService.getExamDetail(id)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Exam>> updateExam(
        @PathVariable UUID id,
        @Valid @RequestBody UpdateExamRequest req
    ) {
        return ResponseEntity.ok(ApiResponse.success(adminExamService.updateExam(id, req)));
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<ApiResponse<Exam>> updateStatus(
        @PathVariable UUID id,
        @Valid @RequestBody ExamStatusRequest req
    ) {
        return ResponseEntity.ok(ApiResponse.success(adminExamService.updateStatus(id, req.status())));
    }

    @PostMapping("/{id}/questions")
    public ResponseEntity<ApiResponse<Void>> addQuestions(
        @PathVariable UUID id,
        @Valid @RequestBody AddQuestionsRequest req
    ) {
        adminExamService.addQuestions(id, req);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @DeleteMapping("/{id}/questions/{questionId}")
    public ResponseEntity<ApiResponse<Void>> removeQuestion(
        @PathVariable UUID id,
        @PathVariable UUID questionId
    ) {
        adminExamService.removeQuestion(id, questionId);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    @GetMapping("/{id}/results")
    public ResponseEntity<ApiResponse<Page<Map<String, Object>>>> getExamResults(
        @PathVariable UUID id,
        @PageableDefault(size = 20) Pageable pageable
    ) {
        Page<Map<String, Object>> results = adminExamService.getExamResults(id, pageable);
        return ResponseEntity.ok(ApiResponse.success(results, Map.of("totalElements", results.getTotalElements())));
    }
}
