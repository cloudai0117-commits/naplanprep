package au.com.naplanprep.exam.controller;

import au.com.naplanprep.common.ApiResponse;
import au.com.naplanprep.exam.dto.*;
import au.com.naplanprep.exam.entity.ExamAnswer;
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

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/v1/exams")
@RequiredArgsConstructor
public class ExamController {

    private final ExamService examService;

    // ─── Ad-hoc practice sessions ────────────────────────────────

    @PostMapping("/sessions")
    public ResponseEntity<ApiResponse<ExamSession>> startExam(
        @Valid @RequestBody StartExamRequest req,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.success(examService.startExam(userId, req)));
    }

    @GetMapping("/sessions/{id}")
    public ResponseEntity<ApiResponse<ExamSession>> getSession(
        @PathVariable UUID id,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        return ResponseEntity.ok(ApiResponse.success(examService.getSession(id, userId)));
    }

    /** Returns ordered questions for any session — used by the exam player. */
    @GetMapping("/sessions/{id}/questions")
    public ResponseEntity<ApiResponse<List<QuestionSummary>>> getSessionQuestions(
        @PathVariable UUID id,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        return ResponseEntity.ok(ApiResponse.success(examService.getSessionQuestions(id, userId)));
    }

    /** Returns all saved answers for a session — used to restore state after disconnect/refresh. */
    @GetMapping("/sessions/{id}/answers")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getSessionAnswers(
        @PathVariable UUID id,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        return ResponseEntity.ok(ApiResponse.success(examService.getSessionAnswers(id, userId)));
    }

    @PostMapping("/sessions/{id}/answer")
    public ResponseEntity<ApiResponse<ExamAnswer>> submitAnswer(
        @PathVariable UUID id,
        @RequestBody Map<String, Object> body,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        UUID questionId = UUID.fromString(body.get("questionId").toString());
        @SuppressWarnings("unchecked")
        Map<String, Object> answer = (Map<String, Object>) body.get("answer");
        Boolean flagged = body.containsKey("flagged") ? (Boolean) body.get("flagged") : null;
        Integer timeTakenSeconds = body.containsKey("timeTakenSeconds")
            ? ((Number) body.get("timeTakenSeconds")).intValue() : null;
        return ResponseEntity.ok(ApiResponse.success(
            examService.submitAnswer(id, userId, questionId, answer, flagged, timeTakenSeconds)));
    }

    @PostMapping("/sessions/{id}/submit")
    public ResponseEntity<ApiResponse<ExamResultDetailResponse>> submitExam(
        @PathVariable UUID id,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        return ResponseEntity.ok(ApiResponse.success(examService.submitExam(id, userId)));
    }

    // ─── Admin-created exam flow ──────────────────────────────────

    @GetMapping("/available")
    public ResponseEntity<ApiResponse<List<AvailableExamResponse>>> getAvailableExams(
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        return ResponseEntity.ok(ApiResponse.success(examService.getAvailableExams(userId)));
    }

    @PostMapping("/{examId}/start")
    public ResponseEntity<ApiResponse<Map<String, Object>>> startAdminExam(
        @PathVariable UUID examId,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.success(examService.startAdminExam(examId, userId)));
    }

    // ─── Testlet navigation (branching exams) ─────────────────────

    /**
     * Called when the student finishes all questions in a testlet and is ready to advance.
     * Server evaluates branching rules, updates navigation state, and returns next testlet.
     *
     * Response includes:
     *   - nextTestletId (null when path is complete)
     *   - calculatorAllowed (whether the next testlet permits calculator use)
     *   - navigationLocked (whether the current testlet can be revisited)
     *   - questions for the next testlet (correctAnswer/rubric stripped)
     *   - pathComplete: true when no more testlets — client should call /submit
     */
    @PostMapping("/sessions/{id}/testlet/{testletId}/complete")
    public ResponseEntity<ApiResponse<Map<String, Object>>> completeTestlet(
        @PathVariable UUID id,
        @PathVariable UUID testletId,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        return ResponseEntity.ok(ApiResponse.success(examService.completeTestlet(id, userId, testletId)));
    }

    /**
     * Flags or unflags a question for review.
     * The updated flaggedQuestions list is returned via GET /sessions/{id}.
     */
    @PutMapping("/sessions/{id}/flag/{questionId}")
    public ResponseEntity<ApiResponse<Void>> flagQuestion(
        @PathVariable UUID id,
        @PathVariable UUID questionId,
        @RequestBody Map<String, Object> body,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        boolean flagged = Boolean.TRUE.equals(body.get("flagged"));
        examService.flagQuestion(id, userId, questionId, flagged);
        return ResponseEntity.ok(ApiResponse.success(null));
    }

    // ─── Results ─────────────────────────────────────────────────

    @GetMapping("/results/{sessionId}")
    public ResponseEntity<ApiResponse<ExamResultDetailResponse>> getDetailedResult(
        @PathVariable UUID sessionId,
        @AuthenticationPrincipal UserDetails principal
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        return ResponseEntity.ok(ApiResponse.success(examService.getDetailedResult(sessionId, userId)));
    }

    @GetMapping("/my-results")
    public ResponseEntity<ApiResponse<Page<ExamSession>>> getMyResults(
        @AuthenticationPrincipal UserDetails principal,
        @PageableDefault(size = 20) Pageable pageable
    ) {
        UUID userId = UUID.fromString(principal.getUsername());
        Page<ExamSession> history = examService.getHistory(userId, pageable);
        return ResponseEntity.ok(ApiResponse.success(history,
            Map.of("totalElements", history.getTotalElements())));
    }
}
