<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Login | HMS</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

  <!-- 🎨 Design-only styles -->
  <style>
    :root{
      --primary:#0d6efd;
      --bg1:#0ea5e9;
      --bg2:#6366f1;
      --bg3:#22c55e;
      --glass-bg:rgba(255,255,255,.12);
      --glass-border:rgba(255,255,255,.25);
      --glass-shadow:0 10px 30px rgba(0,0,0,.25);
    }

    /* Animated gradient background */
    body.auth {
      min-height: 100vh;
      margin: 0;
      display: grid;
      place-items: center;
      color: #0b1220;
      background:
        radial-gradient(1200px 600px at 10% -10%, rgba(255,255,255,.35), transparent 60%),
        radial-gradient(1000px 500px at 110% -20%, rgba(255,255,255,.25), transparent 65%),
        linear-gradient(110deg, var(--bg1), var(--bg2) 50%, var(--bg3));
      background-size: 200% 200%, 200% 200%, 200% 200%;
      animation: moveBG 16s ease-in-out infinite alternate;
    }
    @keyframes moveBG{
      0% { background-position: 0% 30%, 100% 10%, 0% 50%; }
      100%{ background-position: 100% 70%, 0% 90%, 100% 50%; }
    }

    /* Faint dot pattern & glow blobs */
    .pattern {
      position: fixed;
      inset: 0;
      pointer-events: none;
      opacity: .25;
      background-image:
        radial-gradient(circle at 8px 8px, rgba(255,255,255,.55) 1px, transparent 2px);
      background-size: 32px 32px;
      mask-image: linear-gradient(to bottom, rgba(0,0,0,.85), rgba(0,0,0,.35));
    }
    .blob{
      position: fixed;
      filter: blur(56px);
      opacity:.45;
      pointer-events: none;
    }
    .blob.b1{ width:420px; height:420px; background:#60a5fa; top:10%; left:5%;  }
    .blob.b2{ width:380px; height:380px; background:#34d399; bottom:8%; right:12%; }
    .blob.b3{ width:300px; height:300px; background:#a78bfa; bottom:18%; left:18%; }

    /* Glassmorphism card */
    .card-glass{
      width: min(92vw, 420px);
      border-radius: 18px;
      background: var(--glass-bg);
      border: 1px solid var(--glass-border);
      box-shadow: var(--glass-shadow);
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      padding: 28px 26px 24px;
    }
    .card-glass .title{
      display:flex; align-items:center; gap:.6rem;
      justify-content:center;
      margin-bottom:.75rem;
      color:#fff;
      text-shadow: 0 1px 10px rgba(0,0,0,.2);
    }
    .lock{
      width:34px;height:34px;border-radius:10px;
      display:grid;place-items:center;
      background:rgba(255,255,255,.2);
      border:1px solid rgba(255,255,255,.35);
      color:#fff;
    }

    /* Inputs & button (visual only) */
    .form-label { color:#eef3ff; opacity:.85; }
    .form-control{
      background: rgba(255,255,255,.9);
      border: 1px solid rgba(0,0,0,.08);
      height: 46px;
    }
    .form-control:focus{
      border-color: var(--primary);
      box-shadow: 0 0 0 .2rem rgba(13,110,253,.2);
      background:#fff;
    }
    .btn-primary{
      background: var(--primary);
      border: none;
      height:46px;
      box-shadow: 0 8px 18px rgba(13,110,253,.35);
    }
    .btn-primary:focus,
    .btn-primary:hover{
      filter: brightness(.95);
      box-shadow: 0 10px 24px rgba(13,110,253,.45);
    }

    .muted{ color:#e8f0ff; opacity:.9; }
    a.link-light{
      color:#fff !important;
      text-decoration: underline;
      text-underline-offset: 3px;
    }
  </style>
</head>

<body class="auth">
  <!-- Background layers (visual only) -->
  <div class="pattern"></div>
  <div class="blob b1"></div>
  <div class="blob b2"></div>
  <div class="blob b3"></div>

  <!-- 🚪 Login card (all original logic retained) -->
  <main class="card-glass">

    <div class="title">
      <div class="lock" aria-hidden="true">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
          <path d="M7 9V7a5 5 0 1110 0v2" stroke="white" stroke-width="2" stroke-linecap="round"/>
          <rect x="5" y="9" width="14" height="12" rx="3" stroke="white" stroke-width="2"/>
          <circle cx="12" cy="15" r="2" fill="white"/>
        </svg>
      </div>
      <h1 class="h3 mb-0">Login</h1>
    </div>

    <!-- ✅ Success message (after successful signup) -->
    <#if infoMessage?? && infoMessage?has_content>
      <div class="alert alert-success py-2 text-center mb-3">${infoMessage}</div>
    </#if>

    <!-- ❌ Error message -->
    <#if error?? && error?has_content>
      <div class="alert alert-danger py-2 text-center mb-3">${error}</div>
    </#if>

    <!-- Original form: action, fields, names, and required kept as-is -->
    <form action="/login" method="post" class="mt-3">
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

    <!-- 🆕 Sign up link (unchanged URL) -->
    <p class="text-center mt-3 muted mb-0">
      Don’t have an account?
      <a href="/signup" class="link-light fw-semibold">Sign up</a>
    </p>
  </main>
</body>
</html>