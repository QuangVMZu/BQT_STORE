<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Diecast Model Car Slider</title>
        <link rel="stylesheet" href="assects/CSS/home.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div style="width: 100%; margin: 0; padding: 0;">
            <img src="assects/image/banner_1.png" alt="Promotional Banner" style="width: 100%; height: 500px; display: block;">
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
                    <button class="news-page-btn active" data-page="1">1</button>
                    <button class="news-page-btn" data-page="2">2</button>
                </div>
            </div>
        </section>

        <div style="width: 80%; max-width: 1000px; margin: 20px auto; text-align: center;">
            <img src="assects/image/baner_2.jpg" alt="Promotional Banner" style="width: 100%; border-radius: 8px;">
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
                <img src="assects/image/logoGL.png  " alt="GreenLight" style="width: 120px; height: auto; cursor: pointer; transition: transform 0.3s;">
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
    <script src="assects/JS/home.js"></script>
</html>
