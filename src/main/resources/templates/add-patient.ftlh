<!DOCTYPE html>
<html lang="en">
<head>
    <title>Add Patient</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>

<body class="container mt-4">
<h2>Add Patient</h2>

<a href="/" class="btn btn-secondary mb-3">Back</a>

<form action="/add-patient" method="post" class="row g-3">

    <div class="col-md-6">
        <label class="form-label">Full Name</label>
        <input type="text" name="fullName" class="form-control" required>
    </div>

    <div class="col-md-3">
        <label class="form-label">Age</label>
        <input type="number" name="age" class="form-control" required>
    </div>

    <div class="col-md-3">
        <label class="form-label">Gender</label>
        <select name="gender" class="form-select">
            <option>Male</option>
            <option>Female</option>
        </select>
    </div>

    <div class="col-md-6">
        <label class="form-label">Contact Number</label>
        <input type="text" name="contactNumber" class="form-control">
    </div>

    <div class="col-md-6">
        <label class="form-label">Diagnosis</label>
        <input type="text" name="diagnosis" class="form-control" required>
    </div>

    <div class="col-md-6">
        <label class="form-label">Doctor Assigned</label>
        <input type="text" name="doctorAssigned" class="form-control" required>
    </div>

    <div class="col-md-6">
        <label class="form-label">Email</label>
        <input type="email" name="email" class="form-control">
    </div>

    <div class="col-12">
        <label class="form-label">Address</label>
        <textarea name="address" class="form-control"></textarea>
    </div>

    <div class="col-md-4">
        <label class="form-label">Admission Date</label>
        <input type="date" name="admissionDate" class="form-control" required>
    </div>

    <div class="col-12">
        <button type="submit" class="btn btn-success">Save</button>
        <button type="reset" class="btn btn-warning">Reset</button>
    </div>

</form>

</body>
</html>
