<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="utils.AuthUtils" %>
<jsp:include page="header.jsp" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang Đăng Nhập</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #e8f5e9;
                margin: 0;
                padding: 0;
            }
            .container {
                width: 400px;
                margin: 80px auto;
                padding: 30px;
                background-color: #ffffff;
                box-shadow: 0 4px 12px rgba(0, 128, 0, 0.2);
                border-radius: 10px;
            }
            .header h1 {
                color: #2e7d32;
                margin-bottom: 10px;
                text-align: center;
            }
            .header h2 {
                color: #66bb6a;
                font-weight: normal;
                font-size: 16px;
                text-align: center;
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
            .remember-password {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }
            .remember-password label {
                margin-left: 8px;
                color: #4caf50;
            }
            .forgot-password {
                text-align: right;
                margin-bottom: 20px;
            }
            .forgot-password a {
                color: #388e3c;
                text-decoration: none;
                font-size: 14px;
            }
            .forgot-password a:hover {
                text-decoration: underline;
            }
            .btn-login button,
            .btn-register button {
                width: 100%;
                padding: 12px;
                background-color: #4caf50;
                color: white;
                border: none;
                border-radius: 6px;
                font-size: 16px;
                cursor: pointer;
                margin-bottom: 15px;
                transition: background-color 0.3s;
            }
            .btn-login button:hover,
            .btn-register button:hover {
                background-color: #388e3c;
            }

            .error-message {
                color: red;
                text-align: center;
                margin-bottom: 15px;
                font-weight: bold;
            }
        </style>
        <script>
            function togglePassword() {
                const passwordInput = document.getElementById("strPassword");
                const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
                passwordInput.setAttribute("type", type);
            }
        </script>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Đăng Nhập</h1>
                <h2>Nhập thông tin của bạn</h2>
            </div>

            <%
            HttpSession sess = request.getSession(false);
            String msg = null;
            if (sess != null) {
                msg = (String) sess.getAttribute("message");
                sess.removeAttribute("message"); // Xóa sau khi hiển thị 1 lần
            }
            %>
            <% if (msg != null && !msg.isEmpty()) { %>
            <div class="error-message"><%= msg %></div>
            <% } %>

            <!-- Form đăng nhập -->
            <form action="UserController" method="post">
                <div class="form-group">
                    <label for="strUserID">Tên đăng nhập</label>
                    <input type="text" id="strUserID" name="strUserID" placeholder="Nhập tên đăng nhập" required/>
                </div>
                <div class="form-group">
                    <label for="strPassword">Mật Khẩu</label>
                    <div style="position: relative;">
                        <input type="password" id="strPassword" name="strPassword" placeholder="Nhập mật khẩu" required style="padding-right: 40px;"/>
                        <button type="button" onclick="togglePassword()" style="position:absolute; right:10px; top:50%; transform:translateY(-50%); border:none; background:none; cursor:pointer; color:#388e3c;">👁</button>
                    </div>
                </div>
                <div class="remember-password">
                    <input type="checkbox" id="remember" name="remember" value="On"/>
                    <label for="remember">Ghi Nhớ Mật Khẩu</label>
                </div>
                <div class="forgot-password">
                    <a href="#">Quên Mật Khẩu</a>
                </div>
                <div class="btn-login">
                    <button type="submit" name="action" value="login">Đăng Nhập</button>
                </div>
            </form>

            <!-- Form tạo tài khoản -->
            <form action="UserController" method="get">
                <div class="btn-register">
                    <button type="submit" name="action" value="showRegister">Tạo Tài Khoản</button>
                </div>
            </form>
        </div>
    </body>
    <jsp:include page="footer.jsp" />
</html>
