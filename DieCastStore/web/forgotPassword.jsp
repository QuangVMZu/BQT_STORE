<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Forgot Password</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

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
                /*background-color: #e3f2fd;*/
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-family: 'Segoe UI', sans-serif;
            }

            .form-box {
                background: white;
                padding: 40px 35px;
                border-radius: 16px;
                box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
                max-width: 420px;
                width: 100%;
                animation: fadeIn 0.6s ease-in-out;
            }

            .form-title {
                font-size: 28px;
                font-weight: bold;
                margin-bottom: 25px;
                text-align: center;
                color: #0d6efd;
            }

            .form-label {
                font-weight: 500;
                color: #333;
            }

            .form-control {
                border-radius: 10px;
            }

            .btn-primary {
                background-color: #0d6efd;
                border-radius: 10px;
                transition: background 0.3s ease;
            }

            .btn-primary:hover {
                background-color: #0b5ed7;
            }

            .btn-back {
                background-color: #6c757d;
                border-radius: 10px;
                transition: background 0.3s ease;
            }

            .btn-back:hover {
                background-color: #5a6268;
            }

            .alert {
                border-radius: 10px;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>

        <form action="MainController" method="post" class="form-box">
            <input type="hidden" name="action" value="forgotPassword">

            <h2 class="form-title"><i class="bi bi-shield-lock"></i> Forgot Password</h2>

            <c:if test="${not empty message}">
                <div class="alert alert-danger text-center">
                    <i class="bi bi-exclamation-circle-fill"></i> ${message}
                </div>
            </c:if>

            <div class="mb-3">
                <label for="email" class="form-label">Enter your email address</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="name@example.com" required>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-send-fill"></i> Send Reset Email
                </button>
                <button type="button" style="color: #ffffff" class="btn btn-back" onclick="window.location.href = 'MainController?action=showLogin'">
                    <i class="bi bi-arrow-left-circle" style="color: #ffffff; "></i> Back to Login
                </button>
            </div>
        </form>

    </body>
</html>
