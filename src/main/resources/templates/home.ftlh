<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Health Care Management Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    :root{
      --brand:#176BFF;
      --brand-2:#22d3ee;
      --ink:#0f172a;
      --muted:#64748b;
      --card-bg:#ffffff;
      --shadow:0 10px 30px rgba(2,6,23,.08);
      --radius:16px;
    }
    body{ background:#f6f8fb; color:var(--ink); }
    .hero{
      background:
        radial-gradient(900px 300px at 20% -20%, rgba(34,211,238,.25), transparent 60%),
        radial-gradient(900px 300px at 100% 0%, rgba(23,107,255,.22), transparent 60%),
        linear-gradient(135deg, #1ea0ff, #176BFF);
      color:#fff;
      border-radius:22px;
      padding:42px 28px;
      margin:28px auto 26px;
      box-shadow: 0 18px 50px rgba(23,107,255,.20);
      position:relative;
      overflow:hidden;
    }
    .hero h1{ font-weight:700; letter-spacing:.3px; }
    .hero .welcome{ opacity:.9; }
    .hero .logout{
      background:#fff; color:#0f172a; border:none; border-radius:12px;
      padding:.4rem .8rem; box-shadow:0 8px 24px rgba(255,255,255,.25);
    }
    .hero .logout:hover{ filter: brightness(0.95); }

    .card-tile{
      background:var(--card-bg);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      transition: transform .18s ease, box-shadow .18s ease;
      height:100%;
    }
    .card-tile:hover{
      transform: translateY(-3px);
      box-shadow: 0 16px 40px rgba(2,6,23,.12);
    }
    .tile-icon{
      width:36px; height:36px; border-radius:10px;
      display:inline-flex; align-items:center; justify-content:center;
      background:#eff6ff;
    }
    .kpi{
      background:var(--card-bg); border-radius:var(--radius); box-shadow:var(--shadow);
    }
    .btn-pill{
      border-radius:999px;
    }
  </style>
</head>
<body class="container">

  <!-- Header / Welcome -->
  <div class="hero">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
      <div>
        <h1 class="h3 mb-1">🏥 Health Care Management System</h1>
        <p class="welcome mb-0">
          <#if loggedUser??>
            Welcome, <strong>${loggedUser.username}</strong>
            (<span class="text-light">${loggedUser.role}</span>)!
          <#else>
            Welcome, Guest
          </#if>
        </p>
      </div>

      <#if loggedUser??>
        <a href="/logout" class="btn logout btn-sm"
           onclick="return confirm('Are you sure you want to log out?');">
          Logout
        </a>
      </#if>
    </div>
  </div>

  <!-- Quick Navigation Cards -->
  <div class="row g-4">

    <div class="col-md-4">
      <div class="card card-tile p-3">
        <div class="card-body text-center">
          <div class="tile-icon mb-2">📋</div>
          <h5 class="card-title mb-1">View Patients</h5>
          <p class="card-text text-muted">Check the patient list and their details.</p>
          <a href="/patient-list" class="btn btn-primary btn-pill px-4">Go</a>
        </div>
      </div>
    </div>

    <div class="col-md-4">
      <div class="card card-tile p-3">
        <div class="card-body text-center">
          <div class="tile-icon mb-2">➕</div>
          <h5 class="card-title mb-1">Add New Patient</h5>
          <p class="card-text text-muted">Register a new patient into the system.</p>
          <a href="/add-patient" class="btn btn-success btn-pill px-4">Add</a>
        </div>
      </div>
    </div>

    <!-- Reports (Admin only) -->
    <#if loggedUser?? && loggedUser.role?lower_case == "admin">
      <div class="col-md-4">
        <div class="card card-tile p-3">
          <div class="card-body text-center">
            <div class="tile-icon mb-2">📊</div>
            <h5 class="card-title mb-1">Reports</h5>
            <p class="card-text text-muted">View and generate reports for hospital activities.</p>
            <a href="/reports" class="btn btn-warning btn-pill px-4">View</a>
          </div>
        </div>
      </div>
    </#if>

    <!-- Billing (Admin + Receptionist only) -->
    <#if loggedUser?? && (loggedUser.role?lower_case == "admin" || loggedUser.role?lower_case == "receptionist")>
      <div class="col-md-4">
        <div class="card card-tile p-3">
          <div class="card-body text-center">
            <div class="tile-icon mb-2">💳</div>
            <h5 class="card-title mb-1">Billing / Invoices</h5>
            <p class="card-text text-muted">View, add, and manage patient invoices.</p>
            <a href="/billing" class="btn btn-info btn-pill px-4 text-white">Open</a>
          </div>
        </div>
      </div>

      <div class="col-md-4">
        <div class="card card-tile p-3">
          <div class="card-body text-center">
            <div class="tile-icon mb-2">🧾</div>
            <h5 class="card-title mb-1">Add Invoice</h5>
            <p class="card-text text-muted">Create a new invoice for a patient.</p>
            <a href="/add-invoice" class="btn btn-success btn-pill px-4">Add</a>
          </div>
        </div>
      </div>
    </#if>

    <!-- Appointments (Admin + Doctor only) -->
    <#if loggedUser?? && (loggedUser.role?lower_case == "admin" || loggedUser.role?lower_case == "doctor")>
      <div class="col-md-4">
        <div class="card card-tile p-3">
          <div class="card-body text-center">
            <div class="tile-icon mb-2">📅</div>
            <h5 class="card-title mb-1">Appointments</h5>
            <p class="card-text text-muted">View, add, and manage appointments.</p>
            <a href="/appointments" class="btn btn-primary btn-pill px-4">Open</a>
          </div>
        </div>
      </div>
    </#if>

  </div>

  <!-- KPIs -->
  <div class="row g-4 mt-1 mb-5">
    <div class="col-md-6">
      <div class="kpi p-3">
        <div class="d-flex justify-content-between align-items-end">
          <div>
            <h6 class="text-muted mb-1">Total Patients</h6>
            <div class="display-6">${patients?size}</div>
          </div>
          <div class="fs-3">👥</div>
        </div>
      </div>
    </div>

    <#if loggedUser?? && (loggedUser.role?lower_case == "admin" || loggedUser.role?lower_case == "receptionist")>
    <div class="col-md-6">
      <div class="kpi p-3">
        <div class="d-flex justify-content-between align-items-end">
          <div>
            <h6 class="text-muted mb-1">Total Invoices</h6>
            <div class="display-6">${invoices?size}</div>
          </div>
          <div class="fs-3">🧾</div>
        </div>
      </div>
    </div>
  </div>
  </#if>

  <!-- Optional global logout confirm (works across pages if you keep the file) -->
  <script src="/logout-confirm.js"></script>
</body>
</html>
