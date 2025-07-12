<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="utils.AuthUtils" %>
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
        <% 
            if (AuthUtils.isLoggedIn(request)) {
        %>
        <div class="container">
            <%
                Order order = (Order) request.getAttribute("order");
                List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
                String customerName = (String) request.getAttribute("customerName");
                String phone = (String) request.getAttribute("phone");
                String address = (String) request.getAttribute("address");
                boolean isAdmin = AuthUtils.isAdmin(request);
                boolean isCancelable = !"CANCELLED".equalsIgnoreCase(order.getStatus()) &&
                                       !"SHIPPED".equalsIgnoreCase(order.getStatus()) &&
                                       !"DELIVERED".equalsIgnoreCase(order.getStatus());
            %>

            <h2 class="mb-4 text-primary">Order Details - <%= order.getOrderId() %></h2>

            <!-- Order Information -->
            <div class="card mb-4 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title mb-3">Order Information</h5>
                    <p><strong>Status:</strong> <%= order.getStatus() %></p>
                    <p><strong>Date:</strong> <%= order.getOrderDate() %></p>

                    <!-- Customer Info Card Inside -->
                    <div class="card border border-primary-subtle bg-light p-3 mb-3">
                        <h6 class="fw-bold text-primary mb-2">Customer Info</h6>
                        <p class="mb-1"><strong>Customer Name:</strong> <%= customerName != null ? customerName : "Unknown" %></p>
                        <p class="mb-1"><strong>Phone Number:</strong> <%= phone != null ? phone : "Unknown" %></p>
                        <p class="mb-2"><strong>Shipping Address:</strong> <%= address != null ? address : "Unknown" %></p>

                        <% if (!isAdmin && isCancelable) { %>
                        <a href="MainController?action=editProfile" class="btn btn-sm btn-outline-primary">
                            ✏️ Update Information
                        </a>
                        <% } %>
                    </div>

                    <p class="mt-3">
                        <strong>Total:</strong>
                        <span class="text-success fw-bold">$<%= String.format("%.2f", order.getTotalAmount()) %></span>
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
                    <%
                        if (details != null && !details.isEmpty()) {
                            for (OrderDetail d : details) {
                    %>
                    <tr>
                        <td><%= d.getItemType() %></td>
                        <td><%= d.getItemId() %></td>
                        <td class="text-center"><%= d.getUnitQuantity() %></td>
                        <td class="text-end">$<%= String.format("%.2f", d.getUnitPrice() * d.getUnitQuantity()) %></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="4" class="text-center text-muted">No items found in this order.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <!-- Action Buttons -->
            <div class="mt-4">
                <% if (!isAdmin) { %>
                <a href="order?action=list" class="btn btn-outline-secondary me-2">← Back to My Orders</a>
                <% if (isCancelable) { %>
                <a href="order?action=cancel&orderId=<%= order.getOrderId() %>" 
                   class="btn btn-outline-danger"
                   onclick="return confirm('Cancel this order?')">Cancel This Order</a>
                <% } %>
                <% } else { %>
                <div class="d-flex justify-content-center mt-4">
                    <a href="javascript:history.back()" class="btn btn-secondary">
                        ← Back to Manage Orders
                    </a>
                </div>
                <% } %>
            </div>
        </div>
        <br>
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
