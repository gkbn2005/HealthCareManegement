<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | HMS</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">

<h2 class="text-center mb-4">🔐 Login</h2>

<div class="card p-4 mx-auto shadow-sm" style="max-width: 420px; border-radius: 10px;">

    <!-- ✅ Success message (after successful signup) -->
    <#if infoMessage?? && infoMessage?has_content>
        <div class="alert alert-success text-center mb-3">${infoMessage}</div>
    </#if>

    <!-- ❌ Error message -->
    <#if error?? && error?has_content>
        <div class="alert alert-danger text-center mb-3">${error}</div>
    </#if>

    <form action="/login" method="post">
        <div class="mb-3">
            <label class="form-label">Username</label>
            <input type="text" name="username" class="form-control" placeholder="Enter username" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="Enter password" required>
        </div>

        <button type="submit" class="btn btn-primary w-100 mt-2">Login</button>
    </form>

    <!-- 🆕 Sign up link -->
    <div class="text-center mt-3">
        <p class="mb-0">Don’t have an account?
            <a href="/signup" class="text-decoration-none fw-bold">Sign up</a>
        </p>
    </div>
</div>

</body>
</html>