<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="assets/css/header.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

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
                        <button type="submit" class="link-button" style="font-size: 1.5rem">Products</button>
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
                <input type="text" name="keyword" placeholder="Search product..." required 
                       value="${not empty param.keyword ? param.keyword : ''}">
                <button type="submit">Search</button>
            </form>
        </div>

        <!-- Auth Buttons -->
        <div class="auth-buttons">
            <c:choose>
                <c:when test="${not empty sessionScope.account}">
                    <c:set var="user" value="${sessionScope.account}" />
                    <c:set var="userName" value="${user.userName}" />
                    <c:set var="avatarChar" value="${not empty userName ? fn:toUpperCase(fn:substring(userName, 0, 1)) : '?'}" />

                    <div class="user-dropdown">
                        <div class="user-info" onclick="toggleDropdown()">
                            <span class="greeting">Hello, <strong>${userName}</strong></span>
                            <div class="avatar-circle">${avatarChar}</div>
                        </div>

                        <a href="cart" class="cart-icon" title="Cart">
                            <i class="bi bi-cart-fill"></i>
                            <c:if test="${sessionScope.cartSize > 0}">
                                <span class="cart-badge">${sessionScope.cartSize}</span>
                            </c:if>
                        </a>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <a href="profileForm.jsp" class="edit">My Profile</a>

                            <c:if test="${sessionScope.account.role == 1}">
                                <a href="MainController?action=viewAllAccount" class="edit">Manage Accounts</a>
                                <a href="MainController?action=viewAllOrders" class="cart">Manage Order</a>
                                <a href="ProductController?action=listEdit" class="edit">Edit Product</a>
                                <a href="editHome.jsp" class="edit">Edit Home Gallery</a>
                            </c:if>

                            <a href="cart" class="cart">Cart</a>
                            <a href="order" class="payment">My Orders</a>
                            <a href="UserController?action=logout" class="logout">Logout</a>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<script src="assets/js/header.js"></script>