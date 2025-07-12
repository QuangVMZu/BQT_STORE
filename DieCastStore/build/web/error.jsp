<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>404 - Not found page.</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="assets/CSS/error.css">
    </head>
    <body>
        <div class="error-container">
            <div class="error-code">
                <i class="bi bi-exclamation-triangle-fill"></i> 404
            </div>
            <div class="error-message">
                <c:choose>
                    <c:when test="${not empty message}">
                        <p>${message}</p>
                    </c:when>
                    <c:otherwise>
                        <p>The page you are looking for does not exist or has been moved.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            <a href="home.jsp" class="btn btn-primary back-btn">
                <i class="bi bi-house-door-fill"></i> Back to home page
            </a>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
