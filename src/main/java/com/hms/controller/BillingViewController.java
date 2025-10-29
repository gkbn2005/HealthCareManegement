package com.hms.controller;

import com.hms.model.Invoice;
import com.hms.model.Patient;
import com.hms.model.User;
import com.hms.repository.InvoiceRepository;
import com.hms.repository.PatientRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@Controller
public class BillingViewController {

    private final InvoiceRepository invoiceRepo;
    private final PatientRepository patientRepo;

    public BillingViewController(InvoiceRepository invoiceRepo, PatientRepository patientRepo) {
        this.invoiceRepo = invoiceRepo;
        this.patientRepo = patientRepo;
    }

    // List billing page (Admin + Receptionist)
    @GetMapping("/billing")
    public String billingPage(HttpSession session, Model model) {
        Object userObj = session.getAttribute("loggedUser");
        if (userObj == null) return "redirect:/login";

        User user = (User) userObj;
        String role = user.getRole();
        if (!"Admin".equalsIgnoreCase(role) && !"Receptionist".equalsIgnoreCase(role)) {
            return "redirect:/"; // unauthorized
        }

        List<Invoice> invoices = invoiceRepo.findAll();

        // Populate patient names
        for (Invoice inv : invoices) {
            if (inv.getPatientId() != null) {
                patientRepo.findById(inv.getPatientId())
                        .ifPresent(p -> inv.setPatientName(p.getFullName()));
            }
        }

        model.addAttribute("invoices", invoices);
        return "billing-list"; // billing-list.ftlh
    }


    // Add invoice form (GET) - shows patients for selection
    @GetMapping("/add-invoice")
    public String addInvoicePage(HttpSession session, Model model) {
        Object userObj = session.getAttribute("loggedUser");
        if (userObj == null) return "redirect:/login";
        User user = (User) userObj;
        if (!"Admin".equalsIgnoreCase(user.getRole()) && !"Receptionist".equalsIgnoreCase(user.getRole())) {
            return "redirect:/";
        }

        List<Patient> patients = patientRepo.findAll();
        model.addAttribute("patients", patients);
        model.addAttribute("paymentMethods", List.of("Cash","Card","GCash","Insurance"));
        model.addAttribute("invoice", new Invoice());
        return "add-invoice";
    }

    // Save new invoice (POST)
    @PostMapping("/add-invoice")
    public String saveInvoice(@ModelAttribute Invoice invoice, HttpSession session) {
        Object userObj = session.getAttribute("loggedUser");
        if (userObj == null) return "redirect:/login";
        User user = (User) userObj;
        if (!"Admin".equalsIgnoreCase(user.getRole()) && !"Receptionist".equalsIgnoreCase(user.getRole())) {
            return "redirect:/";
        }

        if (invoice.getStatus() == null) invoice.setStatus("Unpaid");
        if (invoice.getInvoiceDate() == null) invoice.setInvoiceDate(LocalDate.now());
        // if patientId provided but patientName missing, try to fill
        if (invoice.getPatientId() != null && (invoice.getPatientName() == null || invoice.getPatientName().isBlank())) {
            patientRepo.findById(invoice.getPatientId()).ifPresent(p -> invoice.setPatientName(p.getFullName()));
        }
        invoiceRepo.save(invoice);
        return "redirect:/billing";
    }

    // Edit invoice (GET)
    @GetMapping("/edit-invoice/{id}")
    public String editInvoicePage(@PathVariable Long id, HttpSession session, Model model) {
        Object userObj = session.getAttribute("loggedUser");
        if (userObj == null) return "redirect:/login";
        User user = (User) userObj;
        if (!"Admin".equalsIgnoreCase(user.getRole()) && !"Receptionist".equalsIgnoreCase(user.getRole())) {
            return "redirect:/";
        }

        Invoice invoice = invoiceRepo.findById(id).orElse(null);
        if (invoice == null) return "redirect:/billing";

        model.addAttribute("invoice", invoice);
        model.addAttribute("patients", patientRepo.findAll());
        model.addAttribute("paymentMethods", List.of("Cash","Card","GCash","Insurance"));
        return "edit-invoice";
    }

    // Update invoice (POST)
    @PostMapping("/edit-invoice/{id}")
    public String updateInvoice(@PathVariable Long id, @ModelAttribute Invoice invoice, HttpSession session) {
        Object userObj = session.getAttribute("loggedUser");
        if (userObj == null) return "redirect:/login";
        User user = (User) userObj;
        if (!"Admin".equalsIgnoreCase(user.getRole()) && !"Receptionist".equalsIgnoreCase(user.getRole())) {
            return "redirect:/";
        }

        return invoiceRepo.findById(id).map(existing -> {
            existing.setPatientId(invoice.getPatientId());
            existing.setPatientName(invoice.getPatientName());
            existing.setAmount(invoice.getAmount());
            existing.setStatus(invoice.getStatus());
            existing.setDescription(invoice.getDescription());
            existing.setInvoiceDate(invoice.getInvoiceDate() == null ? LocalDate.now() : invoice.getInvoiceDate());
            existing.setPaymentMethod(invoice.getPaymentMethod());
            invoiceRepo.save(existing);
            return "redirect:/billing";
        }).orElse("redirect:/billing");
    }

    // Delete invoice
    @GetMapping("/delete-invoice/{id}")
    public String deleteInvoice(@PathVariable Long id, HttpSession session) {
        Object userObj = session.getAttribute("loggedUser");
        if (userObj == null) return "redirect:/login";
        User user = (User) userObj;
        if (!"Admin".equalsIgnoreCase(user.getRole()) && !"Receptionist".equalsIgnoreCase(user.getRole())) {
            return "redirect:/";
        }

        if (invoiceRepo.existsById(id)) invoiceRepo.deleteById(id);
        return "redirect:/billing";
    }

    // Mark invoice paid
    @GetMapping("/pay-invoice/{id}")
    public String payInvoice(@PathVariable Long id, HttpSession session) {
        Object userObj = session.getAttribute("loggedUser");
        if (userObj == null) return "redirect:/login";
        User user = (User) userObj;
        if (!"Admin".equalsIgnoreCase(user.getRole()) && !"Receptionist".equalsIgnoreCase(user.getRole())) {
            return "redirect:/";
        }

        invoiceRepo.findById(id).ifPresent(inv -> {
            inv.setStatus("Paid");
            invoiceRepo.save(inv);
        });
        return "redirect:/billing";
    }
}
