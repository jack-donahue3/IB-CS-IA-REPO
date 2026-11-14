fetch('/api/auth/me').then(response => {
    if (response.ok) {
        window.location.href = 'index.html';
    }
});

const form = document.getElementById('loginform');

form.addEventListener('submit', async (event) => {
    event.preventDefault();

    const response = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json'},
        body: JSON.stringify({
            email: document.getElementById('email').value,
            password: document.getElementById('password').value
        })
    })
    if (response.ok) {
        window.location.href = 'index.html';
    } else {
        alert('Login failed');
    }
})