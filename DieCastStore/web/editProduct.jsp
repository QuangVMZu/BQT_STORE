<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.CustomerAccount"%>
<%@ page import="model.Accessory" %>
<%@ page import="utils.AuthUtils"%>
<%@ page import="model.ModelCar"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Product</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/CSS/editProduct.css">
    </head>
    <body style="background-color: #f1f6fb;">
        <jsp:include page="header.jsp" />
        <br>

        <%
            String checkError = (String) request.getAttribute("checkError");
            String message = (String) request.getAttribute("message");

            if (AuthUtils.isLoggedIn(request) && AuthUtils.isAdmin(request)) {
                List<ModelCar> pageList = (List<ModelCar>) request.getAttribute("pageList");
                List<Accessory> accessoryList = (List<Accessory>) request.getAttribute("accessoryList");
                Integer totalPages = (Integer) request.getAttribute("totalPages");
                Integer currentPage = (Integer) request.getAttribute("currentPage");
        %>

        <div class="container">
            <h2 class="text-center mb-4">🛠 Manage Products</h2>

            <% if (checkError != null) { %>
            <div class="alert alert-danger"><%= checkError %></div>
            <% } else if (message != null) { %>
            <div class="alert alert-success"><%= message %></div>
            <% } %>

            <div class="d-flex justify-content-between mb-3">
                <a href="home.jsp" class="btn btn-outline-secondary rounded-pill">
                    <i class="bi bi-house-door-fill"></i> Home
                </a>
                <a href="productsUpdate.jsp" class="btn btn-success rounded-pill">
                    <i class="bi bi-plus-circle"></i> Add New Product
                </a>
            </div>

            <% if (pageList != null && !pageList.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-bordered table-striped text-center align-middle">
                    <thead class="table-primary">
                        <tr>
                            <th>No.</th>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Scale</th>
                            <th>Brand</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int no = 1;
                for (ModelCar p : pageList) { %>
                        <tr>
                            <td><%= no++ %></td>
                            <td><%= p.getModelId() %></td>
                            <td><%= p.getModelName() %></td>
                            <td><%= p.getScaleId() %></td>
                            <td><%= p.getBrandId() %></td>
                            <td>$<%= String.format("%,.2f", p.getPrice()) %></td>
                            <td><%= p.getQuantity() %></td>
                            <td>
                                <form action="MainController" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="editProduct" />
                                    <input type="hidden" name="modelId" value="<%= p.getModelId() %>" />
                                    <button type="submit" class="btn btn-warning btn-sm"><i class="bi bi-pencil-fill"></i></button>
                                </form>
                                <form action="MainController" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="changeQuantity" />
                                    <input type="hidden" name="modelId" value="<%= p.getModelId() %>" />
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">
                                        <i class="bi bi-trash-fill"></i>
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
                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="MainController?action=listEdit&page=<%= i %>" class="btn btn-sm <%= (i == currentPage) ? "btn-success" : "btn-outline-success" %> mx-1">
                        <%= i %>
                    </a>
                    <% } %>
                </div>
            </nav>
            <% } else { %>
            <div class="alert alert-warning">No products found.</div>
            <% } %>

            <hr class="my-5">

            <h2 class="text-center mb-4">🔧 Manage Accessories</h2>
            <div class="d-flex justify-content-end mb-3">
                <a href="accessoryUpdate.jsp" class="btn btn-success rounded-pill">
                    <i class="bi bi-plus-circle"></i> Add New Accessory
                </a>
            </div>

            <% if (accessoryList != null && !accessoryList.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-bordered table-striped text-center align-middle">
                    <thead class="table-primary">
                        <tr>
                            <th>No.</th>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Image</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int idx = 1;
                        for (Accessory a : accessoryList) { %>
                        <tr>
                            <td><%= idx++ %></td>
                            <td><%= a.getAccessoryId() %></td>
                            <td><%= a.getAccessoryName() %></td>
                            <td>$<%= String.format("%,.2f", a.getPrice()) %></td>
                            <td><%= a.getQuantity() %></td>
                            <td>
                                <% if (a.getImageUrl() != null && !a.getImageUrl().isEmpty()) { %>
                                <img src="<%= a.getImageUrl() %>" alt="Accessory Image" style="max-height: 60px;">
                                <% } else { %>
                                <span class="text-muted">No image</span>
                                <% } %>
                            </td>
                            <td>
                                <form action="MainController" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="editAccessory" />
                                    <input type="hidden" name="accessoryId" value="<%= a.getAccessoryId() %>" />
                                    <button type="submit" class="btn btn-warning btn-sm"><i class="bi bi-pencil-fill"></i></button>
                                </form>
                                <form action="MainController" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="changeAccessoryQuantity" />
                                    <input type="hidden" name="accessoryId" value="<%= a.getAccessoryId() %>" />
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">
                                        <i class="bi bi-trash-fill"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="alert alert-warning">No accessories found.</div>
            <% } %>

        </div>

        <% } else { %>
        <div class="container access-denied text-center mt-5">
            <h2 class="text-danger">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% } %>

        <jsp:include page="footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
