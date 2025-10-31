<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Appointment | Health Care Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
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

<div class="page-header">
    <h2>Add Appointment</h2>
    <p>
        <#if loggedUser??>
            Logged in as <strong>${loggedUser.username!}</strong> (<span>${loggedUser.role!}</span>)
            <a href="/logout" class="btn btn-light btn-sm ms-2">Logout</a>
        <#else>
            Welcome, Guest
        </#if>
    </p>
</div>

<a href="/appointments" class="btn btn-secondary mb-3">← Back</a>

<div class="card card-hover p-4">
    <#if errorMessage?? && errorMessage?has_content>
      <div class="alert alert-danger mb-3">${errorMessage}</div>
    </#if>

    <form action="/add-appointment" method="post" class="row g-3">

        <!-- Select Patient -->
        <div class="col-md-6">
            <label class="form-label">Patient</label>
            <select name="patientId" class="form-select" required>
                <#list patients as p>
                    <option value="${p.id!}">
                        ${p.fullName!} (${p.id!})
                    </option>
                </#list>
            </select>
        </div>

        <!-- Select Doctor -->
        <div class="col-md-6">
            <label class="form-label">Doctor</label>
            <select name="doctor" class="form-select" required>
                <#list doctors as d>
                    <option value="${d.username!}">
                        ${d.username!} (${d.role!})
                    </option>
                </#list>
            </select>
        </div>

        <!-- Appointment Date -->
        <div class="col-md-6">
            <label class="form-label">Date</label>
            <input type="date" name="date" class="form-control" required>
        </div>

        <!-- Appointment Time -->
        <div class="col-md-6">
            <label class="form-label">Time</label>
            <input type="time" name="time" class="form-control" required>
        </div>

        <div class="col-12 mt-3">
            <button type="submit" class="btn btn-success">Save</button>
            <button type="reset" class="btn btn-warning">Reset</button>
        </div>

    </form>
</div>

</body>
</html>
