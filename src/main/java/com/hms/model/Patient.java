package com.hms.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "patients")
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String fullName;
    private Integer age;
    private String gender;
    private String contactNumber;
    private String diagnosis;
    private String doctorAssigned;
    private String address;
    private LocalDate admissionDate;
    private String email;

    public Patient() {}

    public Patient(Long id, String fullName, Integer age, String gender, String contactNumber,
                   String diagnosis, String doctorAssigned, String address,
                   LocalDate admissionDate, String email) {
        this.id = id;
        this.fullName = fullName;
        this.age = age;
        this.gender = gender;
        this.contactNumber = contactNumber;
        this.diagnosis = diagnosis;
        this.doctorAssigned = doctorAssigned;
        this.address = address;
        this.admissionDate = admissionDate;
        this.email = email;
    }

    // ✅ Getters & Setters below

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }

    public String getDoctorAssigned() { return doctorAssigned; }
    public void setDoctorAssigned(String doctorAssigned) { this.doctorAssigned = doctorAssigned; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public LocalDate getAdmissionDate() { return admissionDate; }
    public void setAdmissionDate(LocalDate admissionDate) { this.admissionDate = admissionDate; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
