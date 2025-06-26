<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.CustomerAccount"%>
<%@ page import="utils.AuthUtils"%>
<%@ page import="model.ModelCar"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

<%
    final int ITEMS_PER_PAGE = 10;
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }

    // Lấy danh sách từ request nếu có, ngược lại lấy từ session
    List<ModelCar> fullList = (List<ModelCar>) request.getAttribute("productListEdit");
    if (fullList != null) {
        session.setAttribute("cachedProductListEdit", fullList); // lưu vào session để dùng lại
    } else {
        fullList = (List<ModelCar>) session.getAttribute("cachedProductListEdit");
    }

    int totalItems = (fullList != null) ? fullList.size() : 0;
    int totalPages = (int) Math.ceil((double) totalItems / ITEMS_PER_PAGE);
    int start = (currentPage - 1) * ITEMS_PER_PAGE;
    int end = Math.min(start + ITEMS_PER_PAGE, totalItems);

    List<ModelCar> pageList = new ArrayList<>();
    if (fullList != null && start < totalItems) {
        pageList = fullList.subList(start, end);
    }
%>

<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <link rel="stylesheet" href="assets/CSS/editProduct.css">
</head>
<body>
    <jsp:include page="header.jsp"/><br>
    <%
        if (AuthUtils.isLoggedIn(request)) {
            CustomerAccount user = AuthUtils.getCurrentUser(request);
    %>
    <div class="container">
        <h2>Manage Products</h2>

        <% if (AuthUtils.isAdmin(request)) { %>
        <a href="productsUpdate.jsp" class="add-product-btn">Add Product</a>
        <% } %>

        <% if (!pageList.isEmpty()) { %>
        <table class="products-table">
            <thead>
                <tr>
                    <th>Model Id</th>
                    <th>Model Name</th>
                    <th>Scale Id</th>
                    <th>Brand Id</th>
                    <th>Price</th>
                    <th>Description</th>
                    <th>Quantity</th>
                        <% if (AuthUtils.isAdmin(request)) { %>
                    <th>Action</th>
                        <% } %>
                </tr>
            </thead>
            <tbody>
                <% for (ModelCar p : pageList) { %>
                <tr>
                    <td><%= p.getModelId() %></td>
                    <td><%= p.getModelName() %></td>
                    <td><%= p.getScaleId() %></td>
                    <td><%= p.getBrandId() %></td>
                    <td>$<%= p.getPrice() %></td>
                    <td><%= p.getDescription() %></td>
                    <td><%= p.getQuantity() %></td>
                    <% if (AuthUtils.isAdmin(request)) { %>
                    <td>
                        <form action="MainController" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="editProduct"/>
                            <input type="hidden" name="modelId" value="<%= p.getModelId() %>"/>
                            <input type="submit" value="Edit" class="edit-btn"/>
                        </form>
                        <form action="MainController" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="changeQuantity"/>
                            <input type="hidden" name="productId" value="<%= p.getModelId() %>"/>
                            <input type="submit" value="Delete" class="delete-btn"
                                   onclick="return confirm('Are you sure you want to delete this product?')"/>
                        </form>
                    </td>
                    <% } %>
                </tr>
                <% } %>
            </tbody>
        </table>

        <!-- Pagination -->
        <div class="pagination">
            <% for (int i = 1; i <= totalPages; i++) { %>
            <a href="editProduct.jsp?page=<%= i %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
            <% } %>
        </div>

        <% } else { %>
        <div class="no-results">
            <p>No products found.</p>
        </div>
        <% } %>
    </div>
    <%
        } else {
    %>
    <div class="container">
        <div class="access-denied">
            <h2>Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>">Login Now</a>
        </div>
    </div>
    <% } %>
    <br>
    <jsp:include page="footer.jsp"/>
</body>
