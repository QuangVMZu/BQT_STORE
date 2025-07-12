<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="model.ImageModel" %>
<%@ page import="java.util.List" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= request.getAttribute("product") != null ? "Update Product" : "Add New Product" %></title>
        <link rel="stylesheet" href="assets/CSS/productsUpdate.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp" />
        <% if (AuthUtils.isLoggedIn(request)) {
            if (AuthUtils.isAdmin(request)) {
                ModelCar product = (ModelCar) request.getAttribute("product");
                String keyword = (String) request.getAttribute("keyword");
                String message = (String) request.getAttribute("message");
                String checkError = (String) request.getAttribute("checkError");
                boolean isEdit = (product != null);
                List<ImageModel> images = isEdit && product.getImages() != null ? product.getImages() : null;
                int numberOfImageInputs = 4;
        %>

        <div class="container mt-3">
            <% if (checkError != null && !checkError.isEmpty()) { %>
            <div class="alert alert-danger"><%= checkError %></div>
            <% } else if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success"><%= message %></div>
            <% } %>
        </div>

        <div class="form-image-container container">
            <div class="product-form-box">
                <div class="header mb-3">
                    <a href="ProductController?action=listEdit" class="back-link">&larr; Back to Products</a>
                </div>

                <h2><%= isEdit ? "Update Product" : "Add New Product" %></h2>

                <% if (!isEdit) { %>
                <form action="ProductController?action=productAdding" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="keyword" value="<%= keyword != null ? keyword : "" %>">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="card shadow-sm">
                                <div class="card-header bg-success text-white"><h5 class="mb-0">Add Product</h5></div>
                                <div class="card-body">
                                    <label>Model ID *</label>
                                    <input type="text" name="modelId" class="form-control mb-3" required>

                                    <label>Model Name *</label>
                                    <input type="text" name="modelName" class="form-control mb-3" required>

                                    <label>Scale ID *</label>
                                    <input type="number" name="scale" class="form-control mb-3" required min="1" max="2" step="1">

                                    <label>Brand ID *</label>
                                    <input type="number" name="brandId" class="form-control mb-3" required min="1" max="10" step="1">

                                    <label>Price *</label>
                                    <input type="number" step="0.01" name="price" class="form-control mb-3" required min="0">

                                    <label>Quantity *</label>
                                    <input type="number" name="quantity" class="form-control mb-3" required min="-1">

                                    <label>Description</label>
                                    <textarea name="description" rows="4" class="form-control"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="card shadow-sm">
                                <div class="card-header bg-primary text-white"><h5 class="mb-0">Upload Product Images</h5></div>
                                <div class="card-body">
                                    <% for (int i = 0; i < numberOfImageInputs; i++) { %>
                                    <div class="mb-4 border rounded p-3 bg-light">
                                        <label>Image File <%= (i + 1) %> *</label>
                                        <input type="file" name="imageFiles" class="form-control mb-2" accept="image/*" required>

                                        <label>Caption</label>
                                        <input type="text" name="captionList" class="form-control">
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="text-end mt-4">
                        <button type="submit" class="btn btn-success">Add Product</button>
                    </div>
                </form>
                <% } %>

                <% if (isEdit) { %>
                <div class="row g-4 mt-5">
                    <div class="col-md-6">
                        <form action="ProductController?action=productUpdateMain" method="post">
                            <div class="card shadow-sm">
                                <div class="card-header bg-success text-white"><h5 class="mb-0">Update Product</h5></div>
                                <div class="card-body">
                                    <input type="hidden" name="modelId" value="<%= product.getModelId() %>">
                                    <input type="hidden" name="keyword" value="<%= keyword != null ? keyword : "" %>">

                                    <label>Model Name *</label>
                                    <input type="text" name="modelName" class="form-control mb-3" value="<%= product.getModelName() %>" required>

                                    <label>Scale ID *</label>
                                    <input type="number" name="scale" class="form-control mb-3" value="<%= product.getScaleId() %>" required min="1" max="2" step="1">

                                    <label>Brand ID *</label>
                                    <input type="number" name="brandId" class="form-control mb-3" value="<%= product.getBrandId() %>" required min="1" max="10" step="1">

                                    <label>Price *</label>
                                    <input type="number" step="0.01" name="price" class="form-control mb-3" value="<%= product.getPrice() %>" required min="0">

                                    <label>Quantity *</label>
                                    <input type="number" name="quantity" class="form-control mb-3" value="<%= product.getQuantity() %>" required min="-1">

                                    <label>Description</label>
                                    <textarea name="description" rows="4" class="form-control"><%= product.getDescription() %></textarea>

                                    <button type="submit" class="btn btn-success w-100 mt-3">Update Product</button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="col-md-6">
                        <form action="ProductController?action=productUpdateImages" method="post" enctype="multipart/form-data">
                            <div class="card shadow-sm">
                                <div class="card-header bg-primary text-white"><h5 class="mb-0">Product Images</h5></div>
                                <div class="card-body">
                                    <input type="hidden" name="modelId" value="<%= product.getModelId() %>">
                                    <input type="hidden" name="keyword" value="<%= keyword != null ? keyword : "" %>">

                                    <% for (int i = 0; i < numberOfImageInputs; i++) {
                                        String imageId = "";
                                        String imageUrl = "";
                                        String caption = "";
                                        if (images != null && i < images.size()) {
                                            ImageModel img = images.get(i);
                                            imageId = String.valueOf(img.getImageId());
                                            imageUrl = img.getImageUrl() != null ? img.getImageUrl() : "";
                                            caption = img.getCaption() != null ? img.getCaption() : "";
                                        }
                                    %>
                                    <div class="mb-4 border rounded p-3 bg-light">
                                        <% if (!imageId.isEmpty()) { %>
                                        <input type="hidden" name="imageIdList" value="<%= imageId %>">
                                        <% } %>

                                        <% if (!imageUrl.isEmpty()) { %>
                                        <div class="mb-2">
                                            <label>Current Image:</label><br>
                                            <img src="<%= imageUrl %>" alt="Current Image" style="max-width: 100px; height: auto; border: 1px solid #ccc;">
                                            <p class="small text-muted"><%= imageUrl %></p>
                                        </div>
                                        <% } %>

                                        <label class="form-label">Upload New Image <%= (i + 1) %></label>
                                        <input type="file" name="imageFileList" class="form-control mb-2" accept="image/*">

                                        <label class="form-label">Caption</label>
                                        <input type="text" name="captionList" class="form-control" value="<%= caption %>">
                                    </div>
                                    <% } %>

                                    <button type="submit" class="btn btn-primary w-100">Upload Images</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>
        </div>

        <% } else { %>
        <div class="container access-denied">
            <h2 style="color: #00695c">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% } } else { %>
        <div class="container access-denied">
            <h2 class="text-danger">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% } %>
        <jsp:include page="footer.jsp" />
    </body>
</html>
