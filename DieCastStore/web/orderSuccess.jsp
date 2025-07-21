<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Order Successful - BQT STORE</title>

        <!-- Bootstrap 5 CDN -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/orderSuccess.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <c:choose>
            <c:when test="${isLoggedIn}">
                <div class="container d-flex justify-content-center">
                    <div class="col-md-8 text-center success-container">
                        <div class="check-icon mb-3">&#10003;</div>
                        <h2 class="text-success">Order Successful!</h2>
                        <p class="text-muted">Thank you for ordering at <strong>BQT STORE</strong>.</p>

                        <div class="order-details my-4">
                            <p><strong>Order code:</strong> ${orderId}</p>
                            <p><strong>Total amount:</strong> 
                                <fmt:formatNumber value="${totalAmount}" type="number" maxFractionDigits="2" groupingUsed="true"/> $
                            </p>
                            <p class="text-secondary">We will contact you as soon as possible to confirm your order.</p>
                        </div>

                        <div class="nav-links mt-4">
                            <a href="ProductController?action=list" class="btn btn-primary me-2">Continue Shopping</a>
                            <a href="order" class="btn btn-outline-secondary">Back to My order</a>
                        </div>
                    </div>
                </div><br>
            </c:when>
            <c:otherwise>
                <div class="container access-denied text-center mt-5">
                    <h2 class="text-danger">Access Denied</h2>
                    <p class="text-danger">${AuthUtils.getAccessDeniedMessage("login.jsp")}</p>

                    <!-- Chỉ hiện nếu chưa đăng nhập -->
                    <c:if test="${empty sessionScope.user}">
                        <a href="${loginURL}" class="btn btn-primary mt-2">Login Now</a>
                    </c:if>
                </div><br>
            </c:otherwise>
        </c:choose>

        <jsp:include page="footer.jsp" />
    </body>
</html>
