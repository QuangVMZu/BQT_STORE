<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Register</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" href="assets/css/register.css">
    </head>
    <body>
        <div class="container-fluid py-5">
            <div class="row justify-content-center">
                <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                    <div class="register-container">
                        <div class="card shadow-lg">
                            <div class="card-header">
                                <h1 class="card-title">REGISTER ACCOUNT</h1>
                            </div>
                            <c:if test="${not empty sessionScope.account}">
                                <c:redirect url="home.jsp"/>
                            </c:if>
                            <div class="card-body p-4">
                                <form action="MainController" method="POST" novalidate>
                                    <input type="hidden" name="action" value="register" />

                                    <!-- General Messages - Priority: Empty error should show first -->
                                    <c:if test="${not empty emptyError}">
                                        <div class="alert alert-danger">
                                            ${emptyError}
                                        </div>
                                    </c:if>

                                    <c:if test="${empty emptyError and not empty error}">
                                        <div class="alert alert-danger">
                                            ${error}
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success">
                                            ${success}
                                        </div>
                                    </c:if>

                                    <!-- Username Field -->
                                    <div class="mb-3">
                                        <label for="userName" class="form-label">
                                            Username <span class="required">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="userName" name="userName" 
                                               placeholder="Enter your username" required
                                               value="${param.userName}">
                                        <c:if test="${not empty userNameError and empty emptyError}">
                                            <div class="invalid-feedback">${userNameError}</div>
                                        </c:if>
                                    </div>

                                    <!-- Password Field -->
                                    <div class="mb-3">
                                        <label for="password" class="form-label">
                                            Password <span class="required">*</span>
                                        </label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="password" name="password" 
                                                   placeholder="Enter your password" required>
                                            <button class="btn password-toggle" type="button" onclick="togglePassword('password')">
                                                <i class="fas fa-eye" id="password-icon"></i>
                                            </button>
                                        </div>
                                        <!-- Only show password length error if there's no empty error -->
                                        <c:if test="${not empty lengthError and empty emptyError}">
                                            <div class="invalid-feedback">${lengthError}</div>
                                        </c:if>
                                    </div>

                                    <!-- Confirm Password Field -->
                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">
                                            Confirm Password <span class="required">*</span>
                                        </label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                                   placeholder="Confirm your password" required>
                                            <button class="btn password-toggle" type="button" onclick="togglePassword('confirmPassword')">
                                                <i class="fas fa-eye" id="confirmPassword-icon"></i>
                                            </button>
                                        </div>
                                        <c:if test="${not empty confirmError and empty emptyError}">
                                            <div class="invalid-feedback">${confirmError}</div>
                                        </c:if>
                                    </div>

                                    <!-- Full Name Field -->
                                    <div class="mb-3">
                                        <label for="customerName" class="form-label">
                                            Full Name <span class="required">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="customerName" name="customerName" 
                                               placeholder="Enter your full name" required
                                               value="${param.customerName}">
                                    </div>

                                    <!-- Email Field -->
                                    <div class="mb-3">
                                        <label for="email" class="form-label">
                                            Email <span class="required">*</span>
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               placeholder="Enter your email address" required
                                               value="${param.email}">
                                        <c:if test="${not empty emailError and empty emptyError}">
                                            <div class="invalid-feedback">${emailError}</div>
                                        </c:if>
                                    </div>

                                    <!-- Phone Field -->
                                    <div class="mb-3">
                                        <label for="phone" class="form-label">
                                            Phone <span class="required">*</span>
                                        </label>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               placeholder="Enter your phone number" required
                                               value="${param.phone}">
                                        <c:if test="${not empty phoneError and empty emptyError}">
                                            <div class="invalid-feedback">${phoneError}</div>
                                        </c:if>
                                        <c:if test="${not empty phoneMessage}">
                                            <div class="alert alert-info mt-2 py-2">
                                                ${phoneMessage}
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Address Field -->
                                    <div class="mb-4">
                                        <label for="address" class="form-label">
                                            Address <span class="required">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="address" name="address" 
                                               placeholder="Enter your address" required
                                               value="${param.address}">
                                    </div>

                                    <!-- Submit Buttons -->
                                    <div class="row g-3">
                                        <div class="col-md-8">
                                            <button type="submit" class="btn btn-primary w-100">
                                                Register
                                            </button>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="reset" class="btn btn-secondary w-100">
                                                Reset
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Password Toggle Script -->
        <script src="assets/js/register.js"></script>
    </body>
</html>
