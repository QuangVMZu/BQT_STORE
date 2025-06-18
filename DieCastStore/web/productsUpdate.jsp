<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ImageModel" %>
<jsp:include page="header.jsp" />

<link rel="stylesheet" href="assects/CSS/productsUpdate.css">

<%
    ModelCar product = (ModelCar) request.getAttribute("product");
    String keyword = (String) request.getAttribute("keyword");
    String message = (String) request.getAttribute("message");

    boolean isEdit = (product != null);
%>

<% if (message != null) { %>
<p style="color: green; text-align: center;"><%= message %></p>
<% } %>

<div class="product-update-form">
    <div class="header">
        <a href="editProduct.jsp" class="back-link">← Back to Products</a>
    </div>

    <h2><%= isEdit ? "Product Update" : "Add new product" %></h2>

    <form action="ProductController?action=<%= isEdit ? "productUpdating" : "productAdding" %>" method="post">
        <% if (isEdit) { %>
        <input type="hidden" name="modelId" value="<%= product.getModelId() %>">
        <% } %>
        <input type="hidden" name="keyword" value="<%= keyword != null ? keyword : "" %>">

        <label>Model Name <span style="color: red">*</span></label>
        <input type="text" name="modelName" value="<%= isEdit ? product.getModelName() : "" %>" required>

        <label>Scale ID<span style="color: red">*</span></label>
        <input type="number" name="scale" value="<%= isEdit ? product.getScaleId() : "" %>" required>

        <label>Brand ID<span style="color: red">*</span></label>
        <input type="number" name="brandId" value="<%= isEdit ? product.getBrandId() : "" %>" required>

        <label>Price<span style="color: red">*</span></label>
        <input type="number" step="0.01" name="price" value="<%= isEdit ? product.getPrice() : "" %>" required>

        <label>Quantity<span style="color: red">*</span></label>
        <input type="number" name="quantity" value="<%= isEdit ? product.getQuantity() : "" %>" required>

        <label>Description:</label>
        <textarea name="description" rows="4" cols="50"><%= isEdit ? product.getDescription() : "" %></textarea>

        <% if (isEdit) { %>
        <h3>Product images:</h3>
        <%
            List<ImageModel> images = product.getImages();
            for (int i = 0; i < images.size(); i++) {
                ImageModel img = images.get(i);
        %>
        <div>
            <input type="hidden" name="imageId" value="<%= img.getImageId() %>">
            <label>URL img <%= (i + 1) %><span style="color: red">*</span></label>
            <input type="text" name="imageUrl" value="<%= img.getImageUrl() %>">
            <label>Caption:</label>
            <input type="text" name="caption" value="<%= img.getCaption() != null ? img.getCaption() : "" %>">
        </div>
        <% } %>
        <% } %>

        <button type="submit"><%= isEdit ? "Update" : "Adding" %></button>
    </form>
</div>

<jsp:include page="footer.jsp" />
