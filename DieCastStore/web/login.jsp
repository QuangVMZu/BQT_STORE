<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Login Page</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="assets/css/login.css">
    </head>
    <body>
        <c:if test="${not empty sessionScope.account}">
            <c:redirect url="home.jsp"/>
        </c:if>

        <div class="login-container">
            <div class="login-card">
                <div class="login-header">
                    <h1 class="login-title">Sign in</h1>
                </div>

                <div class="login-body">
                    <!-- Error Messages -->
                    <c:if test="${not empty ban}">
                        <div class="error-alert">
                            <strong>${ban}</strong>
                        </div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="error-alert">
                            <strong>${message}</strong>
                        </div>
                    </c:if>
                    <c:if test="${not empty checkErrorAddToCart}">
                        <div class="error-alert">
                            <strong>${checkErrorAddToCart}</strong>
                        </div>
                    </c:if>
                    <c:if test="${not empty checkErrorPurchase}">
                        <div class="error-alert">
                            <strong>${checkErrorPurchase}</strong>
                        </div>
                    </c:if>
                    <c:if test="${not empty checkError}">
                        <div class="error-alert">
                            <strong>${checkError}</strong>
                        </div>
                    </c:if>

                    <!-- Login Form -->
                    <form action="UserController" method="post">
                        <div class="form-group">
                            <label for="userName" class="form-label">User Name</label>
                            <input type="text" 
                                   class="form-control" 
                                   id="userName" 
                                   name="userName" 
                                   placeholder="Enter User Name" 
                                   required
                                   value="${param.userName}"/>
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Password</label>
                            <div class="input-group">
                                <input type="password" 
                                       class="form-control" 
                                       id="password" 
                                       name="password" 
                                       placeholder="Enter Password" 
                                       required/>
                                <span class="input-group-text" onclick="togglePassword()" style="cursor: pointer; background: #b1d4d6;">
                                    <i class="bi bi-eye" id="toggleIcon"></i>
                                </span>
                            </div>
                        </div>

                        <div class="btn-login">
                            <button type="submit" name="action" value="login" class="btn-signin">
                                Sign In
                            </button>
                        </div>
                    </form>

                    <!-- Register Section -->
                    <div class="register-section">
                        <p class="register-text">Don't have an account?</p>
                        <form action="UserController" method="get">
                            <button type="submit" name="action" value="register" class="btn-register">
                                Create Account
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    <script src="assets/js/login.js"></script>
</html>