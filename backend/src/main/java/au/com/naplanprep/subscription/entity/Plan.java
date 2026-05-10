package au.com.naplanprep.subscription.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "plans")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Plan {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(nullable = false, unique = true)
    private String slug;

    @Column(nullable = false)
    private BigDecimal monthlyPrice;

    private BigDecimal annualPrice;

    private String stripeMonthlyPriceId;

    private String stripeAnnualPriceId;

    private Integer maxChildren;

    private Integer dailyQuestionLimit;

    private Integer annualMockExamLimit;

    private Boolean adaptiveLearning;

    private Boolean parentDashboard;

    private Boolean detailedAnalytics;

    private Boolean active;

    private String description;
}
