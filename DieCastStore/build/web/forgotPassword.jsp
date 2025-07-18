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
        <link rel="stylesheet" href="assets/css/forgotPassword.css">
    </head>
    <body>
        <form action="MainController" method="post" class="form-box">
            <input type="hidden" name="action" value="forgotPassword">

            <h2 class="form-title"><i class="bi bi-shield-lock"></i> Forgot Password</h2>

            <c:if test="${not empty message}">
                <div class="alert alert-success text-center">
                    <i class="bi bi-exclamation-circle-fill"></i> ${message}
                </div>
            </c:if>
            
            <c:if test="${not empty checkError}">
                <div class="alert alert-danger text-center">
                    <i class="bi bi-exclamation-circle-fill"></i> ${checkError}
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
