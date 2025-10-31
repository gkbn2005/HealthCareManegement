package com.hms.controller;

import com.hms.model.Appointment;
import com.hms.model.Patient;
import com.hms.repository.AppointmentRepository;
import com.hms.repository.PatientRepository;
import com.hms.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AppointmentUIController {

    private static final Logger logger = LoggerFactory.getLogger(AppointmentUIController.class);

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

    /** LIST: /appointments */
    @GetMapping("/appointments")
    public String listAppointments(Model model, HttpSession session,
                                   @ModelAttribute("errorMessage") String errorMessage) {
        model.addAttribute("appointments", appointmentRepo.findAll());
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));
        if (errorMessage != null && !errorMessage.isBlank()) {
            model.addAttribute("errorMessage", errorMessage);
        }
        return "appointments-list";
    }

    /** ADD (form) */
    @GetMapping("/add-appointment")
    public String addAppointmentPage(Model model, HttpSession session) {
        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("doctors", userRepo.findByRoleIgnoreCase("DOCTOR"));
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));
        return "add-appointment";
    }

    /** ADD (submit) */
    @PostMapping("/add-appointment")
    public String saveAppointment(@ModelAttribute Appointment appt,
                                  Model model,
                                  RedirectAttributes ra,
                                  HttpSession session) {

        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("doctors", userRepo.findByRoleIgnoreCase("DOCTOR"));
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));

        // --- VALIDATIONS ---
        if (appt.getPatientId() == null || appt.getDoctor() == null ||
                appt.getDate() == null || appt.getTime() == null) {
            model.addAttribute("errorMessage", "All fields are required.");
            model.addAttribute("appointment", appt);
            return "add-appointment";
        }

        // --- Check doctor conflict ---
        if (appointmentRepo.existsByDoctorAndDateAndTime(appt.getDoctor(), appt.getDate(), appt.getTime())) {
            // ⚠️ Show same page with warning message
            model.addAttribute("errorMessage", "⚠️ This doctor already has an appointment at that date and time.");
            model.addAttribute("appointment", appt);
            return "add-appointment";
        }

        // --- Save patient info and appointment ---
        Patient patient = patientRepo.findById(appt.getPatientId()).orElse(null);
        if (patient != null) {
            appt.setPatientName(patient.getFullName());
            patient.setAdmissionDate(appt.getDate());
            patient.setDoctorAssigned(appt.getDoctor());
            patientRepo.save(patient);
        }

        try {
            appointmentRepo.save(appt);
        } catch (Exception e) {
            logger.error("Failed to save appointment: {}", e.getMessage(), e);
            model.addAttribute("errorMessage", "Failed to save appointment: " + e.getMessage());
            model.addAttribute("appointment", appt);
            return "add-appointment";
        }

        ra.addFlashAttribute("successMessage", "✅ Appointment added successfully!");
        return "redirect:/appointments";
    }

    /** EDIT (form): /appointments/{id}/edit */
    @GetMapping("/appointments/{id}/edit")
    public String editAppointmentPage(@PathVariable Long id,
                                      Model model,
                                      HttpSession session,
                                      RedirectAttributes ra) {
        Appointment appt = appointmentRepo.findById(id).orElse(null);
        if (appt == null) {
            ra.addFlashAttribute("errorMessage", "Appointment not found.");
            return "redirect:/appointments";
        }

        model.addAttribute("appointment", appt);
        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("doctors", userRepo.findByRoleIgnoreCase("DOCTOR"));
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));
        return "edit_appointment"; // same as your file name
    }

    /** EDIT (submit): POST /appointments/{id}/edit */
    @PostMapping("/appointments/{id}/edit")
    public String updateAppointment(@PathVariable Long id,
                                    @ModelAttribute Appointment form,
                                    Model model,
                                    RedirectAttributes ra,
                                    HttpSession session) {

        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("doctors", userRepo.findByRoleIgnoreCase("DOCTOR"));
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));

        Appointment existing = appointmentRepo.findById(id).orElse(null);
        if (existing == null) {
            model.addAttribute("errorMessage", "Appointment not found.");
            return "edit_appointment";
        }

        // --- Check doctor conflict (exclude current) ---
        boolean conflict = appointmentRepo.existsByDoctorAndDateAndTime(
                form.getDoctor(), form.getDate(), form.getTime()
        ) && !(existing.getDoctor().equals(form.getDoctor())
                && existing.getDate().equals(form.getDate())
                && existing.getTime().equals(form.getTime()));

        if (conflict) {
            model.addAttribute("errorMessage", "⚠️ This doctor already has an appointment at that date and time.");
            model.addAttribute("appointment", form);
            return "edit_appointment";
        }

        try {
            Patient patient = patientRepo.findById(form.getPatientId()).orElse(null);
            if (patient != null) {
                form.setPatientName(patient.getFullName());
                patient.setAdmissionDate(form.getDate());
                patient.setDoctorAssigned(form.getDoctor());
                patientRepo.save(patient);
            }

            existing.setPatientId(form.getPatientId());
            existing.setPatientName(form.getPatientName());
            existing.setDoctor(form.getDoctor());
            existing.setDate(form.getDate());
            existing.setTime(form.getTime());
            appointmentRepo.save(existing);
        } catch (Exception e) {
            logger.error("Failed to update appointment {}: {}", id, e.getMessage(), e);
            model.addAttribute("errorMessage", "Failed to update appointment: " + e.getMessage());
            model.addAttribute("appointment", form);
            return "edit_appointment";
        }

        ra.addFlashAttribute("successMessage", "✅ Appointment updated successfully!");
        return "redirect:/appointments";
    }

    /** BACKWARD COMPATIBILITY: /edit-appointment/{id} → /appointments/{id}/edit */
    @GetMapping("/edit-appointment/{id}")
    public String redirectOldEdit(@PathVariable String id) {
        try {
            long parsed = Long.parseLong(id);
            return "redirect:/appointments/" + parsed + "/edit";
        } catch (NumberFormatException e) {
            return "redirect:/appointments";
        }
    }

    /** DELETE */
    @GetMapping("/delete-appointment/{id}")
    public String deleteAppointment(@PathVariable String id) {
        try {
            Long appointmentId = Long.parseLong(id);
            appointmentRepo.deleteById(appointmentId);
        } catch (NumberFormatException e) {
            logger.warn("Invalid ID for delete: '{}'", id);
        }
        return "redirect:/appointments";
    }
}
