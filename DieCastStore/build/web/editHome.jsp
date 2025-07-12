<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="utils.AuthUtils" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Home Content</title>
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/CSS/editHome.css">
        <script src="assets/JS/editHome.js"></script>
    </head>
    <body>

        <jsp:include page="header.jsp" />
        <%
            if (AuthUtils.isLoggedIn(request)) {
                if (AuthUtils.isAdmin(request)) {
            String checkError = (String) request.getAttribute("checkError");
            String message = (String) request.getAttribute("message");
            String selectedType = request.getAttribute("selectedType") != null
                ? (String) request.getAttribute("selectedType")
                : "gallery";
        %>

        <div class="py-5">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    <div class="form-section">
                        <h2 class="section-title">📸 Edit Home Banner / Gallery</h2>

                        <form action="UploadHomeImgController" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="upload" />

                            <!-- Upload Type -->
                            <div class="mb-4">
                                <label for="type" class="form-label fw-semibold">🗂️ Select upload type</label>
                                <select name="type" id="type" class="form-select" onchange="toggleDescription()">
                                    <option value="gallery" <%= "gallery".equals(selectedType) ? "selected" : "" %>>Gallery</option>
                                    <option value="banner" <%= "banner".equals(selectedType) ? "selected" : "" %>>Banner</option>
                                </select>
                            </div>

                            <!-- Description (Gallery only) -->
                            <div class="mb-4" id="descriptionSection">
                                <label class="form-label fw-semibold">📝 Description (gallery only)</label>
                                <textarea name="description" class="form-control" rows="4" placeholder="Enter gallery description..."><%= 
                                    session.getAttribute("homeDescription") != null 
                                        ? session.getAttribute("homeDescription") : "" 
                                    %></textarea>
                            </div>

                            <!-- Image Uploads -->
                            <div class="mb-4">
                                <label class="form-label fw-semibold">📁 Upload up to 4 images</label>

                                <!-- Image 1 -->
                                <input type="file" name="image1" accept="image/*" class="form-control mb-2">
                                <input type="text" name="caption1" placeholder="Caption for image 1" class="form-control mb-3">

                                <!-- Image 2 -->
                                <input type="file" name="image2" accept="image/*" class="form-control mb-2">
                                <input type="text" name="caption2" placeholder="Caption for image 2" class="form-control mb-3">

                                <!-- Image 3 -->
                                <input type="file" name="image3" accept="image/*" class="form-control mb-2">
                                <input type="text" name="caption3" placeholder="Caption for image 3" class="form-control mb-3">

                                <!-- Image 4 -->
                                <input type="file" name="image4" accept="image/*" class="form-control mb-2">
                                <input type="text" name="caption4" placeholder="Caption for image 4" class="form-control">
                            </div>

                            <!-- Buttons -->
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="return-section">
                                    <a href="home.jsp" class="btn-return">← Return</a>
                                </div>
                                <button type="submit" class="btn btn-success px-4 py-2">💾 Save</button>
                            </div>

                            <!-- Message -->
                            <% if (checkError != null && !checkError.isEmpty()) { %>
                            <div class="error-message mt-3"><%= checkError %></div>
                            <% } else if (message != null && !message.isEmpty()) { %>
                            <div class="success-message mt-3"><%= message %></div>
                            <% } %>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <% 
        } else { // not admin 
        %>
        <div class="container access-denied">
            <h2 style="color: #00695c">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% 
            } // end if admin
        } else { // not logged in
        %>
        <div class="container access-denied">
            <h2 class="text-danger">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% } %>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="footer.jsp" />
    </body>
</html>
