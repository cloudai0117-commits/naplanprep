package au.com.naplanprep.content.service;

import au.com.naplanprep.common.exception.ResourceNotFoundException;
import au.com.naplanprep.content.dto.QuestionRequest;
import au.com.naplanprep.content.entity.Question;
import au.com.naplanprep.content.repository.QuestionRepository;
import au.com.naplanprep.exam.entity.PackageType;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ContentService {

    private final QuestionRepository questionRepository;

    public Page<Question> searchQuestions(
        Integer yearLevel, Question.Domain domain, String topic,
        Integer difficultyBand, Question.QuestionStatus status,
        PackageType packageType, Pageable pageable
    ) {
        Specification<Question> spec = Specification.where(null);
        if (yearLevel != null)
            spec = spec.and((r, q, cb) -> cb.equal(r.get("yearLevel"), yearLevel));
        if (domain != null)
            spec = spec.and((r, q, cb) -> cb.equal(r.get("domain"), domain));
        if (topic != null)
            spec = spec.and((r, q, cb) -> cb.like(cb.lower(r.get("topic")), "%" + topic.toLowerCase() + "%"));
        if (difficultyBand != null)
            spec = spec.and((r, q, cb) -> cb.equal(r.get("difficultyBand"), difficultyBand));
        if (status != null)
            spec = spec.and((r, q, cb) -> cb.equal(r.get("status"), status));
        if (packageType != null)
            spec = spec.and((r, q, cb) -> cb.equal(r.get("packageType"), packageType));
        return questionRepository.findAll(spec, pageable);
    }

    @Transactional
    public Question createQuestion(QuestionRequest req, UUID createdBy) {
        var builder = Question.builder()
            .questionType(req.questionType())
            .yearLevel(req.yearLevel())
            .domain(req.domain())
            .topic(req.topic())
            .difficultyBand(req.difficultyBand())
            .stimulusText(req.stimulusText())
            .questionText(req.questionText())
            .options(req.options())
            .correctAnswer(req.correctAnswer())
            .explanation(req.explanation())
            .createdBy(createdBy);
        if (req.packageType() != null) builder.packageType(req.packageType());
        if (req.difficulty() != null) builder.difficulty(req.difficulty());
        return questionRepository.save(builder.build());
    }

    @Transactional
    public Question updateQuestion(UUID id, QuestionRequest req) {
        Question question = questionRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Question", id.toString()));

        question.setQuestionType(req.questionType());
        question.setYearLevel(req.yearLevel());
        question.setDomain(req.domain());
        question.setTopic(req.topic());
        question.setDifficultyBand(req.difficultyBand());
        question.setStimulusText(req.stimulusText());
        question.setQuestionText(req.questionText());
        question.setOptions(req.options());
        question.setCorrectAnswer(req.correctAnswer());
        question.setExplanation(req.explanation());
        if (req.packageType() != null) question.setPackageType(req.packageType());
        if (req.difficulty() != null) question.setDifficulty(req.difficulty());

        return questionRepository.save(question);
    }

    @Transactional
    public Question updateStatus(UUID id, Question.QuestionStatus newStatus) {
        Question question = questionRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Question", id.toString()));
        question.setStatus(newStatus);
        return questionRepository.save(question);
    }

    public Question findById(UUID id) {
        return questionRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Question", id.toString()));
    }
}
