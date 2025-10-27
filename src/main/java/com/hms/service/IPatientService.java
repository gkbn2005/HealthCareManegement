package com.hms.service;

import com.hms.model.Patient;
import java.util.List;

public interface IPatientService {
    List<Patient> findAll();
    Patient addPatient(Patient patient);
}
