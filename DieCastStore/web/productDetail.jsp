<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <c:choose>
            <c:when test="${not empty productDetail}">
                <title>${productDetail.modelName} | Product Detail</title>
            </c:when>
            <c:otherwise>
                <title>Product Detail</title>
            </c:otherwise>
        </c:choose>
        <link rel="stylesheet" href="assets/css/productDetail.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="assets/js/productDetail.js"></script>
    </head>
    <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp" />
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="container mt-3">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="alert alert-success text-center">
                            <strong>✓</strong> ${sessionScope.successMessage}
                        </div>
                    </div>
                </div>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        <c:choose>
            <c:when test="${not empty productDetail}">
                <c:set var="images" value="${productDetail.images}" />
                <c:set var="imageUrl" value="${not empty images ? images[0].imageUrl : ''}" />

                <div class="detail-container">

                    <div class="product-top">
                        <div>
                            <img class="detail-image" id="mainImage" src="${imageUrl}" alt="${productDetail.modelName}" />
                            <div class="thumbnails">
                                <c:forEach var="img" items="${images}">
                                    <img class="thumbnail" src="${img.imageUrl}" onclick="changeMainImage('${img.imageUrl}')" alt="Thumbnail" />
                                </c:forEach>
                            </div>
                        </div>

                        <div class="detail-info">
                            <h2 style="font-size: 28px; font-weight: bold">${productDetail.modelName}</h2>
                            <p class="info-muted" style="margin-bottom: -1px;"><strong>Model ID:</strong> ${productDetail.modelId}</p>

                            <c:if test="${not empty productBrand}">
                                <p class="info-muted">
                                    <strong>Brand:</strong>
                                    <span style="color: #2e7d32; font-weight: bold;">${productBrand.brandName}</span>
                                </p>
                                <div class="stock-wrapper">
                                    <span class="stock-badge ${productDetail.quantity > 0 ? '' : 'out'}">
                                        <c:choose>
                                            <c:when test="${productDetail.quantity > 0}">In stock</c:when>
                                            <c:when test="${productDetail.quantity == 0}">Out of stock</c:when>
                                            <c:when test="${productDetail.quantity == -1}">Sales suspension</c:when>
                                            <c:otherwise>Unknown</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </c:if>

                            <p class="price">$<fmt:formatNumber value="${productDetail.price}" type="number" minFractionDigits="2" /></p>

                            <c:if test="${productDetail.quantity > 0}">
                                <div style="margin-top: 15px;">
                                    <label for="quantityInput"><strong>Quantity:</strong></label>
                                    <div style="display: flex; align-items: center; gap: 10px; margin-top: 5px;">
                                        <button type="button" onclick="adjustQuantity(-1)">-</button>
                                        <input type="number" id="quantityInput" name="quantity" value="1" min="1" max="${productDetail.quantity}" style="width: 60px; text-align: center;" />
                                        <button type="button" onclick="adjustQuantity(1)">+</button>
                                    </div>
                                </div>

                                <div class="purchase-buttons" style="margin-top: 20px; display: flex; gap: 15px;">
                                    <form method="post" action="MainController">
                                        <input type="hidden" name="action" value="buyNow" />
                                        <input type="hidden" name="itemType" value="MODEL" />
                                        <input type="hidden" name="itemId" value="${productDetail.modelId}" />
                                        <input type="hidden" name="quantity" id="buyNowQuantity" />
                                        <button type="submit" onclick="setQuantity('buyNowQuantity')"
                                                style="padding: 10px 20px; background-color: #ff5722; color: white; border: none; border-radius: 5px;">
                                            Buy Now
                                        </button>
                                    </form>

                                    <form method="post" action="MainController">
                                        <input type="hidden" name="action" value="add" />
                                        <input type="hidden" name="itemType" value="MODEL" />
                                        <input type="hidden" name="itemId" value="${productDetail.modelId}" />
                                        <input type="hidden" name="quantity" id="addToCartQuantity" />
                                        <button type="submit" onclick="setQuantity('addToCartQuantity')"
                                                style="padding: 10px 20px; background-color: #2196f3; color: white; border: none; border-radius: 5px;">
                                            Add to Cart
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <div class="offer-info">
                                <h4 style="text-align: center">🎁 Special Offers</h4>
                                <ul>
                                    <li>Free nationwide shipping</li>
                                    <li>12-month official warranty</li>
                                    <li>Buy 2 or more products and get a free stand</li>
                                    <li>Extra 10% off for first-time orders</li>
                                    <li>Extra 30% off all products for students</li>
                                </ul>
                            </div>

                            <div class="store-info">
                                <h4 style="text-align: center">🏬 Store Information</h4>
                                <p><strong>Address:</strong> 7 D1 Street, Long Thanh My, Thu Duc, HCM City</p>
                                <p><strong>Opening Hours:</strong> 8:00 AM - 9:00 PM (Mon - Sun)</p>
                                <p><strong>Hotline:</strong> 0123 456 789</p>
                            </div>
                        </div>
                    </div>

                    <div class="product-description">
                        <h3>Model ${productDetail.modelName}</h3>
                        <p>${not empty productDetail.description ? productDetail.description : 'No description available.'}</p>
                    </div>
                </div>
            </c:when>
            <c:when test="${not empty accessoryDetail}">
                <div class="detail-container">
                    <c:if test="${not empty checkError}">
                        <div class="alert alert-danger mt-3">${checkError}</div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="alert alert-success mt-3">${message}</div>
                    </c:if>

                    <div class="product-top">
                        <div>
                            <img class="detail-image" id="mainImage" src="${accessoryDetail.imageUrl}" alt="${accessoryDetail.accessoryName}" />
                            <!-- Không có thumbnails cho accessory -->
                        </div>

                        <div class="detail-info">
                            <h2 style="font-size: 28px; font-weight: bold">${accessoryDetail.accessoryName}</h2>
                            <p class="info-muted"><strong>Accessory ID:</strong> ${accessoryDetail.accessoryId}</p>
                            <p class="info-muted" style="margin-top: -10px">
                                <strong>Brand:</strong>
                                <span style="color: #2e7d32; font-weight: bold;">BQT STORE</span>
                            </p>

                            <div class="stock-wrapper">
                                <span class="stock-badge ${accessoryDetail.quantity > 0 ? '' : 'out'}">
                                    <c:choose>
                                        <c:when test="${accessoryDetail.quantity > 0}">In stock</c:when>
                                        <c:when test="${accessoryDetail.quantity == 0}">Out of stock</c:when>
                                        <c:when test="${accessoryDetail.quantity == -1}">Sales suspension</c:when>
                                        <c:otherwise>Unknown</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <p class="price">$<fmt:formatNumber value="${accessoryDetail.price}" type="number" minFractionDigits="2" /></p>

                            <c:if test="${accessoryDetail.quantity > 0}">
                                <div style="margin-top: 15px;">
                                    <label for="quantityInput"><strong>Quantity:</strong></label>
                                    <div style="display: flex; align-items: center; gap: 10px; margin-top: 5px;">
                                        <button type="button" onclick="adjustQuantity(-1)">-</button>
                                        <input type="number" id="quantityInput" name="quantity" value="1" min="1" max="${accessoryDetail.quantity}" style="width: 60px; text-align: center;" />
                                        <button type="button" onclick="adjustQuantity(1)">+</button>
                                    </div>
                                </div>

                                <div class="purchase-buttons" style="margin-top: 20px; display: flex; gap: 15px;">
                                    <!-- Buy Now -->
                                    <form method="post" action="MainController">
                                        <input type="hidden" name="action" value="buyNow" />
                                        <input type="hidden" name="itemType" value="ACCESSORY" />
                                        <input type="hidden" name="itemId" value="${accessoryDetail.accessoryId}" />
                                        <input type="hidden" name="quantity" id="buyNowQuantity" />
                                        <button type="submit" onclick="setQuantity('buyNowQuantity')"
                                                style="padding: 10px 20px; background-color: #ff5722; color: white; border: none; border-radius: 5px;">
                                            Buy Now
                                        </button>
                                    </form>

                                    <!-- Add to Cart -->
                                    <form method="post" action="MainController">
                                        <input type="hidden" name="action" value="add" />
                                        <input type="hidden" name="itemType" value="ACCESSORY" />
                                        <input type="hidden" name="itemId" value="${accessoryDetail.accessoryId}" />
                                        <input type="hidden" name="quantity" id="addToCartQuantity" />
                                        <button type="submit" onclick="setQuantity('addToCartQuantity')"
                                                style="padding: 10px 20px; background-color: #2196f3; color: white; border: none; border-radius: 5px;">
                                            Add to Cart
                                        </button>
                                    </form>
                                </div>
                            </c:if>

                            <!-- Offers & Store Info -->
                            <div class="offer-info">
                                <h4 style="text-align: center">🎁 Special Offers</h4>
                                <ul>
                                    <li>Free nationwide shipping</li>
                                    <li>12-month official warranty</li>
                                    <li>Buy 2 or more products and get a free stand</li>
                                    <li>Extra 10% off for first-time orders</li>
                                    <li>Extra 30% off all products for students</li>
                                </ul>
                            </div>

                            <div class="store-info">
                                <h4 style="text-align: center">🏬 Store Information</h4>
                                <p><strong>Address:</strong> 7 D1 Street, Long Thanh My, Thu Duc, HCM City</p>
                                <p><strong>Opening Hours:</strong> 8:00 AM - 9:00 PM (Mon - Sun)</p>
                                <p><strong>Hotline:</strong> 0123 456 789</p>
                            </div>
                        </div>
                    </div>

                    <div class="product-description">
                        <h3>Accessory ${accessoryDetail.accessoryName}</h3>
                        <p><c:choose>
                                <c:when test="${not empty accessoryDetail.detail}">${accessoryDetail.detail}</c:when>
                                <c:otherwise>No description available.</c:otherwise>
                            </c:choose></p>
                    </div>
                </div>
            </c:when>
        </c:choose>
        <h2 style="text-align:center; margin-top: 50px; margin-bottom: -30px; font-weight: bold; color: #333;">★ Recommended for you ★</h2><br/>

        <c:choose>
            <c:when test="${not empty productDetail}">
                <section class="news-section">
                    <div class="news-carousel">
                        <div class="news-items">
                            <c:choose>
                                <c:when test="${not empty productsByScale}">
                                    <c:forEach var="productCar" items="${productsByScale}">
                                        <c:if test="${productCar.quantity != -1}">
                                            <c:set var="images" value="${productCar.images}" />
                                            <a href="ProductController?action=detail&amp;modelId=${productCar.modelId}" class="news-card">
                                                <c:choose>
                                                    <c:when test="${not empty images}">
                                                        <img src="${images[0].imageUrl}" alt="${images[0].caption}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="assets/img/default.jpg" alt="No image" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <h3>${productCar.modelName}</h3>
                                                <p>Price: $<fmt:formatNumber value="${productCar.price}" type="number" minFractionDigits="2" /></p>
                                            </a>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p>No products found for this brand.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="news-pagination">
                            <button class="news-page-btn" data-page="1">1</button>
                            <button class="news-page-btn" data-page="2">2</button>
                            <button class="news-page-btn" data-page="3">3</button>
                        </div>
                    </div>
                </section>
            </c:when>

            <c:when test="${not empty accessoryDetail}">
                <section class="news-section">
                    <div class="news-carousel">
                        <div class="news-items">
                            <c:choose>
                                <c:when test="${not empty accessoryList}">
                                    <c:forEach var="accessoryItem" items="${accessoryList}">
                                        <c:if test="${accessoryItem.accessoryId ne accessoryDetail.accessoryId and accessoryItem.quantity != -1}">
                                            <a href="ProductController?action=detail&amp;accessoryId=${accessoryItem.accessoryId}" class="news-card">
                                                <c:choose>
                                                    <c:when test="${not empty accessoryItem.imageUrl}">
                                                        <img src="${accessoryItem.imageUrl}" alt="${accessoryItem.accessoryName}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="assets/img/default.jpg" alt="No image" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <h3>${accessoryItem.accessoryName}</h3>
                                                <p>Price: $<fmt:formatNumber value="${accessoryItem.price}" type="number" minFractionDigits="2" /></p>
                                            </a>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p>No Accessory found.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="news-pagination">
                            <button class="news-page-btn" data-page="1">1</button>
                            <button class="news-page-btn" data-page="2">2</button>
                        </div>
                    </div>
                </section>
            </c:when>
        </c:choose>
        <jsp:include page="footer.jsp" />
    </body>
</html>
