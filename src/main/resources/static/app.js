async function init() {
    const response = await fetch('/api/auth/me');
    if (!response.ok) {
        window.location.href = 'login.html';
        return;
    }
    const user = await response.json();
    document.getElementById('user-name').textContent = user.firstName + ' ' + user.lastName;
    loadAssignments();
}

//get assignments for user and display them
async function loadAssignments() {
    const response = await fetch('/api/assignments');
    const assignments = await response.json();

    const list = document.getElementById('assignments-list');
    list.innerHTML = '';

    for (const a of assignments) {
        const li = document.createElement('li');
        li.textContent = a.title + ' (' + a.points + ' points) ';

        const deleteButton = document.createElement('button');
        deleteButton.textContent = 'Delete';
        deleteButton.addEventListener('click', async () => {
            await fetch(`/api/assignments/${a.id}`, { method: 'DELETE' });
            loadAssignments();
        });
        li.appendChild(deleteButton);
        list.appendChild(li);

    }
}

//create assignment
document.getElementById('create-assignment-form').addEventListener('submit', async (e) => {
    e.preventDefault();

    const response = await fetch('/api/assignments', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            title: document.getElementById('title').value,
            description: document.getElementById('description').value,
            dueDate: document.getElementById('dueDate').value,
            points: document.getElementById('points').value
        })
    });
    if (response.ok) {
        loadAssignments();
    }
    else {
        alert(await response.text());
    }
});

//logout
document.getElementById('logout-button').addEventListener('click', async () => {
    await fetch('/api/auth/logout', { method: 'POST' });
    window.location.href = 'login.html';
});

init();