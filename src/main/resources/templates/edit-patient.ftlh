<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Patient | Health Care Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .page-header {
            background-color: #0d6efd;
            color: white;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
            text-align: center;
        }
        .card-hover:hover {
            transform: translateY(-5px);
            transition: 0.3s;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body class="container mt-4">

    <!-- Header / Welcome -->
    <div class="page-header">
        <h2>Edit Patient</h2>
        <p>
            <#if loggedUser??>
                Logged in as <strong>${loggedUser.username!}</strong> (<span>${loggedUser.role!}</span>)
                <a href="/logout" class="btn btn-light btn-sm ms-2">Logout</a>
            <#else>
                Welcome, Guest
            </#if>
        </p>
    </div>

    <!-- Back Button -->
    <a href="/patient-list" class="btn btn-secondary mb-3">← Back to Patient List</a>

    <!-- Form Card -->
    <div class="card card-hover p-4">
        <form action="/edit-patient/${patient.id!}" method="post" class="row g-3">

            <input type="hidden" name="id" value="${patient.id!}"/>

            <div class="col-md-6">
                <label class="form-label">Full Name</label>
                <input type="text" name="fullName" value="${patient.fullName!}" class="form-control" required>
            </div>

            <div class="col-md-3">
                <label class="form-label">Age</label>
                <input type="number" name="age" value="${patient.age!}" class="form-control" required>
            </div>

            <div class="col-md-3">
                <label class="form-label">Gender</label>
                <select name="gender" class="form-select">
                    <option value="Male" <#if patient.gender?? && patient.gender == "Male">selected</#if>>Male</option>
                    <option value="Female" <#if patient.gender?? && patient.gender == "Female">selected</#if>>Female</option>
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label">Diagnosis</label>
                <input type="text" name="diagnosis" value="${patient.diagnosis!}" class="form-control" required>
            </div>

            <!-- Doctor Dropdown -->
            <div class="col-md-6">
                <label class="form-label">Doctor Assigned</label>
                <select name="doctorAssigned" class="form-select" required>
                    <#list doctors as d>
                        <option value="${d.username}" <#if patient.doctorAssigned == d.username>selected</#if>>
                            ${d.fullName} (${d.username})
                        </option>
                    </#list>
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label">Contact Number</label>
                <input type="text" name="contactNumber" value="${patient.contactNumber!}" class="form-control">
            </div>

            <div class="col-12">
                <label class="form-label">Address</label>
                <textarea name="address" class="form-control">${patient.address!}</textarea>
            </div>

            <div class="col-md-4">
                <label class="form-label">Admission Date</label>
                <input type="date" name="admissionDate" value="${patient.admissionDate!}" class="form-control">
            </div>

            <div class="col-md-6">
                <label class="form-label">Email</label>
                <input type="email" name="email" value="${patient.email!}" class="form-control">
            </div>

            <div class="col-12 mt-3">
                <button type="submit" class="btn btn-primary">Update</button>
                <button type="reset" class="btn btn-warning">Reset</button>
            </div>

        </form>
    </div>

</body>
</html>
