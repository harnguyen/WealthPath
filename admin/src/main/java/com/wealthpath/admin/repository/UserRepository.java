package com.wealthpath.admin.repository;

import com.wealthpath.admin.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
    
    Optional<User> findByEmail(String email);
    
    Page<User> findByNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
        String name, String email, Pageable pageable);
    
    long countByCreatedAtAfter(LocalDateTime date);
    
    @Query("SELECT COUNT(u) FROM User u WHERE u.oauthProvider IS NOT NULL")
    long countOAuthUsers();
    
    @Query("SELECT u.currency, COUNT(u) FROM User u GROUP BY u.currency")
    java.util.List<Object[]> countUsersByCurrency();
}

