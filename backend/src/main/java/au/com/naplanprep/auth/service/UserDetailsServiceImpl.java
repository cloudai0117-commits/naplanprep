package au.com.naplanprep.auth.service;

import au.com.naplanprep.auth.entity.User;
import au.com.naplanprep.auth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
            .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));
        return buildUserDetails(user);
    }

    /** Cached — eliminates the DB hit on every authenticated request. TTL: 5 minutes. */
    @Cacheable(value = "userDetails", key = "#id")
    public UserDetails loadUserById(String id) {
        User user = userRepository.findById(UUID.fromString(id))
            .orElseThrow(() -> new UsernameNotFoundException("User not found: " + id));
        return buildUserDetails(user);
    }

    /** Call this after any change to user status, role, or lock state to force a fresh DB read. */
    @CacheEvict(value = "userDetails", key = "#userId")
    public void evictUserCache(String userId) {
        // cache eviction only
    }

    private UserDetails buildUserDetails(User user) {
        return org.springframework.security.core.userdetails.User.builder()
            .username(user.getId().toString())
            .password(user.getPassword())
            .authorities(List.of(new SimpleGrantedAuthority("ROLE_" + user.getRole().name())))
            .accountLocked(user.isLocked())
            .disabled(user.getStatus() == User.UserStatus.INACTIVE ||
                user.getStatus() == User.UserStatus.SUSPENDED)
            .build();
    }
}
