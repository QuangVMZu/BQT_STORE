<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="model.ImageModel" %>
<%@ page import="model.BrandModel" %>
<%@ page import="java.util.List" %>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <title>Product Detail</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f1f8e9;
                margin: 0;
                padding: 0;
            }

            .detail-container {
                max-width: 1200px;
                margin: 40px auto;
                padding: 20px;
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
            }

            .product-top {
                display: flex;
                gap: 30px;
                align-items: flex-start;
            }

            .detail-image {
                width: 550px;
                height: auto;
                max-width: 650px;
                max-height: 500px;
                object-fit: contain;
                border: none;
                background-color: transparent;
                border-radius: 4px;
                overflow-x: auto;
                white-space: nowrap;
            }

            .thumbnails {
                display: flex;
                gap: 10px;
                margin-top: 10px;
                flex-wrap: wrap;
                max-width: 100%;
            }

            .thumbnail {
                display: inline-block;
                width: 130px;
                height: 130px;
                object-fit: contain;
                border: none;
                background-color: transparent;
                border-radius: 4px;
                cursor: pointer;
                transition: transform 0.2s ease, border-color 0.2s;
            }

            .thumbnail:hover {
                transform: scale(1.1);
                border-color: #66bb6a;
            }

            .detail-info {
                flex-grow: 1;
            }

            .detail-info h2 {
                margin: 0 0 10px;
                color: #2e7d32;
            }

            .detail-info p.price {
                color: #c62828;
                font-size: 26px;
                font-weight: bold;
                margin: 5px 0;
            }

            .product-description {
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #ddd;
            }

            .product-description h3 {
                color: black;
                margin-bottom: 10px;
                font-size: 24px;
            }

            .product-description {
                font-size: 18px;
            }

            input[type=number]::-webkit-inner-spin-button,
            input[type=number]::-webkit-outer-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }

            input[type=number] {
                -moz-appearance: textfield;
            }

            input[type=number] {
                padding: 5px;
                border: 1px solid #a5d6a7;
                border-radius: 5px;
                background-color: #f1f8e9;
                color: #2e7d32;
            }

            button {
                font-size: 16px;
                cursor: pointer;
            }

            button[type="button"] {
                padding: 5px 10px;
                background-color: #a5d6a7;
                color: #1b5e20;
                border: none;
                border-radius: 4px;
                transition: background-color 0.2s;
            }

            button[type="button"]:hover {
                background-color: #81c784;
            }

            .purchase-buttons form button {
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                font-weight: bold;
                transition: background-color 0.3s;
            }

            .purchase-buttons form:first-child button {
                background-color: #43a047;
                color: white;
            }

            .purchase-buttons form:first-child button:hover {
                background-color: #388e3c;
            }

            .purchase-buttons form:last-child button {
                background-color: #66bb6a;
                color: white;
            }

            .purchase-buttons form:last-child button:hover {
                background-color: #4caf50;
            }
            .offer-info, .store-info {
                margin-top: 25px;
                padding: 15px 20px;
                border: 1px solid #a5d6a7;
                border-radius: 16px;
                background-color: #e8f5e9;
                max-width: 650px; /* Giảm kích thước khung */
                font-size: 18px;   /* Thu nhỏ chữ */
            }

            .offer-info h4, .store-info h4 {
                color: #2e7d32;
                margin-bottom: 10px;
                text-align: center;
                font-size: 22px;
                padding-bottom: 5px;
                border-bottom: 1px solid #a5d6a7;
            }

            .offer-info ul {
                list-style: disc;
                margin-left: 20px;
                padding-left: 0;
                color: #33691e;
            }

            .store-info p {
                margin: 3px 0;
                color: #33691e;
            }

            .info-muted {
                font-size: 12px;
                color: #777; /* màu xám mờ */
            }

            .stock-badge {
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 13px;
                font-weight: bold;
                background-color: #e0f2f1;
                color: green;
                border: 1px solid #a5d6a7;
            }

            .stock-badge.out {
                background-color: #ffebee;
                color: red;
                border: 1px solid #ef9a9a;
            }

            .stock-wrapper {
                display: flex;
                justify-content: flex-end;
                margin-top: 5px;
                padding-bottom: 8px;
                border-bottom: 1px solid #ccc; /* Đường kẻ dưới */
            }

            .news-section {
                padding: 30px;
                background-color: #f9f9f9;
                text-align: center;
                background: #f1f8e9;
            }

            .news-title {
                font-size: 28px;
                margin-bottom: 20px;
                color: #222;
            }

            .news-carousel {
                position: relative;
                max-width: 1000px;
                margin: 0 auto;
            }

            .news-items {
                display: grid;
                grid-template-columns: repeat(4, 1fr); /* 4 items mỗi hàng */
                gap: 20px;
                padding: 10px;
                justify-items: center;
                align-items: center;
            }

            .news-card {
                width: 100%;
                aspect-ratio: 4 / 4; /* Giữ tỉ lệ khung hình */
                /*overflow: hidden;*/
                padding: 0;
                margin: 0;
                background: none;
                border: none;
                box-shadow: none;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                transition: transform 0.3s;
                text-decoration: none;
            }

            .news-card:hover {
                transform: scale(1.03);
            }

            .news-card img {
                width: 100%;
                height: 100%;
                object-fit: contain;
                mix-blend-mode: multiply;
            }

            .news-card h3 {
                margin: 10px;
                font-size: 18px;
                color: #000;
            }

            .news-card p {
                margin: 0 10px 10px;
                font-size: 14px;
                color: #555;
            }

            /* Pagination buttons */
            .news-pagination {
                margin-top: 20px;
            }

            .news-page-btn {
                padding: 8px 16px;
                margin: 0 5px;
                background-color: #ddd;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
            }

            .news-page-btn.active {
                background-color: #333;
                color: white;
            }

        </style>
        <script>
            function changeMainImage(src) {
                document.getElementById('mainImage').src = src;
            }

            function adjustQuantity(change) {
                const input = document.getElementById('quantityInput');
                let current = parseInt(input.value);
                let max = parseInt(input.max);
                current += change;
                if (current < 1)
                    current = 1;
                if (current > max)
                    current = max;
                input.value = current;
            }

            function setQuantity(hiddenInputId) {
                const quantity = document.getElementById('quantityInput').value;
                document.getElementById(hiddenInputId).value = quantity;
            }

            document.addEventListener('DOMContentLoaded', function () {
                const itemsPerPage = 4;
                const newsCards = document.querySelectorAll('.news-card');
                const pageButtons = document.querySelectorAll('.news-page-btn');

                function showPage(page) {
                    newsCards.forEach((card, index) => {
                        card.style.display = (index >= (page - 1) * itemsPerPage && index < page * itemsPerPage)
                                ? 'block' : 'none';
                    });

                    pageButtons.forEach(btn => btn.classList.remove('active'));
                    const activeBtn = document.querySelector(`.news-page-btn[data-page="${page}"]`);
                    if (activeBtn)
                        activeBtn.classList.add('active');
                }

                pageButtons.forEach(btn => {
                    btn.addEventListener('click', () => {
                        const page = parseInt(btn.dataset.page);
                        showPage(page);
                    });
                });

                showPage(1);
            });
        </script>
    </head>
    <body>
        <%
            ModelCar product = (ModelCar) request.getAttribute("productDetail");
            if (product != null) {
                List<ImageModel> images = product.getImages();
                String imageUrl = "https://via.placeholder.com/300x200?text=No+Image";
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
