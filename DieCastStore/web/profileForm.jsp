<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>My Profile</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="assets/CSS/profileForm.css">
    </head>
    <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp" />
        <!-- Kiểm tra đăng nhập -->
        <c:if test="${empty sessionScope.account}">
            <c:redirect url="login.jsp"/>
        </c:if>

        <div class="profile-container">
            <div class="profile-header">
                <h1 class="profile-title">My Profile</h1>
            </div>

            <!-- Hiển thị thông báo lỗi -->
            <c:if test="${not empty error}">
                <div class="error-alert">
                    <strong>Error:</strong> ${error}
                </div>
            </c:if>

            <!-- Profile Information -->
            <c:if test="${not empty account and not empty customer}">
                <div class="profile-card">
                    <div class="card-header">
                        <h3>Account Information</h3>
                    </div>
                    <table class="table info-table mb-0">
                        <tr>
                            <th>Username:</th>
                            <td>${account.userName}</td>
                        </tr>
                        <tr>
                            <th>Customer ID:</th>
                            <td>${account.customerId}</td>
                        </tr>
                    </table>
                </div>

                <div class="profile-card">
                    <div class="card-header">
                        <h3>Personal Information</h3>
                    </div>
                    <table class="table info-table mb-0">
                        <tr>
                            <th>Customer ID:</th>
                            <td>${customer.customerId}</td>
                        </tr>
                        <tr>
                            <th>Customer Name:</th>
                            <td>${customer.customerName}</td>
                        </tr>
                        <tr>
                            <th>Email:</th>
                            <td>${customer.email}</td>
                        </tr>
                        <tr>
                            <th>Phone:</th>
                            <td>${customer.phone}</td>
                        </tr>
                        <tr>
                            <th>Address:</th>
                            <td>${customer.address}</td>
                        </tr>
                    </table>
                </div>
            </c:if>

            <!-- Navigation -->
            <div class="navigation-section">
                <form action="MainController" method="get" style="display: inline-block;">
                    <input type="hidden" name="action" value="editProfile">
                    <input type="submit" value="Edit Profile | Change Password" class="nav-btn">
                </form>
                <form action="MainController" method="get" style="display: inline-block;">
                    <input type="submit" value="← Back to Home" class="nav-btn btn-home">
                </form>
            </div>
        </div>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="footer.jsp" />
    </body>
</html>
