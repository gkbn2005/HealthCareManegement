package com.hms.controller;

import com.hms.model.Patient;
import com.hms.repository.PatientRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

@Controller
public class PatientUIController {

    private final PatientRepository repo;

    public PatientUIController(PatientRepository repo) {
        this.repo = repo;
    }



    // ✅ Home Page (protected)
    @GetMapping("/")
    public String home(HttpSession session) {
        if (session.getAttribute("loggedUser") == null) {
            return "redirect:/login";  // NOT logged in -> login
        }
        return "home"; // Logged in -> show home
    }

    // ✅ Show Patient List Page
    @GetMapping("/patient-list")
    public String list(Model model) {
        model.addAttribute("patients", repo.findAll());
        return "list-patients";
    }

    // ✅ Show Add Page
    @GetMapping("/add-patient")
    public String addPatientPage() {
        return "add-patient";
    }

    // ✅ Save New Patient
    @PostMapping("/add-patient")
    public String addPatient(@ModelAttribute Patient p) {
        repo.save(p);
        return "redirect:/patient-list";
    }

    // ✅ Show Edit Page
    @GetMapping("/edit-patient/{id}")
    public String editPatientPage(@PathVariable Long id, Model model) {
        Patient patient = repo.findById(id).orElse(null);
        model.addAttribute("patient", patient);
        return "edit-patient";
    }

    // ✅ Update Patient
    @PostMapping("/edit-patient/{id}")
    public String updatePatient(@PathVariable Long id, @ModelAttribute Patient p) {
        p.setId(id);
        repo.save(p);
        return "redirect:/patient-list";
    }

    // ✅ Delete Patient
    @GetMapping("/delete-patient/{id}")
    public String deletePatient(@PathVariable Long id) {
        repo.deleteById(id);
        return "redirect:/patient-list";
    }
}
