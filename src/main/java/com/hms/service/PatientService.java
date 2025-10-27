package com.hms.service;

import com.hms.model.Patient;
import com.hms.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PatientService implements IPatientService {

    @Autowired
    private PatientRepository repository;

    @Override
    public List<Patient> findAll() {
        return (List<Patient>) repository.findAll();
    }

    @Override
    public Patient addPatient(Patient patient) {
        return repository.save(patient);
    }
}
