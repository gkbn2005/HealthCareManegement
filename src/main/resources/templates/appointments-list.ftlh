<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #e0f2fe, #f8fafc);
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
        }

        h2 {
            font-weight: 700;
            color: #0f172a;
        }

        .btn-secondary {
            background-color: #1e3a8a;
            border: none;
        }

        .btn-secondary:hover {
            background-color: #1d4ed8;
        }

        .btn-success {
            background-color: #059669;
            border: none;
        }

        .btn-success:hover {
            background-color: #047857;
        }

        .btn-primary {
            background-color: #2563eb;
            border: none;
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
        }

        .btn-danger {
            background-color: #dc2626;
            border: none;
        }

        .btn-danger:hover {
            background-color: #b91c1c;
        }

        .table {
            background-color: #ffffff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        thead {
            background-color: #2563eb;
            color: #ffffff;
        }

        tbody tr:hover {
            background-color: #f1f5f9;
        }

        .alert {
            border-radius: 8px;
        }

        .card {
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>

<body class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>📅 Appointments</h2>
        <a href="/" class="btn btn-secondary">← Back to Dashboard</a>
    </div>

    <#-- Display error messages -->
    <#if errorMessage?? && errorMessage?has_content>
        <div class="alert alert-danger">${errorMessage}</div>
    </#if>

    <#-- Add Appointment Button -->
    <#if loggedUser?? && (loggedUser.role?lower_case == "admin" || loggedUser.role?lower_case == "doctor")>
        <div class="mb-3">
            <a href="/add-appointment" class="btn btn-success">➕ Add Appointment</a>
        </div>
    </#if>

    <table class="table table-striped table-hover align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>Patient</th>
                <th>Doctor</th>
                <th>Date</th>
                <th>Time</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <#list appointments as appt>
                <tr>
                    <td>${appt.id!}</td>
                    <td>${appt.patientName!} (${appt.patientId!})</td>
                    <td>${appt.doctor!}</td>

                    <td>
                        <#if appt.date?is_date>
                            ${appt.date?string("yyyy-MM-dd")}
                        <#else>
                            ${appt.date!}
                        </#if>
                    </td>

                    <td>
                        <#if appt.time?is_date>
                            ${appt.time?string("HH:mm")}
                        <#else>
                            ${appt.time!}
                        </#if>
                    </td>

                    <td>
                        <#if loggedUser?? && (loggedUser.role?lower_case == "admin" || loggedUser.role?lower_case == "doctor")>
                            <#if appt.id?? && appt.id?matches("\\d+")>
                                <a href="/appointments/${appt.id}/edit" class="btn btn-primary btn-sm">Edit</a>
                                <a href="/delete-appointment/${appt.id}" class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete appointment #${appt.id}?');">Delete</a>
                            <#else>
                                <span class="text-muted">Invalid ID</span>
                            </#if>
                        </#if>
                    </td>
                </tr>
            </#list>
        </tbody>
    </table>

</body>
</html>
