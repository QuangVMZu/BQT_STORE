<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Order" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Manage Orders</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/CSS/manageOrders.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <%
            if (AuthUtils.isLoggedIn(request)) {
                if (AuthUtils.isAdmin(request)) {
                    String message = (String) request.getAttribute("message");
                    List<Order> orders = (List<Order>) request.getAttribute("orders");
        %>

        <div class="table-container">
            <h2>🧾 Manage All Orders</h2>

            <% if (message != null) { %>
            <div class="alert alert-info text-center"><%= message %></div>
            <% } %>

            <% if (orders != null && !orders.isEmpty()) { %>
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
                        <% 
                        int i = 1;
                        for (Order order : orders) {
                            if ("Cancelled".equalsIgnoreCase(order.getStatus())) continue;
                        %>
                        <tr class="text-center">
                            <td><%= i++ %></td>
                            <td><%= order.getOrderId() %></td>
                            <td><%= order.getCustomerId() %></td>
                            <td><%= order.getShippingAddress() %></td>
                            <td><%= order.getOrderDate() %></td>
                            <td><%= String.format("%.2f", order.getTotalAmount()) %></td>
                            <td>
                                <form method="post" action="MainController" class="d-flex justify-content-center align-items-center gap-2">
                                    <input type="hidden" name="action" value="updateOrderStatus">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                    <select name="status" class="form-select form-select-sm w-auto">
                                        <option value="Pending" <%= "Pending".equals(order.getStatus()) ? "selected" : "" %>>Pending</option>
                                        <option value="Processing" <%= "Processing".equals(order.getStatus()) ? "selected" : "" %>>Processing</option>
                                        <option value="Shipped" <%= "Shipped".equals(order.getStatus()) ? "selected" : "" %>>Shipped</option>
                                        <option value="Delivered" <%= "Delivered".equals(order.getStatus()) ? "selected" : "" %>>Delivered</option>
                                        <option value="Cancelled" <%= "Cancelled".equals(order.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-primary">Save</button>
                                </form>
                            </td>
                            <td>
                                <form method="post" action="MainController" onsubmit="return confirm('Hide this order?')">
                                    <input type="hidden" name="action" value="updateOrderStatus">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                    <input type="hidden" name="status" value="Cancelled">
                                    <a href="order?action=vieworder&orderId=<%= order.getOrderId() %>" class="btn btn-sm btn-info">View</a>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="alert alert-warning text-center">No orders found.</div>
            <% } %>

            <div class="text-center mt-4">
                <a href="home.jsp" class="btn btn-secondary">← Back to Home</a>
            </div>
        </div>
        <% 
        } else { // not admin 
        %>
        <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
            <h2 class="text-danger">Access Denied</h2>
            <p class="text-danger"><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <%
           }
       } else {
        %>
        <!-- Not Logged In -->
        <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
            <h2 class="text-danger">Access Denied</h2>
            <p class="text-danger"><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% } %>
        <jsp:include page="footer.jsp" />
    </body>
</html>
