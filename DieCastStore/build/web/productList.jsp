<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="model.ImageModel" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
    <head>
        <title>All Products</title>
        <link rel="stylesheet" href="assets/CSS/productList.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="banner-slider" style="margin-top: 30px">
            <div class="banner-track">  
                <img src="assets/image/BQT_STORE.png" class="banner-slide" alt="Banner 1">
                <img src="assets/image/banner_2.png" class="banner-slide" alt="Banner 2">
                <img src="assets/image/banner_3.png" class="banner-slide" alt="Banner 3">
            </div>
            <button class="banner-btn prev-btn">&#10094;</button>
            <button class="banner-btn next-btn">&#10095;</button>
        </div>

        <div class="product-page">
            </br>
            <h1 class="title">All Products</h1>

            <%
                List<ModelCar> products = (List<ModelCar>) request.getAttribute("productList");
                if (products != null && !products.isEmpty()) {
            %>
            <div class="carousel-wrapper">
                <div class="arrow left" onclick="scrollCarousel(-1)">&#10094;</div>
                <div class="arrow right" onclick="scrollCarousel(1)">&#10095;</div>

                <div class="product-container" id="carousel">
                    <% for (ModelCar product : products) {
                        String imageUrl = null;
                        List<ImageModel> images = product.getImages();
                        if (images != null && !images.isEmpty()) {
                            imageUrl = images.get(0).getImageUrl();
                        }
                    %>
                    <div class="product-card">
                        <a class="product-link" href="ProductController?action=detail&modelId=<%= product.getModelId() %>" style="text-decoration: none; color: inherit;">
                            <div class="card-inner">
                                <img class="product-image" src="<%= imageUrl %>" alt="<%= product.getModelName() %>">
                                <div class="product-info">
                                    <div class="product-name"><%= product.getModelName() %></div>
                                    <div class="product-price">$<%= String.format("%,.2f", product.getPrice()) %></div>
                                </div>
                            </div>
                        </a>            
                    </div>
                    <% } %>
                </div>
            </div>
            <%
                } else {
            %>
            <p class="no-products">No products found.</p>
            <%
                }
            %>
        </div>

        <h2 style="text-align:center; margin-top: 50px; margin-bottom: 20px; font-weight: bold; color: #333;">★  Social Media  ★</h2>
        <div class="brand-slider-wrapper" style="display: flex; justify-content: center; gap: 20px; margin-bottom: 50px;">
            <a title="Facebook">
                <img src="assets/image/fb.png" alt="Facebook" style="width: 50px; height: 50px; transition: transform 0.3s;">
            </a>
            <a title="Instagram">
                <img src="assets/image/ig.png" alt="Instagram" style="width: 50px; height: 50px; transition: transform 0.3s;">
            </a>
            <a title="TikTok">
                <img src="assets/image/tik.png" alt="TikTok" style="width: 50px; height: 50px; transition: transform 0.3s;">
            </a>
            <a title="YouTube">
                <img src="assets/image/ytb.png" alt="YouTube" style="width: 50px; height: 50px; transition: transform 0.3s;">
            </a>
        </div>

        <hr style="border: none; height: 1.5px; background-color: #90caf9; margin: 0 auto; width: 50%;">

        <h2 style="text-align:center; margin-top: 50px; margin-bottom: 20px; font-weight: bold; color: #333;">★  Our Partners  ★</h2>
        <div class="brand-slider-wrapper" id="brandSlider" style="display: flex; justify-content: center; gap: 20px; padding: 10px 0;">
            <a title="AutoArt">
                <img src="assets/image/logoAA.jpg" alt="AutoArt" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Bburago">
                <img src="assets/image/logoB.png" alt="Bburago" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="GreenLight">
                <img src="assets/image/logoGL.png" alt="GreenLight" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Hot Wheels">
                <img src="assets/image/logoHW.png" alt="Hot Wheels" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Kyosho">
                <img src="assets/image/logoKS.png" alt="Kyosho" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Maisto">
                <img src="assets/image/logoMS.png" alt="Maisto" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Minichamps">
                <img src="assets/image/logoMini.png" alt="Minichamps" style="width: 120px; margin-top: 35px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Welly">
                <img src="assets/image/logoW.png" alt="Welly" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
        </div>
        <jsp:include page="footer.jsp" />
        <script src="assets/JS/productList.js"></script>
    </body>
</html>