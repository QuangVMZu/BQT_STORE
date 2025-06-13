<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />
<html>
    <head>
        <title>Reset Password</title>
        <style>
            body {
                background-color: #e8f5e9; /* màu xanh lá nhạt */
                font-family: Arial, sans-serif;
                color: #2e7d32; /* xanh lá đậm */
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .container {
                background-color: #a5d6a7; /* xanh lá trung bình */
                padding: 30px 40px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(46, 125, 50, 0.3);
                width: 320px;
                text-align: center;
            }
            h2 {
                margin-bottom: 20px;
            }
            input[type="email"] {
                width: 100%;
                padding: 8px 10px;
                margin: 10px 0 20px 0;
                border: 1px solid #81c784;
                border-radius: 5px;
                font-size: 16px;
            }
            input[type="submit"] {
                background-color: #2e7d32;
                color: white;
                border: none;
                padding: 12px 25px;
                font-size: 16px;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            input[type="submit"]:hover {
                background-color: #1b5e20;
            }
            p {
                margin-top: 20px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Yêu cầu đặt lại mật khẩu</h2>
            <form action="reset_password.jsp" method="post">
                Email: <input type="email" name="email" required /><br>
                <input type="submit" value="Gửi yêu cầu" />
            </form>

            <%
                String email = request.getParameter("email");
                if (email != null) {
                    out.println("<p>Đã gửi liên kết đặt lại mật khẩu tới email: " + email + "</p>");
                }
            %>
        </div>
    </body>
    <jsp:include page="footer.jsp" />
</html>
