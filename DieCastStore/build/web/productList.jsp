<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="model.ImageModel" %>
<%@ page import="java.util.List" %>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <title>All Products</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f1f8e9;
                margin: 0;
                padding: 0;
            }

            /* Giãn dòng cho chữ "All Products" */
            h1.title {
                margin-top: 25px;
                margin-bottom: 10px;
            }

            /* Các style còn lại không thay đổi */
            h1 {
                text-align: center;
                margin: 0;
            }

            /* Các class còn lại giữ nguyên */
            .carousel-wrapper {
                position: relative;
                width: 90%;
                margin: auto;
                overflow: hidden;
            }

            .product-container {
                display: flex;
                transition: transform 0.5s ease-in-out;
                scroll-behavior: smooth;
                overflow-x: auto;
                scrollbar-width: none; /* Firefox */
            }
            .product-container::-webkit-scrollbar {
                display: none; /* Chrome, Safari */
            }

            .product-card {
                flex: 0 0 25%;
                box-sizing: border-box;
                padding: 10px;
            }

            .card-inner {
                border: 1px solid #ccc;
                border-radius: 8px;
                text-align: center;
                background-color: #fff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                transition: 0.3s;
                height: 100%; /* đảm bảo full chiều cao nếu cần */
            }


            .card-inner:hover {
                box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            }

            .product-image {
                width: 100%;
                height: 200px; /* hoặc cao hơn nếu cần khung lớn hơn */
                object-fit: contain;
                background-color: transparent; /* nền trong suốt */
                border-radius: 0;
                display: block;
            }

            .product-info {
                padding: 10px;
            }

            .product-name {
                font-size: 16px;
                font-weight: bold;
                margin: 10px 0;
                height: 48px;
                overflow: hidden;
            }

            .product-price {
                color: red;
                font-size: 18px;
                font-weight: bold;
            }

            .arrow {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                font-size: 30px;
                color: #333;
                cursor: pointer;
                user-select: none;
                background: rgba(255,255,255,0.8);
                padding: 5px 10px;
                border-radius: 50%;
                z-index: 10;
            }

            .arrow.left {
                left: 10px;
            }

            .arrow.right {
                right: 10px;
            }

            .no-products {
                text-align: center;
                color: red;
            }

            .brand-slider-wrapper {
                display: flex;
                overflow-x: auto;
                scroll-behavior: smooth;
                flex-grow: 1;
                scrollbar-width: none;
            }

            .brand-slider-wrapper::-webkit-scrollbar {
                display: none;
            }

            .brand-slider-wrapper img {
                mix-blend-mode: multiply;
            }
            /* Hover cho các logo brand */
            .brand-slider-wrapper a img:hover {
                transform: scale(1.2); /* Phóng to khi hover */
            }

            /* Hover cho social media icons */
            .brand-slider-wrapper a[title]:hover img {
                transform: scale(1.3); /* Phóng to nhiều hơn một chút */
            }
            /*            .product-link-btn {
                            background: none;
                            border: none;
                            padding: 0;
                            margin: 0;
                            width: 100%;
                            text-align: left;
                            cursor: pointer;
                            color: inherit;
                            font: inherit;
                            display: block;
                        }
            
                        .product-link-btn:hover {
                            filter: brightness(0.95);  hiệu ứng hover nhẹ 
                        }*/

        </style>
    </head>
    <body>
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
                        String imageUrl = "https://via.placeholder.com/220x150?text=No+Image";
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
        <script>
            const carousel = document.getElementById('carousel');
            function scrollCarousel(direction) {
                const cardWidth = carousel.querySelector('.product-card').offsetWidth;
                carousel.scrollBy({left: direction * cardWidth, behavior: 'smooth'});
            }
        </script>
        <jsp:include page="footer.jsp" />
    </body>
</html>