<%-- 
    Document   : forgot-password
    Created on : May 24, 2025, 4:44:44 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Forgot Password</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #e8f5e9;
                margin: 0;
                padding: 0;
            }

            .container {
                width: 420px;
                margin: 60px auto;
                padding: 30px;
                background-color: #ffffff;
                box-shadow: 0 4px 12px rgba(0, 128, 0, 0.2);
                border-radius: 10px;
            }

            .header h1 {
                color: #2e7d32;
                text-align: center;
                margin-bottom: 30px;
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-group label {
                display: block;
                color: #388e3c;
                font-size: 14px;
                margin-bottom: 8px;
                line-height: 1.5;
            }

            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #a5d6a7;
                border-radius: 5px;
                box-sizing: border-box;
                transition: border-color 0.3s;
            }

            .form-group input:focus {
                border-color: #43a047;
                outline: none;
            }

            .btn-login button {
                width: 100%;
                padding: 12px;
                background-color: #4caf50;
                color: white;
                border: none;
                border-radius: 6px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .btn-login button:hover {
                background-color: #388e3c;
            }

            .login-link {
                text-align: center;
                margin-top: 20px;
                font-size: 14px;
            }

            .login-link a {
                color: #388e3c;
                text-decoration: none;
                font-weight: bold;
            }

            .login-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
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
    </body>
    <jsp:include page="footer.jsp" />
</html>
