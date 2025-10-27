package com.hms.controller;

import com.hms.model.Patient;
import com.hms.repository.PatientRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/patients")
@CrossOrigin(origins = "*")
public class PatientController {

    private final PatientRepository repo;

    public PatientController(PatientRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Patient> list() {
        return repo.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Patient> get(@PathVariable Long id) {
        return repo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Patient create(@RequestBody Patient p) {
        return repo.save(p);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Patient> update(@PathVariable Long id, @RequestBody Patient p) {
        return repo.findById(id).map(existing -> {
            existing.setFullName(p.getFullName());
            existing.setAge(p.getAge());
            existing.setGender(p.getGender());
            existing.setContactNumber(p.getContactNumber());
            existing.setDiagnosis(p.getDiagnosis());
            existing.setDoctorAssigned(p.getDoctorAssigned());
            existing.setAddress(p.getAddress());
            existing.setAdmissionDate(p.getAdmissionDate());
            existing.setEmail(p.getEmail());
            return ResponseEntity.ok(repo.save(existing));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!repo.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
