package com.hms.controller;

import com.hms.model.Invoice;
import com.hms.repository.InvoiceRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/invoices")
@CrossOrigin(origins = "*")
public class InvoiceController {

    private final InvoiceRepository repo;
    public InvoiceController(InvoiceRepository repo) { this.repo = repo; }

    @GetMapping
    public List<Invoice> list() { return repo.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Invoice> get(@PathVariable Long id) {
        return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Invoice create(@RequestBody Invoice inv) {
        if (inv.getStatus() == null) inv.setStatus("Unpaid");
        return repo.save(inv);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Invoice> update(@PathVariable Long id, @RequestBody Invoice inv) {
        return repo.findById(id).map(existing -> {
            existing.setPatientId(inv.getPatientId());
            existing.setPatientName(inv.getPatientName());
            existing.setAmount(inv.getAmount());
            existing.setStatus(inv.getStatus());
            return ResponseEntity.ok(repo.save(existing));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!repo.existsById(id)) return ResponseEntity.notFound().build();
        repo.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/mark-paid")
    public ResponseEntity<Invoice> markPaid(@PathVariable Long id) {
        return repo.findById(id).map(inv -> {
            inv.setStatus("Paid");
            return ResponseEntity.ok(repo.save(inv));
        }).orElse(ResponseEntity.notFound().build());
    }
}
