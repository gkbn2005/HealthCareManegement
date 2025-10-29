<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Appointment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2>Edit Appointment</h2>
    <a href="/appointments" class="btn btn-secondary">← Back to Appointments</a>
</div>

<div class="card p-3">
    <#if errorMessage??>
        <div class="alert alert-danger">${errorMessage}</div>
    </#if>

    <form action="/edit-appointment" method="post" class="row g-3">
        <input type="hidden" name="id" value="${appointment.id!}">

        <!-- Patient -->
        <div class="col-md-6">
            <label class="form-label">Patient</label>
            <select name="patientId" class="form-select" required>
                <#list patients as p>
                    <option value="${p.id!}" <#if appointment.patientId == p.id>selected</#if>>
                        ${p.fullName!} (${p.id!})
                    </option>
                </#list>
            </select>
        </div>

        <!-- Doctor -->
        <div class="col-md-6">
            <label class="form-label">Doctor</label>
            <select name="doctor" class="form-select" required>
                <#list doctors as d>
                    <option value="${d.username!}" <#if appointment.doctor == d.username>selected</#if>>
                        ${d.username!}
                    </option>
                </#list>
            </select>
        </div>

        <!-- Date -->
        <div class="col-md-6">
            <label class="form-label">Date</label>
            <input type="date" name="date"
                   value="<#if appointment.date?is_date>${appointment.date?string('yyyy-MM-dd')}<#else>${appointment.date!}</#if>"
                   class="form-control" required>
        </div>

        <!-- Time -->
        <div class="col-md-6">
            <label class="form-label">Time</label>
            <input type="time" name="time"
                   value="<#if appointment.time?is_date>${appointment.time?string('HH:mm')}<#else>${appointment.time!}</#if>"
                   class="form-control" required>
        </div>

        <div class="col-12 mt-3">
            <button type="submit" class="btn btn-primary">Update</button>
            <a href="/appointments" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

</body>
</html>