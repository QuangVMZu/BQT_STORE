<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="model.ImageModel" %>
<%@ page import="java.util.List" %>

<%
    String keyword = (String) request.getAttribute("keyword");
    List<ModelCar> results = (List<ModelCar>) request.getAttribute("searchResults");
    int currentPage = request.getAttribute("currentPage") != null ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = request.getAttribute("totalPages") != null ? (Integer) request.getAttribute("totalPages") : 1;
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Kết quả tìm kiếm</title>
        <link rel="stylesheet" href="assects/headerCss/style.css" />
        <style>
            .search-content * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            .search-content {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f1f8e9;
                padding-bottom: 60px;
            }

            .search-content h2 {
                text-align: center;
                margin: 40px 0 20px;
                color: #333;
            }

            .search-content .product-container {
                max-width: 1200px;
                margin: 0 auto 20px;
                padding: 30px 20px;
            }
            .product-container {
                background-color: #ffffff;
                border: 1px solid #ccc;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                max-width: 1200px;
                margin: 0 auto 50px;
                padding: 30px 20px;
            }

            .search-content .product-grid {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                justify-content: center;
            }

            .search-content .product-item {
                width: 250px;
                border: 1px solid #ddd;
                border-radius: 10px;
                background: #fff;
                padding: 16px;
                text-align: center;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .search-content .product-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            }

            .search-content .product-item img {
                width: 100%;
                height: 180px;
                object-fit: cover;
                border-radius: 6px;
                margin-bottom: 12px;
            }

            .search-content .product-name {
                font-size: 1.1rem;
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
                min-height: 48px;
            }

            .search-content .product-price {
                font-size: 1rem;
                color: #2e7d32;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .search-content .product-item a {
                text-decoration: none;
                color: inherit;
            }

            .search-content .no-result {
                text-align: center;
                color: #666;
                font-size: 1.2rem;
                margin-top: 60px;
            }

            .search-content .back-button {
                display: block;
                text-align: center;
                margin: 30px auto;
            }

            .search-content h2 {
                margin-top: 0px;
            }

            .search-content .back-button a {
                padding: 10px 20px;
                background-color: #004d40;
                color: white;
                text-decoration: none;
                border-radius: 6px;
                transition: background-color 0.3s ease;
            }

            .search-content .back-button a:hover {
                background-color: #00332c;
            }

            .search-content .pagination {
                text-align: center;
                margin: 20px auto;
            }

            .search-content .pagination a,
            .search-content .pagination strong {
                margin: 0 5px;
                text-decoration: none;
                font-size: 1rem;
                color: #00695c;
                padding: 6px 10px;
                border: 1px solid #a5d6a7; /* Viền xanh lá nhạt */
                border-radius: 4px;
            }

            .search-content .pagination a:hover {
                background-color: #e8f5e9; /* Nền xanh nhạt khi hover */
                text-decoration: none;
            }

            .search-content .pagination strong {
                color: black;
                background-color: #c8e6c9; /* Nền xanh lá nhạt cho trang hiện tại */
                font-weight: bold;
            }

            .brand-slider-wrapper img {
                mix-blend-mode: multiply;
            }

            .brand-slider-wrapper img:hover,
            .social-media-wrapper img:hover {
                transform: scale(1.2);
                transition: transform 0.2s;
            }

            @media (max-width: 768px) {
                .search-content .product-item {
                    width: 90%;
                }
            }
        </style>

    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div style="width: 100%; margin: 0; padding: 0;">
            <img src="assects/image/baner_2.jpg" alt="Promotional Banner" style="width: 100%; height: 500px; display: block;">
        </div>
        <main class="search-content"><br>
            <h2>Kết quả tìm kiếm cho: "<%= keyword %>"</h2>

            <div class="product-container">
                <% if (results != null && !results.isEmpty()) { %>
                <div class="product-grid">
                    <% for (ModelCar car : results) {
                        String imgUrl = "no-image.jpg";
                        if (car.getImages() != null && !car.getImages().isEmpty()) {
                            imgUrl = car.getImages().get(0).getImageUrl();
                        }
                    %>
                    <div class="product-item">
                        <a href="ProductController?action=detail&modelId=<%= car.getModelId() %>">
                            <img src="<%= imgUrl %>" alt="Product Image">
                            <div class="product-name"><%= car.getModelName() %></div>
                        </a>
                        <div class="product-price">$<%= String.format("%,.2f", car.getPrice()) %></div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <p class="no-result">Không tìm thấy sản phẩm nào phù hợp.</p>
                <% } %>
            </div>

            <!-- PHÂN TRANG -->
            <% if (totalPages > 1) { %>
            <div class="pagination">
                <% if (currentPage > 1) { %>
                <a href="ProductController?action=search&keyword=<%= keyword %>&page=<%= currentPage - 1 %>">← Trang trước</a>
                <% } %>

                <% for (int i = 1; i <= totalPages; i++) { %>
                <% if (i == currentPage) { %>
                <strong><%= i %></strong>
                <% } else { %>
                <a href="ProductController?action=search&keyword=<%= keyword %>&page=<%= i %>"><%= i %></a>
                <% } %>
                <% } %>

                <% if (currentPage < totalPages) { %>
                <a href="ProductController?action=search&keyword=<%= keyword %>&page=<%= currentPage + 1 %>">Trang sau →</a>
                <% } %>
            </div>
            <% } %>
        </main>
        <!-- OUR PARTNERS SECTION -->
        <div style="background-color: #f1f8e9; padding: 30px 0;">
            <h2 style="text-align:center; margin-top: 0; margin-bottom: 20px; font-weight: bold; color: #333;">★  Our Partners  ★</h2>
            <div class="brand-slider-wrapper" id="brandSlider" style="display: flex; justify-content: center; flex-wrap: wrap; gap: 20px; padding: 10px 0;">
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
        </div>
        
        <hr style="border: none; height: 2px; background-color: #c5e1a5; margin: 0 auto; width: 80%;">
        
        <!-- SOCIAL MEDIA SECTION -->
        <div style="background-color: #f1f8e9; padding: 30px 0;">
            <h2 style="text-align:center; margin-top: 0; margin-bottom: 20px; font-weight: bold; color: #333;">★  Social Media  ★</h2>
            <div class="social-media-wrapper" style="display: flex; justify-content: center; gap: 20px;">
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
        </div>
    </body>

    <jsp:include page="footer.jsp" />
</html>
