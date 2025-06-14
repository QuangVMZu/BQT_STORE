<%-- 
    Document   : register
    Created on : May 24, 2025, 3:16:58 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Account</title>
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
                margin-bottom: 10px;
            }

            .header h2 {
                color: #66bb6a;
                text-align: center;
                font-weight: normal;
                font-size: 16px;
                margin-bottom: 30px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                color: #388e3c;
                margin-bottom: 5px;
                font-weight: bold;
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

            .btn-submit button {
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

            .btn-submit button:hover {
                background-color: #388e3c;
            }

            .login-link {
                text-align: center;
                margin-top: 15px;
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
    </body>
    <jsp:include page="footer.jsp" />
</html>
