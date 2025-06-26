<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Login Page</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="assets/CSS/login.css">
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
                            <input type="password" 
                                   class="form-control" 
                                   id="password" 
                                   name="password" 
                                   placeholder="Enter Password" 
                                   required/>
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
</html>