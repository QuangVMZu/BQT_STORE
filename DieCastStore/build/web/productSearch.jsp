<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ModelCar" %>
<%@ page import="model.ImageModel" %>
<%@ page import="java.util.List" %>

<%
    String checkError = (String) request.getAttribute("checkError");
    String message = (String) request.getAttribute("message");
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
        <!-- Bootstrap 5 -->
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
            <% 
                if(keyword != null){
            %>
            <h2 class="text-center mb-4">Search results for: "<%= keyword %>"</h2>
            <% } %>
            <% if (results != null && !results.isEmpty()) { %>
            <div class="row g-4">
                <% for (ModelCar car : results) {
                    if (car.getQuantity() <= -1) continue;
                    String imgUrl = "no-image.jpg";
                    if (car.getImages() != null && !car.getImages().isEmpty()) {
                        imgUrl = car.getImages().get(0).getImageUrl();
                    }
                %>
                <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                    <div class="card product-card h-100 shadow-sm">
                        <a href="ProductController?action=detail&modelId=<%= car.getModelId() %>">
                            <img src="<%= imgUrl %>" class="product-img w-100" alt="Product Image">
                        </a>
                        <div class="card-body text-center d-flex flex-column justify-content-between">
                            <div class="product-name"><%= car.getModelName() %></div>
                            <div class="product-price">$<%= String.format("%,.2f", car.getPrice()) %></div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <p class="text-center text-danger mt-5"><%= checkError %></p>
            <% } %>


            <!-- Pagination -->
            <% if (totalPages > 1) { %>
            <nav class="mt-5">
                <ul class="pagination justify-content-center">
                    <% if (currentPage > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="ProductController?action=search&keyword=<%= keyword %>&page=<%= currentPage - 1 %>">← Trang trước</a>
                    </li>
                    <% } %>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <li class="page-item <%= i == currentPage ? "active" : "" %>">
                        <a class="page-link" href="ProductController?action=search&keyword=<%= keyword %>&page=<%= i %>"><%= i %></a>
                    </li>
                    <% } %>

                    <% if (currentPage < totalPages) { %>
                    <li class="page-item">
                        <a class="page-link" href="ProductController?action=search&keyword=<%= keyword %>&page=<%= currentPage + 1 %>">Trang sau →</a>
                    </li>
                    <% } %>
                </ul>
            </nav>
            <% } %>
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
