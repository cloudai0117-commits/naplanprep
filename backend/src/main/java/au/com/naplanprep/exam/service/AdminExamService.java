package au.com.naplanprep.exam.service;

import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.exam.dto.*;
import au.com.naplanprep.exam.entity.Exam;
import au.com.naplanprep.exam.entity.ExamQuestion;
import au.com.naplanprep.exam.entity.PackageType;
import au.com.naplanprep.exam.entity.ExamSession;
import au.com.naplanprep.exam.repository.ExamAnswerRepository;
import au.com.naplanprep.exam.repository.ExamQuestionRepository;
import au.com.naplanprep.exam.repository.ExamRepository;
import au.com.naplanprep.exam.repository.ExamResultRepository;
import au.com.naplanprep.exam.repository.ExamSessionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class AdminExamService {

    private final ExamRepository examRepository;
    private final ExamQuestionRepository examQuestionRepository;
    private final ExamSessionRepository sessionRepository;
    private final ExamAnswerRepository answerRepository;
    private final ExamResultRepository resultRepository;
    private final QuestionRepository questionRepository;
    private final UserRepository userRepository;

    @Transactional
    public Exam createExam(CreateExamRequest req, UUID adminId) {
        Exam exam = Exam.builder()
            .title(req.title())
            .description(req.description())
            .yearLevel(req.yearLevel())
            .domain(req.domain())
            .packageType(req.packageType())
            .timeLimitSeconds(req.timeLimitSeconds())
            .availableFrom(req.availableFrom())
            .availableUntil(req.availableUntil())
            .status(Exam.ExamStatus.DRAFT)
            .createdBy(adminId)
            .build();
        return examRepository.save(exam);
    }

    @Transactional
    public Exam updateExam(UUID examId, UpdateExamRequest req) {
        Exam exam = findExamOrThrow(examId);
        if (exam.getStatus() == Exam.ExamStatus.ARCHIVED) {
            throw new BusinessException("Cannot update an archived exam");
        }
        exam.setTitle(req.title());
        exam.setDescription(req.description());
        exam.setYearLevel(req.yearLevel());
        exam.setDomain(req.domain());
        exam.setPackageType(req.packageType());
        exam.setTimeLimitSeconds(req.timeLimitSeconds());
        exam.setAvailableFrom(req.availableFrom());
        exam.setAvailableUntil(req.availableUntil());
        return examRepository.save(exam);
    }

    @Transactional
    public Exam updateStatus(UUID examId, Exam.ExamStatus newStatus) {
        Exam exam = findExamOrThrow(examId);
        validateStatusTransition(exam.getStatus(), newStatus);
        exam.setStatus(newStatus);
        return examRepository.save(exam);
    }

    @Transactional(readOnly = true)
    public Page<Map<String, Object>> listExams(
            Exam.ExamStatus status, Integer yearLevel, Question.Domain domain, Pageable pageable) {

        Page<Exam> exams = examRepository.findWithFilters(status, yearLevel, domain, pageable);
        List<Map<String, Object>> enriched = exams.getContent().stream().map(e -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", e.getId());
            m.put("title", e.getTitle());
            m.put("description", e.getDescription());
            m.put("yearLevel", e.getYearLevel());
            m.put("domain", e.getDomain());
            m.put("packageType", e.getPackageType());
            m.put("timeLimitSeconds", e.getTimeLimitSeconds());
            m.put("availableFrom", e.getAvailableFrom());
            m.put("availableUntil", e.getAvailableUntil());
            m.put("status", e.getStatus());
            m.put("questionCount", examQuestionRepository.findByExamIdOrdered(e.getId()).size());
            m.put("attemptCount", examRepository.countAttemptsByExamId(e.getId()));
            m.put("createdAt", e.getCreatedAt());
            return m;
        }).toList();
        return new PageImpl<>(enriched, pageable, exams.getTotalElements());
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getExamDetail(UUID examId) {
        Exam exam = findExamOrThrow(examId);
        List<ExamQuestion> eqs = examQuestionRepository.findByExamIdOrdered(examId);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("id", exam.getId());
        result.put("title", exam.getTitle());
        result.put("description", exam.getDescription());
        result.put("yearLevel", exam.getYearLevel());
        result.put("domain", exam.getDomain());
        result.put("packageType", exam.getPackageType());
        result.put("timeLimitSeconds", exam.getTimeLimitSeconds());
        result.put("availableFrom", exam.getAvailableFrom());
        result.put("availableUntil", exam.getAvailableUntil());
        result.put("status", exam.getStatus());
        result.put("createdAt", exam.getCreatedAt());
        result.put("questions", eqs.stream().map(eq -> {
            Map<String, Object> q = new LinkedHashMap<>();
            q.put("questionId", eq.getQuestion().getId());
            q.put("questionOrder", eq.getQuestionOrder());
            q.put("questionText", eq.getQuestion().getQuestionText());
            q.put("topic", eq.getQuestion().getTopic());
            q.put("domain", eq.getQuestion().getDomain());
            q.put("difficultyBand", eq.getQuestion().getDifficultyBand());
            return q;
        }).toList());
        return result;
    }

    @Transactional
    public void addQuestions(UUID examId, AddQuestionsRequest req) {
        Exam exam = findExamOrThrow(examId);
        for (AddQuestionsRequest.QuestionOrderItem item : req.questions()) {
            Question q = questionRepository.findById(item.questionId())
                .orElseThrow(() -> new ResourceNotFoundException("Question", item.questionId().toString()));
            ExamQuestion.ExamQuestionId pk = new ExamQuestion.ExamQuestionId(examId, q.getId());
            if (!examQuestionRepository.existsById(pk)) {
                ExamQuestion eq = ExamQuestion.builder()
                    .id(pk)
                    .exam(exam)
                    .question(q)
                    .questionOrder(item.order())
                    .build();
                examQuestionRepository.save(eq);
            }
        }
    }

    @Transactional
    public void removeQuestion(UUID examId, UUID questionId) {
        findExamOrThrow(examId);
        examQuestionRepository.deleteByExamIdAndQuestionId(examId, questionId);
    }

    @Transactional(readOnly = true)
    public Page<Map<String, Object>> getExamResults(UUID examId, Pageable pageable) {
        findExamOrThrow(examId);
        Page<ExamSession> sessions = sessionRepository.findByExamIdAndStatus(
            examId, ExamSession.SessionStatus.SUBMITTED, pageable);

        List<Map<String, Object>> rows = sessions.getContent().stream().map(s -> {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("sessionId", s.getId());
            row.put("userId", s.getUserId());
            row.put("startedAt", s.getStartedAt());
            row.put("submittedAt", s.getSubmittedAt());
            if (s.getStartedAt() != null && s.getSubmittedAt() != null) {
                row.put("timeTakenSeconds",
                    s.getSubmittedAt().getEpochSecond() - s.getStartedAt().getEpochSecond());
            }
            resultRepository.findBySessionId(s.getId()).ifPresent(r -> {
                row.put("totalQuestions", r.getTotalQuestions());
                row.put("correctAnswers", r.getCorrectAnswers());
                row.put("percentage", r.getScorePercentage());
                row.put("band", r.getNaplanBand());
            });
            return row;
        }).toList();

        return new PageImpl<>(rows, pageable, sessions.getTotalElements());
    }

    private Exam findExamOrThrow(UUID examId) {
        return examRepository.findById(examId)
            .orElseThrow(() -> new ResourceNotFoundException("Exam", examId.toString()));
    }

    private void validateStatusTransition(Exam.ExamStatus current, Exam.ExamStatus next) {
        boolean valid = switch (current) {
            case DRAFT -> next == Exam.ExamStatus.PUBLISHED || next == Exam.ExamStatus.HIDDEN;
            case PUBLISHED -> next == Exam.ExamStatus.ARCHIVED || next == Exam.ExamStatus.DRAFT || next == Exam.ExamStatus.HIDDEN;
            case HIDDEN -> next == Exam.ExamStatus.PUBLISHED || next == Exam.ExamStatus.DRAFT || next == Exam.ExamStatus.ARCHIVED;
            case ARCHIVED -> false;
        };
        if (!valid) {
            throw new BusinessException(
                "Cannot transition exam from " + current + " to " + next);
        }
    }

    /** Deletes all exam sessions and results for predefined UAT test accounts.
     *  Allows repeated test runs without redeploying a new Flyway migration. */
    @Transactional
    public Map<String, Integer> resetTestUserSessions() {
        List<String> testEmails = List.of(
            "student1@test.com", "student2@test.com", "parent1@test.com",
            "admin@naplanprep.com.au"
        );
        int resultCount = 0;
        int sessionCount = 0;
        for (String email : testEmails) {
            var userOpt = userRepository.findByEmail(email);
            if (userOpt.isEmpty()) continue;
            UUID uid = userOpt.get().getId();
            // Delete results first (no DB CASCADE from exam_sessions to exam_results)
            List<au.com.naplanprep.exam.entity.ExamResult> results =
                resultRepository.findByUserIdOrderByCalculatedAtDesc(uid);
            resultCount += results.size();
            resultRepository.deleteAll(results);
            // Delete sessions (exam_answers cascade automatically via DB constraint)
            List<ExamSession> sessions = sessionRepository.findByUserId(uid);
            sessionCount += sessions.size();
            sessionRepository.deleteAll(sessions);
        }
        log.info("Test data reset: deleted {} results, {} sessions", resultCount, sessionCount);
        return Map.of("sessions", sessionCount, "results", resultCount);
    }
}
