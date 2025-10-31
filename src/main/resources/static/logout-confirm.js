// logout-confirm.js
// Single, safe, no-double-popup logout confirmation

if (!window.__logoutConfirmInitialized) {
  window.__logoutConfirmInitialized = true;

  function isLogoutUrl(url) {
    if (!url) return false;
    try {
      const a = document.createElement('a');
      a.href = url;
      const path = (a.pathname || url).toLowerCase();
      return path.endsWith('/logout') || path === 'logout' || path.includes('/logout');
    } catch {
      return String(url).toLowerCase().includes('logout');
    }
  }

  // Tracks if the user confirmed logout
  window.__logoutConfirmed = false;

  function confirmLogout(e) {
    if (window.__logoutConfirmed) return;

    e.preventDefault();
    e.stopImmediatePropagation();

    const ok = confirm('Are you sure you want to log out?');
    if (ok) {
      window.__logoutConfirmed = true;

      // If it’s a link, navigate manually
      if (e.target.closest('a')) {
        window.location.href = e.target.closest('a').href;
      }
      // If it’s a form, submit manually
      else if (e.target.closest('form')) {
        e.target.closest('form').submit();
      }
    }
  }

  // Handle clicks on logout links or buttons
  document.addEventListener('click', function (e) {
    const el = e.target.closest('a, button, [data-logout]');
    if (!el) return;

    // Only trigger confirm for logout actions
    if (el.hasAttribute('data-logout') || (el.tagName === 'A' && isLogoutUrl(el.href)) ||
        (el.tagName === 'BUTTON' && el.form && isLogoutUrl(el.form.action))) {
      confirmLogout(e);
    }
  }, true);

  // Handle direct form submissions to logout
  document.addEventListener('submit', function (e) {
    const form = e.target;
    if (form && isLogoutUrl(form.action) && !window.__logoutConfirmed) {
      confirmLogout(e);
    }
  }, true);

  console.debug('✅ logout-confirm.js initialized (no double confirm)');
}
