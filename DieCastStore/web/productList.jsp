<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>All Products</title>
        <link rel="stylesheet" href="assets/css/productList.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background: #e3f2fd;">

        <jsp:include page="header.jsp" />

        <!-- Banner -->
        <div class="banner-slider" style="margin-top: 30px">
            <div class="banner-track">  
                <img src="assets/image/BQT_STORE.png" class="banner-slide" alt="Banner 1">
                <img src="assets/image/banner_2.png" class="banner-slide" alt="Banner 2">
                <img src="assets/image/banner_3.png" class="banner-slide" alt="Banner 3">
            </div>
            <button class="banner-btn prev-btn">&#10094;</button>
            <button class="banner-btn next-btn">&#10095;</button>
        </div>

        <!-- Model Cars -->
        <div class="product-page container" style="max-width: 1400px">
            <br>
            <h1 class="title">★ All Products ★</h1>

            <c:choose>
                <c:when test="${not empty productList}">
                    <div class="carousel-wrapper">
                        <div class="arrow left" onclick="scrollCarousel(-1)">&#10094;</div>
                        <div class="arrow right" onclick="scrollCarousel(1)">&#10095;</div>

                        <div class="product-container" id="carousel">
                            <c:forEach var="product" items="${productList}">
                                <c:if test="${product.quantity > -1}">
                                    <c:set var="imageUrl" value="" />
                                    <c:if test="${not empty product.images}">
                                        <c:set var="imageUrl" value="${product.images[0].imageUrl}" />
                                    </c:if>

                                    <div class="product-card">
                                        <a class="product-link" href="ProductController?action=detail&modelId=${product.modelId}" style="text-decoration: none; color: inherit;">
                                            <div class="card-inner">
                                                <img class="product-image" src="${imageUrl}" alt="${product.modelName}">
                                                <div class="product-info">
                                                    <div class="product-name">${product.modelName}</div>
                                                    <div class="product-price">$<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" /></div>
                                                </div>
                                            </div>
                                        </a>            
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="no-products">No products found.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Accessories -->
        <div class="product-page container" style="max-width: 1400px">
            <br>
            <h1 class="title">★ All Accessory ★</h1>

            <c:choose>
                <c:when test="${not empty accessoryList}">
                    <div class="carousel-wrapper">
                        <div class="arrow left" onclick="scrollAccessoryCarousel(-1)">&#10094;</div>

                        <div class="product-container" id="accessory-carousel">
                            <c:forEach var="acc" items="${accessoryList}">
                                <c:if test="${acc.quantity > -1}">
                                    <div class="product-card">
                                        <a class="product-link" href="ProductController?action=detail&accessoryId=${acc.accessoryId}" style="text-decoration: none; color: inherit;">
                                            <div class="card-inner">
                                                <img class="product-image" src="${acc.imageUrl}" alt="${acc.accessoryName}">
                                                <div class="product-info">
                                                    <div class="product-name">${acc.accessoryName}</div>
                                                    <div class="product-price">$<fmt:formatNumber value="${acc.price}" type="number" minFractionDigits="2" /></div>
                                                </div>
                                            </div>
                                        </a>            
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>

                        <div class="arrow right" onclick="scrollAccessoryCarousel(1)">&#10095;</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="no-products">No products found.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Social Media -->
        <h2 style="text-align:center; margin-top: 50px; margin-bottom: 20px; font-weight: bold; color: #333;">★  Social Media  ★</h2>
        <div class="brand-slider-wrapper" style="display: flex; justify-content: center; gap: 20px; margin-bottom: 50px;">
            <a title="Facebook"><img src="assets/image/fb.png" alt="Facebook" style="width: 50px; height: 50px;"></a>
            <a title="Instagram"><img src="assets/image/ig.png" alt="Instagram" style="width: 50px; height: 50px;"></a>
            <a title="TikTok"><img src="assets/image/tik.png" alt="TikTok" style="width: 50px; height: 50px;"></a>
            <a title="YouTube"><img src="assets/image/ytb.png" alt="YouTube" style="width: 50px; height: 50px;"></a>
        </div>

        <hr style="border: none; height: 1.5px; background-color: #90caf9; margin: 0 auto; width: 50%;">

        <!-- Partners -->
        <h2 style="text-align:center; margin-top: 50px; margin-bottom: 20px; font-weight: bold; color: #333;">★  Our Partners  ★</h2>
        <div class="brand-slider-wrapper" style="display: flex; justify-content: center; gap: 20px; padding: 10px 0;">
            <a title="AutoArt"><img src="assets/image/logoAA.png" alt="AutoArt" style="width: 120px;"></a>
            <a title="Bburago"><img src="assets/image/logoB.png" alt="Bburago" style="width: 120px;"></a>
            <a title="GreenLight"><img src="assets/image/logoGL.png" alt="GreenLight" style="width: 120px;"></a>
            <a title="Hot Wheels"><img src="assets/image/logoHW.png" alt="Hot Wheels" style="width: 120px;"></a>
            <a title="Kyosho"><img src="assets/image/logoKS.png" alt="Kyosho" style="width: 120px;"></a>
            <a title="Maisto"><img src="assets/image/logoMS.png" alt="Maisto" style="width: 120px;"></a>
            <a title="Minichamps"><img src="assets/image/logoMini.png" alt="Minichamps" style="width: 120px; margin-top: 35px;"></a>
            <a title="Welly"><img src="assets/image/logoW.png" alt="Welly" style="width: 120px;"></a>
        </div>

        <script id="chatbase-script"
                src="https://www.chatbase.co/embed.min.js"
                chatbotId="24voNCBYpeJgbiYuJUH4Z"
                domain="www.chatbase.co"
                popup="true">
        </script>
        <jsp:include page="footer.jsp" />
        <script src="assets/js/productList.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>