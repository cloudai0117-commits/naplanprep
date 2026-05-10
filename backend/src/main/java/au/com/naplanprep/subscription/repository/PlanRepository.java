package au.com.naplanprep.subscription.repository;

import au.com.naplanprep.subscription.entity.Plan;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface PlanRepository extends JpaRepository<Plan, UUID> {
    List<Plan> findByActiveTrueOrderByMonthlyPriceAsc();
    Optional<Plan> findBySlug(String slug);
    Optional<Plan> findByStripeMonthlyPriceId(String priceId);
    Optional<Plan> findByStripeAnnualPriceId(String priceId);
}
