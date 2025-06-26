<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@page import="model.CustomerAccount"%>
<%@page import="utils.AuthUtils"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Diecast Model_BQT Store</title>
        <link rel="stylesheet" href="assets/CSS/home.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="banner-slider">
            <div class="banner-track">
                <img src="assets/image/BQT_STORE.png" class="banner-slide" alt="Banner 1">
                <img src="assets/image/banner_2.png" class="banner-slide" alt="Banner 2">
                <img src="assets/image/banner_3.png" class="banner-slide" alt="Banner 3">
            </div>
            <button class="banner-btn prev-btn">&#10094;</button>
            <button class="banner-btn next-btn">&#10095;</button>
        </div>

        <h2 style="text-align:center; margin-top: 50px; margin-bottom: -30px; font-weight: bold; color: #333;">★  New product  ★</h2><br/>

        <% if (AuthUtils.isAdmin(request)) { %>
        <div style="text-align:center; margin-bottom: 10px;">
            <a href="EditNewProducts.jsp" class="edit-btn" style="padding: 6px 12px; background-color: #ffc107; color: #000; border-radius: 5px; text-decoration: none;">Edit New Products</a>
        </div>
        <% } %>
        <section class="news-section">
            <div class="news-carousel">
                <div class="news-items">
                    <a href="ProductController?action=detail&modelId=KYO001" class="news-card">
                        <img src="assets/img/KYO001/1.jpg" alt="KYO001">
                        <h3>Mazda RX-7 FD3S</h3>
                        <p>Kyosho presents the highly detailed 1/24 scale RX-7 FD3S.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=MTB002" class="news-card">
                        <img src="assets/img/MTB002/1.jpg" alt="MTB002">
                        <h3>Land Rover Defender 90</h3>
                        <p>Matchbox presents the Defender 90 1/64 scale.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=AAT001" class="news-card">
                        <img src="assets/img/AAT001/1.jpg" alt="AAT001">
                        <h3>Porsche 911 GT3 RS</h3>
                        <p>AutoArt is famous for its detailed 1/64 scale models. </p>
                    </a>
                    <a href="ProductController?action=detail&modelId=AAT002" class="news-card">
                        <img src="assets/img/AAT002/1.jpg" alt="Off-AAT002">
                        <h3>McLaren P1</h3>
                        <p>AutoArt presents the ultimate 1/18 scale McLaren P1 model.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=WLY002" class="news-card">
                        <img src="assets/img/WLY002/1.jpg" alt="WLY002">
                        <h3>Audi R8 V10 Plus</h3>
                        <p>Audi R8 V10 model is 1/24 of Welly with exquisite details.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=GL001" class="news-card">
                        <img src="assets/img/GL001/1.jpg" alt="GL001">
                        <h3>Dodge Charger R/T</h3>
                        <p>GreenLight is classic muscle car Dodge Charger R/T in 1/64 scale.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=BBR003" class="news-card">
                        <img src="assets/img/BBR003/1.jpg" alt="BBR003">
                        <h3>Ferrari 488 GTB</h3>
                        <p>Bburago's 1/24 model the Ferrari 488 GTB supercar with sporty.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=MGT003" class="news-card">
                        <img src="assets/img/MGT003/1.jpg" alt="MGT003">
                        <h3>Honda Civic Type R FK8</h3>
                        <p>MiniGT presents the 1/64 scale Civic Type R FK8 with a sporty.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=AAT001" class="news-card">
                        <img src="assets/img/AAT001/1.jpg" alt="AAT001">
                        <h3>Porsche 911 GT3 RS</h3>
                        <p>AutoArt delivers the high-performance Porsche 911 GT3 RS in stunning 1/18 scale detail.</p>
                    </a>

                    <a href="ProductController?action=detail&modelId=BBR002" class="news-card">
                        <img src="assets/img/BBR002/1.jpg" alt="BBR002">
                        <h3>Lamborghini Huracán</h3>
                        <p>BBR showcases the aggressive and aerodynamic Lamborghini Huracán EVO in premium scale.</p>
                    </a>

                    <a href="ProductController?action=detail&modelId=HW002" class="news-card">
                        <img src="assets/img/HW002/1.jpg" alt="HW002">
                        <h3>Ford Mustang GT</h3>
                        <p>Hot Wheels features the iconic American muscle Ford Mustang GT in compact 1/64 scale.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=GL002" class="news-card">
                        <img src="assets/img/GL002/1.jpg" alt="GL002">
                        <h3>Chevrolet Impala SS</h3>
                        <p>GreenLight presents the classic Chevrolet Impala SS in detailed 1/64 scale for collectors.</p>
                    </a>

                    <a href="ProductController?action=detail&modelId=AAT003" class="news-card">
                        <img src="assets/img/AAT003/1.jpg" alt="AAT003">
                        <h3>BMW I8</h3>
                        <p>AutoArt introduces the futuristic BMW i8 in 1/18 scale, combining luxury and performance.</p>
                    </a>

                    <a href="ProductController?action=detail&modelId=BBR003" class="news-card">
                        <img src="assets/img/BBR003/1.jpg" alt="BBR003">
                        <h3>Ferrari 488 GTB</h3>
                        <p>BBR presents the sleek and powerful Ferrari 488 GTB in exquisite 1/18 collector scale.</p>
                    </a>

                    <a href="ProductController?action=detail&modelId=HW003" class="news-card">
                        <img src="assets/img/HW003/1.jpg" alt="HW003">
                        <h3>Tesla Model S</h3>
                        <p>Hot Wheels brings the cutting-edge electric Tesla Model S to life in compact 1/64 scale.</p>
                    </a>

                    <a href="ProductController?action=detail&modelId=GL004" class="news-card">
                        <img src="assets/img/GL004/1.jpg" alt="GL004">
                        <h3>Jeep Grand Cherokee</h3>
                        <p>GreenLight offers the rugged and capable Jeep Grand Cherokee in a realistic 1/64 scale model.</p>
                    </a>

                    <a href="ProductController?action=detail&modelId=TMC002" class="news-card">
                        <img src="assets/img/TMC002/1.jpg" alt="TMC002">
                        <h3>Suzuki Jimny</h3>
                        <p>Tomica presents the compact and iconic Suzuki Jimny with realistic details in 1/64 scale.</p>
                    </a>

                    <a href="ProductController?action=detail&modelId=MST002" class="news-card">
                        <img src="assets/img/MST002/1.jpg" alt="MST002">
                        <h3>Jeep Wrangler Rubicon</h3>
                        <p>Maisto delivers the off-road-ready Jeep Wrangler Rubicon in rugged 1/24 scale form.</p>
                    </a>

                    <a href="ProductController?action=detail&modelId=KYO003" class="news-card">
                        <img src="assets/img/KYO003/1.jpg" alt="KYO003">
                        <h3>Nissan GT-R R35</h3>
                        <p>Kyosho showcases the legendary Nissan GT-R R35 in 1/18 scale with precision detailing.</p>
                    </a>

                    <a href="ProductController?action=detail&modelId=TMC004" class="news-card">
                        <img src="assets/img/TMC004/1.jpg" alt="TMC004">
                        <h3>Subaru Outback</h3>
                        <p>Tomica models the versatile Subaru Outback in 1/64 scale with impressive all-terrain styling.</p>
                    </a>
                </div>
                <div class="news-pagination">
                    <button class="news-page-btn active" data-page="1">1</button>
                    <button class="news-page-btn" data-page="2">2</button>
                    <button class="news-page-btn" data-page="3">3</button>
                </div>
            </div>

            <div class="model-intro">
                <h3>About the Car Model</h3>
                <p>
                    Car models are exquisite miniature copies of famous car lines in the world.
                    With popular scales such as 1:18, 1:24, 1:64,... the models are produced by prestigious brands such as AutoArt, Bburago, Kyosho, Welly,...
                    They are not only aesthetic but also show the passion of model car players.
                    Collecting model cars is more than just a hobby — it is a way to preserve automotive history and craftsmanship in a compact, tangible form.
                    Each piece is meticulously crafted with attention to detail, from engine components to interior design, allowing collectors to experience the elegance and engineering of real vehicles.
                    Whether you are a seasoned enthusiast or just starting out, model cars offer a unique blend of art, nostalgia, and technical fascination.
                </p>

                <div class="model-gallery">
                    <img src="assets/img/KYO001/1.jpg" alt="Mazda RX-7">
                    <img src="assets/img/MTB002/1.jpg" alt="Land Rover Defender">
                    <img src="assets/img/AAT001/1.jpg" alt="Porsche 911 GT3 RS">
                    <img src="assets/img/WLY002/1.jpg" alt="Audi R8 V10">
                </div>
            </div>

        </section>
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
