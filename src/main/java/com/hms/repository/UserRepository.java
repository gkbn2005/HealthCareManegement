package com.hms.repository;

import com.hms.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for managing User entities.
 * Provides methods for authentication, role-based queries, and duplicate checks.
 */
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Finds a user by username.
     * Used during login authentication.
     *
     * @param username the username to look for
     * @return an Optional containing the User if found, or empty otherwise
     */
    Optional<User> findByUsername(String username);

    /**
     * Fetches all users that have the given role (case-insensitive).
     * Commonly used to retrieve all doctors, admins, etc.
     *
     * @param role the role name (e.g., "DOCTOR", "ADMIN")
     * @return a list of users with that role
     */
    List<User> findByRoleIgnoreCase(String role);

    /**
     * Checks if a user already exists with the given username (case-insensitive).
     * Used during signup to prevent duplicate accounts.
     *
     * @param username the username to check
     * @return true if the username exists, false otherwise
     */
    boolean existsByUsernameIgnoreCase(String username);
}
