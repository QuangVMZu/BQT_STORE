<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Orders - BQT STORE</title>
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/orderlist.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <c:choose>
            <c:when test="${isLoggedIn}">
                <div class="container">
                    <h2 class="mb-4">My Orders</h2>

                    <c:if test="${not empty messageCancelOrder}">
                        <div class="alert alert-info">${messageCancelOrder}</div>
                    </c:if>
                    <c:if test="${not empty checkErrorCancelOrder}">
                        <div class="alert alert-info">${checkErrorCancelOrder}</div>
                    </c:if>    

                    <table class="table table-bordered table-hover">
                        <thead class="table-dark text-center">
                            <tr>
                                <th>#</th>
                                <th>Order ID</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Total</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="index" value="0" />
                            <c:forEach var="o" items="${orders}">
                                <c:if test="${o.status ne 'Cancelled'}">
                                    <c:set var="index" value="${index + 1}" />
                                    <tr class="text-center">
                                        <td>${index}</td>
                                        <td>${o.orderId}</td>
                                        <td>${o.orderDate}</td>
                                        <td>
                                            <span class="badge
                                                  ${o.status == 'PENDING' ? 'bg-warning' :
                                                    o.status == 'PROCESSING' ? 'bg-info' :
                                                    o.status == 'SHIPPED' ? 'bg-primary' :
                                                    o.status == 'DELIVERED' ? 'bg-success' :
                                                    o.status == 'CANCELLED' ? 'bg-danger' : 'bg-secondary'}">
                                                      ${o.status}
                                                  </span>
                                            </td>
                                            <td>
                                                $<fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="2" />
                                            </td>
                                            <td>
                                                <a href="order?action=vieworder&amp;orderId=${o.orderId}" class="btn btn-sm btn-info">View</a>
                                                <c:if test="${fn:trim(fn:toLowerCase(o.status)) == 'pending' || fn:trim(fn:toLowerCase(o.status)) == 'processing'}">
                                                    <a href="order?action=cancel&amp;orderId=${o.orderId}"
                                                       onclick="return confirm('Cancel this order?')"
                                                       class="btn btn-sm btn-danger ms-2">Cancel</a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${empty orders}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted">You have no orders.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>

                        <div class="mt-5 text-center">
                            <a href="home.jsp" class="btn btn-secondary mx-auto">← Back to Home Page</a>
                        </div>
                    </div><br>
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
