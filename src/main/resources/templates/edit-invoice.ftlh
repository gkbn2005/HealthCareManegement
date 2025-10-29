<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Invoice</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">

    <!-- Header with Back buttons -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Edit Invoice</h2>
        <div>
            <a href="/" class="btn btn-secondary me-2">← Back to Dashboard</a>
            <a href="/billing" class="btn btn-secondary">← Back to View Invoices</a>
        </div>
    </div>

    <div class="card p-3">
        <form action="/edit-invoice/${invoice.id}" method="post" class="row g-3">

            <input type="hidden" name="id" value="${invoice.id!}">

            <div class="col-md-12">
                <label class="form-label">Patient</label>
                <select name="patientId" class="form-select" required>
                    <#list patients as p>
                        <option value="${p.id}" <#if invoice.patientId == p.id>selected</#if>>
                            ${p.fullName} (${p.id})
                        </option>
                    </#list>
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label">Amount</label>
                <input type="number" step="0.01" name="amount" value="${invoice.amount!}" class="form-control" required>
            </div>

            <div class="col-md-6">
                <label class="form-label">Payment Method</label>
                <select name="paymentMethod" class="form-select" required>
                    <#list paymentMethods as pm>
                        <option value="${pm}" <#if invoice.paymentMethod == pm>selected</#if>>${pm}</option>
                    </#list>
                </select>
            </div>

            <div class="col-12">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control">${invoice.description!}</textarea>
            </div>

            <div class="col-md-6">
                <label class="form-label">Invoice Date</label>
                <input type="date" name="invoiceDate" class="form-control"
                       value="<#if invoice.invoiceDate??>
                                <#if invoice.invoiceDate?is_date>
                                    ${invoice.invoiceDate?string('yyyy-MM-dd')}
                                <#else>
                                    ${invoice.invoiceDate!}
                                </#if>
                             </#if>">
            </div>

            <div class="col-md-6">
                <label class="form-label">Status</label>
                <select name="status" class="form-select">
                    <option value="Unpaid" <#if invoice.status != "Paid">selected</#if>>Unpaid</option>
                    <option value="Paid" <#if invoice.status == "Paid">selected</#if>>Paid</option>
                </select>
            </div>

            <div class="col-12 mt-3">
                <button type="submit" class="btn btn-primary">Update</button>
                <a href="/billing" class="btn btn-secondary">Cancel</a>
            </div>

        </form>
    </div>

</body>
</html>
