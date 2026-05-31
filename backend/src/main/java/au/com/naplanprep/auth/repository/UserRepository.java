package au.com.naplanprep.auth.repository;

import au.com.naplanprep.auth.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);

    @Query("SELECT u FROM User u LEFT JOIN FETCH u.profile WHERE u.id = :id")
    Optional<User> findByIdWithProfile(@Param("id") UUID id);

    @Query(value = "SELECT u FROM User u LEFT JOIN FETCH u.profile p WHERE " +
        "(:search IS NULL OR :search = '' OR LOWER(u.email) LIKE LOWER(CONCAT('%', :search, '%')) " +
        "OR LOWER(p.firstName) LIKE LOWER(CONCAT('%', :search, '%')))",
        countQuery = "SELECT COUNT(u) FROM User u LEFT JOIN u.profile p WHERE " +
        "(:search IS NULL OR :search = '' OR LOWER(u.email) LIKE LOWER(CONCAT('%', :search, '%')) " +
        "OR LOWER(p.firstName) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<User> searchUsers(@Param("search") String search, Pageable pageable);
}
