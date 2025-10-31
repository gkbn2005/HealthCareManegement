<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Add Invoice | HMS</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    :root{
      --brand:#176BFF;
      --bg:#f6f8fb;
      --radius:14px;
      --shadow:0 10px 30px rgba(2,6,23,.08);
    }
    body{
      background:var(--bg);
      min-height:100vh;
      color:#0f172a;
    }
    .hero{
      background:
        radial-gradient(900px 300px at 20% -20%, rgba(34,211,238,.25), transparent 60%),
        radial-gradient(900px 300px at 100% 0%, rgba(23,107,255,.22), transparent 60%),
        linear-gradient(135deg, #1ea0ff, #176BFF);
      color:#fff;
      border-radius:22px;
      padding:28px 22px;
      margin:32px auto 24px;
      box-shadow: 0 18px 50px rgba(23,107,255,.20);
    }
    .hero h2{
      font-weight:700; margin:0;
    }

    .form-card{
      background:#fff;
      border-radius:var(--radius);
      box-shadow:var(--shadow);
      border:1px solid #e2e8f0;
      padding:2rem;
      max-width:720px;
      margin:auto;
    }

    label{ font-weight:500; }
    input, select, textarea{
      border-radius:.6rem!important;
    }

    .btn-primary{
      background:var(--brand);
      border:none;
      border-radius:.8rem;
      box-shadow:0 8px 20px rgba(23,107,255,.25);
    }
    .btn-primary:hover{ background:#0f5cf0; }

    .btn-secondary{
      border-radius:.8rem;
      background:#94a3b8;
      border:none;
    }
    .btn-secondary:hover{ background:#64748b; }

    .back-btn{
      background:#475569;
      border:none;
      color:#fff;
      border-radius:.6rem;
      padding:.45rem 1rem;
    }
    .back-btn:hover{ background:#334155; }
  </style>
</head>
<body class="container py-3">

  <!-- Header -->
  <div class="hero d-flex justify-content-between align-items-center">
    <h2 class="h4 mb-0">🧾 Add Invoice</h2>
    <a href="/" class="back-btn">← Back to Dashboard</a>
  </div>

  <!-- Main Form -->
  <div class="form-card">
    <form action="/add-invoice" method="post">

      <!-- Patient Selection -->
      <div class="mb-3">
        <label for="patientName" class="form-label">Select Patient</label>
        <input type="text" id="patientName" name="patientName" class="form-control" placeholder="Type patient name..." required>
      </div>

      <div class="mb-3">
        <label class="form-label text-muted">Or pick from list</label>
        <select name="patientId" class="form-select">
          <option value="">-- choose patient --</option>
          <#list patients as p>
            <option value="${p.id}">${p.fullName}</option>
          </#list>
        </select>
      </div>

      <!-- Amount & Payment -->
      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label">Amount</label>
          <input type="number" name="amount" step="0.01" class="form-control" required>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label">Payment Method</label>
          <select name="paymentMethod" class="form-select">
            <option>Cash</option>
            <option>Card</option>
            <option>Online</option>
          </select>
        </div>
      </div>

      <!-- Description -->
      <div class="mb-3">
        <label class="form-label">Description</label>
        <textarea name="description" class="form-control" rows="3"></textarea>
      </div>

      <!-- Invoice Date -->
      <div class="mb-4">
        <label class="form-label">Invoice Date</label>
        <input type="date" name="invoiceDate" class="form-control" value="${.now?string('yyyy-MM-dd')}">
      </div>

      <div class="d-flex gap-2">
        <button type="submit" class="btn btn-primary">Create Invoice</button>
        <a href="/" class="btn btn-secondary">Cancel</a>
      </div>
    </form>
  </div>

</body>
</html>
