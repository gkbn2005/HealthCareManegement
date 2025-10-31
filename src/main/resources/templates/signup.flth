<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up | HMS</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">

<h2 class="text-center mb-4">🆕 Sign Up</h2>

<div class="card p-4 mx-auto" style="max-width: 420px;">
    <#-- Error or Success flash messages -->
    <#if errorMessage?? && errorMessage?has_content>
        <div class="alert alert-danger">${errorMessage}</div>
    </#if>
    <#if infoMessage?? && infoMessage?has_content>
        <div class="alert alert-success">${infoMessage}</div>
    </#if>

    <form action="/signup" method="post">
        <div class="mb-3">
            <label class="form-label">Username</label>
            <input type="text" name="username" class="form-control" placeholder="Choose a username" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="Enter password" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Confirm Password</label>
            <input type="password" name="confirmPassword" class="form-control" placeholder="Re-enter password" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Role</label>
            <select name="role" class="form-select" required>
                <option value="RECEPTIONIST">Receptionist</option>
                <option value="DOCTOR">Doctor</option>
                <option value="ADMIN">Admin</option>
            </select>
        </div>

        <button type="submit" class="btn btn-success w-100">Create Account</button>
    </form>

    <div class="text-center mt-3">
        Already have an account? <a href="/login">Login here</a>
    </div>
</div>

</body>
</html>
