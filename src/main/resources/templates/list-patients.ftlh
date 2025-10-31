<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patients List | Health Care Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --brand: #0d6efd;
            --brand-light: #1ea0ff;
            --background: #f5f8fc;
            --shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            --radius: 14px;
        }

        body {
            background-color: var(--background);
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
            color: #1f2937;
            padding-bottom: 50px;
        }

        /* Header Section */
        .page-header {
            background: linear-gradient(90deg, var(--brand), var(--brand-light));
            color: white;
            padding: 2rem 1rem;
            border-radius: var(--radius);
            margin: 20px auto 30px;
            text-align: center;
            box-shadow: var(--shadow);
        }

        .page-header h2 {
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .page-header p {
            margin: 0;
            font-size: 0.95rem;
        }

        .page-header .btn {
            background-color: #fff;
            color: var(--brand);
            border-radius: 50px;
            padding: 4px 14px;
            font-size: 0.85rem;
            margin-left: 8px;
        }

        /* Buttons Section */
        .action-buttons {
            display: flex;
            justify-content: flex-start;
            gap: 10px;
            margin-bottom: 20px;
        }

        .action-buttons .btn {
            border-radius: 10px;
            padding: 8px 16px;
            font-weight: 500;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            transition: 0.3s;
        }

        .action-buttons .btn:hover {
            transform: translateY(-2px);
            opacity: 0.9;
        }

        /* Table Styling */
        .card {
            border: none;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
        }

        .table {
            border-radius: var(--radius);
            overflow: hidden;
        }

        .table thead {
            background-color: var(--brand);
            color: white;
        }

        .table th {
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 0.3px;
        }

        .table-striped tbody tr:nth-of-type(odd) {
            background-color: #f9fbff;
        }

        .table-hover tbody tr:hover {
            background-color: #eef6ff;
            transition: 0.3s;
        }

        /* Buttons in Table */
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
            border-radius: 8px;
            padding: 4px 10px;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border-radius: 8px;
            padding: 4px 10px;
        }

        .btn-warning:hover, .btn-danger:hover {
            opacity: 0.9;
        }
    </style>
</head>

<body class="container mt-4">

    <!-- Header / Welcome -->
    <div class="page-header">
        <h2>🩺 Patient Records</h2>
        <p>
            <#if loggedUser??>
                Logged in as <strong>${loggedUser.username}</strong> (<span>${loggedUser.role}</span>)

            <#else>
                Welcome, Guest
            </#if>
        </p>
    </div>

    <!-- Navigation Buttons -->
    <div class="action-buttons">
        <a href="/" class="btn btn-secondary">← Back to Dashboard</a>
        <a href="/add-patient" class="btn btn-success">+ Add Patient</a>
    </div>

    <!-- Table Card -->
    <div class="card p-3">
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Age</th>
                    <th>Diagnosis</th>
                    <th>Doctor</th>
                    <th>Admission Date</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <#list patients as p>
                <tr>
                    <td>${p.id!}</td>
                    <td>${p.fullName!}</td>
                    <td>${p.age!}</td>
                    <td>${p.diagnosis!}</td>
                    <td>${p.doctorAssigned!}</td>
                    <td>
                        <#if p.admissionDate??>
                            <#if p.admissionDate?is_date>
                                ${p.admissionDate?string("yyyy-MM-dd")}
                            <#else>
                                ${p.admissionDate}
                            </#if>
                        <#else>
                            N/A
                        </#if>
                    </td>
                    <td>
                        <a href="/edit-patient/${p.id}" class="btn btn-warning btn-sm">Edit</a>
                        <a href="/delete-patient/${p.id}" class="btn btn-danger btn-sm"
                           onclick="return confirm('Delete this record?')">Delete</a>
                    </td>
                </tr>
                </#list>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>
