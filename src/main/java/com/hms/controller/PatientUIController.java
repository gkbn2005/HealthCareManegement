package com.hms.controller;

import com.hms.model.Patient;
import com.hms.model.User;
import com.hms.repository.PatientRepository;
import com.hms.repository.InvoiceRepository;
import com.hms.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class PatientUIController {

    private final PatientRepository repo;
    private final InvoiceRepository invoiceRepo;
    private final UserRepository userRepo;

    public PatientUIController(PatientRepository repo, InvoiceRepository invoiceRepo, UserRepository userRepo) {
        this.repo = repo;
        this.invoiceRepo = invoiceRepo;
        this.userRepo = userRepo;
    }

    // Home page
    @GetMapping("/")
    public String home(HttpSession session, Model model) {
        Object userObj = session.getAttribute("loggedUser");
        if (userObj == null) return "redirect:/login";

        model.addAttribute("patients", repo.findAll());
        model.addAttribute("invoices", invoiceRepo.findAll());
        model.addAttribute("loggedUser", userObj);
        return "home";
    }

    // Patient list page
    @GetMapping("/patient-list")
    public String list(HttpSession session, Model model) {
        model.addAttribute("patients", repo.findAll());
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));
        return "list-patients";
    }

    // Add patient page
    @GetMapping("/add-patient")
    public String addPatientPage(HttpSession session, Model model) {
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));

        // Fetch all doctors from DB
        List<User> doctors = userRepo.findByRoleIgnoreCase("DOCTOR");
        model.addAttribute("doctors", doctors);

        return "add-patient";
    }

    // Save new patient
    @PostMapping("/add-patient")
    public String addPatient(@ModelAttribute Patient p) {
        repo.save(p);
        return "redirect:/patient-list";
    }

    // Edit patient page
    @GetMapping("/edit-patient/{id}")
    public String editPatientPage(@PathVariable Long id, Model model, HttpSession session) {
        Patient patient = repo.findById(id).orElse(null);
        model.addAttribute("patient", patient);
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));

        // Fetch all doctors from DB
        List<User> doctors = userRepo.findByRoleIgnoreCase("DOCTOR");
        model.addAttribute("doctors", doctors);

        return "edit-patient";
    }

    // Update patient
    @PostMapping("/edit-patient/{id}")
    public String updatePatient(@PathVariable Long id, @ModelAttribute Patient p) {
        p.setId(id);
        repo.save(p);
        return "redirect:/patient-list";
    }

    // Delete patient
    @GetMapping("/delete-patient/{id}")
    public String deletePatient(@PathVariable Long id) {
        repo.deleteById(id);
        return "redirect:/patient-list";
    }
}
