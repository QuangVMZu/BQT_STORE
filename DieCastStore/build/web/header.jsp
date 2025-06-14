<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.CustomerAccount"%>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    header {
        background-color: #00695c;
        color: #ffffff;
        padding: 25px 0;
    }

    .header-container {
        max-width: 1400px;
        margin: auto;
        padding: 0 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
    }

    .logo h1 {
        font-size: 2rem;
        font-weight: bold;
    }

    .logo a {
        color: #ffffff;
        text-decoration: none;
    }

    .main-nav ul {
        list-style: none;
        display: flex;
        gap: 30px;
        font-size: 1.3rem;
    }

    .main-nav a {
        color: #ffffff;
        text-decoration: none;
        font-weight: 500;
        transition: color 0.3s;
    }

    .link-button {
        background: none;
        border: none;
        padding: 0;
        margin: 0;
        font: inherit;
        font-size: 1.3rem;
        font-weight: 500;
        color: #ffffff;
        cursor: pointer;
        text-decoration: none;
        transition: color 0.3s;
    }

    .link-button:hover {
        color: #b2dfdb;
    }

    .main-nav a:hover {
        color: #b2dfdb;
    }

    .search-bar input {
        padding: 6px 10px;
        border: none;
        border-radius: 4px 0 0 4px;
        outline: none;
    }

    .search-bar button {
        padding: 6px 12px;
        border: none;
        background-color: #004d40;
        color: #fff;
        border-radius: 0 4px 4px 0;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .search-bar button:hover {
        background-color: #00332c;
    }

    .auth-buttons a {
        margin-left: 10px;
        color: #ffffff;
        text-decoration: none;
        padding: 6px 12px;
        background-color: #00897b;
        border-radius: 4px;
        transition: background-color 0.3s;
    }

    .auth-buttons a:hover {
        background-color: #00796b;
    }

    .avatar-circle {
        width: 40px;
        height: 40px;
        background-color: #81C784;
        color: white;
        font-weight: bold;
        font-size: 20px;
        border-radius: 50%;
        text-align: center;
        line-height: 40px;
        display: inline-block;
        margin-right: 10px;
    }

    .user-dropdown {
        position: relative;
        display: flex;
        align-items: center;
    }

    .user-info {
        display: flex;
        align-items: center;
        cursor: pointer;
    }

    .greeting {
        color: #ffffff;
        margin-right: 10px;
        font-size: 1rem;
    }

    .dropdown-menu {
        display: none;
        position: absolute;
        right: 0;
        top: 50px;
        background-color: #b3f1e0;
        min-width: 280px;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
        border-radius: 10px;
        z-index: 1000;
        padding: 12px 12px;
        font-size: 1rem;
    }

    .dropdown-menu a {
        display: flex;
        align-items: center;
        color: #000000 !important; /* Chữ đen */
        text-decoration: none;
        padding: 8px 8px;
        transition: background-color 0.2s;
        margin: 0;
        gap: 15px;
        background-color: transparent;
    }

    .dropdown-menu a:hover {
        background-color: #81C784;
    }

    .dropdown-menu a::before {
        display: inline-block;
        width: 17px;
        text-align: center;
        margin-right: 5px;
    }

    .dropdown-menu a.edit::before {
        content: "✏️";
    }

    .dropdown-menu a.cart::before {
        content: "🛒";
    }

    .dropdown-menu a.payment::before {
        content: "💳";
    }

    .dropdown-menu a.logout::before {
        content: "🚪";
    }
</style>

<header>
    <div class="header-container">
        <!-- Logo -->
        <div class="logo">
            <h1><a href="home.jsp">BQT Store</a></h1>
        </div>

        <!-- Main Navigation -->
        <nav class="main-nav">
            <ul>
                <li><a href="home.jsp">Home</a></li>
                <li>
                    <form action="MainController" method="get" style="display:inline;">
                        <input type="hidden" name="action" value="list">
                        <button type="submit" class="link-button">Products</button>
                    </form>
                </li>
                <li><a href="about.jsp">About Us</a></li>
                <li><a href="contact.jsp">Contact</a></li>
            </ul>
        </nav>

        <!-- Search Bar -->
        <div class="search-bar">
            <form action="MainController" method="get">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" placeholder="Search product..." required value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
                <button type="submit">Search</button>
            </form>
        </div>

        <!-- Auth Buttons -->
        <div class="auth-buttons">
            <%
                CustomerAccount user = (CustomerAccount) session.getAttribute("user");
                if (user != null) {
                    String userName = user.getUserName();
                    String avatarChar = userName != null && !userName.isEmpty() ? userName.substring(0, 1).toUpperCase() : "?";
            %>
            <div class="user-dropdown">
                <div class="user-info" onclick="toggleDropdown()">
                    <span class="greeting">Hello, <strong><%= userName %></strong></span>
                    <div class="avatar-circle"><%= avatarChar %></div>
                </div>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="editProfile.jsp" class="edit">Edit Profile</a>
                    <a href="cart.jsp" class="cart">Cart</a>
                    <a href="paymentMethods.jsp" class="payment">Payment Methods</a>
                    <a href="UserController?action=logout" class="logout">Logout</a>
                </div>
            </div>
            <%
                } else {
            %>
            <a href="login.jsp">Login</a>
            <a href="register.jsp">Register</a>
            <%
                }
            %>
        </div>
    </div>
</header>

<script>
    function toggleDropdown() {
        const menu = document.getElementById("dropdownMenu");
        menu.style.display = menu.style.display === "block" ? "none" : "block";
    }

    window.onclick = function (event) {
        if (!event.target.closest('.user-dropdown')) {
            const menu = document.getElementById("dropdownMenu");
            if (menu)
                menu.style.display = "none";
        }
    }
</script>
