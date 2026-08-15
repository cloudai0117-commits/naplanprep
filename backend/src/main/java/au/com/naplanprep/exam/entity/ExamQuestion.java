package au.com.naplanprep.exam.entity;

import au.com.naplanprep.content.entity.Question;
import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.util.UUID;

@Entity
@Table(name = "exam_questions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExamQuestion {

    @EmbeddedId
    private ExamQuestionId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("examId")
    @JoinColumn(name = "exam_id", nullable = false)
    private Exam exam;

    @ManyToOne(fetch = FetchType.EAGER)
    @MapsId("questionId")
    @JoinColumn(name = "question_id", nullable = false)
    private Question question;

    @Column(nullable = false)
    private Integer questionOrder;

    /**
     * Section this question belongs to within the exam.
     * Null for flat exams without a section hierarchy.
     */
    @Column(name = "section_id")
    private UUID sectionId;

    /**
     * Testlet this question belongs to.
     * Null for flat exams without testlets.
     */
    @Column(name = "testlet_id")
    private UUID testletId;

    @Embeddable
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @EqualsAndHashCode
    public static class ExamQuestionId implements Serializable {
        private UUID examId;
        private UUID questionId;
    }
}
