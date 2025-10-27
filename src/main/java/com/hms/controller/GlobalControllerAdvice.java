package com.hms.controller;

import com.hms.model.User;
import com.hms.repository.PatientRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalControllerAdvice {

    private final PatientRepository patientRepo;

    public GlobalControllerAdvice(PatientRepository patientRepo) {
        this.patientRepo = patientRepo;
    }

    @ModelAttribute("loggedUser")
    public User addLoggedUserToModel(HttpSession session) {
        return (User) session.getAttribute("loggedUser");
    }

    @ModelAttribute("patients")
    public Object addPatientsToModel() {
        return patientRepo.findAll(); // now ${patients} exists in all templates
    }
}
