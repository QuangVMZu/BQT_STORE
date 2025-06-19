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
        <link rel="stylesheet" href="assets/CSS/productSearch.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div style="width: 100%; margin: 0; padding: 0; text-align: center; background-color: #f1f8e9;">
            <img src="assets/image/BQT_STORE.png" alt="Promotional Banner"
                 style="width: 1200px; height: 300px; display: inline-block;">
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
                <p class="no-result">No matching products were found.</p>
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
        </div>

        <hr style="border: none; height: 2px; background-color: #c5e1a5; margin: 0 auto; width: 80%;">

        <!-- SOCIAL MEDIA SECTION -->
        <div style="background-color: #f1f8e9; padding: 30px 0;">
            <h2 style="text-align:center; margin-top: 0; margin-bottom: 20px; font-weight: bold; color: #333;">★  Social Media  ★</h2>
            <div class="social-media-wrapper" style="display: flex; justify-content: center; gap: 20px;">
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
        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>
