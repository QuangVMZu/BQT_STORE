<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.CustomerAccount"%>
<%@page import="utils.AuthUtils"%>
<link rel="stylesheet" href="assets/CSS/header.css">

<header>
    <div class="header-container">
        <!-- Logo -->
        <div class="logo">
            <h1><a href="home.jsp">BQT STORE</a></h1>
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
                CustomerAccount user = (CustomerAccount) session.getAttribute("account");
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
                    <a href="profileForm.jsp" class="edit">My Profile</a>
                    <% if (AuthUtils.isAdmin(request)) { %>
                    <a href="ProductController?action=listEdit" class="edit">Edit Product</a>
                    <% } %>
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
<script src="assets/JS/header.js"></script>