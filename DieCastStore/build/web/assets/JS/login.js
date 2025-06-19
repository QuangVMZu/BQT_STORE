function togglePassword() {
    const passwordInput = document.getElementById("strPassword");
    const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
    passwordInput.setAttribute("type", type);
}