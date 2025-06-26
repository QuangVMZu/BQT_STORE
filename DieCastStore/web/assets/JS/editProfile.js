function togglePassword(fieldId) {
    const passwordField = document.getElementById(fieldId);
    const icon = document.getElementById(fieldId + 'Icon');

    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        icon.className = 'bi bi-eye';
    } else {
        passwordField.type = 'password';
        icon.className = 'bi bi-eye-slash';
    }
}