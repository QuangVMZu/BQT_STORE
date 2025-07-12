<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Orders - BQT STORE</title>
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet" href="assets/CSS/orderlist.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <% 
            if (AuthUtils.isLoggedIn(request)) {
        %>
        <div class="container">
            <h2 class="mb-4">🛒 My Orders</h2>

            <%
                String message = (String) request.getAttribute("message");
                List<Order> orders = (List<Order>) request.getAttribute("orders");
                if (message != null) {
            %>
            <div class="alert alert-info"><%= message %></div>
            <% } %>

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
                    <%
                        if (orders != null && !orders.isEmpty()) {
                            int index = 0;
                            for (Order o : orders) {
                            index++;
                                if ("Cancelled".equalsIgnoreCase(o.getStatus())) continue;
                    %>
                    <tr class="text-center">
                        <td><%= index %></td>
                        <td><%= o.getOrderId() %></td>
                        <td><%= o.getOrderDate() %></td>
                        <td><span class="badge bg-<%= "SHIPPED".equalsIgnoreCase(o.getStatus()) || "DELIVERED".equalsIgnoreCase(o.getStatus()) ? "success" : "secondary" %>">
                                <%= o.getStatus() %>
                            </span></td>
                        <td>$<%= String.format("%.2f", o.getTotalAmount()) %></td>
                        <td>
                            <a href="order?action=vieworder&orderId=<%= o.getOrderId() %>" class="btn btn-sm btn-info">View</a>
                            <%
                                String status = o.getStatus();
                                if (!"CANCELLED".equalsIgnoreCase(status) &&
                                    !"SHIPPED".equalsIgnoreCase(status) &&
                                    !"DELIVERED".equalsIgnoreCase(status)) {
                            %>
                            <a href="order?action=cancel&orderId=<%= o.getOrderId() %>"
                               onclick="return confirm('Cancel this order?')"
                               class="btn btn-sm btn-danger ms-2">Cancel</a>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5" class="text-center text-muted">You have no orders.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="mt-5 text-center">
                <a href="home.jsp" class="btn btn-secondary mx-auto">
                    ← Back to Home Page
                </a>
            </div>
        </div><br>
        <% 
                } else { // not LogIned
        %>
        <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
            <h2 class="text-danger">Access Denied</h2>
            <p class="text-danger"><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% } %>
        <jsp:include page="footer.jsp" />
    </body>
</html>
