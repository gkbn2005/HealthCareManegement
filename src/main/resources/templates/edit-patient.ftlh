<!DOCTYPE html>
<html lang="en">
<head>
    <title>Edit Patient</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>

<body class="container mt-4">

<h2>Edit Patient</h2>
<a href="/patient-list" class="btn btn-secondary mb-3">Back</a>

<form action="/edit-patient/${patient.id}" method="post" class="row g-3">

    <input type="hidden" name="id" value="${patient.id}"/>

    <div class="col-md-6">
        <label class="form-label">Full Name</label>
        <input type="text" name="fullName" value="${patient.fullName}" class="form-control" required>
    </div>

    <div class="col-md-3">
        <label class="form-label">Age</label>
        <input type="number" name="age" value="${patient.age}" class="form-control">
    </div>

    <div class="col-md-3">
        <label class="form-label">Gender</label>
        <select name="gender" class="form-select">
            <option ${patient.gender == "Male"?then("selected","")}>Male</option>
            <option ${patient.gender == "Female"?then("selected","")}>Female</option>
        </select>
    </div>

    <div class="col-md-6">
        <label class="form-label">Diagnosis</label>
        <input type="text" name="diagnosis" value="${patient.diagnosis}" class="form-control">
    </div>

    <div class="col-md-6">
        <label class="form-label">Doctor Assigned</label>
        <input type="text" name="doctorAssigned" value="${patient.doctorAssigned}" class="form-control">
    </div>

    <div class="col-md-6">
        <label class="form-label">Contact Number</label>
        <input type="text" name="contactNumber" value="${patient.contactNumber}" class="form-control">
    </div>

    <div class="col-12">
        <label class="form-label">Address</label>
        <textarea name="address" class="form-control">${patient.address}</textarea>
    </div>

    <div class="col-md-4">
        <label class="form-label">Admission Date</label>
        <input type="date" name="admissionDate"
               value="${patient.admissionDate}" class="form-control">
    </div>

    <div class="col-md-6">
        <label class="form-label">Email</label>
        <input type="email" name="email" value="${patient.email}" class="form-control">
    </div>

    <div class="col-12">
        <button type="submit" class="btn btn-primary">Update</button>
    </div>

</form>

</body>
</html>
