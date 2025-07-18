document.addEventListener('DOMContentLoaded', function () {
    document.querySelector('form').addEventListener('submit', function (e) {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (newPassword !== confirmPassword) {
            e.preventDefault();
            alert('Confirmation password does not match!');
        }
    });

    document.querySelectorAll('.toggle-password').forEach(function (eyeIcon) {
        eyeIcon.addEventListener('click', function () {
            const targetId = this.getAttribute('data-target');
            const passwordInput = document.getElementById(targetId);
            const type = passwordInput.getAttribute('type');

            if (type === 'password') {
                passwordInput.setAttribute('type', 'text');
                this.classList.remove('bi-eye-slash');
                this.classList.add('bi-eye');
            } else {
                passwordInput.setAttribute('type', 'password');
                this.classList.remove('bi-eye');
                this.classList.add('bi-eye-slash');
            }
        });
    });
});
