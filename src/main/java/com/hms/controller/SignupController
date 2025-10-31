package com.hms.controller;

import com.hms.model.User;
import com.hms.repository.UserRepository;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class SignupController {

    private final UserRepository userRepository;

    public SignupController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /** Render the sign up page (templates/signup.ftlh) */
    @GetMapping("/signup")
    public String showSignupPage() {
        return "signup"; // must match src/main/resources/templates/signup.ftlh
    }

    /** Handle sign up form submit */
    @PostMapping("/signup")
    public String handleSignup(@RequestParam String username,
                               @RequestParam String password,
                               @RequestParam String confirmPassword,
                               @RequestParam String role,
                               RedirectAttributes ra) {

        // Basic validation
        if (username == null || username.isBlank()
                || password == null || password.isBlank()
                || confirmPassword == null || confirmPassword.isBlank()) {
            ra.addFlashAttribute("errorMessage", "All fields are required.");
            return "redirect:/signup";
        }

        if (!password.equals(confirmPassword)) {
            ra.addFlashAttribute("errorMessage", "Passwords do not match.");
            return "redirect:/signup";
        }

        if (userRepository.existsByUsernameIgnoreCase(username.trim())) {
            ra.addFlashAttribute("errorMessage", "Username is already taken.");
            return "redirect:/signup";
        }

        // Create and save the user
        User u = new User();
        u.setUsername(username.trim());
        u.setPassword(password);            // If you use a PasswordEncoder, encode here.
        u.setRole(role == null ? "RECEPTIONIST" : role.toUpperCase());
        userRepository.save(u);

        ra.addFlashAttribute("infoMessage", "Account created successfully. Please log in.");
        return "redirect:/login";
    }
}
