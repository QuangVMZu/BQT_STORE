<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Accessory" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= request.getAttribute("accessory") != null ? "Update Accessory" : "Add New Accessory" %></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/CSS/accessoryUpdate.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <%
            if (AuthUtils.isLoggedIn(request)) {
                if (AuthUtils.isAdmin(request)) {
                Accessory accessory = (Accessory) request.getAttribute("accessory");
                String message = (String) request.getAttribute("message");
                String checkError = (String) request.getAttribute("checkError");
                boolean isEdit = accessory != null;
        %>

        <div class="container mt-5">
            <div class="form-wrapper">
                <div class="form-container">
                    <h2 class="text-center"><%= isEdit ? "Update Accessory" : "Add New Accessory" %></h2>

                    <% if (checkError != null) { %>
                    <div class="alert alert-danger"><%= checkError %></div>
                    <% } else if (message != null) { %>
                    <div class="alert alert-success"><%= message %></div>
                    <% } %>

                    <form action="ProductController" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="<%= isEdit ? "accessoryUpdate" : "accessoryAdding" %>">
                        <% if (isEdit) { %>
                        <input type="hidden" name="accessoryId" value="<%= accessory.getAccessoryId() %>">
                        <% } %>

                        <div class="mb-3">
                            <label class="form-label">Name *</label>
                            <input type="text" name="name" class="form-control" required
                                   value="<%= isEdit ? accessory.getAccessoryName() : "" %>">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Price *</label>
                            <input type="number" name="price" step="0.01" min="0" class="form-control" required
                                   value="<%= isEdit ? accessory.getPrice() : "" %>">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Quantity *</label>
                            <input type="number" name="quantity" min="-1" class="form-control" required
                                   value="<%= isEdit ? accessory.getQuantity() : "" %>">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="detail" class="form-control" rows="4"><%= isEdit ? accessory.getDetail() : "" %></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Image</label>
                            <% if (isEdit && accessory.getImageUrl() != null && !accessory.getImageUrl().isEmpty()) { %>
                            <div class="mb-2">
                                <img src="<%= accessory.getImageUrl() %>" class="preview-img">
                                <span class="small text-muted"><%= accessory.getImageUrl() %></span>
                            </div>
                            <% } %>
                            <input type="file" name="imageFile" class="form-control" accept="image/*">
                        </div>

                        <div class="text-center mt-4">
                            <button type="submit" class="btn btn-primary">
                                <%= isEdit ? "Update" : "Add" %> Accessory
                            </button>
                            <a href="ProductController?action=listEdit" class="btn btn-secondary">
                                <i class="bi"></i>← Back to List
                            </a>
                        </div>
                    </form>
                </div>
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
