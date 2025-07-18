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

        <link rel="stylesheet" href="assets/css/resetPassword.css">
        <script src="assets/js/resetPassword.js"></script>
    </head>
    <body>
        <div class="reset-box">
            <h2><i class="bi bi-shield-lock-fill me-2"></i>Reset Password</h2>

            <c:if test="${not empty messageResetPassword}">
                <div class="alert alert-success text-center">${messageResetPassword}</div>
            </c:if>

            <c:if test="${not empty checkErrorResetPassword}">
                <div class="alert alert-danger text-center">${checkErrorResetPassword}</div>
            </c:if>

            <form action="MainController" method="post">
                <input type="hidden" name="action" value="resetPassword">
                <input type="hidden" name="token" value="${param.token}">

                <!-- New Password -->
                <div class="mb-3">
                    <label for="newPassword" class="form-label">New Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-key-fill"></i></span>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        <span class="input-group-text">
                            <i class="bi bi-eye-slash toggle-password" data-target="newPassword" style="cursor: pointer;"></i>
                        </span>
                    </div>
                </div>

                <!-- Confirm Password -->
                <div class="mb-4">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-key-fill"></i></span>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        <span class="input-group-text">
                            <i class="bi bi-eye-slash toggle-password" data-target="confirmPassword" style="cursor: pointer;"></i>
                        </span>
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
    </body>
</html>
