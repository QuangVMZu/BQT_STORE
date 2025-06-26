<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ImageModel" %>
<jsp:include page="header.jsp" />

<link rel="stylesheet" href="assets/CSS/productsUpdate.css">

<%
    ModelCar product = (ModelCar) request.getAttribute("product");
    String keyword = (String) request.getAttribute("keyword");
    String message = (String) request.getAttribute("message");
    boolean isEdit = (product != null);
%>

<% if (message != null) { %>
<p class="success-message"><%= message %></p>
<% } %>

<div class="form-image-container">
    <!-- Add/Edit Product Table -->
    <div class="product-form-box">
        <div class="header">
            <a href="editProduct.jsp" class="back-link">← Back to Products</a>
        </div>

        <h2><%= isEdit ? "Update Product" : "Add New Product" %></h2>

        <form action="ProductController?action=<%= isEdit ? "productUpdating" : "productAdding" %>" method="post">
            <% if (isEdit) { %>
            <input type="hidden" name="modelId" value="<%= product.getModelId() %>">
            <% } %>
            <input type="hidden" name="keyword" value="<%= keyword != null ? keyword : "" %>">

            <label>Model Name <span class="required">*</span></label>
            <input type="text" name="modelName" value="<%= isEdit ? product.getModelName() : "" %>" required>

            <label>Scale ID <span class="required">*</span></label>
            <input type="number" name="scale" value="<%= isEdit ? product.getScaleId() : "" %>" required>

            <label>Brand ID <span class="required">*</span></label>
            <input type="number" name="brandId" value="<%= isEdit ? product.getBrandId() : "" %>" required>

            <label>Price <span class="required">*</span></label>
            <input type="number" step="0.01" name="price" value="<%= isEdit ? product.getPrice() : "" %>" required>

            <label>Quantity <span class="required">*</span></label>
            <input type="number" name="quantity" min="-1" value="<%= isEdit ? product.getQuantity() : "" %>" required>

            <label>Description</label>
            <textarea name="description" rows="4"><%= isEdit ? product.getDescription() : "" %></textarea>

            <button type="submit"><%= isEdit ? "Update" : "Add Product" %></button>
        </form>
    </div>

    <!-- Product Images Table -->
    <div class="product-images-box">
        <h2 style="margin-top: 36px">Product Images</h2>
        <form>
            <%
                int numberOfImageInputs = 4;
                List<ImageModel> images = isEdit && product.getImages() != null ? product.getImages() : null;
                for (int i = 0; i < (isEdit ? images.size() : numberOfImageInputs); i++) {
                    String imageId = "";
                    String imageUrl = "";
                    String caption = "";

                    if (isEdit && images != null && i < images.size()) {
                        ImageModel img = images.get(i);
                        imageId = String.valueOf(img.getImageId());
                        imageUrl = img.getImageUrl();
                        caption = img.getCaption() != null ? img.getCaption() : "";
                    }
            %>
            <div class="image-row">
                <% if (isEdit) { %>
                <input type="hidden" name="imageId" value="<%= imageId %>">
                <% } %>
                <label>Image URL <%= (i + 1) %> <span class="required">*</span></label>
                <input type="text" name="imageUrl" value="<%= imageUrl %>">

                <label>Caption</label>
                <input type="text" name="caption" value="<%= caption %>">
            </div>
            <% } %>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
