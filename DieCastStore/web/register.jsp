<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Account</title>
        <link rel="stylesheet" href="assets/CSS/register.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="container register-container">
            <div class="header">
                <h1>Register</h1>
                <h2>Create a New Account</h2>
            </div>

            <!-- Display success or error message if available -->
            <%
                String message = (String) session.getAttribute("message");
                if (message != null) {
            %>
            <p style="color: red; text-align:center;"><%= message %></p>
            <%
                    session.removeAttribute("message"); // Remove after displaying
                }
            %>
            <form action="UserController" method="post">
                <div class="form-group">
                    <label for="fullname">Full Name</label>
                    <input type="text" id="fullname" name="fullname" placeholder="Enter your full name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" placeholder="Enter your phone number">
                </div>
                <div class="form-group">
                    <label for="userName">Username</label>
                    <input type="text" id="userName" name="userName" placeholder="Choose a username" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter your password" required>
                </div>
                <div class="btn-submit">
                    <button type="submit" name="action" value="register">Register</button>
                </div>
            </form>
        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>
