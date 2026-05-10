package au.com.naplanprep.exam.service;

import au.com.naplanprep.common.exception.BusinessException;
import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.exam.dto.StartExamRequest;
import au.com.naplanprep.exam.entity.ExamAnswer;
import au.com.naplanprep.exam.entity.ExamResult;
import au.com.naplanprep.exam.entity.ExamSession;
import au.com.naplanprep.exam.repository.ExamAnswerRepository;
import au.com.naplanprep.exam.repository.ExamResultRepository;
import au.com.naplanprep.exam.repository.ExamSessionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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
        ExamSession.ExamType.PRACTICE, 30 * 60,
        ExamSession.ExamType.MOCK, 65 * 60,
        ExamSession.ExamType.DIAGNOSTIC, 20 * 60
    );

    private final ExamSessionRepository sessionRepository;
    private final ExamAnswerRepository answerRepository;
    private final ExamResultRepository resultRepository;
    private final QuestionRepository questionRepository;

    @Transactional
    public ExamSession startExam(UUID userId, StartExamRequest req) {
        int count = req.resolvedQuestionCount();
        Pageable pageable = PageRequest.of(0, count);

        List<Question> questions;
        if (req.domain() != null) {
            questions = questionRepository.findRandomByYearLevelAndDomain(req.yearLevel(), req.domain(), pageable);
        } else {
            questions = questionRepository.findRandomByYearLevelAndDomain(
                req.yearLevel(), Question.Domain.NUMERACY, pageable);
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

    public ExamSession getSession(UUID sessionId, UUID userId) {
        ExamSession session = sessionRepository.findById(sessionId)
            .orElseThrow(() -> new ResourceNotFoundException("ExamSession", sessionId.toString()));
        if (!session.getUserId().equals(userId)) {
            throw new BusinessException("Access denied");
        }
        if (session.getStatus() == ExamSession.SessionStatus.IN_PROGRESS
            && Instant.now().isAfter(session.getExpiresAt())) {
            session.setStatus(ExamSession.SessionStatus.TIMED_OUT);
            session.setSubmittedAt(Instant.now());
            sessionRepository.save(session);
            calculateAndSaveResult(session);
        }
        return session;
    }

    @Transactional
    public ExamAnswer submitAnswer(UUID sessionId, UUID userId, UUID questionId, Map<String, Object> answer, Boolean flagged) {
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

        ExamAnswer existingAnswer = answerRepository.findBySessionIdAndQuestionId(sessionId, questionId).orElse(null);

        if (existingAnswer != null) {
            existingAnswer.setAnswer(answer);
            existingAnswer.setCorrect(correct);
            existingAnswer.setFlagged(flagged != null ? flagged : existingAnswer.getFlagged());
            return answerRepository.save(existingAnswer);
        }

        ExamAnswer examAnswer = ExamAnswer.builder()
            .sessionId(sessionId)
            .questionId(questionId)
            .answer(answer)
            .correct(correct)
            .flagged(flagged != null ? flagged : false)
            .build();

        return answerRepository.save(examAnswer);
    }

    @Transactional
    public ExamResult submitExam(UUID sessionId, UUID userId) {
        ExamSession session = getSession(sessionId, userId);
        if (session.getStatus() != ExamSession.SessionStatus.IN_PROGRESS) {
            throw new BusinessException("Session already submitted");
        }

        session.setStatus(ExamSession.SessionStatus.SUBMITTED);
        session.setSubmittedAt(Instant.now());
        sessionRepository.save(session);

        return calculateAndSaveResult(session);
    }

    public ExamResult getResult(UUID sessionId, UUID userId) {
        ExamSession session = sessionRepository.findById(sessionId)
            .orElseThrow(() -> new ResourceNotFoundException("ExamSession", sessionId.toString()));
        if (!session.getUserId().equals(userId)) {
            throw new BusinessException("Access denied");
        }
        return resultRepository.findBySessionId(sessionId)
            .orElseThrow(() -> new ResourceNotFoundException("ExamResult for session", sessionId.toString()));
    }

    public Page<ExamSession> getHistory(UUID userId, Pageable pageable) {
        return sessionRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
    }

    private ExamResult calculateAndSaveResult(ExamSession session) {
        List<ExamAnswer> answers = answerRepository.findBySessionId(session.getId());
        int total = session.getQuestionIds().size();
        long correct = answers.stream().filter(a -> Boolean.TRUE.equals(a.getCorrect())).count();
        double score = total > 0 ? (correct * 100.0) / total : 0;
        int band = calculateNaplanBand(score);

        Map<String, Object> domainBreakdown = new HashMap<>();
        Map<String, Object> topicBreakdown = new HashMap<>();

        List<UUID> questionIds = answers.stream().map(ExamAnswer::getQuestionId).toList();
        List<Question> questions = questionRepository.findAllById(questionIds);
        Map<UUID, Question> questionMap = questions.stream()
            .collect(Collectors.toMap(Question::getId, q -> q));

        for (ExamAnswer answer : answers) {
            Question q = questionMap.get(answer.getQuestionId());
            if (q == null) continue;
            String domain = q.getDomain().name();
            String topic = q.getTopic();

            domainBreakdown.merge(domain + "_total", 1, (a, b) -> (int)a + (int)b);
            if (Boolean.TRUE.equals(answer.getCorrect())) {
                domainBreakdown.merge(domain + "_correct", 1, (a, b) -> (int)a + (int)b);
            }
            topicBreakdown.merge(topic + "_total", 1, (a, b) -> (int)a + (int)b);
            if (Boolean.TRUE.equals(answer.getCorrect())) {
                topicBreakdown.merge(topic + "_correct", 1, (a, b) -> (int)a + (int)b);
            }
        }

        ExamResult result = ExamResult.builder()
            .sessionId(session.getId())
            .userId(session.getUserId())
            .totalQuestions(total)
            .correctAnswers((int) correct)
            .scorePercentage(score)
            .naplanBand(band)
            .domainBreakdown(domainBreakdown)
            .topicBreakdown(topicBreakdown)
            .build();

        return resultRepository.save(result);
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
