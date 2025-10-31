<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Add Appointment</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      background: linear-gradient(135deg, #e0f2fe, #f8fafc);
      min-height: 100vh;
      font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
      padding-bottom: 56px;
    }

    /* Hero */
    .hero {
      background: #0ea5e9;
      background: linear-gradient(135deg, #2563eb 0%, #0ea5e9 100%);
      color: #fff;
      border-radius: 14px;
      padding: 28px 24px;
      margin: 24px auto 18px;
      text-align: center;
      box-shadow: 0 8px 24px rgba(2, 132, 199, .25);
    }
    .hero h1 {
      font-size: 28px;
      font-weight: 800;
      letter-spacing: .2px;
      margin: 0 0 6px;
    }
    .hero .subtle {
      font-size: 14px;
      opacity: .95;
    }

    /* Card & form */
    .card {
      border: none;
      border-radius: 14px;
      box-shadow: 0 10px 28px rgba(2, 8, 23, .06);
    }
    .form-label {
      font-weight: 600;
      color: #0f172a;
    }
    .form-control, .form-select {
      border-radius: 10px;
      border: 1px solid #cbd5e1;
      transition: border-color .15s ease, box-shadow .15s ease;
    }
    .form-control:focus, .form-select:focus {
      border-color: #2563eb;
      box-shadow: 0 0 0 .2rem rgba(37, 99, 235, .25);
    }

    /* Buttons */
    .btn-secondary {
      background-color: #1e3a8a; border: none;
    }
    .btn-secondary:hover { background-color: #1d4ed8; }
    .btn-primary {
      background-color: #2563eb; border: none;
    }
    .btn-primary:hover { background-color: #1d4ed8; }
    .btn-success { background-color: #16a34a; border: none; }
    .btn-success:hover { background-color: #15803d; }
    .btn-warning { background-color: #f59e0b; border: none; color: #111827; }
    .btn-warning:hover { background-color: #d97706; color: #111827; }

    .alert { border-radius: 10px; }

    /* Layout width */
    .page-wrap { max-width: 1050px; margin: 0 auto; }
  </style>
</head>
<body>

  <div class="page-wrap">

    <!-- Hero header (purely visual) -->
    <div class="hero">
      <h1>➕ Add Appointment</h1>
      <div class="subtle">
        <#if loggedUser??>
          Logged in as <strong>${loggedUser.username!}</strong> (${loggedUser.role!})
          <a href="/logout" class="btn btn-light btn-sm ms-2">Logout</a>
        <#else>
          Please complete the form below
        </#if>
      </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-3">
      <a href="/" class="btn btn-secondary">← Back</a>
    </div>

    <div class="card">
      <div class="card-body p-4">

        <!-- Errors (if any) -->
        <#if errorMessage?? && errorMessage?has_content>
          <div class="alert alert-danger mb-3">${errorMessage}</div>
        </#if>

        <!-- SUCCESS/INFO flash (optional) -->
        <#if infoMessage?? && infoMessage?has_content>
          <div class="alert alert-success mb-3">${infoMessage}</div>
        </#if>

        <!-- ⚠️ FUNCTIONALITY UNCHANGED: same field names & POST target -->
        <form action="/add-appointment" method="post" class="row g-3">

          <!-- Patient -->
          <div class="col-md-6">
            <label class="form-label">Patient</label>
            <select name="patientId" class="form-select" required>
              <#-- expects a `patients` list with id/fullName -->
              <#if patients?? && patients?size gt 0>
                <#list patients as p>
                  <option value="${p.id!}">${p.fullName!} (${p.id!})</option>
                </#list>
              <#else>
                <option disabled selected>No patients found</option>
              </#if>
            </select>
          </div>

          <!-- Doctor -->
          <div class="col-md-6">
            <label class="form-label">Doctor</label>
            <select name="doctor" class="form-select" required>
              <#-- expects a `doctors` list with username/role -->
              <#if doctors?? && doctors?size gt 0>
                <#list doctors as d>
                  <option value="${d.username!}">${d.username!} <#if d.role??>(${d.role!})</#if></option>
                </#list>
              <#else>
                <option disabled selected>No doctors found</option>
              </#if>
            </select>
          </div>

          <!-- Date -->
          <div class="col-md-6">
            <label class="form-label">Date</label>
            <input type="date" name="date" class="form-control" required>
          </div>

          <!-- Time -->
          <div class="col-md-6">
            <label class="form-label">Time</label>
            <input type="time" name="time" class="form-control" required>
          </div>

          <!-- Actions -->
          <div class="col-12 mt-3 d-flex gap-2">
            <button type="submit" class="btn btn-success">Save</button>
            <button type="reset" class="btn btn-warning">Reset</button>
          </div>
        </form>
      </div>
    </div>

  </div>
</body>
</html>
