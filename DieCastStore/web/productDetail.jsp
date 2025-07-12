<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="model.Accessory" %>
<%@ page import="dao.ModelCarDAO" %>
<%@ page import="model.ImageModel" %>
<%@ page import="model.BrandModel" %>
<%@ page import="java.util.List" %>

<%
    String checkError = (String) request.getAttribute("checkError");
    String message = (String) request.getAttribute("message");
    ModelCar product = (ModelCar) request.getAttribute("productDetail");
    Accessory accessory = (Accessory) request.getAttribute("accessoryDetail");
%>


<!DOCTYPE html>
<html>
    <head>
        <title><%= (product != null) ? product.getModelName() + " | Product Detail" : "Product Detail" %></title>
        <link rel="stylesheet" href="assets/CSS/productDetail.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="assets/JS/productDetail.js"></script>
    </head>
    <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp" />
        <%
            if (product != null) {
                List<ImageModel> images = product.getImages();
                String imageUrl = null;
                if (images != null && !images.isEmpty()) {
                    imageUrl = images.get(0).getImageUrl();
                }
        %>
        <div class="detail-container">
            <!-- Message -->
            <% if (checkError != null && !checkError.isEmpty()) { %>
            <div class="alert alert-danger mt-3"><%= checkError %></div>
            <% } else if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success mt-3"><%= message %></div>
            <% } %>
            <div class="product-top">
                <div>
                    <img class="detail-image" id="mainImage" src="<%= imageUrl %>" alt="<%= product.getModelName() %>">
                    <div class="thumbnails">
                        <%
                            if (images != null && !images.isEmpty()) {
                                for (ImageModel img : images) {
                        %>
                        <img class="thumbnail" src="<%= img.getImageUrl() %>" onclick="changeMainImage('<%= img.getImageUrl() %>')" alt="Thumbnail">
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
                <div class="detail-info">
                    <h2 style="font-size: 28px; font-weight: bold"><%= product.getModelName() %></h2>
                    <% if (product != null) { %>
                    <p class="info-muted" style="margin-bottom: -1px;"><strong>Model ID:</strong> <%= product.getModelId() %></p>

                    <%
                        BrandModel brand = (BrandModel) request.getAttribute("productBrand");
                        int quantity = product.getQuantity();
                    %>

                    <% if (brand != null) { %>

                    <p class="info-muted">
                        <strong>Brand:</strong>
                        <span style="color: #2e7d32; font-weight: bold;"><%= brand.getBrandName() %></span>
                    </p>

                    <div class="stock-wrapper">
                        <span class="stock-badge <%= quantity > 0 ? "" : "out" %>">
                            <%= quantity > 0 ? "In stock" : (quantity == 0 ? "Out of stock" : (quantity == -1 ? "Sales suspension" : "Unknown")) %>
                        </span>
                    </div>

                    <% } %>
                    <p class="price" >$<%= String.format("%,.2f", product.getPrice()) %></p>

                    <% if (quantity > 0) { %>
                    <div style="margin-top: 15px;">
                        <label for="quantityInput"><strong>Quantity:</strong></label>
                        <div style="display: flex; align-items: center; gap: 10px; margin-top: 5px;">
                            <button type="button" onclick="adjustQuantity(-1)">-</button>
                            <input type="number" id="quantityInput" name="quantity" value="1" min="1" max="<%= quantity %>" style="width: 60px; text-align: center;">
                            <button type="button" onclick="adjustQuantity(1)">+</button>
                        </div>
                    </div>
                    <!-- Các nút hành động -->
                    <div class="purchase-buttons" style="margin-top: 20px; display: flex; gap: 15px;">
                        <!-- Buy Now -->
                        <form method="post" action="MainController">
                            <input type="hidden" name="action" value="buyNow">
                            <input type="hidden" name="itemType" value="MODEL">
                            <input type="hidden" name="itemId" value="<%= product.getModelId() %>">
                            <input type="hidden" name="quantity" id="buyNowQuantity">
                            <button type="submit" onclick="setQuantity('buyNowQuantity')"
                                    style="padding: 10px 20px; background-color: #ff5722; color: white; border: none; border-radius: 5px;">
                                Buy Now
                            </button>
                        </form>

                        <!-- Add to Cart -->
                        <form method="post" action="MainController">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="itemType" value="MODEL">
                            <input type="hidden" name="itemId" value="<%= product.getModelId() %>">
                            <input type="hidden" name="quantity" id="addToCartQuantity">
                            <button type="submit" onclick="setQuantity('addToCartQuantity')"
                                    style="padding: 10px 20px; background-color: #2196f3; color: white; border: none; border-radius: 5px;">
                                Add to Cart
                            </button>
                        </form>
                    </div>
                    <% } %>

                    <!-- Special Offers -->
                    <div class="offer-info">
                        <h4 style="text-align: center">🎁 Special Offers</h4>
                        <ul>
                            <li>Free nationwide shipping</li>
                            <li>12-month official warranty</li>
                            <li>Buy 2 or more products and get a free stand</li>
                            <li>Extra 10% off for first-time orders</li>
                            <li>Extra 30% off all products for students</li>
                        </ul>
                    </div>

                    <!-- Store Information -->
                    <div class="store-info">
                        <h4 style="text-align: center">🏬 Store Information</h4>
                        <p><strong>Address:</strong> 7 D1 Street, Long Thanh My, Thu Duc, HCM City</p>
                        <p><strong>Opening Hours:</strong> 8:00 AM - 9:00 PM (Mon - Sun)</p>
                        <p><strong>Hotline:</strong> 0123 456 789</p>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="product-description">
                <h3>Model <%= product.getModelName()%></h3>
                <p><%= product.getDescription() != null ? product.getDescription() : "No description available." %></p>
            </div>
        </div>
        <% } else if (accessory != null) { %>
        <div class="detail-container">
            <!-- Message -->
            <% if (checkError != null && !checkError.isEmpty()) { %>
            <div class="alert alert-danger mt-3"><%= checkError %></div>
            <% } else if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success mt-3"><%= message %></div>
            <% } %>

            <div class="product-top">
                <div>
                    <img class="detail-image" id="mainImage" src="<%= accessory.getImageUrl() %>" alt="<%= accessory.getAccessoryName() %>">
                    <!-- KHÔNG CÓ thumbnails CHO ACCESSORY -->
                </div>

                <div class="detail-info">
                    <h2 style="font-size: 28px; font-weight: bold"><%= accessory.getAccessoryName() %></h2>
                    <p class="info-muted"><strong>Accessory ID:</strong> <%= accessory.getAccessoryId() %></p>
                    <p class="info-muted" style="margin-top: -10px">
                        <strong>Brand:</strong>
                        <span style="color: #2e7d32; font-weight: bold;">BQT STORE</span>
                    </p>
                    <div class="stock-wrapper">
                        <span class="stock-badge <%= accessory.getQuantity() > 0 ? "" : "out" %>">
                            <%= accessory.getQuantity() > 0 ? "In stock" : (accessory.getQuantity() == 0 ? "Out of stock" : (accessory.getQuantity() == -1 ? "Sales suspension" : "Unknown")) %>
                        </span>
                    </div>

                    <p class="price">$<%= String.format("%,.2f", accessory.getPrice()) %></p>

                    <% if (accessory.getQuantity() > 0) { %>
                    <div style="margin-top: 15px;">
                        <label for="quantityInput"><strong>Quantity:</strong></label>
                        <div style="display: flex; align-items: center; gap: 10px; margin-top: 5px;">
                            <button type="button" onclick="adjustQuantity(-1)">-</button>
                            <input type="number" id="quantityInput" name="quantity" value="1" min="1" max="<%= accessory.getQuantity() %>" style="width: 60px; text-align: center;">
                            <button type="button" onclick="adjustQuantity(1)">+</button>
                        </div>
                    </div>

                    <div class="purchase-buttons" style="margin-top: 20px; display: flex; gap: 15px;">
                        <!-- Buy Now -->
                        <form method="post" action="MainController">
                            <input type="hidden" name="action" value="buyNow">
                            <input type="hidden" name="itemType" value="ACCESSORY">
                            <input type="hidden" name="itemId" value="<%= accessory.getAccessoryId() %>">
                            <input type="hidden" name="quantity" id="buyNowQuantity">
                            <button type="submit" onclick="setQuantity('buyNowQuantity')"
                                    style="padding: 10px 20px; background-color: #ff5722; color: white; border: none; border-radius: 5px;">
                                Buy Now
                            </button>
                        </form>

                        <!-- Add to Cart -->
                        <form method="post" action="MainController">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="itemType" value="ACCESSORY">
                            <input type="hidden" name="itemId" value="<%= accessory.getAccessoryId() %>">
                            <input type="hidden" name="quantity" id="addToCartQuantity">
                            <button type="submit" onclick="setQuantity('addToCartQuantity')"
                                    style="padding: 10px 20px; background-color: #2196f3; color: white; border: none; border-radius: 5px;">
                                Add to Cart
                            </button>
                        </form>
                    </div>
                    <% } %>

                    <!-- Offers & Store Info -->
                    <div class="offer-info">
                        <h4 style="text-align: center">🎁 Special Offers</h4>
                        <ul>
                            <li>Free nationwide shipping</li>
                            <li>12-month official warranty</li>
                            <li>Buy 2 or more products and get a free stand</li>
                            <li>Extra 10% off for first-time orders</li>
                            <li>Extra 30% off all products for students</li>
                        </ul>
                    </div>

                    <div class="store-info">
                        <h4 style="text-align: center">🏬 Store Information</h4>
                        <p><strong>Address:</strong> 7 D1 Street, Long Thanh My, Thu Duc, HCM City</p>
                        <p><strong>Opening Hours:</strong> 8:00 AM - 9:00 PM (Mon - Sun)</p>
                        <p><strong>Hotline:</strong> 0123 456 789</p>
                    </div>
                </div>
            </div>

            <div class="product-description">
                <h3>Accessory <%= accessory.getAccessoryName() %></h3>
                <p><%= accessory.getDetail() != null ? accessory.getDetail() : "No description available." %></p>
            </div>
        </div>
        <% } else { %>
        <p style="color: red; text-align: center;">Product information not found.</p>
        <% } %>

        <h2 style="text-align:center; margin-top: 50px; margin-bottom: -30px; font-weight: bold; color: #333;">★  Recommended for you  ★</h2><br/>
        <% if (product != null) { %>

        <section class="news-section">
            <div class="news-carousel">
                <div class="news-items">
                    <% 
                        List<ModelCar> productsByScale = (List<ModelCar>) request.getAttribute("productsByScale");
                        if (productsByScale != null) {
                            for (ModelCar productCar : productsByScale) { 
                                List<ImageModel> images = productCar.getImages();
                    %>
                    <a href="ProductController?action=detail&modelId=<%= productCar.getModelId() %>" class="news-card">
                        <% if (images != null && !images.isEmpty()) { %>
                        <img src="<%= images.get(0).getImageUrl() %>" alt="<%= images.get(0).getCaption() %>">
                        <% } else { %>
                        <img src="assets/img/default.jpg" alt="No image">
                        <% } %>
                        <h3><%= productCar.getModelName() %></h3>
                        <p>Price: $<%= String.format("%,.2f", productCar.getPrice()) %></p>
                    </a>
                    <% 
                            } // end for
                        } else {
                    %>
                    <p>No products found for this brand.</p>
                    <% } %>
                </div>
                <div class="news-pagination">
                    <button class="news-page-btn" data-page="1">1</button>
                    <button class="news-page-btn" data-page="2">2</button>
                    <button class="news-page-btn" data-page="3">3</button>
                </div>
            </div>
        </section>
        <% } else if (accessory != null) {%>
        <section class="news-section">
            <div class="news-carousel">
                <div class="news-items">
                    <% 
                        List<Accessory> acs = (List<Accessory>) request.getAttribute("accessoryList");
                        if (accessory != null) {
                            for (Accessory accessorys : acs) {
                            if (accessorys.getAccessoryId().equals(accessory.getAccessoryId())) continue;
                    %>
                    <a href="ProductController?action=detail&accessoryId=<%= accessorys.getAccessoryId() %>" class="news-card">
                        <% if (accessorys.getImageUrl() != null && !accessorys.getImageUrl().isEmpty()) { %>
                        <img src="<%= accessorys.getImageUrl() %>">
                        <% } else { %>
                        <img src="assets/img/default.jpg" alt="No image">
                        <% } %>
                        <h3><%= accessorys.getAccessoryName() %></h3>
                        <p>Price: $<%= String.format("%,.2f", accessorys.getPrice()) %></p>
                    </a>
                    <% 
                            } // end for
                        } else {
                    %>
                    <p>No Accessory found.</p>
                    <% } %>
                </div>
                <div class="news-pagination">
                    <button class="news-page-btn" data-page="1">1</button>
                    <button class="news-page-btn" data-page="2">2</button>
                </div>
            </div>
        </section>
        <% } %>
        <jsp:include page="footer.jsp" />
    </body>
</html>
