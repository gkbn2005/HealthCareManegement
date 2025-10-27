<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Patient | Health Care Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .page-header {
            background-color: #0d6efd;
            color: white;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
            text-align: center;
        }
        .card-hover:hover {
            transform: translateY(-5px);
            transition: 0.3s;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body class="container mt-4">

    <!-- Header / Welcome -->
    <div class="page-header">
        <h2>Add Patient</h2>
        <p>
            <#if loggedUser??>
                Logged in as <strong>${loggedUser.username}</strong> (<span>${loggedUser.role}</span>)
                <a href="/logout" class="btn btn-light btn-sm ms-2">Logout</a>
            <#else>
                Welcome, Guest
            </#if>
        </p>
    </div>

    <!-- Back Button -->
    <a href="/" class="btn btn-secondary mb-3">← Back to Dashboard</a>

    <!-- Form Card -->
    <div class="card card-hover p-4">
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

            <div class="col-12 mt-3">
                <button type="submit" class="btn btn-success">Save</button>
                <button type="reset" class="btn btn-warning">Reset</button>
            </div>

        </form>
    </div>

</body>
</html>
