package au.com.naplanprep.exam.service;

import au.com.naplanprep.audit.entity.AuditLog;
import au.com.naplanprep.audit.service.AuditLogService;
import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.exam.dto.*;
import au.com.naplanprep.exam.entity.*;
import au.com.naplanprep.exam.repository.*;
import au.com.naplanprep.exam.service.scoring.ScoringStrategy;
import au.com.naplanprep.exam.service.scoring.ScoringStrategyFactory;
import au.com.naplanprep.auth.repository.UserRepository;
import au.com.naplanprep.exam.repository.TestletRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
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
    private final SessionQuestionSnapshotRepository snapshotRepository;
    private final PracticeScoreBandRepository scoreBandRepository;
    private final ExamSnapshotService snapshotService;
    private final ScoringStrategyFactory scoringFactory;
    private final AuditLogService auditLogService;
    private final BranchingEngine branchingEngine;
    private final TestletRepository testletRepository;

    // ─────────────────────────────────────────────────────────────
    // Practice / ad-hoc sessions
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
        long seed = now.toEpochMilli() ^ userId.getLeastSignificantBits();

        ExamSession session = ExamSession.builder()
            .userId(userId)
            .examType(req.examType())
            .yearLevel(req.yearLevel())
            .domain(req.domain())
            .questionIds(questionIds)
            .startedAt(now)
            .expiresAt(now.plusSeconds(timeLimit))
            .timeLimitSeconds(timeLimit)
            .randomisationSeed(seed)
            .currentQuestionOrder(1)
            .answerCount(0)
            .hasSnapshot(false)
            .build();

        ExamSession saved = sessionRepository.save(session);
        auditLogService.log(AuditLog.EXAM_STARTED, userId, saved.getId(),
            "type=" + req.examType() + " domain=" + domain + " questions=" + questionIds.size());
        return saved;
    }

    // ─────────────────────────────────────────────────────────────
    // Admin-created exam flow — idempotent start
    // ─────────────────────────────────────────────────────────────

    @Transactional
    public Map<String, Object> startAdminExam(UUID examId, UUID userId) {
        // Idempotent: return existing IN_PROGRESS session if one exists.
        // The DB partial unique index (uq_user_exam_inprogress) guarantees at most one.
        Optional<ExamSession> existing = sessionRepository.findByUserIdAndExamIdAndStatus(
            userId, examId, ExamSession.SessionStatus.IN_PROGRESS);
        if (existing.isPresent()) {
            ExamSession resume = existing.get();
            auditLogService.log(AuditLog.EXAM_RESUMED, userId, resume.getId(), "idempotent-start");
            return buildStartResponse(resume, examId);
        }

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
            .randomisationSeed(now.toEpochMilli() ^ userId.getLeastSignificantBits())
            .currentQuestionOrder(1)
            .answerCount(0)
            .hasSnapshot(false)
            .build();

        ExamSession saved = sessionRepository.save(session);

        // Write immutable snapshots before returning — any future reads use snapshots only
        snapshotService.createSnapshots(saved);

        // For branching/testlet exams, set the initial testlet so only that testlet's
        // questions are returned to the student (not the entire pooled question set).
        // The initial testlet is determined from the first snapshot (lowest questionOrder).
        List<SessionQuestionSnapshot> allSnaps =
            snapshotRepository.findByIdSessionIdOrderByQuestionOrder(saved.getId());
        if (!allSnaps.isEmpty() && allSnaps.get(0).getTestletId() != null) {
            UUID initialTestletId = allSnaps.get(0).getTestletId();
            saved.setCurrentTestletId(initialTestletId);
            saved.setQuestionPath(new ArrayList<>(List.of(initialTestletId)));
        }

        sessionRepository.save(saved); // persist hasSnapshot = true + currentTestletId + questionPath

        auditLogService.log(AuditLog.EXAM_STARTED, userId, saved.getId(),
            "examId=" + examId + " questions=" + questionIds.size());

        return buildStartResponse(saved, examId);
    }

    private Map<String, Object> buildStartResponse(ExamSession session, UUID examId) {
        // For branching exams, return only the initial testlet's questions.
        // Returning all snapshots (all testlets) would expose the full question pool
        // and show incorrect "Question 1 of 128" instead of "Question 1 of 16".
        List<SessionQuestionSnapshot> snaps = (session.getCurrentTestletId() != null)
            ? snapshotRepository.findByIdSessionIdAndTestletIdOrderByQuestionOrder(
                session.getId(), session.getCurrentTestletId())
            : snapshotRepository.findByIdSessionIdOrderByQuestionOrder(session.getId());

        List<Map<String, Object>> questions = snaps.stream()
            .map(s -> studentView(s.getSnapshot(), s.getQuestionOrder()))
            .toList();

        Exam exam = examRepository.findById(examId).orElse(null);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("sessionId",       session.getId());
        result.put("examId",          examId);
        result.put("examTitle",       exam != null ? exam.getTitle() : null);
        result.put("startedAt",       session.getStartedAt());
        result.put("expiresAt",       session.getExpiresAt());
        result.put("timeLimitSeconds",session.getTimeLimitSeconds());
        result.put("status",          session.getStatus());
        result.put("answerCount",     session.getAnswerCount());
        result.put("currentQuestion", session.getCurrentQuestionOrder());
        result.put("questions",       questions);
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
                && session.getExpiresAt() != null
                && Instant.now().isAfter(session.getExpiresAt())) {
            session.setStatus(ExamSession.SessionStatus.TIMED_OUT);
            session.setSubmittedAt(Instant.now());
            sessionRepository.save(session);
            calculateAndSaveResult(session);
            auditLogService.log(AuditLog.EXAM_TIMED_OUT, userId, sessionId);
        }
        return session;
    }

    @Transactional(readOnly = true)
    public List<QuestionSummary> getSessionQuestions(UUID sessionId, UUID userId) {
        ExamSession session = getSession(sessionId, userId);

        // Snapshot path (admin exams with snapshots)
        if (Boolean.TRUE.equals(session.getHasSnapshot())) {
            // For branching exams, return only the current testlet's questions.
            // The full pool spans all testlets; only the active testlet is shown to the student.
            List<SessionQuestionSnapshot> snaps = (session.getCurrentTestletId() != null)
                ? snapshotRepository.findByIdSessionIdAndTestletIdOrderByQuestionOrder(
                    sessionId, session.getCurrentTestletId())
                : snapshotRepository.findByIdSessionIdOrderByQuestionOrder(sessionId);
            return snaps.stream().map(s -> snapshotToQuestionSummary(s)).toList();
        }

        // Flat path (practice sessions without snapshots)
        if (session.getExamId() != null) {
            return examQuestionRepository.findByExamIdOrdered(session.getExamId()).stream()
                .map(eq -> {
                    Question q = eq.getQuestion();
                    return new QuestionSummary(q.getId(), eq.getQuestionOrder(),
                        q.getQuestionType(), q.getQuestionText(), q.getStimulusText(),
                        q.getOptions(), q.getTopic(), q.getDifficultyBand(),
                        q.getCalculatorAllowed(), q.getAudioUrl(),
                        q.getDomain() != null ? q.getDomain().name() : null);
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
                    q.getTopic(), q.getDifficultyBand(), q.getCalculatorAllowed(),
                    q.getAudioUrl(), q.getDomain() != null ? q.getDomain().name() : null));
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
                m.put("answer",     a.getAnswer());
                m.put("flagged",    a.getFlagged());
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

        Boolean correct = scoreAnswer(session, questionId, answer);

        ExamAnswer existing = answerRepository.findBySessionIdAndQuestionId(sessionId, questionId).orElse(null);
        final ExamAnswer saved;
        if (existing != null) {
            existing.setAnswer(answer);
            existing.setCorrect(correct);
            if (flagged != null) existing.setFlagged(flagged);
            if (timeTakenSeconds != null) existing.setTimeTakenSeconds(timeTakenSeconds);
            saved = answerRepository.save(existing);
        } else {
            saved = answerRepository.save(ExamAnswer.builder()
                .sessionId(sessionId).questionId(questionId)
                .answer(answer).correct(correct)
                .flagged(flagged != null ? flagged : false)
                .timeTakenSeconds(timeTakenSeconds)
                .build());
            // Increment cached answer count on the session
            session.setAnswerCount(session.getAnswerCount() + 1);
            sessionRepository.save(session);
        }

        auditLogService.log(AuditLog.ANSWER_SAVED, userId, sessionId,
            "questionId=" + questionId + " correct=" + correct);
        return saved;
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
        auditLogService.log(AuditLog.EXAM_SUBMITTED, userId, sessionId);
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

    /**
     * Called when the student completes a testlet and is ready to advance.
     *
     * 1. Calculates the score ratio for the completed testlet.
     * 2. Evaluates branching transitions (data-driven via testlet_transitions).
     * 3. Updates session navigation state: currentTestletId, questionPath.
     * 4. Returns the next testlet ID, whether calculator is allowed, and the
     *    questions in the next testlet (stripped of server-only fields).
     *
     * If there is no next testlet (path ends), returns nextTestletId = null.
     * The client should then call POST /sessions/{id}/submit.
     */
    @Transactional
    public Map<String, Object> completeTestlet(UUID sessionId, UUID userId, UUID completedTestletId) {
        ExamSession session = getSession(sessionId, userId);

        if (session.getStatus() != ExamSession.SessionStatus.IN_PROGRESS) {
            throw new BusinessException("Session is not in progress");
        }
        if (!completedTestletId.equals(session.getCurrentTestletId())
                && session.getCurrentTestletId() != null) {
            throw new BusinessException("Testlet " + completedTestletId + " is not the current testlet");
        }

        // Enforce navigation lock: if the student has already passed this testlet, block return
        List<UUID> alreadyTraversed = session.getQuestionPath() != null ? session.getQuestionPath() : List.of();
        int completedIndex = alreadyTraversed.indexOf(completedTestletId);
        if (completedIndex >= 0 && completedIndex < alreadyTraversed.size() - 1) {
            // Testlet is in the path but NOT the last one — student is trying to re-complete
            Testlet pastTestlet = testletRepository.findById(completedTestletId).orElse(null);
            if (pastTestlet != null && Boolean.TRUE.equals(pastTestlet.getNavigationLocked())) {
                throw new BusinessException("This testlet is locked and cannot be resubmitted");
            }
        }

        // Calculate score ratio for the completed testlet
        List<SessionQuestionSnapshot> testletSnaps =
            snapshotRepository.findByIdSessionIdAndTestletIdOrderByQuestionOrder(sessionId, completedTestletId);

        int totalMarks  = testletSnaps.stream()
            .mapToInt(s -> {
                Object m = s.getSnapshot().get("marks");
                return m instanceof Number n ? n.intValue() : 1;
            }).sum();

        List<UUID> testletQuestionIds = testletSnaps.stream()
            .map(s -> s.getId().getQuestionId()).toList();

        long earnedMarks = answerRepository.findBySessionId(sessionId).stream()
            .filter(a -> testletQuestionIds.contains(a.getQuestionId()) && Boolean.TRUE.equals(a.getCorrect()))
            .mapToLong(a -> {
                // Get marks from snapshot
                return testletSnaps.stream()
                    .filter(s -> s.getId().getQuestionId().equals(a.getQuestionId()))
                    .mapToInt(s -> {
                        Object m = s.getSnapshot().get("marks");
                        return m instanceof Number n ? n.intValue() : 1;
                    }).findFirst().orElse(1);
            }).sum();

        double scoreRatio = totalMarks > 0 ? (double) earnedMarks / totalMarks : 0.0;

        // Evaluate branching
        Optional<UUID> nextTestletId = branchingEngine.resolveNext(completedTestletId, scoreRatio);

        // Update session navigation state
        nextTestletId.ifPresent(nextId -> {
            session.setCurrentTestletId(nextId);
            List<UUID> path = new ArrayList<>(session.getQuestionPath() != null ? session.getQuestionPath() : List.of());
            if (!path.contains(nextId)) path.add(nextId);
            session.setQuestionPath(path);
        });

        if (nextTestletId.isEmpty()) {
            // Path complete — do not auto-submit; client controls final submit
            session.setCurrentTestletId(null);
        }

        sessionRepository.save(session);
        auditLogService.log(AuditLog.TESTLET_TRANSITIONED, userId, sessionId,
            "from=" + completedTestletId + " to=" + nextTestletId.orElse(null) + " score=" + scoreRatio);

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("completedTestletId", completedTestletId);
        response.put("scoreRatioForTestlet", scoreRatio);
        response.put("nextTestletId", nextTestletId.orElse(null));
        response.put("pathComplete", nextTestletId.isEmpty());

        // If there is a next testlet, return its questions and calculator permission
        if (nextTestletId.isPresent()) {
            Testlet nextTestlet = testletRepository.findById(nextTestletId.get()).orElse(null);
            if (nextTestlet != null) {
                // Testlet-level calculator hint for the transition UI.
                // Per-question values in the questions array are authoritative —
                // clients must read calculatorAllowed from each question object.
                Boolean calcAllowed = nextTestlet.getCalculatorAllowed();
                if (calcAllowed == null) {
                    calcAllowed = nextTestlet.getSection().getCalculatorAllowed();
                }
                response.put("testletCalculatorAllowed", calcAllowed);
                response.put("navigationLocked", nextTestlet.getNavigationLocked());
                response.put("testletTitle", nextTestlet.getTitle());
                response.put("testletInstructions", nextTestlet.getInstructions());
            }

            List<SessionQuestionSnapshot> nextSnaps =
                snapshotRepository.findByIdSessionIdAndTestletIdOrderByQuestionOrder(sessionId, nextTestletId.get());
            List<Map<String, Object>> nextQuestions = nextSnaps.stream()
                .map(s -> studentView(s.getSnapshot(), s.getQuestionOrder()))
                .toList();
            response.put("questions", nextQuestions);
        }

        return response;
    }

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

        List<UUID> examIds = filtered.stream().map(Exam::getId).toList();
        Map<UUID, Long> qCounts = examQuestionRepository.countByExamIds(examIds).stream()
            .collect(Collectors.toMap(row -> (UUID) row[0], row -> (Long) row[1]));

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

    /** Toggle a question's flagged state for review. Persisted server-side. */
    @Transactional
    public void flagQuestion(UUID sessionId, UUID userId, UUID questionId, boolean flagged) {
        ExamSession session = getSession(sessionId, userId);
        if (session.getStatus() != ExamSession.SessionStatus.IN_PROGRESS) {
            throw new BusinessException("Session is not in progress");
        }
        List<UUID> flags = new ArrayList<>(
            session.getFlaggedQuestions() != null ? session.getFlaggedQuestions() : List.of());
        if (flagged && !flags.contains(questionId)) {
            flags.add(questionId);
        } else if (!flagged) {
            flags.remove(questionId);
        }
        session.setFlaggedQuestions(flags);
        sessionRepository.save(session);
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
                auditLogService.log(AuditLog.EXAM_TIMED_OUT, session.getUserId(), session.getId());
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

    /**
     * Score an answer using the strategy pattern.
     * For sessions with snapshots, correctAnswer comes from the snapshot (immutable).
     * For practice sessions, reads from the live question as a fallback.
     */
    private Boolean scoreAnswer(ExamSession session, UUID questionId, Map<String, Object> studentAnswer) {
        Map<String, Object> correctAnswer = null;
        Question.QuestionType questionType = null;
        int marks = 1;

        if (Boolean.TRUE.equals(session.getHasSnapshot())) {
            Optional<SessionQuestionSnapshot> snap =
                snapshotRepository.findByIdSessionIdAndIdQuestionId(session.getId(), questionId);
            if (snap.isPresent()) {
                Map<String, Object> snapshot = snap.get().getSnapshot();
                correctAnswer = (Map<String, Object>) snapshot.get("correctAnswer");
                String typeStr = (String) snapshot.get("questionType");
                if (typeStr != null) questionType = Question.QuestionType.valueOf(typeStr);
                Object m = snapshot.get("marks");
                if (m instanceof Number n) marks = n.intValue();
            }
        } else {
            Question q = questionRepository.findById(questionId).orElse(null);
            if (q != null) {
                correctAnswer = q.getCorrectAnswer();
                questionType = q.getQuestionType();
                marks = q.getMarks() != null ? q.getMarks() : 1;
            }
        }

        if (correctAnswer == null || questionType == null || studentAnswer == null) {
            return false;
        }

        ScoringStrategy strategy = scoringFactory.forType(questionType);
        return strategy.score(studentAnswer, correctAnswer, marks);
    }

    private ExamResult calculateAndSaveResult(ExamSession session) {
        Optional<ExamResult> existing = resultRepository.findBySessionId(session.getId());
        if (existing.isPresent()) {
            return existing.get();
        }

        List<ExamAnswer> answers = answerRepository.findBySessionId(session.getId());
        int total = session.getQuestionIds().size();
        long correctCount = answers.stream().filter(a -> Boolean.TRUE.equals(a.getCorrect())).count();
        double score = total > 0 ? (correctCount * 100.0) / total : 0;

        // Practice score band lookup — NOT NAPLAN band
        String domain = session.getDomain() != null ? session.getDomain().name() : null;
        Integer yearLevel = session.getYearLevel();
        int bandNumber = 1;
        String bandLabel = "Foundation Level 1";

        if (domain != null && yearLevel != null) {
            Optional<PracticeScoreBand> band = scoreBandRepository.findBand(
                yearLevel, domain, BigDecimal.valueOf(score));
            if (band.isPresent()) {
                bandNumber = band.get().getBand();
                bandLabel  = band.get().getLabel();
            }
        }

        Map<String, Object> domainBreakdown = new HashMap<>();
        Map<String, Object> topicBreakdown  = new HashMap<>();
        List<UUID> qIds = answers.stream().map(ExamAnswer::getQuestionId).toList();
        Map<UUID, Question> qMap = questionRepository.findAllById(qIds).stream()
            .collect(Collectors.toMap(Question::getId, q -> q));

        for (ExamAnswer a : answers) {
            Question q = qMap.get(a.getQuestionId());
            if (q == null) continue;
            String d = q.getDomain().name();
            String t = q.getTopic();
            domainBreakdown.merge(d + "_total",   1, (x, y) -> (int) x + (int) y);
            topicBreakdown.merge( t + "_total",   1, (x, y) -> (int) x + (int) y);
            if (Boolean.TRUE.equals(a.getCorrect())) {
                domainBreakdown.merge(d + "_correct", 1, (x, y) -> (int) x + (int) y);
                topicBreakdown.merge( t + "_correct", 1, (x, y) -> (int) x + (int) y);
            }
        }

        // If any answer has null correct (EXTENDED_WRITING), mark result as pending review
        boolean hasUnscoredWriting = answers.stream().anyMatch(a -> a.getCorrect() == null);

        return resultRepository.save(ExamResult.builder()
            .sessionId(session.getId())
            .userId(session.getUserId())
            .examId(session.getExamId())
            .totalQuestions(total)
            .correctAnswers((int) correctCount)
            .scorePercentage(score)
            .practiceBand(bandNumber)
            .practiceLabel(bandLabel)
            .pendingReview(hasUnscoredWriting)
            .domainBreakdown(domainBreakdown)
            .topicBreakdown(topicBreakdown)
            .build());
    }

    private ExamResultDetailResponse buildDetailedResult(ExamSession session) {
        ExamResult storedResult = resultRepository.findBySessionId(session.getId()).orElse(null);

        List<ExamAnswer> answers = answerRepository.findBySessionId(session.getId());
        Map<UUID, ExamAnswer> answerMap = answers.stream()
            .collect(Collectors.toMap(ExamAnswer::getQuestionId, a -> a));

        List<ExamResultDetailResponse.QuestionReview> reviews;

        if (Boolean.TRUE.equals(session.getHasSnapshot())) {
            // Use snapshots for review — never reads live questions table
            reviews = snapshotRepository.findByIdSessionIdOrderByQuestionOrder(session.getId()).stream()
                .map(snap -> {
                    Map<String, Object> s = snap.getSnapshot();
                    UUID qId = UUID.fromString((String) s.get("questionId"));
                    ExamAnswer ans = answerMap.get(qId);
                    String studentAns = ans != null && ans.getAnswer() != null
                        ? Objects.toString(ans.getAnswer().get("value"), null) : null;
                    String correctAns = s.get("correctAnswer") instanceof Map<?,?> ca
                        ? Objects.toString(ca.get("value"), null) : null;
                    boolean correct = ans != null && Boolean.TRUE.equals(ans.getCorrect());
                    return new ExamResultDetailResponse.QuestionReview(
                        snap.getQuestionOrder(), qId,
                        (String) s.get("questionText"),
                        (String) s.get("stimulusText"),
                        (List<Map<String, Object>>) s.get("options"),
                        studentAns, correctAns, correct,
                        (String) s.get("explanation"),
                        ans != null ? ans.getTimeTakenSeconds() : null
                    );
                }).toList();
        } else {
            // Flat practice session — read live questions
            List<UUID> questionIds = session.getQuestionIds();
            Map<UUID, Question> qMap = questionRepository.findAllById(questionIds).stream()
                .collect(Collectors.toMap(Question::getId, q -> q));

            List<QuestionSummary> summaries;
            if (session.getExamId() != null) {
                summaries = examQuestionRepository.findByExamIdOrdered(session.getExamId()).stream()
                    .map(eq -> new QuestionSummary(eq.getQuestion().getId(), eq.getQuestionOrder(),
                        eq.getQuestion().getQuestionType(), eq.getQuestion().getQuestionText(),
                        eq.getQuestion().getStimulusText(), eq.getQuestion().getOptions(),
                        eq.getQuestion().getTopic(), eq.getQuestion().getDifficultyBand(),
                        eq.getQuestion().getCalculatorAllowed(), eq.getQuestion().getAudioUrl(),
                        eq.getQuestion().getDomain() != null ? eq.getQuestion().getDomain().name() : null))
                    .toList();
            } else {
                summaries = new ArrayList<>();
                for (int i = 0; i < questionIds.size(); i++) {
                    Question q = qMap.get(questionIds.get(i));
                    if (q != null) {
                        summaries.add(new QuestionSummary(q.getId(), i + 1, q.getQuestionType(),
                            q.getQuestionText(), q.getStimulusText(), q.getOptions(),
                            q.getTopic(), q.getDifficultyBand(), q.getCalculatorAllowed(),
                            q.getAudioUrl(), q.getDomain() != null ? q.getDomain().name() : null));
                    }
                }
            }

            reviews = summaries.stream().map(qs -> {
                Question q = qMap.get(qs.id());
                ExamAnswer ans = answerMap.get(qs.id());
                String studentAns = ans != null && ans.getAnswer() != null
                    ? Objects.toString(ans.getAnswer().get("value"), null) : null;
                String correctAns = q != null && q.getCorrectAnswer() != null
                    ? Objects.toString(q.getCorrectAnswer().get("value"), null) : null;
                boolean correct = ans != null && Boolean.TRUE.equals(ans.getCorrect());
                return new ExamResultDetailResponse.QuestionReview(
                    qs.questionOrder(), qs.id(), qs.questionText(), qs.stimulusText(),
                    qs.options(), studentAns, correctAns, correct,
                    q != null ? q.getExplanation() : null,
                    ans != null ? ans.getTimeTakenSeconds() : null
                );
            }).toList();
        }

        Map<String, ExamResultDetailResponse.TopicScore> domainScores = new LinkedHashMap<>();
        for (ExamResultDetailResponse.QuestionReview r : reviews) {
            String topic = "unknown";
            domainScores.merge(topic,
                new ExamResultDetailResponse.TopicScore(r.correct() ? 1 : 0, 1, 0),
                (a, b) -> new ExamResultDetailResponse.TopicScore(
                    a.correct() + b.correct(), a.total() + b.total(), 0));
        }
        domainScores.replaceAll((k, v) ->
            new ExamResultDetailResponse.TopicScore(v.correct(), v.total(),
                v.total() > 0 ? (v.correct() * 100.0 / v.total()) : 0));

        int total      = storedResult != null ? storedResult.getTotalQuestions() : session.getQuestionIds().size();
        int correct    = storedResult != null ? storedResult.getCorrectAnswers()
            : (int) answers.stream().filter(a -> Boolean.TRUE.equals(a.getCorrect())).count();
        double pct     = storedResult != null ? storedResult.getScorePercentage()
            : (total > 0 ? correct * 100.0 / total : 0);
        int band       = storedResult != null ? storedResult.getPracticeBand() : 1;
        String label   = storedResult != null ? storedResult.getPracticeLabel() : null;

        Long timeTaken = (session.getStartedAt() != null && session.getSubmittedAt() != null)
            ? session.getSubmittedAt().getEpochSecond() - session.getStartedAt().getEpochSecond() : null;

        String examTitle = null;
        if (session.getExamId() != null) {
            examTitle = examRepository.findById(session.getExamId()).map(Exam::getTitle).orElse(null);
        }

        return new ExamResultDetailResponse(
            session.getId(), session.getExamId(), examTitle,
            session.getStartedAt(), session.getSubmittedAt(), timeTaken,
            total, correct, pct, band, domainScores, reviews
        );
    }

    /** Remove server-only fields before sending question data to the student. */
    private Map<String, Object> studentView(Map<String, Object> snapshot, int order) {
        Map<String, Object> view = new LinkedHashMap<>(snapshot);
        view.remove("correctAnswer");
        view.remove("markingRubric");
        view.remove("explanation");
        view.put("questionOrder", order);
        return view;
    }

    @SuppressWarnings("unchecked")
    private QuestionSummary snapshotToQuestionSummary(SessionQuestionSnapshot snap) {
        Map<String, Object> s = snap.getSnapshot();
        UUID qId = UUID.fromString((String) s.get("questionId"));
        Question.QuestionType type = Question.QuestionType.valueOf((String) s.get("questionType"));
        Boolean calcAllowed = s.get("calculatorAllowed") instanceof Boolean b ? b : true;
        return new QuestionSummary(
            qId,
            snap.getQuestionOrder(),
            type,
            (String) s.get("questionText"),
            (String) s.get("stimulusText"),
            (List<Map<String, Object>>) s.get("options"),
            (String) s.get("topic"),
            s.get("difficultyBand") instanceof Number n ? n.intValue() : null,
            calcAllowed,
            (String) s.get("audioUrl"),
            (String) s.get("domain")
        );
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
}
