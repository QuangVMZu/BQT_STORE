<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="model.ImageModel" %>
<%@ page import="model.BrandModel" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Product Detail</title>
        <link rel="stylesheet" href="assects/CSS/productDetail.css">
        <script src="assects/JS/productDetail.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <%
            ModelCar product = (ModelCar) request.getAttribute("productDetail");
            if (product != null) {
                List<ImageModel> images = product.getImages();
                String imageUrl = null;
                if (images != null && !images.isEmpty()) {
                    imageUrl = images.get(0).getImageUrl();
                }
        %>
        <div class="detail-container">
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
                    <h2 style="font-size: 28px"><%= product.getModelName() %></h2>
                    <% if (product != null) { %>
                    <p class="info-muted"><strong>Model ID:</strong> <%= product.getModelId() %></p>

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
                            <%= quantity > 0 ? "In stock" : "Out of stock" %>
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
                    <div class="purchase-buttons" style="margin-top: 20px; display: flex; gap: 15px;">
                        <form method="post" action="BuyNowServlet">
                            <input type="hidden" name="modelId" value="<%= product.getModelId() %>">
                            <input type="hidden" name="quantity" id="buyNowQuantity">
                            <button type="submit" onclick="setQuantity('buyNowQuantity')" style="padding: 10px 20px; background-color: #ff5722; color: white; border: none; border-radius: 5px;">Buy Now</button>
                        </form>

                        <form method="post" action="AddToCartServlet">
                            <input type="hidden" name="modelId" value="<%= product.getModelId() %>">
                            <input type="hidden" name="quantity" id="addToCartQuantity">
                            <button type="submit" onclick="setQuantity('addToCartQuantity')" style="padding: 10px 20px; background-color: #2196f3; color: white; border: none; border-radius: 5px;">Add to Cart</button>
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
        <% } else { %>
        <p style="color: red; text-align: center;">Product information not found.</p>
        <% } %>

        <div style="width: 80%; max-width: 1000px; margin: 20px auto; text-align: center;">
            <img src="assects/image/banner.jpg" alt="Promotional Banner" style="width: 100%; border-radius: 8px;">
        </div>

        <h2 style="text-align:center; margin-top: 50px; margin-bottom: -30px; font-weight: bold; color: #333;">★  New product  ★</h2><br/>

        <section class="news-section">
            <div class="news-carousel">
                <div class="news-items">
                    <a href="ProductController?action=detail&modelId=KYO001" class="news-card">
                        <img src="assects/img/KYO001/1.jpg" alt="KYO001">
                        <h3>Mazda RX-7 FD3S</h3>
                        <p>Kyosho presents the highly detailed 1/24 scale RX-7 FD3S.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=MTB002" class="news-card">
                        <img src="assects/img/MTB002/1.jpg" alt="MTB002">
                        <h3>Land Rover Defender 90</h3>
                        <p>Matchbox presents the Defender 90 1/64 scale.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=AAT001" class="news-card">
                        <img src="assects/img/AAT001/1.jpg" alt="AAT001">
                        <h3>Porsche 911 GT3 RS</h3>
                        <p>AutoArt is famous for its detailed 1/64 scale models. </p>
                    </a>
                    <a href="ProductController?action=detail&modelId=AAT002" class="news-card">
                        <img src="assects/img/AAT002/1.jpg" alt="Off-AAT002">
                        <h3>McLaren P1</h3>
                        <p>AutoArt presents the ultimate 1/18 scale McLaren P1 model.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=WLY002" class="news-card">
                        <img src="assects/img/WLY002/1.jpg" alt="WLY002">
                        <h3>Audi R8 V10 Plus</h3>
                        <p>Audi R8 V10 model is 1/24 of Welly with exquisite details.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=GL001" class="news-card">
                        <img src="assects/img/GL001/1.jpg" alt="GL001">
                        <h3>Dodge Charger R/T</h3>
                        <p>GreenLight is classic muscle car Dodge Charger R/T in 1/64 scale.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=BBR003" class="news-card">
                        <img src="assects/img/BBR003/1.jpg" alt="BBR003">
                        <h3>Ferrari 488 GTB</h3>
                        <p>Bburago's 1/24 model the Ferrari 488 GTB supercar with sporty.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=MGT003" class="news-card">
                        <img src="assects/img/MGT003/1.jpg" alt="MGT003">
                        <h3>Honda Civic Type R FK8</h3>
                        <p>MiniGT presents the 1/64 scale Civic Type R FK8 with a sporty.</p>
                    </a>
                </div>
                <div class="news-pagination">
                    <button class="news-page-btn" data-page="1">1</button>
                    <button class="news-page-btn" data-page="2">2</button>
                </div>
            </div>
        </section>
        <jsp:include page="footer.jsp" />
    </body>
</html>
