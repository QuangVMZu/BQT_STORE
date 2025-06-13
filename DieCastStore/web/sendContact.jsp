<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String message = request.getParameter("message");

    // You can process saving to database, sending email, or logging here

%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Contact Sent</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <div class="alert alert-success text-center">
                <h4>✅ Thank you, <%= name %>!</h4>
                <p>We have received your contact information and will respond shortly.</p>
            </div>
        </div>
    </body>
</html>