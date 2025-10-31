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

import java.time.LocalDate;
import java.time.LocalTime;

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

    /** EDIT (form): /appointments/{id}/edit */
    @GetMapping("/appointments/{id}/edit")
    public String editAppointmentPage(@PathVariable Long id,
                                      Model model,
                                      HttpSession session,
                                      RedirectAttributes ra) {
        if (id == null || id <= 0) {
            ra.addFlashAttribute("errorMessage", "Appointment ID must be a positive number.");
            return "redirect:/appointments";
        }

        Appointment appt = appointmentRepo.findById(id).orElse(null);
        if (appt == null) {
            ra.addFlashAttribute("errorMessage", "Appointment not found.");
            return "redirect:/appointments";
        }

        model.addAttribute("appointment", appt);
        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("doctors", userRepo.findByRoleIgnoreCase("DOCTOR"));
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));
        return "edit_appointment"; // src/main/resources/templates/edit_appointment.ftlh
    }

    /** EDIT (submit): POST /appointments/{id}/edit */
    @PostMapping("/appointments/{id}/edit")
    public String updateAppointment(@PathVariable Long id,
                                    @ModelAttribute Appointment form,
                                    Model model,
                                    RedirectAttributes ra,
                                    HttpSession session) {
        // Preload dropdowns in case of re-render
        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("doctors", userRepo.findByRoleIgnoreCase("DOCTOR"));
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));

        if (id == null || id <= 0) {
            model.addAttribute("errorMessage", "Invalid appointment ID.");
            model.addAttribute("appointment", form);
            return "edit_appointment";
        }

        Appointment existing = appointmentRepo.findById(id).orElse(null);
        if (existing == null) {
            model.addAttribute("errorMessage", "Appointment not found.");
            model.addAttribute("appointment", form);
            return "edit_appointment";
        }

        // VALIDATIONS
        if (form.getPatientId() == null) {
            model.addAttribute("errorMessage", "Patient must be selected.");
            model.addAttribute("appointment", form);
            return "edit_appointment";
        }
        if (form.getDoctor() == null || form.getDoctor().isBlank()) {
            model.addAttribute("errorMessage", "Doctor must be selected.");
            model.addAttribute("appointment", form);
            return "edit_appointment";
        }
        if (form.getDate() == null) {
            model.addAttribute("errorMessage", "Date is required.");
            model.addAttribute("appointment", form);
            return "edit_appointment";
        }
        if (form.getTime() == null) {
            model.addAttribute("errorMessage", "Time is required.");
            model.addAttribute("appointment", form);
            return "edit_appointment";
        }

        // Resolve patient and update related info
        Patient patient = patientRepo.findById(form.getPatientId()).orElse(null);
        if (patient == null) {
            model.addAttribute("errorMessage", "Selected patient does not exist.");
            model.addAttribute("appointment", form);
            return "edit_appointment";
        }
        patient.setAdmissionDate(form.getDate());
        patient.setDoctorAssigned(form.getDoctor());
        patientRepo.save(patient);

        // UPDATE the appointment
        try {
            existing.setPatientId(form.getPatientId());
            existing.setPatientName(patient.getFullName());
            existing.setDoctor(form.getDoctor());

            LocalDate date = form.getDate();
            LocalTime time = form.getTime();
            existing.setDate(date);
            existing.setTime(time);

            appointmentRepo.save(existing);
        } catch (Exception e) {
            logger.error("Failed to update appointment {}: {}", id, e.getMessage(), e);
            model.addAttribute("errorMessage", "Failed to update appointment: " + e.getMessage());
            model.addAttribute("appointment", form);
            return "edit_appointment";
        }

        return "redirect:/appointments";
    }

    /** BACK-COMPAT: redirect /edit-appointment/{id} -> /appointments/{id}/edit */
    @GetMapping("/edit-appointment/{id}")
    public String redirectOldEdit(@PathVariable String id) {
        try {
            long parsed = Long.parseLong(id);
            return "redirect:/appointments/" + parsed + "/edit";
        } catch (NumberFormatException e) {
            // If it's not a number, just go back to list with a message
            return "redirect:/appointments";
        }
    }

    /** DELETE: unchanged */
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
