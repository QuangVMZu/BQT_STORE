<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>404 - Không tìm thấy trang</title>
        
    </head>
    <body>
        <h1>404</h1>
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) { %>
        <p style="color: black; text-align: center;"><%= message %></p>
        <% } %>
        <a href="home.jsp">Quay lại trang chủ</a>
    </body>
</html>
