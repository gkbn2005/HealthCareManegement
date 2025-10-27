package com.hms;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import com.hms.model.User;
import com.hms.repository.UserRepository;

@SpringBootApplication
public class HealthCareBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(HealthCareBackendApplication.class, args);
    }

    // Seed a couple of users (simple plain-text password for demo only)
    @Bean
    CommandLineRunner init(UserRepository userRepo) {
        return args -> {
            if (userRepo.count() == 0) {
                userRepo.save(new User(null, "admin", "admin123", "ADMIN"));
                userRepo.save(new User(null, "doctor", "doctor123", "DOCTOR"));
                userRepo.save(new User(null, "receptionist", "receptionist123", "RECEPTIONIST"));
            }
        };
    }
}
