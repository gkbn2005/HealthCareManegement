<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Health Care Management Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .dashboard-header {
            background-color: #0d6efd;
            color: white;
            padding: 2rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
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
    <div class="dashboard-header text-center">
        <h1>🏥 Health Care Management System</h1>
        <p class="lead">
            <#if loggedUser??>
                Welcome, <strong>${loggedUser.username}</strong> (<span>${loggedUser.role}</span>)!
                <a href="/logout" class="btn btn-light btn-sm ms-2">Logout</a>
            <#else>
                Welcome, Guest
            </#if>
        </p>
    </div>

    <!-- Quick Navigation Cards -->
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card card-hover text-center p-3">
                <div class="card-body">
                    <h5 class="card-title">View Patients</h5>
                    <p class="card-text">Check the patient list and their details.</p>
                    <a href="/patient-list" class="btn btn-primary">Go</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-hover text-center p-3">
                <div class="card-body">
                    <h5 class="card-title">Add New Patient</h5>
                    <p class="card-text">Register a new patient into the system.</p>
                    <a href="/add-patient" class="btn btn-success">Add</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-hover text-center p-3">
                <div class="card-body">
                    <h5 class="card-title">Reports</h5>
                    <p class="card-text">View and generate reports for hospital activities.</p>
                    <a href="#" class="btn btn-warning">View</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Optional stats section -->
    <div class="row mt-5">
        <div class="col-md-6">
            <div class="card p-3">
                <div class="card-body">
                    <h5 class="card-title">Total Patients</h5>
                    <p class="card-text display-6">
                        ${patients?size!0} <!-- If patients list is not passed, defaults to 0 -->
                    </p>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card p-3">
                <div class="card-body">
                    <h5 class="card-title">User Role</h5>
                    <p class="card-text display-6">
                        <#if loggedUser??>${loggedUser.role}<#else>Guest</#if>
                    </p>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
