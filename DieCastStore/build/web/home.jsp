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
        <link rel="stylesheet" href="assets/CSS/home.css">

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
        <h2 style="text-align:center; margin-top: 20px; margin-bottom: 20px; font-weight: bold; color: #333;">★  Social Media  ★</h2>
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
                <img src="assets/image/logoAA.png" alt="AutoArt" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="Bburago">
                <img src="assets/image/logoB.png" alt="Bburago" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
            </a>
            <a title="GreenLight">
                <img src="assets/image/logoGL.png  " alt="GreenLight" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
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
        </div><br>
        <jsp:include page="footer.jsp" />
    </body>
    <script src="assets/JS/home.js"></script>
</html>
