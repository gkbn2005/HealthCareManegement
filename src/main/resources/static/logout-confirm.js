// logout-confirm.js
// Show a confirm dialog for ANY logout attempt across the app.

// Helper: does a URL look like it's going to logout?
function isLogoutUrl(url) {
  if (!url) return false;
  try {
    // Support absolute, root-relative, and relative URLs
    const a = document.createElement('a');
    a.href = url;
    // Normalize to pathname if possible
    const path = (a.pathname || url).toLowerCase();
    return path.endsWith('/logout') || path === 'logout' || path.includes('/logout');
  } catch (e) {
    // Fallback: simple includes check
    return String(url).toLowerCase().includes('logout');
  }
}

document.addEventListener('click', function (e) {
  // Match links OR any element you mark with data-logout="true"
  const el = e.target.closest('a, button, [data-logout]');
  if (!el) return;

  // Case 1: explicit marker
  if (el.hasAttribute('data-logout')) {
    if (!confirm('Are you sure you want to log out?')) {
      e.preventDefault();
      e.stopImmediatePropagation();
    }
    return;
  }

  // Case 2: anchor with href that points to logout (absolute or relative)
  if (el.tagName === 'A') {
    const href = el.getAttribute('href');
    if (isLogoutUrl(href)) {
      if (!confirm('Are you sure you want to log out?')) {
        e.preventDefault();
        e.stopImmediatePropagation();
      }
    }
  }
});

// Also catch forms that POST/GET to logout
document.addEventListener('submit', function (e) {
  const form = e.target;
  const action = form && form.getAttribute('action');
  if (isLogoutUrl(action)) {
    if (!confirm('Are you sure you want to log out?')) {
      e.preventDefault();
      e.stopImmediatePropagation();
    }
  }
});
