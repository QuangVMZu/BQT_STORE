<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Result to search</title>
        <link rel="stylesheet" href="assets/css/productSearch.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp" />

        <!-- Banner -->
        <div class="text-center">
            <img src="assets/image/BQT_STORE.png" class="img-fluid" style="height: 300px; object-fit: cover; margin-top: 30px;" alt="Banner">
        </div>

        <!-- Main -->
        <main class="container my-5">
            <c:if test="${not empty keyword}">
                <h2 class="text-center mb-4">Search results for: "${keyword}"</h2>
            </c:if>

            <c:choose>
                <c:when test="${not empty searchResults}">
                    <div class="row g-4">
                        <c:forEach var="car" items="${searchResults}">
                            <c:if test="${car.quantity gt -1}">
                                <c:set var="imgUrl" value="no-image.jpg" />
                                <c:if test="${not empty car.images}">
                                    <c:set var="imgUrl" value="${car.images[0].imageUrl}" />
                                </c:if>
                                <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                                    <div class="card product-card h-100 shadow-sm">
                                        <a href="ProductController?action=detail&amp;modelId=${car.modelId}">
                                            <img src="${imgUrl}" class="product-img w-100" alt="Product Image">
                                        </a>
                                        <div class="card-body text-center d-flex flex-column justify-content-between">
                                            <div class="product-name">${car.modelName}</div>
                                            <div class="product-price">
                                                $<fmt:formatNumber value="${car.price}" type="number" maxFractionDigits="2"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="text-center text-danger mt-5">${checkError}</p>
                </c:otherwise>
            </c:choose>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav class="mt-5">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="ProductController?action=search&amp;keyword=${keyword}&amp;page=${currentPage - 1}">← Trang trước</a>
                            </li>
                        </c:if>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="ProductController?action=search&amp;keyword=${keyword}&amp;page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="ProductController?action=search&amp;keyword=${keyword}&amp;page=${currentPage + 1}">Trang sau →</a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </main>

        <!-- Social Media -->
        <section class="py-5" style="background-color: #e3f2fd;">
            <h2 class="text-center fw-bold mb-4">★ Social Media ★</h2>
            <div class="d-flex justify-content-center gap-4 social-media-wrapper">
                <img src="assets/image/fb.png" alt="Facebook" class="img-fluid" style="width: 50px;">
                <img src="assets/image/ig.png" alt="Instagram" class="img-fluid" style="width: 50px;">
                <img src="assets/image/tik.png" alt="TikTok" class="img-fluid" style="width: 50px;">
                <img src="assets/image/ytb.png" alt="YouTube" class="img-fluid" style="width: 50px;">
            </div>
        </section>

        <!-- Partners -->
        <section class="py-5" style="background-color: #e3f2fd;">
            <hr class="w-50 mx-auto mb-4" style="margin-top: -20px; margin-bottom: 10px"></br>
            <h2 class="text-center fw-bold mb-4">★ Our Partners ★</h2>
            <div class="d-flex flex-wrap justify-content-center gap-4 brand-slider-wrapper">
                <img src="assets/image/logoAA.png" alt="AutoArt" class="img-fluid" style="width: 120px;">
                <img src="assets/image/logoB.png" alt="Bburago" class="img-fluid" style="width: 120px;">
                <img src="assets/image/logoGL.png" alt="GreenLight" class="img-fluid" style="width: 120px;">
                <img src="assets/image/logoHW.png" alt="Hot Wheels" class="img-fluid" style="width: 120px;">
                <img src="assets/image/logoKS.png" alt="Kyosho" class="img-fluid" style="width: 120px;">
                <img src="assets/image/logoMS.png" alt="Maisto" class="img-fluid" style="width: 120px;">
                <img src="assets/image/logoMini.png" alt="Minichamps" class="img-fluid" style="width: 120px;">
                <img src="assets/image/logoW.png" alt="Welly" class="img-fluid" style="width: 120px;">
            </div>
        </section>

        <jsp:include page="footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
