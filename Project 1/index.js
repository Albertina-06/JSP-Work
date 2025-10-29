// Simple client-side "authentication" (NOT SECURE).
// Credentials are hard-coded only for demo purposes.
const VALID_CREDENTIALS = { username: 'user', password: 'pass123' };

document.addEventListener('DOMContentLoaded', () => {
    // If already logged in, go to dashboard
    if (sessionStorage.getItem('loggedIn') === 'true') {
        window.location.href = 'dashboard.html';
    }
});

function handleLogin(event) {
    event.preventDefault();
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value;
    const messageEl = document.getElementById('loginMessage');

    if (username === VALID_CREDENTIALS.username && password === VALID_CREDENTIALS.password) {
        // start a "session" in sessionStorage
        sessionStorage.setItem('loggedIn', 'true');
        sessionStorage.setItem('username', username);
        // redirect to protected page
        window.location.href = 'dashboard.html';
    } else {
        messageEl.textContent = 'Nome de usuário ou senha incorretos.';
        messageEl.style.color = 'red';
    }
}

function handleLogout() {
    sessionStorage.removeItem('loggedIn');
    sessionStorage.removeItem('username');
    window.location.href = 'index.html';
}