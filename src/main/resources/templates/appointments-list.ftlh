<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Appointments</h2>
    <a href="/" class="btn btn-secondary">← Back to Dashboard</a>
</div>

<!-- Display error messages from redirects (e.g., invalid edit ID) -->
<#if errorMessage?? && errorMessage?has_content>
    <div class="alert alert-danger">${errorMessage}</div>
</#if>

<!-- Optional: support for success/info messages -->
<#if successMessage?? && successMessage?has_content>
    <div class="alert alert-success">${successMessage}</div>
</#if>
<#if infoMessage?? && infoMessage?has_content>
    <div class="alert alert-info">${infoMessage}</div>
</#if>

<!-- Only Admin and Doctor can see Add Appointment button -->
<#if loggedUser?? && (loggedUser.role?lower_case == "admin" || loggedUser.role?lower_case == "doctor")>
    <div class="mb-3">
        <a href="/add-appointment" class="btn btn-success">Add Appointment</a>
    </div>
</#if>

<table class="table table-striped">
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

                <!-- Safe date display -->
                <td>
                    <#if appt.date?is_date>
                        ${appt.date?string("yyyy-MM-dd")}
                    <#else>
                        ${appt.date!}
                    </#if>
                </td>

                <!-- Safe time display -->
                <td>
                    <#if appt.time?is_date>
                        ${appt.time?string("HH:mm")}
                    <#else>
                        ${appt.time!}
                    </#if>
                </td>

                <td>
                    <#if loggedUser?? && (loggedUser.role?lower_case == "admin" || loggedUser.role?lower_case == "doctor")>
                        <!-- Ensure we have a numeric ID -->
                        <#if appt.id?? && appt.id?matches("\\d+")>
                            <!-- Use absolute path for edit and delete routes -->
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
