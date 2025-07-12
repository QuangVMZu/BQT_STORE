<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Order Details - DieCastStore</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/CSS/orderdetail.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <c:choose>
            <c:when test="${isLoggedIn}">
                <div class="container">
                    <c:set var="isCancelable" value="${order.status ne 'CANCELLED' and order.status ne 'SHIPPED' and order.status ne 'DELIVERED'}" />

                    <h2 class="mb-4 text-primary">Order Details - ${order.orderId}</h2>

                    <!-- Order Information -->
                    <div class="card mb-4 shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title mb-3">Order Information</h5>
                            <p><strong>Status:</strong> ${order.status}</p>
                            <p><strong>Date:</strong> ${order.orderDate}</p>

                            <!-- Customer Info -->
                            <div class="card border border-primary-subtle bg-light p-3 mb-3">
                                <h6 class="fw-bold text-primary mb-2">Customer Info</h6>
                                <p class="mb-1"><strong>Customer Name:</strong> <c:out value="${customerName}" default="Unknown"/></p>
                                <p class="mb-1"><strong>Phone Number:</strong> <c:out value="${phone}" default="Unknown"/></p>
                                <p class="mb-2"><strong>Shipping Address:</strong> <c:out value="${address}" default="Unknown"/></p>

                                <c:if test="${not isAdmin and isCancelable}">
                                    <a href="MainController?action=editProfile" class="btn btn-sm btn-outline-primary">
                                        ✏️ Update Information
                                    </a>
                                </c:if>
                            </div>

                            <p class="mt-3">
                                <strong>Total:</strong>
                                <span class="text-success fw-bold">
                                    $<fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="2"/>
                                </span>
                            </p>
                        </div>
                    </div>

                    <!-- Order Details Table -->
                    <table class="table table-bordered table-hover">
                        <thead class="table-light text-center">
                            <tr>
                                <th>Item Type</th>
                                <th>Model ID</th>
                                <th>Quantity</th>
                                <th>Price</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty details}">
                                    <c:forEach var="d" items="${details}">
                                        <tr>
                                            <td>${d.itemType}</td>
                                            <td>${d.itemId}</td>
                                            <td class="text-center">${d.unitQuantity}</td>
                                            <td class="text-end">
                                                $<fmt:formatNumber value="${d.unitPrice * d.unitQuantity}" type="number" maxFractionDigits="2"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="text-center text-muted">No items found in this order.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>

                    <!-- Action Buttons -->
                    <div class="mt-4">
                        <c:choose>
                            <c:when test="${not isAdmin}">
                                <a href="order?action=list" class="btn btn-outline-secondary me-2">← Back to My Orders</a>
                                <c:if test="${isCancelable}">
                                    <a href="order?action=cancel&amp;orderId=${order.orderId}" 
                                       class="btn btn-outline-danger"
                                       onclick="return confirm('Cancel this order?')">Cancel This Order</a>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <div class="d-flex justify-content-center mt-4">
                                    <a href="javascript:history.back()" class="btn btn-secondary">← Back to Manage Orders</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <br>
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
