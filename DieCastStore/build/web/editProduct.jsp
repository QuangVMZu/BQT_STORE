<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.CustomerAccount"%>
<%@ page import="utils.AuthUtils"%>
<%@ page import="model.ModelCar"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Product</title>
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/CSS/editProduct.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <br>

        <%
            String checkError = (String) request.getAttribute("checkError");
            String message = (String) request.getAttribute("message");

            if (AuthUtils.isLoggedIn(request)) {
                if (AuthUtils.isAdmin(request)) {
                    CustomerAccount user = AuthUtils.getCurrentUser(request);
                    List<ModelCar> pageList = (List<ModelCar>) request.getAttribute("pageList");
                    Integer totalPages = (Integer) request.getAttribute("totalPages");
                    Integer currentPage = (Integer) request.getAttribute("currentPage");
        %>

        <div class="container">
            <h2 class="text-center">🛠 Manage Products</h2>

            <%-- Hiển thị thông báo lỗi / thành công --%>
            <% if (checkError != null && !checkError.isEmpty()) { %>
            <div class="alert alert-danger mt-3"><%= checkError %></div>
            <% } else if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success mt-3"><%= message %></div>
            <% } %>

            <a href="home.jsp" class="btn btn-outline-secondary rounded-pill mb-3">
                <i class="bi bi-house-door-fill"></i> Home
            </a>

            <a href="productsUpdate.jsp" class="btn btn-success add-product-btn mb-3">
                <i class="bi bi-plus-circle"></i> Add New Product
            </a>

            <% if (pageList != null && !pageList.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-bordered table-striped align-middle text-center">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Scale</th>
                            <th>Brand</th>
                            <th>Price</th>
                            <!--<th>Description</th>-->
                            <th>Quantity</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int no = 0; %>
                        <% for (ModelCar p : pageList) {
                               no++;
                        %>
                        <tr>
                            <td><%= no %></td>
                            <td><%= p.getModelId() %></td>
                            <td><%= p.getModelName() %></td>
                            <td><%= p.getScaleId() %></td>
                            <td><%= p.getBrandId() %></td>
                            <td>$<%= p.getPrice() %></td>
                            <!--<td><%= p.getDescription() %></td>-->
                            <td><%= p.getQuantity() %></td>
                            <td>
                                <form action="MainController" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="editProduct" />
                                    <input type="hidden" name="modelId" value="<%= p.getModelId() %>" />
                                    <button type="submit" class="btn btn-sm btn-warning">
                                        <i class="bi bi-pencil-fill"></i> Edit
                                    </button>
                                </form>
                                <form action="MainController" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="changeQuantity" />
                                    <input type="hidden" name="modelId" value="<%= p.getModelId() %>" />
                                    <button type="submit" class="btn btn-sm btn-danger"
                                            onclick="return confirm('Are you sure you want to delete this product?')">
                                        <i class="bi bi-trash-fill"></i> Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <nav class="mt-4 text-center">
                <div class="pagination justify-content-center">
                    <% if (totalPages != null && currentPage != null) {
                    for (int i = 1; i <= totalPages; i++) { %>
                    <a href="MainController?action=listEdit&page=<%= i %>"
                       class="btn btn-sm <%= (i == currentPage) ? "btn-success" : "btn-outline-success" %> mx-1"><%= i %></a>
                    <% }} %>
                </div>
            </nav>

            <% } else { %>
            <div class="alert alert-warning">No products found.</div>
            <% } %>

        </div>

        <% 
            } else { // not admin 
        %>
        <div class="container access-denied">
            <h2 style="color: #00695c">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div>
        <% 
            } // end if admin
        } else { // not logged in
        %>
        <div class="container access-denied">
            <h2 style="color: #00695c">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div>
        <% } %>

        <br>
        <jsp:include page="footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
