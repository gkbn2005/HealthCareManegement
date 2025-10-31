package com.hms.controller;

import com.hms.model.Appointment;
import com.hms.repository.AppointmentRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/appointments")
@CrossOrigin(origins = "*")
public class AppointmentController {

    private final AppointmentRepository repo;

    public AppointmentController(AppointmentRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Appointment> list() {
        return repo.findAll();
    }

    // only match numeric ids to avoid routes like "edit-appointment"
    @GetMapping("/{id:\\d+}")
    public ResponseEntity<Appointment> get(@PathVariable Long id) {
        return repo.findById(id).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Appointment> create(@RequestBody Appointment appt) {
        return ResponseEntity.ok(repo.save(appt));
    }

    @DeleteMapping("/{id:\\d+}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!repo.existsById(id)) return ResponseEntity.notFound().build();
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
