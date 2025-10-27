package com.hms.controller;

import com.hms.model.User;
import com.hms.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class LoginViewController {

    private final UserRepository userRepo;

    public LoginViewController(UserRepository userRepo) {
        this.userRepo = userRepo;
    }

    @GetMapping("/login")
    public String showLogin() {
        return "login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam String username,
                          @RequestParam String password,
                          HttpSession session,
                          Model model) {

        User user = userRepo.findByUsername(username).orElse(null);

        if (user == null || !user.getPassword().equals(password)) {
            model.addAttribute("error", "Invalid username or password");
            return "login";  // stay on login page with error
        }

        // Store user in session for access in all templates
        session.setAttribute("loggedUser", user);

        // Redirect based on role
        if ("ADMIN".equals(user.getRole())) {
            return "redirect:/";              // home page
        } else {
            return "redirect:/patient-list";  // doctors or other roles
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
