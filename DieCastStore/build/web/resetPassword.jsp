<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Reset Password</title>

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            :root {
                --navy-blue: #2c3e50;
                --light-pastel-blue: #a8cfd1;
                --gray-teal: #5c7d7a;
                --deep-sky-blue: #4a90e2;
            }
            body {
                background: linear-gradient(135deg, var(--light-pastel-blue) 0%, #e8f4f8 100%);
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: 'Segoe UI', sans-serif;
            }

            .reset-box {
                background-color: #ffffff;
                padding: 35px 40px;
                border-radius: 16px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 450px;
            }

            .reset-box h2 {
                font-weight: 600;
                color: #0d6efd;
                text-align: center;
                margin-bottom: 25px;
            }

            .form-label {
                font-weight: 500;
            }

            .form-control:focus {
                border-color: #0d6efd;
                box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
            }

            .btn-primary {
                border-radius: 50px;
                padding: 10px;
                font-weight: 500;
            }

            .btn-primary:hover {
                background-color: #0b5ed7;
            }

            .back-link {
                display: inline-block;
                font-size: 1rem;
                font-weight: 500;
                color: #6c757d;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .back-link:hover {
                color: #0d6efd;
                transform: translateX(-3px);
                text-decoration: none;
            }

            .input-group-text {
                background-color: #f1f3f5;
            }
        </style>
    </head>
    <body>
        <div class="reset-box">
            <h2><i class="bi bi-shield-lock-fill me-2"></i>Reset Password</h2>

            <c:if test="${not empty message}">
                <div class="alert alert-danger text-center">${message}</div>
            </c:if>

            <form action="MainController" method="post">
                <input type="hidden" name="action" value="resetPassword">
                <input type="hidden" name="token" value="${param.token}">

                <div class="mb-3">
                    <label for="newPassword" class="form-label">New Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-key-fill"></i></span>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-key-fill"></i></span>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    </div>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-arrow-repeat me-1"></i>Reset Password</button>
                </div>
            </form>

            <div class="text-center mt-4">
                <a href="MainController?action=showLogin" class="back-link">
                    <i class="bi bi-arrow-left-circle me-1"></i>Back to Login
                </a>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- JS Password Validation -->
        <script>
            document.querySelector('form').addEventListener('submit', function (e) {
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                if (newPassword !== confirmPassword) {
                    e.preventDefault();
                    alert('Confirmation password does not match!');
                }
            });
        </script>
    </body>
</html>
