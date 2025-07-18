<!-- JS Password Validation -->
document.querySelector('form').addEventListener('submit', function (e) {
        const newPassword = document.getElementById('newPassword').value;
const confirmPassword = document.getElementById('confirmPassword').value;
if (newPassword !== confirmPassword) {
    e.preventDefault();
    alert('Confirmation password does not match!');
}
});