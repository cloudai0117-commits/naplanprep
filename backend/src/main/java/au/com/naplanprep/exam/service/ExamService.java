package au.com.naplanprep.exam.service;

import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.exam.dto.*;
import au.com.naplanprep.exam.entity.*;
import au.com.naplanprep.exam.repository.*;
import au.com.naplanprep.auth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    private final UserRepository userRepository;

    // ─────────────────────────────────────────────────────────────
    // Practice / ad-hoc sessions (existing flow)
    // ─────────────────────────────────────────────────────────────

    @Transactional
    public ExamSession startExam(UUID userId, StartExamRequest req) {
        int count = req.resolvedQuestionCount();
        Question.Domain domain = req.domain() != null ? req.domain() : Question.Domain.NUMERACY;
        org.springframework.data.domain.Pageable pageable =
            org.springframework.data.domain.PageRequest.of(0, count);

        List<Question> questions;
        if (req.examType() == ExamSession.ExamType.PRACTICE) {
            List<UUID> seenIds = answerRepository.findSeenQuestionIdsByUserId(userId);
            if (!seenIds.isEmpty()) {
                questions = questionRepository.findUnseenRandom(req.yearLevel(), domain, seenIds, pageable);
                if (questions.size() < count) {
                    questions = questionRepository.findRandomByYearLevelAndDomain(req.yearLevel(), domain, pageable);
                }
            } else {
                questions = questionRepository.findRandomByYearLevelAndDomain(req.yearLevel(), domain, pageable);
            }
        } else {
            questions = questionRepository.findRandomByYearLevelAndDomain(req.yearLevel(), domain, pageable);
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
        Set<PackageType> userPackages = resolveUserPackages(userId);
        List<Exam> all = examRepository.findAllPublished();
        Instant now = Instant.now();

        Integer userYearLevel = userRepository.findByIdWithProfile(userId)
            .map(u -> u.getProfile() != null ? u.getProfile().getYearLevel() : null)
            .orElse(null);

        List<Exam> filtered = all.stream()
            .filter(exam -> userYearLevel == null || exam.getYearLevel() == null
                || exam.getYearLevel().equals(userYearLevel))
            .toList();

        if (filtered.isEmpty()) return List.of();

        // Batch fetch question counts — one query for all exams instead of N queries
        List<UUID> examIds = filtered.stream().map(Exam::getId).toList();
        Map<UUID, Long> qCounts = examQuestionRepository.countByExamIds(examIds).stream()
            .collect(Collectors.toMap(row -> (UUID) row[0], row -> (Long) row[1]));

        // Batch fetch all SUBMITTED sessions for this user — one query instead of N
        Map<UUID, UUID> submittedSessionIdByExamId = sessionRepository
            .findSubmittedByUserIdAndExamIds(userId, examIds).stream()
            .collect(Collectors.toMap(ExamSession::getExamId, ExamSession::getId));

        return filtered.stream()
            .filter(exam -> qCounts.getOrDefault(exam.getId(), 0L) > 0)
            .map(exam -> {
                int qCount = qCounts.getOrDefault(exam.getId(), 0L).intValue();
                boolean attempted = submittedSessionIdByExamId.containsKey(exam.getId());
                UUID completedSessionId = submittedSessionIdByExamId.get(exam.getId());
                String availability = computeAvailability(exam, userPackages, now);
                return new AvailableExamResponse(
                    exam.getId(), exam.getTitle(), exam.getDescription(),
                    exam.getDomain(), exam.getYearLevel(), exam.getTimeLimitSeconds(),
                    exam.getAvailableFrom(), exam.getAvailableUntil(),
                    qCount, exam.getPackageType(), availability,
                    attempted, completedSessionId
                );
            }).toList();
    }

    @Transactional
    public Map<String, Object> startAdminExam(UUID examId, UUID userId) {
        Exam exam = examRepository.findById(examId)
            .orElseThrow(() -> new ResourceNotFoundException("Exam", examId.toString()));

        if (exam.getStatus() != Exam.ExamStatus.PUBLISHED) {
            throw new BusinessException("Exam is not available");
        }

        Set<PackageType> userPackages = resolveUserPackages(userId);
        if (!userPackages.contains(exam.getPackageType())) {
            throw new AccessDeniedException("Upgrade to " + exam.getPackageType() + " to access this exam");
        }

        Instant now = Instant.now();
        if (exam.getAvailableFrom() != null && now.isBefore(exam.getAvailableFrom())) {
            throw new BusinessException("Exam not yet open. Opens at " + exam.getAvailableFrom());
        }
        if (exam.getAvailableUntil() != null && now.isAfter(exam.getAvailableUntil())) {
            throw new BusinessException("Exam window has closed");
        }

        if (sessionRepository.existsByUserIdAndExamIdAndStatus(
                userId, examId, ExamSession.SessionStatus.SUBMITTED)) {
            throw new BusinessException("You have already completed this exam");
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
        if (!session.getUserId().equals(userId)) throw new AccessDeniedException("Access denied");
        if (session.getStatus() == ExamSession.SessionStatus.IN_PROGRESS
                && Instant.now().isAfter(session.getExpiresAt())) {
            session.setStatus(ExamSession.SessionStatus.TIMED_OUT);
            session.setSubmittedAt(Instant.now());
            sessionRepository.save(session);
            calculateAndSaveResult(session);
        }
        return session;
    }

    @Transactional(readOnly = true)
    public List<QuestionSummary> getSessionQuestions(UUID sessionId, UUID userId) {
        ExamSession session = getSession(sessionId, userId);

        if (session.getExamId() != null) {
            return examQuestionRepository.findByExamIdOrdered(session.getExamId()).stream()
                .map(eq -> {
                    Question q = eq.getQuestion();
                    return new QuestionSummary(q.getId(), eq.getQuestionOrder(),
                        q.getQuestionType(), q.getQuestionText(), q.getStimulusText(),
                        q.getOptions(), q.getTopic(), q.getDifficultyBand());
                }).toList();
        }

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

    /** Returns all saved answers for a session — used to restore state after disconnect/refresh. */
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getSessionAnswers(UUID sessionId, UUID userId) {
        ExamSession session = sessionRepository.findById(sessionId)
            .orElseThrow(() -> new ResourceNotFoundException("ExamSession", sessionId.toString()));
        if (!session.getUserId().equals(userId)) throw new AccessDeniedException("Access denied");

        return answerRepository.findBySessionId(sessionId).stream()
            .map(a -> {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("questionId", a.getQuestionId());
                m.put("answer", a.getAnswer());
                m.put("flagged", a.getFlagged());
                m.put("timeTakenSeconds", a.getTimeTakenSeconds());
                return m;
            }).toList();
    }

    @Transactional
    public ExamAnswer submitAnswer(UUID sessionId, UUID userId, UUID questionId,
                                   Map<String, Object> answer, Boolean flagged, Integer timeTakenSeconds) {
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
            if (timeTakenSeconds != null) existing.setTimeTakenSeconds(timeTakenSeconds);
            return answerRepository.save(existing);
        }
        return answerRepository.save(ExamAnswer.builder()
            .sessionId(sessionId).questionId(questionId)
            .answer(answer).correct(correct)
            .flagged(flagged != null ? flagged : false)
            .timeTakenSeconds(timeTakenSeconds)
            .build());
    }

    @Transactional
    public ExamResultDetailResponse submitExam(UUID sessionId, UUID userId) {
        ExamSession session = getSession(sessionId, userId);
        if (session.getStatus() != ExamSession.SessionStatus.IN_PROGRESS) {
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
        if (!session.getUserId().equals(userId)) throw new AccessDeniedException("Access denied");
        return buildDetailedResult(session);
    }

    public ExamResult getResult(UUID sessionId, UUID userId) {
        ExamSession session = sessionRepository.findById(sessionId)
            .orElseThrow(() -> new ResourceNotFoundException("ExamSession", sessionId.toString()));
        if (!session.getUserId().equals(userId)) throw new AccessDeniedException("Access denied");
        return resultRepository.findBySessionId(sessionId)
            .orElseThrow(() -> new ResourceNotFoundException("ExamResult", sessionId.toString()));
    }

    public Page<ExamSession> getHistory(UUID userId, Pageable pageable) {
        return sessionRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
    }

    // ─────────────────────────────────────────────────────────────
    // Background: expire overdue sessions every 60 seconds
    // ─────────────────────────────────────────────────────────────

    @Scheduled(fixedDelay = 60_000)
    public void expireOverdueSessions() {
        List<ExamSession> expired = sessionRepository.findByStatusAndExpiresAtBefore(
            ExamSession.SessionStatus.IN_PROGRESS, Instant.now());
        for (ExamSession session : expired) {
            try {
                session.setStatus(ExamSession.SessionStatus.TIMED_OUT);
                session.setSubmittedAt(Instant.now());
                sessionRepository.save(session);
                calculateAndSaveResult(session);
            } catch (Exception e) {
                log.warn("Failed to expire session {}: {}", session.getId(), e.getMessage());
            }
        }
        if (!expired.isEmpty()) {
            log.info("Expired {} overdue exam sessions", expired.size());
        }
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
        Optional<ExamResult> existing = resultRepository.findBySessionId(session.getId());
        if (existing.isPresent()) {
            return existing.get();
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

    private Set<PackageType> resolveUserPackages(UUID userId) {
        return userRepository.findById(userId)
            .map(User::getTags)
            .filter(tags -> tags != null && !tags.isEmpty())
            .orElse(Set.of(PackageType.FREE));
    }

    private String computeAvailability(Exam exam, Set<PackageType> userPackages, Instant now) {
        if (!userPackages.contains(exam.getPackageType())) return "UPGRADE_REQUIRED";
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
