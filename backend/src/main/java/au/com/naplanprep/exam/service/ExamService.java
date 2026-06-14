package au.com.naplanprep.exam.service;

import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.exam.dto.*;
import au.com.naplanprep.exam.entity.*;
import au.com.naplanprep.exam.repository.*;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.subscription.entity.Subscription;
import au.com.naplanprep.subscription.repository.SubscriptionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ExamService {

    private static final Map<ExamSession.ExamType, Integer> TIME_LIMITS = Map.of(
        ExamSession.ExamType.PRACTICE,   30 * 60,
        ExamSession.ExamType.MOCK,       65 * 60,
        ExamSession.ExamType.DIAGNOSTIC, 20 * 60
    );

    private final ExamSessionRepository sessionRepository;
    private final ExamAnswerRepository answerRepository;
    private final ExamResultRepository resultRepository;
    private final ExamRepository examRepository;
    private final ExamQuestionRepository examQuestionRepository;
    private final QuestionRepository questionRepository;
    private final SubscriptionRepository subscriptionRepository;
    private final UserRepository userRepository;

    // ─────────────────────────────────────────────────────────────
    // Practice / ad-hoc sessions (existing flow)
    // ─────────────────────────────────────────────────────────────

    @Transactional
    public ExamSession startExam(UUID userId, StartExamRequest req) {
        int count = req.resolvedQuestionCount();
        List<Question> questions;
        if (req.domain() != null) {
            questions = questionRepository.findRandomByYearLevelAndDomain(
                req.yearLevel(), req.domain(),
                org.springframework.data.domain.PageRequest.of(0, count));
        } else {
            questions = questionRepository.findRandomByYearLevelAndDomain(
                req.yearLevel(), Question.Domain.NUMERACY,
                org.springframework.data.domain.PageRequest.of(0, count));
        }
        if (questions.isEmpty()) {
            throw new BusinessException("No questions available for the selected criteria");
        }
        Collections.shuffle(questions);
        List<UUID> questionIds = questions.stream().map(Question::getId).toList();

        int timeLimit = TIME_LIMITS.getOrDefault(req.examType(), 30 * 60);
        Instant now = Instant.now();

        ExamSession session = ExamSession.builder()
            .userId(userId)
            .examType(req.examType())
            .yearLevel(req.yearLevel())
            .domain(req.domain())
            .questionIds(questionIds)
            .startedAt(now)
            .expiresAt(now.plusSeconds(timeLimit))
            .timeLimitSeconds(timeLimit)
            .build();

        return sessionRepository.save(session);
    }

    // ─────────────────────────────────────────────────────────────
    // Admin-created exam flow
    // ─────────────────────────────────────────────────────────────

    @Transactional(readOnly = true)
    public List<AvailableExamResponse> getAvailableExams(UUID userId) {
        Exam.PackageTier userTier = resolveUserTier(userId);
        List<Exam> all = examRepository.findAllPublished();
        Instant now = Instant.now();

        // Filter by student's year level (if set on their profile)
        Integer userYearLevel = userRepository.findByIdWithProfile(userId)
            .map(u -> u.getProfile() != null ? u.getProfile().getYearLevel() : null)
            .orElse(null);

        return all.stream()
            .filter(exam -> userYearLevel == null || exam.getYearLevel() == null || exam.getYearLevel().equals(userYearLevel))
            .map(exam -> {
            int qCount = examQuestionRepository.findByExamIdOrdered(exam.getId()).size();
            if (qCount == 0) return null;  // skip exams with no questions
            boolean attempted = sessionRepository.existsByUserIdAndExamIdAndStatus(
                userId, exam.getId(), ExamSession.SessionStatus.SUBMITTED);

            UUID completedSessionId = null;
            if (attempted) {
                completedSessionId = sessionRepository
                    .findByUserIdAndExamIdAndStatus(userId, exam.getId(), ExamSession.SessionStatus.SUBMITTED)
                    .map(ExamSession::getId).orElse(null);
            }

            String availability = computeAvailability(exam, userTier, now);
            return new AvailableExamResponse(
                exam.getId(), exam.getTitle(), exam.getDescription(),
                exam.getDomain(), exam.getYearLevel(), exam.getTimeLimitSeconds(),
                exam.getAvailableFrom(), exam.getAvailableUntil(),
                qCount, exam.getPackageTier(), availability,
                attempted, completedSessionId
            );
        }).filter(java.util.Objects::nonNull).toList();
    }

    @Transactional
    public Map<String, Object> startAdminExam(UUID examId, UUID userId) {
        Exam exam = examRepository.findById(examId)
            .orElseThrow(() -> new ResourceNotFoundException("Exam", examId.toString()));

        if (exam.getStatus() != Exam.ExamStatus.PUBLISHED) {
            throw new BusinessException("Exam is not available");
        }

        // Entitlement check
        Exam.PackageTier userTier = resolveUserTier(userId);
        if (!userTier.satisfies(exam.getPackageTier())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                "Upgrade to " + exam.getPackageTier() + " to access this exam");
        }

        // Time window check
        Instant now = Instant.now();
        if (exam.getAvailableFrom() != null && now.isBefore(exam.getAvailableFrom())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                "Exam not yet open. Opens at " + exam.getAvailableFrom());
        }
        if (exam.getAvailableUntil() != null && now.isAfter(exam.getAvailableUntil())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                "Exam window has closed");
        }

        // One-attempt enforcement
        if (sessionRepository.existsByUserIdAndExamIdAndStatus(
                userId, examId, ExamSession.SessionStatus.SUBMITTED)) {
            ExamSession prev = sessionRepository
                .findByUserIdAndExamIdAndStatus(userId, examId, ExamSession.SessionStatus.SUBMITTED)
                .orElseThrow();
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                "You have already completed this exam. Session: " + prev.getId());
        }

        List<ExamQuestion> examQuestions = examQuestionRepository.findByExamIdOrdered(examId);
        if (examQuestions.isEmpty()) {
            throw new BusinessException("This exam has no questions assigned yet");
        }

        List<UUID> questionIds = examQuestions.stream()
            .map(eq -> eq.getQuestion().getId()).toList();

        ExamSession session = ExamSession.builder()
            .userId(userId)
            .examId(examId)
            .examType(ExamSession.ExamType.MOCK)
            .yearLevel(exam.getYearLevel())
            .domain(exam.getDomain())
            .questionIds(questionIds)
            .startedAt(now)
            .expiresAt(now.plusSeconds(exam.getTimeLimitSeconds()))
            .timeLimitSeconds(exam.getTimeLimitSeconds())
            .build();

        ExamSession saved = sessionRepository.save(session);

        List<QuestionSummary> questions = examQuestions.stream().map(eq -> {
            Question q = eq.getQuestion();
            return new QuestionSummary(q.getId(), eq.getQuestionOrder(),
                q.getQuestionType(), q.getQuestionText(), q.getStimulusText(),
                q.getOptions(), q.getTopic(), q.getDifficultyBand());
        }).toList();

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("sessionId", saved.getId());
        result.put("examId", examId);
        result.put("examTitle", exam.getTitle());
        result.put("startedAt", saved.getStartedAt());
        result.put("expiresAt", saved.getExpiresAt());
        result.put("timeLimitSeconds", saved.getTimeLimitSeconds());
        result.put("status", saved.getStatus());
        result.put("questions", questions);
        return result;
    }

    // ─────────────────────────────────────────────────────────────
    // Shared session operations
    // ─────────────────────────────────────────────────────────────

    public ExamSession getSession(UUID sessionId, UUID userId) {
        ExamSession session = sessionRepository.findById(sessionId)
            .orElseThrow(() -> new ResourceNotFoundException("ExamSession", sessionId.toString()));
        if (!session.getUserId().equals(userId)) throw new BusinessException("Access denied");
        if (session.getStatus() == ExamSession.SessionStatus.IN_PROGRESS
                && Instant.now().isAfter(session.getExpiresAt())) {
            session.setStatus(ExamSession.SessionStatus.TIMED_OUT);
            session.setSubmittedAt(Instant.now());
            sessionRepository.save(session);
            calculateAndSaveResult(session);
        }
        return session;
    }

    /** Returns ordered questions for a session — used by the exam player. */
    @Transactional(readOnly = true)
    public List<QuestionSummary> getSessionQuestions(UUID sessionId, UUID userId) {
        ExamSession session = getSession(sessionId, userId);

        if (session.getExamId() != null) {
            // Admin exam: questions in defined order
            return examQuestionRepository.findByExamIdOrdered(session.getExamId()).stream()
                .map(eq -> {
                    Question q = eq.getQuestion();
                    return new QuestionSummary(q.getId(), eq.getQuestionOrder(),
                        q.getQuestionType(), q.getQuestionText(), q.getStimulusText(),
                        q.getOptions(), q.getTopic(), q.getDifficultyBand());
                }).toList();
        }

        // Practice: questions in the shuffled order stored in questionIds
        List<UUID> ids = session.getQuestionIds();
        Map<UUID, Question> qMap = questionRepository.findAllById(ids).stream()
            .collect(Collectors.toMap(Question::getId, q -> q));
        List<QuestionSummary> summaries = new ArrayList<>();
        for (int i = 0; i < ids.size(); i++) {
            Question q = qMap.get(ids.get(i));
            if (q != null) {
                summaries.add(new QuestionSummary(q.getId(), i + 1, q.getQuestionType(),
                    q.getQuestionText(), q.getStimulusText(), q.getOptions(),
                    q.getTopic(), q.getDifficultyBand()));
            }
        }
        return summaries;
    }

    @Transactional
    public ExamAnswer submitAnswer(UUID sessionId, UUID userId, UUID questionId,
                                   Map<String, Object> answer, Boolean flagged) {
        ExamSession session = getSession(sessionId, userId);
        if (session.getStatus() != ExamSession.SessionStatus.IN_PROGRESS) {
            throw new BusinessException("Session is not in progress");
        }
        if (!session.getQuestionIds().contains(questionId)) {
            throw new BusinessException("Question not in this session");
        }
        Question question = questionRepository.findById(questionId)
            .orElseThrow(() -> new ResourceNotFoundException("Question", questionId.toString()));
        boolean correct = checkAnswer(question, answer);

        ExamAnswer existing = answerRepository.findBySessionIdAndQuestionId(sessionId, questionId).orElse(null);
        if (existing != null) {
            existing.setAnswer(answer);
            existing.setCorrect(correct);
            if (flagged != null) existing.setFlagged(flagged);
            return answerRepository.save(existing);
        }
        return answerRepository.save(ExamAnswer.builder()
            .sessionId(sessionId).questionId(questionId)
            .answer(answer).correct(correct)
            .flagged(flagged != null ? flagged : false)
            .build());
    }

    @Transactional
    public ExamResultDetailResponse submitExam(UUID sessionId, UUID userId) {
        ExamSession session = getSession(sessionId, userId);
        if (session.getStatus() != ExamSession.SessionStatus.IN_PROGRESS) {
            // Already submitted — return existing result
            return buildDetailedResult(session);
        }
        session.setStatus(ExamSession.SessionStatus.SUBMITTED);
        session.setSubmittedAt(Instant.now());
        sessionRepository.save(session);
        calculateAndSaveResult(session);
        return buildDetailedResult(session);
    }

    public ExamResultDetailResponse getDetailedResult(UUID sessionId, UUID userId) {
        ExamSession session = sessionRepository.findById(sessionId)
            .orElseThrow(() -> new ResourceNotFoundException("ExamSession", sessionId.toString()));
        if (!session.getUserId().equals(userId)) throw new BusinessException("Access denied");
        return buildDetailedResult(session);
    }

    public ExamResult getResult(UUID sessionId, UUID userId) {
        ExamSession session = sessionRepository.findById(sessionId)
            .orElseThrow(() -> new ResourceNotFoundException("ExamSession", sessionId.toString()));
        if (!session.getUserId().equals(userId)) throw new BusinessException("Access denied");
        return resultRepository.findBySessionId(sessionId)
            .orElseThrow(() -> new ResourceNotFoundException("ExamResult", sessionId.toString()));
    }

    public Page<ExamSession> getHistory(UUID userId, Pageable pageable) {
        return sessionRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
    }

    // ─────────────────────────────────────────────────────────────
    // Private helpers
    // ─────────────────────────────────────────────────────────────

    private ExamResultDetailResponse buildDetailedResult(ExamSession session) {
        ExamResult storedResult = resultRepository.findBySessionId(session.getId()).orElse(null);

        List<ExamAnswer> answers = answerRepository.findBySessionId(session.getId());
        List<UUID> questionIds = session.getQuestionIds();
        Map<UUID, Question> qMap = questionRepository.findAllById(questionIds).stream()
            .collect(Collectors.toMap(Question::getId, q -> q));
        Map<UUID, ExamAnswer> answerMap = answers.stream()
            .collect(Collectors.toMap(ExamAnswer::getQuestionId, a -> a));

        // Build question ordering (from exam_questions if admin exam, else from questionIds order)
        List<QuestionSummary> orderedSummaries;
        if (session.getExamId() != null) {
            orderedSummaries = examQuestionRepository.findByExamIdOrdered(session.getExamId()).stream()
                .map(eq -> new QuestionSummary(eq.getQuestion().getId(), eq.getQuestionOrder(),
                    eq.getQuestion().getQuestionType(), eq.getQuestion().getQuestionText(),
                    eq.getQuestion().getStimulusText(), eq.getQuestion().getOptions(),
                    eq.getQuestion().getTopic(), eq.getQuestion().getDifficultyBand()))
                .toList();
        } else {
            orderedSummaries = new ArrayList<>();
            for (int i = 0; i < questionIds.size(); i++) {
                Question q = qMap.get(questionIds.get(i));
                if (q != null) {
                    orderedSummaries.add(new QuestionSummary(q.getId(), i + 1,
                        q.getQuestionType(), q.getQuestionText(), q.getStimulusText(),
                        q.getOptions(), q.getTopic(), q.getDifficultyBand()));
                }
            }
        }

        List<ExamResultDetailResponse.QuestionReview> reviews = orderedSummaries.stream().map(qs -> {
            Question q = qMap.get(qs.id());
            ExamAnswer ans = answerMap.get(qs.id());
            String studentAnswer = ans != null && ans.getAnswer() != null
                ? Objects.toString(ans.getAnswer().get("value"), null) : null;
            String correctAnswer = q != null && q.getCorrectAnswer() != null
                ? Objects.toString(q.getCorrectAnswer().get("value"), null) : null;
            boolean correct = ans != null && Boolean.TRUE.equals(ans.getCorrect());
            return new ExamResultDetailResponse.QuestionReview(
                qs.questionOrder(), qs.id(), qs.questionText(), qs.stimulusText(),
                qs.options(), studentAnswer, correctAnswer, correct,
                q != null ? q.getExplanation() : null,
                ans != null ? ans.getTimeTakenSeconds() : null
            );
        }).toList();

        // Topic breakdown
        Map<String, ExamResultDetailResponse.TopicScore> domainScores = new LinkedHashMap<>();
        for (QuestionSummary qs : orderedSummaries) {
            Question q = qMap.get(qs.id());
            if (q == null) continue;
            String topic = q.getTopic();
            ExamAnswer ans = answerMap.get(qs.id());
            boolean correct = ans != null && Boolean.TRUE.equals(ans.getCorrect());
            domainScores.merge(topic,
                new ExamResultDetailResponse.TopicScore(correct ? 1 : 0, 1, 0),
                (a, b) -> new ExamResultDetailResponse.TopicScore(
                    a.correct() + b.correct(), a.total() + b.total(), 0));
        }
        // Compute percentages
        domainScores.replaceAll((k, v) ->
            new ExamResultDetailResponse.TopicScore(v.correct(), v.total(),
                v.total() > 0 ? (v.correct() * 100.0 / v.total()) : 0));

        int total = storedResult != null ? storedResult.getTotalQuestions() : questionIds.size();
        int correct = storedResult != null ? storedResult.getCorrectAnswers()
            : (int) answers.stream().filter(a -> Boolean.TRUE.equals(a.getCorrect())).count();
        double pct = storedResult != null ? storedResult.getScorePercentage()
            : (total > 0 ? correct * 100.0 / total : 0);
        int band = storedResult != null ? storedResult.getNaplanBand() : calculateNaplanBand(pct);

        Long timeTaken = (session.getStartedAt() != null && session.getSubmittedAt() != null)
            ? session.getSubmittedAt().getEpochSecond() - session.getStartedAt().getEpochSecond()
            : null;

        String examTitle = null;
        if (session.getExamId() != null) {
            examTitle = examRepository.findById(session.getExamId())
                .map(Exam::getTitle).orElse(null);
        }

        return new ExamResultDetailResponse(
            session.getId(), session.getExamId(), examTitle,
            session.getStartedAt(), session.getSubmittedAt(), timeTaken,
            total, correct, pct, band, domainScores, reviews
        );
    }

    private ExamResult calculateAndSaveResult(ExamSession session) {
        if (resultRepository.findBySessionId(session.getId()).isPresent()) {
            return resultRepository.findBySessionId(session.getId()).get();
        }
        List<ExamAnswer> answers = answerRepository.findBySessionId(session.getId());
        int total = session.getQuestionIds().size();
        long correct = answers.stream().filter(a -> Boolean.TRUE.equals(a.getCorrect())).count();
        double score = total > 0 ? (correct * 100.0) / total : 0;
        int band = calculateNaplanBand(score);

        Map<String, Object> domainBreakdown = new HashMap<>();
        Map<String, Object> topicBreakdown = new HashMap<>();
        List<UUID> qIds = answers.stream().map(ExamAnswer::getQuestionId).toList();
        Map<UUID, Question> qMap = questionRepository.findAllById(qIds).stream()
            .collect(Collectors.toMap(Question::getId, q -> q));
        for (ExamAnswer a : answers) {
            Question q = qMap.get(a.getQuestionId());
            if (q == null) continue;
            String domain = q.getDomain().name();
            String topic = q.getTopic();
            domainBreakdown.merge(domain + "_total", 1, (x, y) -> (int) x + (int) y);
            if (Boolean.TRUE.equals(a.getCorrect()))
                domainBreakdown.merge(domain + "_correct", 1, (x, y) -> (int) x + (int) y);
            topicBreakdown.merge(topic + "_total", 1, (x, y) -> (int) x + (int) y);
            if (Boolean.TRUE.equals(a.getCorrect()))
                topicBreakdown.merge(topic + "_correct", 1, (x, y) -> (int) x + (int) y);
        }
        return resultRepository.save(ExamResult.builder()
            .sessionId(session.getId()).userId(session.getUserId())
            .totalQuestions(total).correctAnswers((int) correct)
            .scorePercentage(score).naplanBand(band)
            .domainBreakdown(domainBreakdown).topicBreakdown(topicBreakdown)
            .build());
    }

    private Exam.PackageTier resolveUserTier(UUID userId) {
        return subscriptionRepository.findFirstByUserIdAndStatusInOrderByCreatedAtDesc(
                userId, List.of(Subscription.SubscriptionStatus.ACTIVE, Subscription.SubscriptionStatus.TRIALING))
            .map(sub -> {
                String name = sub.getPlan().getName().toUpperCase();
                try { return Exam.PackageTier.valueOf(name); }
                catch (Exception e) { return Exam.PackageTier.FREE; }
            })
            .orElse(Exam.PackageTier.FREE);
    }

    private String computeAvailability(Exam exam, Exam.PackageTier userTier, Instant now) {
        if (!userTier.satisfies(exam.getPackageTier())) return "UPGRADE_REQUIRED";
        if (exam.getAvailableFrom() != null && now.isBefore(exam.getAvailableFrom())) return "UPCOMING";
        if (exam.getAvailableUntil() != null && now.isAfter(exam.getAvailableUntil())) return "EXPIRED";
        return "AVAILABLE";
    }

    private boolean checkAnswer(Question question, Map<String, Object> answer) {
        if (question.getCorrectAnswer() == null || answer == null) return false;
        Object expected = question.getCorrectAnswer().get("value");
        Object given = answer.get("value");
        if (expected == null || given == null) return false;
        return expected.toString().equalsIgnoreCase(given.toString());
    }

    private int calculateNaplanBand(double score) {
        if (score >= 90) return 10;
        if (score >= 80) return 9;
        if (score >= 70) return 8;
        if (score >= 60) return 7;
        if (score >= 50) return 6;
        if (score >= 40) return 5;
        if (score >= 30) return 4;
        if (score >= 20) return 3;
        if (score >= 10) return 2;
        return 1;
    }
}
