<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Cart"%>
<%@ page import="utils.AuthUtils" %>
<%@page import="model.CartItem"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Cart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/CSS/cart.css">
        <script src="assets/JS/cart.js"></script>
    </head>
    <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp" />
        <% 
            if (AuthUtils.isLoggedIn(request)) {
        %>
        <div class="container cart-container">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">🛒 My Cart</h4>
                </div>
                <div class="card-body">

                    <%-- Alerts --%>
                    <%
                        Cart cart = (Cart) request.getAttribute("cart");
                        String error = (String) request.getAttribute("error");
                        if (error != null) {
                    %><div class="alert alert-danger"><strong>Error:</strong> <%= error %></div><% } %>

                    <%
                        String success = (String) request.getAttribute("success");
                        if (success != null) {
                    %><div class="alert alert-success"><strong>Success:</strong> <%= success %></div><% } %>

                    <%
                        String successMessage = (String) session.getAttribute("successMessage");
                        if (successMessage != null) {
                    %><div class="alert alert-success"><strong>✓</strong> <%= successMessage %></div>
                    <% session.removeAttribute("successMessage"); } %>

                    <%
                        String errorMessage = (String) session.getAttribute("errorMessage");
                        if (errorMessage != null) {
                    %><div class="alert alert-danger"><strong>✗</strong> <%= errorMessage %></div>
                    <% session.removeAttribute("errorMessage"); } %>

                    <%
                        List<String> inventoryErrors = (List<String>) session.getAttribute("inventoryErrors");
                        if (inventoryErrors != null && !inventoryErrors.isEmpty()) {
                    %>
                    <div class="alert alert-warning"><strong>⚠ Inventory Alert:</strong>
                        <ul><% for (String err : inventoryErrors) { %><li><%= err %></li><% } %></ul>
                    </div>
                    <% session.removeAttribute("inventoryErrors"); } %>

                    <% if (cart == null || cart.isEmpty()) { %>
                    <div class="alert alert-info text-center">
                        <h4>Your cart is empty</h4>
                        <a href="ProductController?action=list" class="btn btn-primary mt-2">Continue Shopping</a>
                    </div>
                    <% } else { List<CartItem> items = cart.getItems(); %>

                    <div class="mb-3 cart-summary">
                        <p>Total products: <strong><%= cart.getTotalQuantity() %></strong></p>
                        <p>Total amount: <strong><%= String.format("%.2f", cart.getTotalAmount()) %> $</strong></p>
                    </div>

                    <div class="alert alert-info">
                        <strong>Selected: <span id="selectedCount">0</span> | Total: <span id="selectedTotal">0.00 $</span></strong>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover cart-table align-middle">
                            <thead class="table-secondary">
                                <tr>
                                    <th><input type="checkbox" id="selectAll" onchange="toggleSelectAll()"> All</th>
                                    <th>#</th>
                                    <th>Image</th>
                                    <th>Product</th>
                                    <th>Type</th>
                                    <th>Unit Price</th>
                                    <th>Quantity</th>
                                    <th>Total</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% int index = 1;
                                   for (CartItem item : items) {
                                       boolean isOut = item.getAvailableQuantity() <= 0;
                                       boolean isMissing = !item.isItemExists();
                                       String rowClass = (isOut || isMissing) ? "out-of-stock" : "";
                                %>
                                <tr class="<%= rowClass %>">
                                    <td>
                                        <input type="checkbox" class="form-check-input item-checkbox"
                                               value="<%= item.getItemType() %>_<%= item.getItemId() %>"
                                               onchange="checkSelectAllStatus()" <%= (isOut || isMissing) ? "disabled" : "" %>>
                                    </td>
                                    <td><%= index++ %></td>
                                    <td><img src="<%= item.getImageUrl() %>" alt="Image"></td>
                                    <td>
                                        <a href="ProductController?action=detail&modelName=<%= java.net.URLEncoder.encode(item.getItemName(), "UTF-8") %>"
                                           style="color: inherit; text-decoration: none;">
                                            <%= item.getItemName() %>
                                        </a>
                                        <% if (isMissing) { %><br><em>(No longer available)</em>
                                        <% } else if (isOut) { %><br><em>(Out of stock)</em><% } %>
                                    </td>
                                    <td><%= "MODEL".equals(item.getItemType()) ? "Car Model" : "Accessory" %></td>
                                    <td><%= String.format("%.2f", item.getUnitPrice()) %> $</td>
                                    <td>
                                        <% if (isMissing || isOut) { %>
                                        <span class="text-danger"><%= item.getQuantity() %></span>
                                        <% } else { %>
                                        <form action="cart" method="post" class="d-flex align-items-center gap-2">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="itemType" value="<%= item.getItemType() %>">
                                            <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                                            <input type="number" name="quantity" value="<%= item.getQuantity() %>"
                                                   min="0" class="form-control form-control-sm" style="width: 60px;" autocomplete="off">
                                            <input type="submit" value="Update" class="btn btn-sm btn-primary px-2 py-1">
                                        </form>
                                        <% } %>
                                    </td>
                                    <td class="subtotal"><%= String.format("%.2f", item.getSubTotal()) %> $</td>
                                    <td>
                                        <a href="cart?action=remove&itemType=<%= item.getItemType() %>&itemId=<%= item.getItemId() %>"
                                           class="btn btn-sm btn-danger"
                                           onclick="return confirm('Are you sure you want to remove this item?')">Delete</a>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4 d-flex flex-wrap gap-2">
                        <a href="cart?action=clear" class="btn btn-outline-danger"
                           onclick="return confirm('Are you sure to clear the entire cart?')">🗑️ Clear Cart</a>
                        <a href="ProductController?action=list" class="btn btn-outline-secondary btn-continue">
                            🛍️ Continue Shopping
                        </a>
                        <button id="checkoutBtn" class="btn btn-secondary text-white" onclick="checkoutSelected()" disabled>
                            ✅ Pay Selected
                        </button>
                        <a href="checkout?action=show" class="btn btn-success">💳 Pay All</a>
                    </div>

                    <% } %>

                    <div class="mt-5 text-center">
                        <a href="home.jsp" class="btn btn-secondary mx-auto">
                            ← Back to Home Page
                        </a>
                    </div>
                </div> <!-- end card-body -->
            </div> <!-- end card -->
        </div> <!-- end container -->
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
