<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Reports</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

<div class="d-flex justify-content-between align-items-center mb-3">
  <h2>📊 Hospital Reports</h2>
  <div>
    <a href="/" class="btn btn-secondary">← Back to Dashboard</a>
    <a
      href="/reports/export.csv<#if start?? || end??>?<#if start??>start=${start?string('yyyy-MM-dd')}</#if><#if end??><#if start??>&</#if>end=${end?string('yyyy-MM-dd')}</#if></#if>"
      class="btn btn-outline-success"
    >Export CSV</a>
    <#if loggedUser??>
      <a href="/logout" class="btn btn-light btn-sm ms-2" data-logout>Logout</a>
    </#if>
  </div>
</div>

<form method="get" action="/reports" class="row g-3 mb-4">
  <div class="col-md-3">
    <label class="form-label">Start date</label>
    <input type="date" name="start" class="form-control"
           value="<#if start??>${start?string('yyyy-MM-dd')}</#if>">
  </div>
  <div class="col-md-3">
    <label class="form-label">End date</label>
    <input type="date" name="end" class="form-control"
           value="<#if end??>${end?string('yyyy-MM-dd')}</#if>">
  </div>
  <div class="col-md-3 d-flex align-items-end">
    <button class="btn btn-primary">Apply</button>
  </div>
</form>

<!-- KPI cards -->
<div class="row g-3 mb-4">
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6 class="text-muted mb-1">Total Patients</h6>
        <div class="display-6">${totalPatients}</div>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6 class="text-muted mb-1">Total Appointments</h6>
        <div class="display-6">${totalAppointments}</div>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6 class="text-muted mb-1">Total Invoices</h6>
        <div class="display-6">${totalInvoices}</div>
      </div>
    </div>
  </div>
  <div class="col-md-3">
    <div class="card text-center">
      <div class="card-body">
        <h6 class="text-muted mb-1">Revenue (range)</h6>
        <div class="display-6">₱ ${revenueInRange!0}</div>
      </div>
    </div>
  </div>
</div>

<div class="row g-4">

  <!-- Appointments by Doctor -->
  <div class="col-lg-6">
    <div class="card">
      <div class="card-header fw-bold">Appointments by Doctor (in range)</div>
      <div class="card-body p-0">
        <table class="table mb-0">
          <thead><tr><th>Doctor</th><th class="text-end">Count</th></tr></thead>
          <tbody>
          <#if apptsByDoctor?size == 0>
            <tr><td colspan="2" class="text-center text-muted">No data</td></tr>
          <#else>
            <#list apptsByDoctor?keys as d>
              <tr>
                <td>${d!''}</td>
                <td class="text-end">${apptsByDoctor[d]!0}</td>
              </tr>
            </#list>
          </#if>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- New Patients by Day (SAFE: uses prebuilt list) -->
  <div class="col-lg-6">
    <div class="card">
      <div class="card-header fw-bold">New Patients (by day, in range)</div>
      <div class="card-body p-0">
        <table class="table mb-0">
          <thead><tr><th>Date</th><th class="text-end">New Patients</th></tr></thead>
          <tbody>
          <#if newPatientsByDayList?has_content>
            <#list newPatientsByDayList as row>
              <tr>
                <td>${row.dateStr!''}</td>
                <td class="text-end">${row.count!0}</td>
              </tr>
            </#list>
          <#else>
            <tr><td colspan="2" class="text-center text-muted">No data</td></tr>
          </#if>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Upcoming Appointments (7 days) -->
  <div class="col-12">
    <div class="card">
      <div class="card-header fw-bold">Upcoming Appointments (next 7 days)</div>
      <div class="card-body p-0">
        <table class="table mb-0">
          <thead>
            <tr>
              <th>Date</th><th>Time</th><th>Patient</th><th>Doctor</th>
            </tr>
          </thead>
          <tbody>
          <#if upcoming7?size == 0>
            <tr><td colspan="4" class="text-center text-muted">No upcoming appointments</td></tr>
          <#else>
            <#list upcoming7 as a>
              <tr>
                <td><#if a.date?is_date>${a.date?string('yyyy-MM-dd')}<#else>${a.date!}</#if></td>
                <td><#if a.time?is_date>${a.time?string('HH:mm')}<#else>${a.time!}</#if></td>
                <td>${a.patientName!}</td>
                <td>${a.doctor!}</td>
              </tr>
            </#list>
          </#if>
          </tbody>
        </table>
      </div>
    </div>
  </div>

</div>

<!-- Global logout confirm -->
<script src="/logout-confirm.js"></script>
</body>
</html>
