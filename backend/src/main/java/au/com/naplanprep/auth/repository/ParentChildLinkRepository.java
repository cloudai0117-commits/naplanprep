package au.com.naplanprep.auth.repository;

import au.com.naplanprep.auth.entity.ParentChildLink;
import au.com.naplanprep.auth.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ParentChildLinkRepository extends JpaRepository<ParentChildLink, UUID> {
    List<ParentChildLink> findByParent(User parent);
    List<ParentChildLink> findByChild(User child);
    Optional<ParentChildLink> findByParentAndChild(User parent, User child);
    boolean existsByParentAndChild(User parent, User child);
}
