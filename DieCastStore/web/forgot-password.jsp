<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Forgot Password</title>
        <link rel="stylesheet" href="assets/CSS/forgot-password.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="container">
            <div class="header">
                <h1>Forgot Your Password?</h1>
            </div>
            <form action="AuthController" method="post">
                <div class="form-group">
                    <label for="email">Please enter your registered username or email address. We will send you a link to reset your password.</label>
                    <input type="email" id="email" name="email" placeholder="Enter your username or email" required>
                </div>
                <div class="btn-login">
                    <button type="submit" name="action" value="forgot">Send Password Reset Request</button> 
                </div>
                <div class="login-link">
                    <p>Back to - <a href="login.jsp">Login</a></p>
                </div>
            </form>
        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>
