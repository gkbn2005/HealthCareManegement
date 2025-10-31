<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Appointment</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      background: linear-gradient(135deg, #e0f2fe, #f8fafc);
      min-height: 100vh;
      font-family: 'Segoe UI', sans-serif;
      padding-bottom: 50px;
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

    .btn-primary {
      background-color: #2563eb;
      border: none;
    }

    .btn-primary:hover {
      background-color: #1d4ed8;
    }

    .btn-outline-secondary {
      color: #475569;
      border-color: #cbd5e1;
    }

    .btn-outline-secondary:hover {
      background-color: #f1f5f9;
    }

    .card {
      border: none;
      border-radius: 12px;
      box-shadow: 0 4px 14px rgba(0, 0, 0, 0.08);
      background: #ffffff;
    }

    .form-label {
      font-weight: 600;
      color: #1e293b;
    }

    .form-control, .form-select {
      border-radius: 8px;
      border: 1px solid #cbd5e1;
      transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    .form-control:focus, .form-select:focus {
      border-color: #2563eb;
      box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
    }

    .alert {
      border-radius: 8px;
    }

    .container {
      max-width: 850px;
    }
  </style>
</head>

<body class="container mt-4">

  <div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="mb-0">✏️ Edit Appointment</h2>
    <a href="/appointments" class="btn btn-secondary">← Back to Appointments</a>
  </div>

  <div class="card">
    <div class="card-body p-4">
      <#if errorMessage?? && errorMessage?has_content>
        <div class="alert alert-danger mb-3">${errorMessage}</div>
      </#if>

      <!-- IMPORTANT: post to /appointments/{id}/edit -->
      <form action="/appointments/${appointment.id}/edit" method="post" class="row g-3">
        <input type="hidden" name="id" value="${appointment.id!}"/>

        <!-- Patient -->
        <div class="col-md-6">
          <label class="form-label">Patient</label>
          <select name="patientId" class="form-select" required>
            <#list patients as p>
              <#assign selectedById = (appointment.patientId?? && appointment.patientId == p.id)>
              <#assign selectedByObj = (appointment.patient?? && appointment.patient.id == p.id)>
              <option value="${p.id!}" <#if selectedById || selectedByObj>selected</#if>>
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
              <option value="${d.username!}" <#if appointment.doctor?? && appointment.doctor == d.username>selected</#if>>
                ${d.username!}
              </option>
            </#list>
          </select>
        </div>

        <!-- Date -->
        <div class="col-md-6">
          <label class="form-label">Date</label>
          <input
            type="date"
            name="date"
            class="form-control"
            required
            value="<#if appointment.date?is_date>${appointment.date?string('yyyy-MM-dd')}<#else>${appointment.date!}</#if>">
        </div>

        <!-- Time -->
        <div class="col-md-6">
          <label class="form-label">Time</label>
          <input
            type="time"
            name="time"
            class="form-control"
            required
            value="<#if appointment.time?is_date>${appointment.time?string('HH:mm')}<#else>${appointment.time!}</#if>">
        </div>

        <div class="col-12 mt-3">
          <button type="submit" class="btn btn-primary">💾 Update</button>
          <a href="/appointments" class="btn btn-outline-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </div>

</body>
</html>
