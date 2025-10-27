package com.hms.controller;

import com.hms.model.Appointment;
import com.hms.repository.AppointmentRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@RestController
@RequestMapping("/api/appointments")
@CrossOrigin(origins = "*")
public class AppointmentController {

    private final AppointmentRepository repo;
    public AppointmentController(AppointmentRepository repo) { this.repo = repo; }

    @GetMapping
    public List<Appointment> list() { return repo.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Appointment> get(@PathVariable Long id) {
        return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Appointment appt) {
        // check conflict
        if (appt.getDoctor() != null && appt.getDate() != null && appt.getTime() != null) {
            List<Appointment> existing = repo.findByDoctorAndDateAndTime(appt.getDoctor(), appt.getDate(), appt.getTime());
            if (!existing.isEmpty()) {
                return ResponseEntity.badRequest().body("Conflict: doctor already booked at that date/time.");
            }
        }
        Appointment saved = repo.save(appt);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Appointment> update(@PathVariable Long id, @RequestBody Appointment appt) {
        return repo.findById(id).map(existing -> {
            existing.setPatientId(appt.getPatientId());
            existing.setPatientName(appt.getPatientName());
            existing.setDoctor(appt.getDoctor());
            existing.setDate(appt.getDate());
            existing.setTime(appt.getTime());
            return ResponseEntity.ok(repo.save(existing));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!repo.existsById(id)) return ResponseEntity.notFound().build();
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
