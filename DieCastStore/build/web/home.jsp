<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@page import="model.CustomerAccount"%>
<%@page import="utils.AuthUtils"%>
<%@page import="dao.HomeGalleryDAO"%>
<%@page import="dao.ModelCarDAO"%>
<%@page import="model.HomeGallery"%>
<%@page import="model.ModelCar"%>
<%@page import="model.ImageModel"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Diecast Model_BQT Store</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/home.css">

    <body>
        <jsp:include page="header.jsp" />
        <% 
            HomeGalleryDAO galleryDAO = new HomeGalleryDAO();
            List<HomeGallery> gallery = galleryDAO.getGallery(); // bạn nên sắp xếp theo display_order trong DAO
            String description = gallery.isEmpty() ? "" : gallery.get(0).getDescription(); // tất cả ảnh dùng chung description
            HomeGalleryDAO dao = new HomeGalleryDAO();
            List<HomeGallery> bannerList = dao.getBanner(); // Hàm này trả về ảnh banner
            ModelCarDAO car = new ModelCarDAO();
            List<ModelCar> newestProducts = car.getNewest16Products();
            String checkError = (String) request.getAttribute("checkError");
            String message = (String) request.getAttribute("message");
        %>

        <% if (checkError != null && !checkError.isEmpty()) { %>
        <div class="error-message mt-3"><%= checkError %></div>
        <% } else if (message != null && !message.isEmpty()) { %>
        <div class="success-message mt-3"><%= message %></div>
        <% } %>

        <div class="banner-slider">
            <div class="banner-track">
                <% if (bannerList == null || bannerList.isEmpty()) { %>
                <img src="assets/image/BQT_STORE.png" class="banner-slide" alt="Banner">
                <img src="assets/image/banner_2.png" class="banner-slide" alt="Banner">
                <img src="assets/image/banner.png" class="banner-slide" alt="Banner">
                <img src="assets/image/banner_3.png" class="banner-slide" alt="Banner">
                <% } else { 
                for (HomeGallery banner : bannerList) { %>
                <img src="<%= banner.getImageUrl() %>" class="banner-slide" alt="Banner">
                <%  } 
            } %>
            </div>
            <button class="banner-btn prev-btn">&#10094;</button>
            <button class="banner-btn next-btn">&#10095;</button>
        </div>


        <h2 style="text-align:center; margin-top: 50px; margin-bottom: -30px; font-weight: bold; color: #333;">★  New product  ★</h2><br/>

        <section class="news-section">
            <div class="news-carousel">
                <div class="news-items">
                    <% for (ModelCar productCar : newestProducts) { 
                            if(productCar.getQuantity() == - 1) continue;
                        List<ImageModel> images = productCar.getImages();
                    %>
                    <a href="ProductController?action=detail&modelId=<%= productCar.getModelId() %>" class="news-card">
                        <% if (images != null && !images.isEmpty()) { %>
                        <img src="<%= images.get(0).getImageUrl() %>" alt="<%= images.get(0).getCaption() %>">
                        <% } else { %>
                        <img src="assets/img/default.jpg" alt="No image">
                        <% } %>
                        <h3><%= productCar.getModelName() %></h3>
                        <p>Price: <%= productCar.getPrice() %></p>
                    </a>
                    <% } %>
                </div>
                <div class="news-pagination">
                    <button class="news-page-btn active" data-page="1">1</button>
                    <button class="news-page-btn" data-page="2">2</button>
                    <button class="news-page-btn" data-page="3">3</button>
                </div>
            </div>

            <div class="model-intro">
                <h3>About the Car Model</h3>
                <% if (gallery == null || gallery.isEmpty()) { %>
                <p>
                    Car models are exquisite miniature copies of famous car lines in the world.
                    With popular scales such as 1:18, 1:24, 1:64,... the models are produced by prestigious brands such as AutoArt, Bburago, Kyosho, Welly,...
                    They are not only aesthetic but also show the passion of model car players.
                    Collecting model cars is more than just a hobby — it is a way to preserve automotive history and craftsmanship in a compact, tangible form.
                    Each piece is meticulously crafted with attention to detail, from engine components to interior design, allowing collectors to experience the elegance and engineering of real vehicles.
                    Whether you are a seasoned enthusiast or just starting out, model cars offer a unique blend of art, nostalgia, and technical fascination.
                </p>
                <% } else { %>
                <%-- Mô tả lấy từ DB --%>
                <p><%= description %></p>
                <% } %>
                <%-- Thư viện ảnh --%>
                <div class="model-gallery">
                    <% if (gallery == null || gallery.isEmpty()) { %>
                    <div style="display: inline-block; margin: 10px;">
                        <img src="assets/img/AAT001/1.jpg" alt="Default Gallery 1" style="width: 200px; height: auto;"><br>                      
                    </div>
                    <div style="display: inline-block; margin: 10px;">
                        <img src="assets/img/AAT001/2.jpg" alt="Default Gallery 2" style="width: 200px; height: auto;"><br>
                    </div>
                    <div style="display: inline-block; margin: 10px;">
                        <img src="assets/img/AAT001/3.jpg" alt="Default Gallery 3" style="width: 200px; height: auto;"><br>
                    </div>
                    <div style="display: inline-block; margin: 10px;">
                        <img src="assets/img/AAT001/4.jpg" alt="Default Gallery 4" style="width: 200px; height: auto;"><br>
                    </div>
                    <% } else { 
                        for (HomeGallery img : gallery) { %>
                    <div style="display: inline-block; margin: 10px;">
                        <img src="<%= img.getImageUrl() %>" alt="<%= img.getCaption() %>" style="width: 200px; height: auto;"><br>
                        <span><%= img.getCaption() %></span>
                    </div>
                    <% } } %>
                </div>
            </div>
        </section>

        <script id="chatbase-script"
                src="https://www.chatbase.co/embed.min.js"
                chatbotId="24voNCBYpeJgbiYuJUH4Z"
                domain="www.chatbase.co"
                popup="true">
        </script>
        <jsp:include page="footer.jsp" />
    </body>
    <script src="assets/js/home.js"></script>
</html>
