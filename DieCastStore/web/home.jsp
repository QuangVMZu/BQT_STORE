<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<jsp:include page="header.jsp" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Diecast Model Car Slider</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f1f8e9;
                margin: 0;
                padding: 0;
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
                grid-template-columns: repeat(2, 1fr);
                grid-template-rows: repeat(2, auto);
                gap: 20px;
                transition: transform 0.5s ease-in-out;
            }

            .news-card {
                background: none;         /* Không nền */
                border: none;             /* Không viền */
                border-radius: 0;         /* Không bo góc */
                box-shadow: none;         /* Không bóng */
                overflow: hidden;
                text-decoration: none;
                color: #333;
                transition: transform 0.3s;
                padding: 0;               /* Không khoảng đệm */
                margin: 0;                /* Không khoảng cách dư */
            }

            .news-card:hover {
                transform: scale(1.03);
            }

            .news-card img {
                width: 100%;
                height: 280px;
                width: 460px;
                object-fit: cover;
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

            .prev-btn, .next-btn {
                position: absolute;
                top: 40%;
                transform: translateY(-50%);
                background-color: #ffffff;
                border: none;
                font-size: 24px;
                padding: 8px 12px;
                cursor: pointer;
                border-radius: 50%;
                box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            }

            .prev-btn {
                left: 10px;
            }

            .next-btn {
                right: 10px;
            }

            .prev-btn:hover, .next-btn:hover {
                background-color: #e0e0e0;
            }
        </style>
    </head>
    <body>

        <div style="width: 100%; margin: 0; padding: 0;">
            <img src="assects/image/baner_2.jpg" alt="Promotional Banner" style="width: 100%; height: 500px; display: block;">
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
                        <img src="assects/img/MTB002/4.jpg" alt="MTB002">
                        <h3>Land Rover Defender 90</h3>
                        <p>Matchbox presents the Defender 90 1/64 scale.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=AAT001" class="news-card">
                        <img src="assects/img/AAT001/3.jpg" alt="AAT001">
                        <h3>Porsche 911 GT3 RS</h3>
                        <p>AutoArt is famous for its detailed large scale models and this 911 GT3 RS is proof.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=AAT002" class="news-card">
                        <img src="assects/img/AAT002/1.jpg" alt="Off-AAT002">
                        <h3>McLaren P1</h3>
                        <p>AutoArt presents the ultimate 1/18 scale McLaren P1 model.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=WLY002" class="news-card">
                        <img src="assects/img/WLY002/1.jpg" alt="WLY002">
                        <h3>Audi R8 V10 Plus</h3>
                        <p>Welly 1/24 scale model simulates the Audi R8 V10 supercar with exquisite details.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=GL001" class="news-card">
                        <img src="assects/img/GL001/1.jpg" alt="GL001">
                        <h3>Dodge Charger R/T</h3>
                        <p>GreenLight brings you the classic muscle car Dodge Charger R/T in 1/64 scale.</p>
                    </a>
                    <a href="ProductController?action=detail&modelId=BBR003" class="news-card">
                        <img src="assects/img/BBR003/1.jpg" alt="BBR003">
                        <h3>Ferrari 488 GTB</h3>
                        <p>Bburago is 1/24 model recreates the Ferrari 488 GTB supercar with sporty lines.</p>
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
            <img src="assects/image/banner.jpg" alt="Promotional Banner" style="width: 100%; border-radius: 8px;">
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
            const itemsPerPage = 4;
            const newsCards = document.querySelectorAll('.news-card');
            const pageButtons = document.querySelectorAll('.news-page-btn');

            function showPage(page) {
                newsCards.forEach((card, index) => {
                    card.style.display = (index >= (page - 1) * itemsPerPage && index < page * itemsPerPage)
                            ? 'block' : 'none';
                });

                pageButtons.forEach(btn => btn.classList.remove('active'));
                document.querySelector(`.news-page-btn[data-page="${page}"]`).classList.add('active');
            }

            pageButtons.forEach(btn => {
                btn.addEventListener('click', () => {
                    const page = parseInt(btn.dataset.page);
                    showPage(page);
                });
            });

            // Show first page on load
            showPage(1);
        </script>
    </body>
    <jsp:include page="footer.jsp" />
</html>
