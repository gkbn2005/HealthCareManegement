<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Add Patient | Health Care Management</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    :root {
      --brand: #0d6efd;
      --light-bg: #f6f8fb;
      --card-radius: 16px;
      --shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    }

    body {
      background: var(--light-bg);
      font-family: 'Segoe UI', Roboto, Arial, sans-serif;
      color: #1f2937;
      padding-bottom: 40px;
    }

    .hero {
      background: linear-gradient(90deg, #0d6efd, #1ea0ff);
      color: #fff;
      border-radius: var(--card-radius);
      padding: 2rem 1rem;
      text-align: center;
      box-shadow: 0 15px 40px rgba(13, 110, 253, 0.25);
      margin: 20px auto 40px;
    }

    .hero h2 {
      font-weight: 700;
      margin-bottom: 0.5rem;
    }

    .hero p {
      font-size: 0.95rem;
      margin-bottom: 0;
    }

    .hero a.btn {
      background: #fff;
      color: #0d6efd;
      border-radius: 50px;
      font-weight: 500;
      padding: 4px 14px;
      font-size: 0.85rem;
    }

    .form-card {
      background: #fff;
      border-radius: var(--card-radius);
      box-shadow: var(--shadow);
      padding: 2rem;
      max-width: 800px;
      margin: auto;
    }

    .form-label {
      font-weight: 500;
    }

    input, select, textarea {
      border-radius: 10px !important;
      border: 1px solid #dee2e6;
    }

    .btn-primary {
      background: var(--brand);
      border: none;
      border-radius: 10px;
      box-shadow: 0 6px 18px rgba(13, 110, 253, 0.3);
    }
    .btn-primary:hover { background: #0b5ed7; }

    .btn-warning {
      border-radius: 10px;
    }

    .btn-secondary {
      border-radius: 10px;
      font-size: 0.9rem;
      padding: 6px 14px;
    }

    .form-section {
      margin-top: 1.5rem;
      border-top: 1px solid #eee;
      padding-top: 1.5rem;
    }

    .form-section h5 {
      font-weight: 600;
      margin-bottom: 1rem;
    }
  </style>
</head>
<body class="container mt-4">

  <!-- Header / Welcome -->
  <div class="hero">
    <h2>🩺 Add New Patient</h2>
    <p>
      <#if loggedUser??>
        Logged in as <strong>${loggedUser.username}</strong> (<span>${loggedUser.role}</span>)
        <a href="/logout" class="btn btn-light btn-sm ms-2">Logout</a>
      <#else>
        Welcome, Guest
      </#if>
    </p>
  </div>

  <!-- Back Button -->
  <div class="text-start mb-3">
    <a href="/" class="btn btn-secondary">← Back to Dashboard</a>
  </div>

  <!-- Form Card -->
  <div class="form-card">
    <form action="/add-patient" method="post" class="row g-3">

      <div class="col-md-6">
        <label class="form-label">Full Name</label>
        <input type="text" name="fullName" class="form-control" placeholder="Enter full name" required>
      </div>

      <div class="col-md-3">
        <label class="form-label">Age</label>
        <input type="number" name="age" class="form-control" min="0" placeholder="Age" required>
      </div>

      <div class="col-md-3">
        <label class="form-label">Gender</label>
        <select name="gender" class="form-select">
          <option>Male</option>
          <option>Female</option>
          <option>Other</option>
        </select>
      </div>

      <div class="col-md-6">
        <label class="form-label">Contact Number</label>
        <input type="text" name="contactNumber" class="form-control" placeholder="e.g. 0912-345-6789">
      </div>

      <div class="col-md-6">
        <label class="form-label">Diagnosis</label>
        <input type="text" name="diagnosis" class="form-control" placeholder="Enter diagnosis" required>
      </div>

      <div class="col-md-6">
        <label class="form-label">Email</label>
        <input type="email" name="email" class="form-control" placeholder="name@example.com">
      </div>

      <div class="col-12">
        <label class="form-label">Address</label>
        <textarea name="address" class="form-control" rows="2" placeholder="Complete address"></textarea>
      </div>

      <div class="col-12 mt-3 d-flex gap-2">
        <button type="submit" class="btn btn-primary px-4">Save</button>
        <button type="reset" class="btn btn-warning px-4">Reset</button>
      </div>

    </form>
  </div>

</body>
</html>
