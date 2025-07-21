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
                <img src="assets/image/banner.png" class="banner-slide" alt="Banner 4">
            </div>
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