<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Hospital Reports</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    :root{
      --brand:#0d6efd;          /* Bootstrap primary */
      --card-shadow: 0 10px 30px rgba(0,0,0,.08);
      --header-shadow: 0 12px 40px rgba(13,110,253,.18);
    }
    body{
      background:#f6f8fb;
      font-family: system-ui, -apple-system, "Segoe UI", Roboto, Arial, "Noto Sans", "Apple Color Emoji", "Segoe UI Emoji";
      padding: 24px 0 48px;
    }
    .container{ max-width: 1200px; }
    .page-head{
      background: linear-gradient(180deg, #fff, #f9fbff);
      border:1px solid #eef1f6;
      border-radius: 16px;
      padding: 18px 20px;
      box-shadow: var(--header-shadow);
    }
    .kpi .card{
      border:1px solid #eef1f6;
      border-radius: 16px;
      box-shadow: var(--card-shadow);
    }
    .kpi .display-6{
      font-weight:700;
      color:#1f2937;
    }
    .section-card{
      border:1px solid #eef1f6;
      border-radius: 16px;
      overflow:hidden;
      box-shadow: var(--card-shadow);
      background:#fff;
    }
    .section-card .card-header{
      background:#fff;
      border-bottom:1px solid #eef1f6;
      font-weight:700;
      color:#1f2633;
      padding:14px 18px;
    }
    .table{ margin:0; }
    .table thead th{
      background:#f2f6ff;
      color:#334155;
      border-bottom:1px solid #e6ecf5;
    }
    .table tbody tr:hover{ background:#fcfdff; }
    .btn-rounded{ border-radius: 999px; }
  </style>
</head>
<body>
<div class="container">

  <#-- Build a safe query string for the export button -->
  <#assign qs="">
  <#if (start??) || (end??)>
    <#assign parts=[]>
    <#if start??>
      <#assign parts = parts + ["start=" + (start?string("yyyy-MM-dd"))]>
    </#if>
    <#if end??>
      <#assign parts = parts + ["end=" + (end?string("yyyy-MM-dd"))]>
    </#if>
    <#assign qs = "?" + parts?join("&")>
  </#if>

  <!-- Header -->
  <div class="page-head d-flex justify-content-between align-items-center mb-4">
    <h2 class="m-0 fw-bold text-primary">📊 Hospital Reports</h2>
    <div class="d-flex align-items-center gap-2">
      <a href="/" class="btn btn-secondary btn-rounded">← Back to Dashboard</a>
      <a href="/reports/export.csv${qs}" class="btn btn-outline-success btn-rounded">Export CSV</a>
      <#if loggedUser??>
        <a href="/logout" class="btn btn-light btn-sm btn-rounded" data-logout>Logout</a>
      </#if>
    </div>
  </div>

  <!-- Filters -->
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
      <button class="btn btn-primary btn-rounded px-4">Apply</button>
    </div>
  </form>

  <!-- KPI cards -->
  <div class="row g-3 mb-4 kpi">
    <div class="col-md-3">
      <div class="card text-center">
        <div class="card-body">
          <div class="text-muted small mb-1">Total Patients</div>
          <div class="display-6">${totalPatients}</div>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card text-center">
        <div class="card-body">
          <div class="text-muted small mb-1">Total Appointments</div>
          <div class="display-6">${totalAppointments}</div>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card text-center">
        <div class="card-body">
          <div class="text-muted small mb-1">Total Invoices</div>
          <div class="display-6">${totalInvoices}</div>
        </div>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card text-center">
        <div class="card-body">
          <div class="text-muted small mb-1">Revenue (range)</div>
          <div class="display-6">₱ ${revenueInRange!0}</div>
        </div>
      </div>
    </div>
  </div>

  <div class="row g-4">

    <!-- Appointments by Doctor -->
    <div class="col-lg-6">
      <div class="section-card">
        <div class="card-header">Appointments by Doctor (in range)</div>
        <div class="card-body p-0">
          <table class="table table-hover align-middle">
            <thead>
              <tr><th>Doctor</th><th class="text-end">Count</th></tr>
            </thead>
            <tbody>
            <#if apptsByDoctor?size == 0>
              <tr><td colspan="2" class="text-center text-muted py-3">No data</td></tr>
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

    <!-- New Patients by Day (uses prebuilt list from controller) -->
    <div class="col-lg-6">
      <div class="section-card">
        <div class="card-header">New Patients (by day, in range)</div>
        <div class="card-body p-0">
          <table class="table table-hover align-middle">
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
              <tr><td colspan="2" class="text-center text-muted py-3">No data</td></tr>
            </#if>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Upcoming Appointments -->
    <div class="col-12">
      <div class="section-card">
        <div class="card-header">Upcoming Appointments (next 7 days)</div>
        <div class="card-body p-0">
          <table class="table table-hover align-middle">
            <thead>
              <tr>
                <th>Date</th><th>Time</th><th>Patient</th><th>Doctor</th>
              </tr>
            </thead>
            <tbody>
            <#if upcoming7?size == 0>
              <tr><td colspan="4" class="text-center text-muted py-3">No upcoming appointments</td></tr>
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
</div>

<script src="/logout-confirm.js"></script>
</body>
</html>
