package com.hms.controller;

import com.hms.model.Appointment;
import com.hms.model.Patient;
import com.hms.repository.AppointmentRepository;
import com.hms.repository.PatientRepository;
import com.hms.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;  // Add this import
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AppointmentUIController {

    private static final Logger logger = LoggerFactory.getLogger(AppointmentUIController.class);  // Add this

    private final AppointmentRepository appointmentRepo;
    private final PatientRepository patientRepo;
    private final UserRepository userRepo;

    public AppointmentUIController(AppointmentRepository appointmentRepo,
                                   PatientRepository patientRepo,
                                   UserRepository userRepo) {
        this.appointmentRepo = appointmentRepo;
        this.patientRepo = patientRepo;
        this.userRepo = userRepo;
    }

    // List all appointments
    @GetMapping("/appointments")
    public String listAppointments(Model model, HttpSession session) {
        model.addAttribute("appointments", appointmentRepo.findAll());
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));
        return "appointments-list";
    }

    // Add Appointment Page
    @GetMapping("/add-appointment")
    public String addAppointmentPage(Model model, HttpSession session) {
        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("doctors", userRepo.findByRoleIgnoreCase("DOCTOR"));
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));
        return "add-appointment";
    }

    // Save Appointment
    @PostMapping("/add-appointment")
    public String saveAppointment(@ModelAttribute Appointment appt) {
        Patient patient = patientRepo.findById(appt.getPatientId()).orElse(null);
        if (patient != null) {
            appt.setPatientName(patient.getFullName());
            patient.setAdmissionDate(appt.getDate());
            patient.setDoctorAssigned(appt.getDoctor());
            patientRepo.save(patient);
        }
        appointmentRepo.save(appt);
        return "redirect:/appointments";
    }

    // Edit Appointment Page - UPDATED: Accept String id and parse manually to handle invalid IDs
    @GetMapping("/edit-appointment/{id}")
    public String editAppointmentPage(@PathVariable String id, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        logger.info("Received ID for edit: '{}'", id);  // Added logging

        Long appointmentId = null;
        try {
            appointmentId = Long.parseLong(id);
        } catch (NumberFormatException e) {
            logger.error("Invalid ID format: '{}'", id);  // Added logging
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid appointment ID: " + id);
            return "redirect:/appointments";
        }

        if (appointmentId == null || appointmentId <= 0) {
            logger.warn("Invalid or null ID: {}", appointmentId);  // Added logging
            redirectAttributes.addFlashAttribute("errorMessage", "Appointment ID must be a positive number.");
            return "redirect:/appointments";
        }

        Appointment appt = appointmentRepo.findById(appointmentId).orElse(null);
        if (appt == null) {
            logger.warn("Appointment not found for ID: {}", appointmentId);  // Added logging
            redirectAttributes.addFlashAttribute("errorMessage", "Appointment not found.");
            return "redirect:/appointments";
        }

        model.addAttribute("appointment", appt);
        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("doctors", userRepo.findByRoleIgnoreCase("DOCTOR"));
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));
        return "edit-appointment";
    }

    // Update Appointment — UPDATED: Minor tweak for consistency (already handles null ID)
    @PostMapping("/edit-appointment")
    public String updateAppointment(@ModelAttribute Appointment appt, Model model) {
        // Pre-populate model for re-rendering if needed
        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("doctors", userRepo.findByRoleIgnoreCase("DOCTOR"));

        if (appt.getId() == null || appt.getId() <= 0) {
            model.addAttribute("errorMessage", "Invalid appointment ID.");
            return "edit-appointment";
        }

        Appointment existing = appointmentRepo.findById(appt.getId()).orElse(null);
        if (existing == null) {
            model.addAttribute("errorMessage", "Appointment not found.");
            return "edit-appointment";
        }

        // Validate patient
        if (appt.getPatientId() == null) {
            model.addAttribute("errorMessage", "Patient must be selected.");
            return "edit-appointment";
        }

        Patient patient = patientRepo.findById(appt.getPatientId()).orElse(null);
        if (patient == null) {
            model.addAttribute("errorMessage", "Selected patient does not exist.");
            return "edit-appointment";
        }

        // Validate doctor
        if (appt.getDoctor() == null || appt.getDoctor().isBlank()) {
            model.addAttribute("errorMessage", "Doctor must be selected.");
            return "edit-appointment";
        }

        // Validate date/time
        if (appt.getDate() == null) {
            model.addAttribute("errorMessage", "Date is required.");
            return "edit-appointment";
        }
        if (appt.getTime() == null) {
            model.addAttribute("errorMessage", "Time is required.");
            return "edit-appointment";
        }

        // Update patient info
        patient.setAdmissionDate(appt.getDate());
        patient.setDoctorAssigned(appt.getDoctor());
        patientRepo.save(patient);

        // Update appointment info
        existing.setPatientId(appt.getPatientId());
        existing.setPatientName(patient.getFullName());
        existing.setDoctor(appt.getDoctor());
        existing.setDate(appt.getDate());
        existing.setTime(appt.getTime());
        appointmentRepo.save(existing);

        return "redirect:/appointments";
    }

    // Delete Appointment - UNCHANGED (already handles invalid IDs well)
    @GetMapping("/delete-appointment/{id}")
    public String deleteAppointment(@PathVariable String id) {
        try {
            Long appointmentId = Long.parseLong(id);
            appointmentRepo.deleteById(appointmentId);
        } catch (NumberFormatException e) {
            logger.warn("Invalid ID for delete: '{}'", id);  // Added logging
        }
        return "redirect:/appointments";
    }
}
