<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="utils.AuthUtils" %>
<%
    String orderId = (String) request.getAttribute("orderId");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Order Successful - DieCastStore</title>

        <!-- Bootstrap 5 CDN -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet" href="assets/CSS/orderSuccess.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <% if (AuthUtils.isLoggedIn(request)) { %>
        <div class="container d-flex justify-content-center">
            <div class="col-md-8 text-center success-container">
                <div class="check-icon mb-3">&#10003;</div>
                <h2 class="text-success">Order Successful!</h2>
                <p class="text-muted">Thank you for ordering at <strong>BQT STORE</strong>.</p>

                <div class="order-details my-4">
                    <p><strong>Order code:</strong> <%= orderId %></p>
                    <p><strong>Total amount:</strong> <%= String.format("%,.2f", totalAmount) %> $</p>
                    <p class="text-secondary">We will contact you as soon as possible to confirm your order.</p>
                </div>

                <div class="nav-links mt-4">
                    <a href="ProductController?action=list" class="btn btn-primary me-2">Continue Shopping</a>
                    <a href="home.jsp" class="btn btn-outline-secondary">Back to Home Page</a>
                </div>
            </div>
        </div><br>
        <% } else { %>
        <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
            <h2 class="text-danger">Access Denied</h2>
            <p class="text-danger"><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% } %>
        <jsp:include page="footer.jsp" />
    </body>
</html>
