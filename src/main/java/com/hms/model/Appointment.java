package com.hms.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "appointments")
public class Appointment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Keep simple references: patientId and patientName for convenience
    private Long patientId;
    private String patientName;
    private String doctor;
    private LocalDate date;
    private LocalTime time;

    public Appointment() {}

    public Appointment(Long id, Long patientId, String patientName, String doctor, LocalDate date, LocalTime time) {
        this.id = id; this.patientId = patientId; this.patientName = patientName; this.doctor = doctor; this.date = date; this.time = time;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getPatientId() { return patientId; }
    public void setPatientId(Long patientId) { this.patientId = patientId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getDoctor() { return doctor; }
    public void setDoctor(String doctor) { this.doctor = doctor; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getTime() { return time; }
    public void setTime(LocalTime time) { this.time = time; }
}
