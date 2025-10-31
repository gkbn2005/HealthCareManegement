package com.hms.controller;

import com.hms.model.Appointment;
import com.hms.model.Invoice;
import com.hms.model.Patient;
import com.hms.repository.AppointmentRepository;
import com.hms.repository.InvoiceRepository;
import com.hms.repository.PatientRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class ReportsController {

    private final PatientRepository patientRepo;
    private final AppointmentRepository appointmentRepo;
    private final InvoiceRepository invoiceRepo;

    public ReportsController(PatientRepository patientRepo,
                             AppointmentRepository appointmentRepo,
                             InvoiceRepository invoiceRepo) {
        this.patientRepo = patientRepo;
        this.appointmentRepo = appointmentRepo;
        this.invoiceRepo = invoiceRepo;
    }

    // VIEW
    @GetMapping("/reports")
    public String reports(@RequestParam(required = false) String start,
                          @RequestParam(required = false) String end,
                          Model model,
                          HttpSession session) {

        LocalDate startDate = parseDateSafely(start);
        LocalDate endDate   = parseDateSafely(end);
        if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
            LocalDate t = startDate;
            startDate = endDate;
            endDate = t;
        }

        List<Patient> patients = patientRepo.findAll();
        List<Appointment> appts = appointmentRepo.findAll();
        List<Invoice> invoices = invoiceRepo.findAll();

        final LocalDate sd = startDate, ed = endDate;

        // Range-filtered lists
        List<Patient> patientsInRange = patients.stream()
                .filter(p -> inRange(patientDate(p), sd, ed))
                .toList();

        List<Appointment> apptsInRange = appts.stream()
                .filter(a -> inRange(apptDate(a), sd, ed))
                .toList();

        List<Invoice> invoicesInRange = invoices.stream()
                .filter(i -> inRange(invoiceDate(i), sd, ed))
                .toList();

        // KPIs
        long totalPatients = patients.size();
        long totalAppointments = appts.size();
        long totalInvoices = invoices.size();

        BigDecimal totalRevenue = invoices.stream()
                .map(this::invoiceAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal revenueInRange = invoicesInRange.stream()
                .map(this::invoiceAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Appointments by doctor (in range)
        Map<String, Long> apptsByDoctor = apptsInRange.stream()
                .collect(Collectors.groupingBy(a -> Optional.ofNullable(a.getDoctor()).orElse("(unknown)"),
                        TreeMap::new, Collectors.counting()));

        // New patients by day (in range)
        Map<LocalDate, Long> newPatientsByDay = patientsInRange.stream()
                .collect(Collectors.groupingBy(this::patientDate, TreeMap::new, Collectors.counting()));

        // Convert to template-friendly rows (avoid map indexing in FTL)
        List<Map<String, Object>> newPatientsByDayList = new ArrayList<>();
        DateTimeFormatter isoFmt = DateTimeFormatter.ISO_DATE;
        for (Map.Entry<LocalDate, Long> e : newPatientsByDay.entrySet()) {
            Map<String, Object> row = new HashMap<>();
            row.put("dateStr", e.getKey() != null ? e.getKey().format(isoFmt) : "");
            row.put("count", e.getValue());
            newPatientsByDayList.add(row);
        }

        // Upcoming appointments next 7 days
        LocalDate today = LocalDate.now();
        List<Appointment> upcoming7 = appts.stream()
                .filter(a -> {
                    LocalDate d = apptDate(a);
                    return d != null && !d.isBefore(today) && !d.isAfter(today.plusDays(7));
                })
                .sorted(Comparator.comparing(this::apptDate, Comparator.nullsLast(Comparator.naturalOrder())))
                .toList();

        // Model
        model.addAttribute("loggedUser", session.getAttribute("loggedUser"));
        model.addAttribute("start", startDate);
        model.addAttribute("end", endDate);

        model.addAttribute("totalPatients", totalPatients);
        model.addAttribute("totalAppointments", totalAppointments);
        model.addAttribute("totalInvoices", totalInvoices);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("revenueInRange", revenueInRange);

        model.addAttribute("apptsByDoctor", apptsByDoctor);
        model.addAttribute("newPatientsByDayList", newPatientsByDayList);
        model.addAttribute("upcoming7", upcoming7);

        model.addAttribute("apptsInRange", apptsInRange);
        model.addAttribute("invoicesInRange", invoicesInRange);
        model.addAttribute("patientsInRange", patientsInRange);

        return "reports";
    }

    // EXPORT CSV
    @GetMapping(value = "/reports/export.csv", produces = "text/csv")
    public ResponseEntity<byte[]> exportCsv(@RequestParam(required = false) String start,
                                            @RequestParam(required = false) String end) {
        LocalDate startDate = parseDateSafely(start);
        LocalDate endDate   = parseDateSafely(end);

        List<Appointment> appts = appointmentRepo.findAll();
        List<Invoice> invoices = invoiceRepo.findAll();
        List<Patient> patients = patientRepo.findAll();

        List<Appointment> apptsInRange = appts.stream()
                .filter(a -> inRange(apptDate(a), startDate, endDate))
                .toList();

        BigDecimal revenueInRange = invoices.stream()
                .filter(i -> inRange(invoiceDate(i), startDate, endDate))
                .map(this::invoiceAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        StringBuilder csv = new StringBuilder();
        csv.append("Hospital Reports");
        if (startDate != null || endDate != null) {
            csv.append(" (")
                    .append(startDate != null ? startDate : "")
                    .append(" to ")
                    .append(endDate != null ? endDate : "")
                    .append(")");
        }
        csv.append("\n\n");

        csv.append("Total Patients,").append(patients.size()).append("\n");
        csv.append("Total Appointments,").append(appts.size()).append("\n");
        csv.append("Total Invoices,").append(invoices.size()).append("\n");
        csv.append("Revenue (range),").append(revenueInRange).append("\n\n");

        csv.append("Appointments In Range\n");
        csv.append("ID,Date,Time,Patient,Doctor\n");
        for (Appointment a : apptsInRange) {
            csv.append(s(a.getId())).append(",");
            csv.append(s(apptDate(a))).append(",");
            csv.append(s(a.getTime())).append(",");
            csv.append(qq(a.getPatientName())).append(",");
            csv.append(qq(a.getDoctor())).append("\n");
        }

        byte[] bytes = csv.toString().getBytes(StandardCharsets.UTF_8);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"hospital-reports.csv\"")
                .contentType(new MediaType("text", "csv", StandardCharsets.UTF_8))
                .body(bytes);
    }

    /* ====================== Helpers (model-friendly) ====================== */

    private LocalDate patientDate(Patient p) {
        try { return p.getAdmissionDate(); } catch (Exception ignore) { return null; }
    }

    private LocalDate apptDate(Appointment a) {
        try { return a.getDate(); } catch (Exception ignore) { return null; }
    }

    private LocalDate invoiceDate(Invoice i) {
        Object value = invokeFirst(i,
                "getDate", "getInvoiceDate", "getBillingDate", "getCreatedAt");
        return toLocalDate(value);
    }

    private BigDecimal invoiceAmount(Invoice i) {
        Object value = invokeFirst(i,
                "getAmount", "getTotal", "getTotalAmount", "getPrice", "getBillAmount");
        return toBigDecimal(value);
    }

    private boolean inRange(LocalDate d, LocalDate start, LocalDate end) {
        if (d == null) return false;
        if (start != null && d.isBefore(start)) return false;
        if (end != null && d.isAfter(end)) return false;
        return true;
    }

    private static String s(Object o) {
        return (o == null) ? "" : String.valueOf(o);
    }

    private static String qq(Object o) {
        String x = s(o);
        return "\"" + x.replace("\"", "\"\"") + "\"";
    }

    private LocalDate parseDateSafely(String v) {
        if (v == null || v.isBlank()) return null;
        try { return LocalDate.parse(v); } catch (Exception e) { return null; }
    }

    private Object invokeFirst(Object target, String... methodNames) {
        for (String m : methodNames) {
            try {
                Method method = target.getClass().getMethod(m);
                return method.invoke(target);
            } catch (Exception ignored) { }
        }
        return null;
    }

    private LocalDate toLocalDate(Object value) {
        if (value == null) return null;
        if (value instanceof LocalDate ld) return ld;
        if (value instanceof java.util.Date d) {
            return d.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        }
        if (value instanceof java.sql.Date sd) {
            return sd.toLocalDate();
        }
        if (value instanceof CharSequence s) {
            String str = s.toString().trim();
            try { return LocalDate.parse(str); } catch (Exception ignore) { }
            for (String pat : new String[]{"yyyy/MM/dd", "MM/dd/yyyy", "dd/MM/yyyy"}) {
                try { return LocalDate.parse(str, DateTimeFormatter.ofPattern(pat)); } catch (Exception ignore) { }
            }
        }
        return null;
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) return BigDecimal.ZERO;
        if (value instanceof BigDecimal bd) return bd;
        if (value instanceof Number n) return BigDecimal.valueOf(n.doubleValue());
        if (value instanceof CharSequence s) {
            String str = s.toString().replace(",", "").trim();
            try { return new BigDecimal(str); } catch (Exception ignore) { }
        }
        return BigDecimal.ZERO;
    }
}
