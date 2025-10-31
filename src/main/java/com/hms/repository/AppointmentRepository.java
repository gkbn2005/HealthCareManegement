package com.hms.repository;

import com.hms.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {

    // Used for checking if a doctor already has an appointment at a specific date and time
    boolean existsByDoctorAndDateAndTime(String doctor, LocalDate date, LocalTime time);

    // Used to fetch all appointments for a particular patient
    List<Appointment> findByPatientId(Long patientId);
}
