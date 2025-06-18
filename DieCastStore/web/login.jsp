<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="utils.AuthUtils" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang Đăng Nhập</title>
        <link rel="stylesheet" href="assects/CSS/login.css">
        
    </head>
    <body>
        <jsp:include page="header.jsp" />
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
        <jsp:include page="footer.jsp" />
    </body>
    <script src="assects/JS/login.js"></script>
</html>
