<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="model.ImageModel" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
    <head>
        <title>All Products</title>
        <link rel="stylesheet" href="assects/CSS/productList.css">
        <script src="assects/JS/productList.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div style="width: 100%; margin: 0; padding: 0;">
            <img src="assects/image/banner.jpg" alt="Promotional Banner" style="width: 100%; height: 500px; display: block;">
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
        <h2 style="text-align:center; margin-top: 50px; margin-bottom: 20px; font-weight: bold; color: #333;">★  Our Partners  ★</h2>
        <div class="brand-slider-wrapper" id="brandSlider" style="display: flex; justify-content: center; gap: 20px; padding: 10px 0;">
            <a title="AutoArt">
                <img src="assects/image/logoAA.jpg" alt="AutoArt" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Bburago">
                <img src="assects/image/logoB.png" alt="Bburago" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="GreenLight">
                <img src="assects/image/logoGL.png" alt="GreenLight" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Hot Wheels">
                <img src="assects/image/logoHW.png" alt="Hot Wheels" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Kyosho">
                <img src="assects/image/logoKS.png" alt="Kyosho" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Maisto">
                <img src="assects/image/logoMS.png" alt="Maisto" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Minichamps">
                <img src="assects/image/logoMini.png" alt="Minichamps" style="width: 120px; margin-top: 35px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Welly">
                <img src="assects/image/logoW.png" alt="Welly" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
        </div>

        <hr style="border: none; height: 2px; background-color: #c5e1a5; margin: 0 auto; width: 80%;">

        <h2 style="text-align:center; margin-top: 50px; margin-bottom: 20px; font-weight: bold; color: #333;">★  Social Media  ★</h2>
        <div class="brand-slider-wrapper" style="display: flex; justify-content: center; gap: 20px; margin-bottom: 50px;">
            <a title="Facebook">
                <img src="assects/image/fb.png" alt="Facebook" style="width: 50px; height: 50px; transition: transform 0.3s;">
            </a>
            <a title="Instagram">
                <img src="assects/image/ig.png" alt="Instagram" style="width: 50px; height: 50px; transition: transform 0.3s;">
            </a>
            <a title="TikTok">
                <img src="assects/image/tik.png" alt="TikTok" style="width: 50px; height: 50px; transition: transform 0.3s;">
            </a>
            <a title="YouTube">
                <img src="assects/image/ytb.png" alt="YouTube" style="width: 50px; height: 50px; transition: transform 0.3s;">
            </a>
        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>