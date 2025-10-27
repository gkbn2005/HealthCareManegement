package com.hms.repository;
import com.hms.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByDoctorAndDateAndTime(String doctor, LocalDate date, LocalTime time);
    List<Appointment> findByPatientId(Long patientId);
}
