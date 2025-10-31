<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Billing / Invoices</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    :root{
      --brand:#176BFF;
      --ink:#0f172a;
      --muted:#64748b;
      --radius:16px;
      --shadow:0 10px 30px rgba(2,6,23,.08);
    }
    body{ background:#f6f8fb; color:var(--ink); }

    .hero{
      background:
        radial-gradient(900px 300px at 20% -20%, rgba(34,211,238,.25), transparent 60%),
        radial-gradient(900px 300px at 100% 0%, rgba(23,107,255,.22), transparent 60%),
        linear-gradient(135deg, #1ea0ff, #176BFF);
      color:#fff;
      border-radius:22px;
      padding:26px 22px;
      margin:28px auto 20px;
      box-shadow: 0 18px 50px rgba(23,107,255,.20);
    }
    .hero h2{ margin:0; font-weight:700; }
    .hero .sub{ opacity:.9; }

    .toolbar .btn{ border-radius:10px; }
    .card-surface{
      background:#fff; border-radius:var(--radius);
      box-shadow:var(--shadow); border:1px solid #eef2f7;
    }

    .table-responsive{ border-radius:14px; }
    table.table{
      margin-bottom:0;
    }
    thead th{
      position:sticky; top:0; background:#f8fafc; z-index:1;
      font-weight:600;
    }
    tbody tr:hover{ background:#fbfdff; }
    .amount{ text-align:right; white-space:nowrap; }
    .status-pill{
      padding:.35rem .6rem; border-radius:999px; font-size:.82rem; font-weight:600;
    }
    .status-paid{ background:#dcfce7; color:#166534; border:1px solid #bbf7d0; }
    .status-pending{ background:#fff7ed; color:#9a3412; border:1px solid #fed7aa; }
    .status-overdue{ background:#fee2e2; color:#991b1b; border:1px solid #fecaca; }

    .action-btns .btn{ border-radius:8px; }
  </style>
</head>
<body class="container">

  <!-- Header -->
  <div class="hero d-flex justify-content-between align-items-center gap-3">
    <div>
      <h2 class="h4 mb-1">🧾 Invoices</h2>
      <div class="sub">Manage patient billing and payments</div>
    </div>
    <div class="toolbar">
      <a href="/add-invoice" class="btn btn-success me-2">+ Add Invoice</a>
      <a href="/" class="btn btn-light text-dark">← Back</a>
    </div>
  </div>

  <div class="card-surface p-3">
    <div class="table-responsive">
      <table class="table align-middle">
        <thead class="table-light">
          <tr>
            <th style="width:80px;">ID</th>
            <th>Patient</th>
            <th class="text-end" style="width:140px;">Amount</th>
            <th style="width:160px;">Invoice Date</th>
            <th style="width:160px;">Payment Method</th>
            <th style="width:130px;">Status</th>
            <th style="width:230px;">Actions</th>
          </tr>
        </thead>
        <tbody>
          <#list invoices as inv>
            <tr>
              <td class="text-muted">${inv.id!}</td>

              <!-- Patient name (already your behavior) -->
              <td>
                <div class="fw-semibold">${inv.patientName!}</div>
              </td>

              <!-- Amount -->
              <td class="amount">
                ${inv.amount!}
              </td>

              <!-- Invoice Date (keep your robust formatting) -->
              <td>
                <#if inv.invoiceDate??>
                  <#if inv.invoiceDate?is_date>
                    ${inv.invoiceDate?string("yyyy-MM-dd")}
                  <#else>
                    ${inv.invoiceDate!}
                  </#if>
                <#else>
                  -
                </#if>
              </td>

              <td>${inv.paymentMethod!}</td>

              <!-- Status with a pleasant pill look (display-only) -->
              <td>
                <#assign _status = (inv.status!'')?lower_case>
                <#if _status == 'paid'>
                  <span class="status-pill status-paid">Paid</span>
                <#elseif _status == 'overdue'>
                  <span class="status-pill status-overdue">Overdue</span>
                <#elseif _status == 'pending'>
                  <span class="status-pill status-pending">Pending</span>
                <#else>
                  <span class="badge bg-secondary"> ${inv.status!} </span>
                </#if>
              </td>

              <!-- Actions (unchanged behavior) -->
              <td class="action-btns">
                <a href="/edit-invoice/${inv.id}" class="btn btn-sm btn-primary me-1">Edit</a>
                <a href="/delete-invoice/${inv.id}" class="btn btn-sm btn-danger me-1"
                   onclick="return confirm('Are you sure?');">Delete</a>
                <#if inv.status != "Paid">
                  <a href="/pay-invoice/${inv.id}" class="btn btn-sm btn-success">Mark Paid</a>
                </#if>
              </td>
            </tr>
          </#list>

          <#if invoices?size == 0>
            <tr>
              <td colspan="7" class="text-center text-muted py-4">
                No invoices found.
              </td>
            </tr>
          </#if>
        </tbody>
      </table>
    </div>
  </div>

</body>
</html>
