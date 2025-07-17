<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Manage Accounts</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/manageAccounts.css">
    </head>
    <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp" />

        <c:choose>
            <c:when test="${isLoggedIn}">
                <c:choose>
                    <c:when test="${isAdmin}">
                        <div class="table-container">
                            <h2 class="mb-4 text-center text-primary fw-bold">Customer Account Management</h2>

                            <!-- Alert Messages -->
                            <c:choose>
                                <c:when test="${not empty updatedUserId}">
                                    <c:choose>
                                        <c:when test="${not empty checkError}">
                                            <div class="alert alert-danger alert-dismissible fade show text-center shadow-sm rounded" role="alert">
                                                ${checkError}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-success alert-dismissible fade show text-center shadow-sm rounded" role="alert">
                                                ${message}
                                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:when test="${not empty messageiewAccount}">
                                    <div class="alert alert-success alert-dismissible fade show text-center shadow-sm rounded" role="alert">
                                        ${messageiewAccount}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:when>
                                <c:when test="${not empty checkErrorViewAccount}">
                                    <div class="alert alert-danger alert-dismissible fade show text-center shadow-sm rounded" role="alert">
                                        ${checkErrorViewAccount}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:when>
                            </c:choose>

                            <!-- Table -->
                            <table class="table table-hover table-bordered bg-white align-middle">
                                <thead class="table-primary text-center">
                                    <tr>
                                        <th>Customer ID</th>
                                        <th>Customer Name</th>
                                        <th>Address</th>
                                        <th>Current Role</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty accounts}">
                                            <c:forEach var="acc" items="${accounts}">
                                                <c:if test="${acc.role != 1}">
                                                    <c:set var="fullName" value="Unknown" />
                                                    <c:set var="address" value="Unknown" />
                                                    <c:forEach var="cus" items="${customers}">
                                                        <c:if test="${cus.customerId == acc.customerId}">
                                                            <c:set var="fullName" value="${cus.customerName}" />
                                                            <c:set var="address" value="${cus.address}" />
                                                        </c:if>
                                                    </c:forEach>

                                                    <tr>
                                                        <td class="text-center">${acc.customerId}</td>
                                                        <td>${fullName}</td>
                                                        <td>${address}</td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${acc.role == 0}">
                                                                    <span class="badge bg-danger">Banned</span>
                                                                </c:when>
                                                                <c:when test="${acc.role == 1}">
                                                                    <span class="badge bg-primary">Admin</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">User</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <form method="post" action="MainController" class="d-flex align-items-center justify-content-center gap-2">
                                                                <input type="hidden" name="action" value="updateRole" />
                                                                <input type="hidden" name="customerId" value="${acc.customerId}" />
                                                                <select name="role" class="form-select form-select-sm w-auto rounded">
                                                                    <option value="0" <c:if test="${acc.role == 0}">selected</c:if>>0 - Banned</option>
                                                                    <option value="1" <c:if test="${acc.role == 1}">selected</c:if>>1 - Admin</option>
                                                                    <option value="2" <c:if test="${acc.role == 2}">selected</c:if>>2 - User</option>
                                                                    </select>
                                                                    <button type="submit" class="btn btn-sm btn-outline-success rounded px-3">Update</button>
                                                                </form>
                                                            </td>
                                                        </tr>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center text-danger">⚠️ No account data found!</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>

                            <div class="text-center mt-4">
                                <a href="home.jsp" class="btn btn-secondary">← Back to Home</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Not Admin -->
                        <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
                            <h2 class="text-danger">Access Denied</h2>
                            <p>${accessDeniedMessage}</p>
                            <a href="${loginURL}" class="btn btn-primary mt-2">Login Now</a>
                        </div><br>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <!-- Not Logged In -->
                <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
                    <h2 class="text-danger">Access Denied</h2>
                    <p>${accessDeniedMessage}</p>
                    <a href="${loginURL}" class="btn btn-primary mt-2">Login Now</a>
                </div><br>
            </c:otherwise>
        </c:choose>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="footer.jsp" />
    </body>
</html>
