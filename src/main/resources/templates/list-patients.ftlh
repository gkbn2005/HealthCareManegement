<!DOCTYPE html>
<html lang="en">
<head>
    <title>Patients List</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>

<body class="container mt-4">

<h2>Patient Records</h2>
<a href="/" class="btn btn-secondary mb-3">Home</a>
<a href="/add-patient" class="btn btn-success mb-3">Add Patient</a>

<table class="table table-striped table-bordered">
    <thead class="table-dark">
    <tr>
        <th>ID</th>
        <th>Full Name</th>
        <th>Age</th>
        <th>Diagnosis</th>
        <th>Doctor</th>
        <th>Actions</th>
    </tr>
    </thead>

    <tbody>
    <#list patients as p>
        <tr>
            <td>${p.id}</td>
            <td>${p.fullName}</td>
            <td>${p.age}</td>
            <td>${p.diagnosis}</td>
            <td>${p.doctorAssigned}</td>
            <td>
                <a href="/edit-patient/${p.id}" class="btn btn-warning btn-sm">Edit</a>
                <a href="/delete-patient/${p.id}" class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete this record?')">Delete</a>
            </td>
        </tr>
    </#list>
    </tbody>

</table>

</body>
</html>
