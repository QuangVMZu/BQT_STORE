<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="utils.AuthUtils" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Manage Orders</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/CSS/manageOrders.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <c:choose>
            <c:when test="${isLoggedIn}">
                <c:choose>
                    <c:when test="${isAdmin}">
                        <div class="table-container">
                            <h2>Manage All Orders</h2>

                            <c:if test="${not empty message}">
                                <div class="alert alert-info text-center">${message}</div>
                            </c:if>

                            <c:if test="${not empty orders}">
                                <div class="table-responsive">
                                    <table class="table table-hover table-bordered table-striped align-middle">
                                        <thead class="table-dark">
                                            <tr class="text-center">
                                                <th>#</th>
                                                <th>Order ID</th>
                                                <th>Customer ID</th>
                                                <th>Customer add</th>
                                                <th>Order Date</th>
                                                <th>Total ($)</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:set var="i" value="1" />
                                            <c:forEach var="order" items="${orders}">
                                                <c:if test="${order.status ne 'Cancelled'}">
                                                    <tr class="text-center">
                                                        <td>${i}</td>
                                                        <c:set var="i" value="${i + 1}" />
                                                        <td>${order.orderId}</td>
                                                        <td>${order.customerId}</td>
                                                        <td>${order.shippingAddress}</td>
                                                        <td>${order.orderDate}</td>
                                                        <td><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="2" /></td>
                                                        <td>
                                                            <form method="post" action="MainController" class="d-flex justify-content-center align-items-center gap-2">
                                                                <input type="hidden" name="action" value="updateOrderStatus">
                                                                <input type="hidden" name="orderId" value="${order.orderId}">
                                                                <select name="status" class="form-select form-select-sm w-auto">
                                                                    <option value="Pending" <c:if test="${order.status eq 'Pending'}">selected</c:if>>Pending</option>
                                                                    <option value="Processing" <c:if test="${order.status eq 'Processing'}">selected</c:if>>Processing</option>
                                                                    <option value="Shipped" <c:if test="${order.status eq 'Shipped'}">selected</c:if>>Shipped</option>
                                                                    <option value="Delivered" <c:if test="${order.status eq 'Delivered'}">selected</c:if>>Delivered</option>
                                                                    <option value="Cancelled" <c:if test="${order.status eq 'Cancelled'}">selected</c:if>>Cancelled</option>
                                                                    </select>
                                                                    <button type="submit" class="btn btn-sm btn-primary">Save</button>
                                                                </form>
                                                            </td>
                                                            <td>
                                                                <form method="post" action="MainController" onsubmit="return confirm('Hide this order?')">
                                                                    <input type="hidden" name="action" value="updateOrderStatus">
                                                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                                                <input type="hidden" name="status" value="Cancelled">
                                                                <a href="order?action=vieworder&amp;orderId=${order.orderId}" class="btn btn-sm btn-info">View</a>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                            <c:if test="${empty orders}">
                                <div class="alert alert-warning text-center">No orders found.</div>
                            </c:if>

                            <div class="text-center mt-4">
                                <a href="home.jsp" class="btn btn-secondary">← Back to Home</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
                            <h2 class="text-danger">Access Denied</h2>
                            <p class="text-danger">${accessDeniedMessage}</p>
                            <a href="${loginURL}" class="btn btn-primary mt-2">Login Now</a>
                        </div><br>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
                    <h2 class="text-danger">Access Denied</h2>
                    <p class="text-danger">${accessDeniedMessage}</p>
                    <a href="${loginURL}" class="btn btn-primary mt-2">Login Now</a>
                </div><br>
            </c:otherwise>
        </c:choose>

        <jsp:include page="footer.jsp" />
    </body>
</html>
