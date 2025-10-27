package com.hms.controller;

import com.hms.model.User;
import com.hms.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {
    private final UserRepository userRepo;
    public AuthController(UserRepository userRepo) { this.userRepo = userRepo; }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String,String> payload) {
        String username = payload.get("username");
        String password = payload.get("password");
        return userRepo.findByUsername(username)
                .map(u -> {
                    if (u.getPassword().equals(password)) {
                        // return user role and id (tokenless simple auth)
                        return ResponseEntity.ok(Map.of("id", u.getId(), "username", u.getUsername(), "role", u.getRole()));
                    } else {
                        return ResponseEntity.status(401).body("Invalid credentials");
                    }
                }).orElse(ResponseEntity.status(404).body("User not found"));
    }
}
