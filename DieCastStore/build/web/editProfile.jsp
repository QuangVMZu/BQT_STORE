
<%-- 
    Document   : editProfile
    Created on : Jun 18, 2025, 9:00:40 PM
    Author     : hqthi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Edit Profile</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="assets/CSS/editProfile.css">
    </head>
    <body>
        <c:if test="${empty sessionScope.account}">
            <c:redirect url="login.jsp"/>
        </c:if>

        <div class="edit-container">
            <h1 class="page-title">Edit Profile</h1>

            <div class="cards-row">
                <!-- Profile Information Section -->
                <div class="edit-card profile-card">
                    <div class="card-header">
                        <h3>Profile Information</h3>
                    </div>
                    <div class="card-body">
                        <!-- Success and Error Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">
                                ${success}
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <strong>Error:</strong> ${error}
                            </div>
                        </c:if>
                        <c:if test="${not empty updateError}">
                            <div class="alert alert-danger">
                                <strong>Update Error:</strong> ${updateError}
                            </div>
                        </c:if>

                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="updateProfile">

                            <div class="row">
                                <div class="col-md-6">
                                    <!-- Username (Read Only) -->
                                    <div class="form-group">
                                        <label for="userName" class="form-label">Username <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="userName" name="userName" 
                                               value="${account.userName}" readonly/>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <!-- Customer ID (Read Only) -->
                                    <div class="form-group">
                                        <label for="customerId" class="form-label">Customer ID <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="customerId" name="customerId" 
                                               value="${account.customerId}" readonly/>
                                    </div>
                                </div>
                            </div>

                            <!-- Full Name -->
                            <div class="form-group">
                                <label for="customerName" class="form-label">Full Name <span class="required">*</span></label>
                                <input type="text" class="form-control" id="customerName" name="customerName" 
                                       value="${not empty param.customerName ? param.customerName : customer.customerName}" required/>
                                <c:if test="${not empty nameError}">
                                    <div class="error-message">${nameError}</div>
                                </c:if>
                            </div>

                            <!-- Email -->
                            <div class="form-group">
                                <label for="email" class="form-label">Email <span class="required">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${not empty param.email ? param.email : customer.email}" required/>
                                <c:if test="${not empty emailError}">
                                    <div class="error-message">${emailError}</div>
                                </c:if>
                            </div>

                            <!-- Phone -->
                            <div class="form-group">
                                <label for="phone" class="form-label">Phone <span class="required">*</span></label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       value="${not empty param.phone ? param.phone : customer.phone}" required/>
                                <c:if test="${not empty phoneError}">
                                    <div class="error-message">${phoneError}</div>
                                </c:if>
                                <c:if test="${not empty phoneMessage}">
                                    <div class="alert alert-info mt-2">
                                        ${phoneMessage}
                                    </div>
                                </c:if>
                            </div>

                            <!-- Address -->
                            <div class="form-group">
                                <label for="address" class="form-label">Address <span class="required">*</span></label>
                                <textarea class="form-control" id="address" name="address" rows="3" required>${not empty param.address ? param.address : customer.address}</textarea>
                                <c:if test="${not empty addressError}">
                                    <div class="error-message">${addressError}</div>
                                </c:if>
                            </div>

                            <!-- Action Button -->
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary">Update Profile</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Password Change Section -->
                <div class="edit-card password-card">
                    <div class="card-header">
                        <h3>Change Password</h3>
                    </div>
                    <div class="card-body">
                        <!-- Password Change Messages -->
                        <c:if test="${not empty successChanging}">
                            <div class="alert alert-success">
                                ${successChanging}
                            </div>
                        </c:if>
                        <c:if test="${not empty changeError}">
                            <div class="alert alert-danger">
                                <strong>Password Change Error:</strong> ${changeError}
                            </div>
                        </c:if>
                        <c:if test="${not empty passwordMessage}">
                            <div class="alert alert-info">
                                ${passwordMessage}
                            </div>
                        </c:if>

                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="changePassword">

                            <div class="form-group">
                                <label for="oldPassword" class="form-label">Current Password</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="oldPassword" name="oldPassword"/>
                                    <button type="button" class="password-toggle" onclick="togglePassword('oldPassword')">
                                        <i class="bi bi-eye-slash" id="oldPasswordIcon"></i>
                                    </button>
                                </div>
                                <c:if test="${not empty oldPasswordError}">
                                    <div class="error-message">${oldPasswordError}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="newPassword" class="form-label">New Password</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="newPassword" name="newPassword"/>
                                    <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                                        <i class="bi bi-eye-slash" id="newPasswordIcon"></i>
                                    </button>
                                </div>
                                <c:if test="${not empty passwordError}">
                                    <div class="error-message">${passwordError}</div>
                                </c:if>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"/>
                                    <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                        <i class="bi bi-eye-slash" id="confirmPasswordIcon"></i>
                                    </button>
                                </div>
                                <c:if test="${not empty confirmError}">
                                    <div class="error-message">${confirmError}</div>
                                </c:if>
                            </div>

                            <!-- Action Button -->
                            <div class="text-center">
                                <button type="submit" class="btn btn-secondary">Change Password</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Return Button -->
            <div class="return-section">
                <a href="MainController?action=viewProfile" class="btn-return">Return to Profile</a>
            </div>
        </div>
        
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Password Toggle Script -->
        <script src="assets/JS/editProfile.js"></script>
    </body>
</html>
