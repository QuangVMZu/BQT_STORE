<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="utils.AuthUtils" %>
<%@ page import="model.Customer" %>
<%@ page import="model.Cart" %>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>

<jsp:useBean id="cart" scope="request" class="model.Cart" />
<jsp:useBean id="customer" scope="session" class="model.Customer" />
<jsp:useBean id="error" scope="request" class="java.lang.String" />

<c:set var="items" value="${cart.items}" />
<c:set var="isEmpty" value="${empty items}" />
<c:set var="totalAmount" value="${cart.totalAmount}" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><c:choose><c:when test="${isEmpty}">Cart is empty</c:when><c:otherwise>Checkout</c:otherwise></c:choose> - BQT STORE</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="assets/CSS/checkout.css">
                <script src="assets/JS/checkout.js"></script>
            </head>
            <body>
        <jsp:include page="header.jsp" />
        <c:choose>
            <c:when test="${AuthUtils.isLoggedIn(pageContext.request)}">
                <div class="container">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger text-center mb-4">${error}</div>
                    </c:if>

                    <c:choose>
                        <c:when test="${isEmpty}">
                            <div class="alert alert-warning text-center">
                                <h4 class="alert-heading">Your cart is empty</h4>
                                <p>Please add some products before checking out.</p>
                                <hr>
                                <a href="ProductController?action=list" class="btn btn-primary">&larr; Continue Shopping</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <h2 class="text-center text-primary mb-4">Checkout</h2>

                            <form action="checkout?action=process" method="post" onsubmit="return validateForm()" class="row g-4">
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="toggleShippingInfo" onclick="toggleShippingForm()">
                                    <label class="form-check-label" for="toggleShippingInfo">
                                        I want to enter shipping information
                                    </label>
                                </div>

                                <div id="shippingForm" style="display: none;">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label for="customerName" class="form-label">Full Name *</label>
                                            <input type="text" id="customerName" name="customerName" class="form-control"
                                                   value="${customer.customerName}" />
                                        </div>

                                        <div class="col-md-6">
                                            <label for="phone" class="form-label">Phone Number *</label>
                                            <input type="tel" id="phone" name="phone" class="form-control"
                                                   pattern="[0-9]{10,11}" title="Phone number must be 10-11 digits"
                                                   value="${customer.phone}" />
                                        </div>

                                        <div class="col-12">
                                            <label for="address" class="form-label">Address *</label>
                                            <textarea id="address" name="address" rows="3" class="form-control">${customer.address}</textarea>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12 order-summary">
                                    <h4 class="mb-3">Your Order</h4>
                                    <table class="table table-bordered table-hover">
                                        <thead class="table-light text-center">
                                            <tr>
                                                <th>Product</th>
                                                <th>Quantity</th>
                                                <th>Unit Price</th>
                                                <th>Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${items}">
                                                <tr>
                                                    <td>${item.itemName}</td>
                                                    <td class="text-center">${item.quantity}</td>
                                                    <td class="text-end">
                                                        <fmt:formatNumber value="${item.unitPrice}" pattern="#0.00" /> $
                                                    </td>
                                                    <td class="text-end">
                                                        <fmt:formatNumber value="${item.unitPrice * item.quantity}" pattern="#0.00" /> $
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <tr>
                                                <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                                <td class="text-end text-success">
                                                    <strong><fmt:formatNumber value="${totalAmount}" pattern="#0.00" /> $</strong>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="col-12 d-flex justify-content-center mt-4">
                                    <button type="submit" class="btn btn-success btn-confirm me-3">Confirm Order</button>
                                    <a href="cart?action=view" class="btn btn-outline-secondary btn-confirm">&larr; Back to Cart</a>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div><br />
            </c:when>
            <c:otherwise>
                <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
                    <h2 class="text-danger">Access Denied</h2>
                    <p class="text-danger">${AuthUtils.getAccessDeniedMessage("login.jsp")}</p>
                    <a href="${AuthUtils.getLoginURL()}" class="btn btn-primary mt-2">Login Now</a>
                </div><br />
            </c:otherwise>
        </c:choose>
        <jsp:include page="footer.jsp" />
    </body>
</html>