<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patients List | Health Care Management</title>
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
        <h2>Patient Records</h2>
        <p>
            <#if loggedUser??>
                Logged in as <strong>${loggedUser.username}</strong> (<span>${loggedUser.role}</span>)
                <a href="/logout" class="btn btn-light btn-sm ms-2">Logout</a>
            <#else>
                Welcome, Guest
            </#if>
        </p>
    </div>

    <!-- Navigation Buttons -->
    <div class="mb-3">
        <a href="/" class="btn btn-secondary">Back to Dashboard</a>
        <a href="/add-patient" class="btn btn-success">Add Patient</a>
    </div>

    <!-- Table Card -->
    <div class="card card-hover p-3">
        <div class="table-responsive">
            <table class="table table-striped table-bordered mb-0">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Age</th>
                    <th>Diagnosis</th>
                    <th>Doctor</th>
                    <th>Admission Date</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <#list patients as p>
                <tr>
                    <td>${p.id!}</td>
                    <td>${p.fullName!}</td>
                    <td>${p.age!}</td>
                    <td>${p.diagnosis!}</td>
                    <td>${p.doctorAssigned!}</td>
                    <td>
                        <#if p.admissionDate??>
                            <#-- If it's a Date/LocalDate -->
                            <#if p.admissionDate?is_date>
                                ${p.admissionDate?string("yyyy-MM-dd")}
                            <#else>
                                ${p.admissionDate}  <#-- it's already a string -->
                            </#if>
                        <#else>
                            N/A
                        </#if>
                    </td>

                    <td>
                        <a href="/edit-patient/${p.id}" class="btn btn-warning btn-sm">Edit</a>
                        <a href="/delete-patient/${p.id}" class="btn btn-danger btn-sm"
                           onclick="return confirm('Delete this record?')">Delete</a>
                    </td>
                </tr>
                </#list>
                </tbody>

            </table>
        </div>
    </div>

</body>
</html>
