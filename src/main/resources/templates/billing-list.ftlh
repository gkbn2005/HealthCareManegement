<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Billing / Invoices</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Invoices</h2>
        <div>
            <a href="/add-invoice" class="btn btn-success">+ Add Invoice</a>
            <a href="/" class="btn btn-secondary">← Back</a>
        </div>
    </div>

    <div class="card p-3">
        <table class="table table-bordered table-hover">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Patient</th>
                    <th>Amount</th>
                    <th>Invoice Date</th>
                    <th>Payment Method</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <#list invoices as inv>
                <tr>
                    <td>${inv.id!}</td>
                    <!-- Show patient name instead of patientId -->
                    <td>${inv.patientName!}</td>
                    <td>${inv.amount!}</td>
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
                    <td>${inv.status!}</td>
                    <td>
                        <a href="/edit-invoice/${inv.id}" class="btn btn-sm btn-primary">Edit</a>
                        <a href="/delete-invoice/${inv.id}" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?');">Delete</a>
                        <#if inv.status != "Paid">
                            <a href="/pay-invoice/${inv.id}" class="btn btn-sm btn-success">Mark Paid</a>
                        </#if>
                    </td>
                </tr>
                </#list>
                <#if invoices?size == 0>
                <tr>
                    <td colspan="7" class="text-center">No invoices found.</td>
                </tr>
                </#if>
            </tbody>
        </table>
    </div>

</body>
</html>
