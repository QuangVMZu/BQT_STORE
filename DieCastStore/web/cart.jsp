<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Cart"%>
<%@ page import="utils.AuthUtils" %>
<%@page import="model.CartItem"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Cart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/cart.css">
        <script src="assets/js/cart.js"></script>
    </head>
    <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp" />
        <c:choose>
            <c:when test="${AuthUtils.isLoggedIn(pageContext.request)}">
                <div class="container cart-container">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <h4 class="mb-0">My Cart</h4>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger"><strong>Error:</strong> ${error}</div>
                            </c:if>

                            <c:if test="${not empty success}">
                                <div class="alert alert-success"><strong>Success:</strong> ${success}</div>
                            </c:if>

                            <c:if test="${not empty sessionScope.successMessage}">
                                <div class="alert alert-success"><strong>✓</strong> ${sessionScope.successMessage}</div>
                                <c:remove var="successMessage" scope="session" />
                            </c:if>

                            <c:if test="${not empty sessionScope.errorMessage}">
                                <div class="alert alert-danger"><strong>✗</strong> ${sessionScope.errorMessage}</div>
                                <c:remove var="errorMessage" scope="session" />
                            </c:if>

                            <c:if test="${not empty sessionScope.inventoryErrors}">
                                <div class="alert alert-warning"><strong>⚠ Inventory Alert:</strong>
                                    <ul>
                                        <c:forEach var="err" items="${sessionScope.inventoryErrors}">
                                            <li>${err}</li>
                                            </c:forEach>
                                    </ul>
                                </div>
                                <c:remove var="inventoryErrors" scope="session" />
                            </c:if>

                            <c:choose>
                                <c:when test="${cart == null or empty cart.items}">
                                    <div class="alert alert-info text-center">
                                        <h4>Your cart is empty</h4>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="mb-3 cart-summary">
                                        <p>Total products: <strong>${cart.totalQuantity}</strong></p>
                                        <p>Total amount: <strong><fmt:formatNumber value="${cart.totalAmount}" pattern="##0.00" /> $</strong></p>
                                    </div>

                                    <div class="alert alert-info">
                                        <strong>Selected: <span id="selectedCount">0</span> | Total: <span id="selectedTotal">0.00 $</span></strong>
                                    </div>

                                    <div class="table-responsive">
                                        <table class="table table-bordered table-hover cart-table align-middle">
                                            <thead class="table-secondary">
                                                <tr>
                                                    <th><input type="checkbox" id="selectAll" onchange="toggleSelectAll()"> All</th>
                                                    <th>#</th>
                                                    <th>Image</th>
                                                    <th>Product</th>
                                                    <th>Type</th>
                                                    <th>Unit Price</th>
                                                    <th>Quantity</th>
                                                    <th>Total</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${cart.items}" varStatus="status">
                                                    <c:set var="isOut" value="${item.availableQuantity <= 0}" />
                                                    <c:set var="isMissing" value="${not item.itemExists}" />
                                                    <c:set var="rowClass" value="${isOut || isMissing ? 'out-of-stock' : ''}" />
                                                    <tr class="${rowClass}">
                                                        <td>
                                                            <input type="checkbox" class="form-check-input item-checkbox"
                                                                   value="${item.itemType}_${item.itemId}"
                                                                   onchange="checkSelectAllStatus()"
                                                                   <c:if test="${isOut || isMissing}">disabled</c:if>>
                                                            </td>
                                                            <td>${status.index + 1}</td>
                                                        <td><img src="${item.imageUrl}" alt="Image"></td>
                                                        <td>
                                                            <a href="ProductController?action=detail&modelName=${fn:escapeXml(item.itemName)}"
                                                               style="color: inherit; text-decoration: none;">
                                                                ${item.itemName}
                                                            </a>
                                                            <c:if test="${isMissing}">
                                                                <br><em>(No longer available)</em>
                                                            </c:if>
                                                            <c:if test="${not isMissing and isOut}">
                                                                <br><em>(Out of stock)</em>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.itemType == 'MODEL'}">Car Model</c:when>
                                                                <c:otherwise>Accessory</c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><fmt:formatNumber value="${item.unitPrice}" pattern="##0.00" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${isMissing || isOut}">
                                                                    <span class="text-danger">${item.quantity}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <form action="cart" method="post" class="d-flex align-items-center gap-2">
                                                                        <input type="hidden" name="action" value="update">
                                                                        <input type="hidden" name="itemType" value="${item.itemType}">
                                                                        <input type="hidden" name="itemId" value="${item.itemId}">
                                                                        <input type="number" name="quantity" value="${item.quantity}"
                                                                               min="0" class="form-control form-control-sm" style="width: 60px;" autocomplete="off">
                                                                        <input type="submit" value="Update" class="btn btn-sm btn-primary px-2 py-1">
                                                                    </form>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="subtotal"><fmt:formatNumber value="${item.subTotal}" pattern="##0.00" /> $</td>
                                                        <td>
                                                            <a href="cart?action=remove&itemType=${item.itemType}&itemId=${item.itemId}"
                                                               class="btn btn-sm btn-danger"
                                                               onclick="return confirm('Are you sure you want to remove this item?')">Delete</a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="mt-4 d-flex flex-wrap gap-2">
                                        <a href="cart?action=clear" class="btn btn-outline-danger"
                                           onclick="return confirm('Are you sure to clear the entire cart?')">🗑️ Clear Cart</a>
                                        <a href="ProductController?action=list" class="btn btn-outline-secondary btn-continue">
                                            🛍️ Continue Shopping
                                        </a>
                                        <button id="checkoutBtn" class="btn btn-secondary text-white" onclick="checkoutSelected()" disabled>
                                            ✅ Pay Selected
                                        </button>
                                        <a href="checkout?action=show" class="btn btn-success">💳 Pay All</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="mt-5 text-center">
                                <a href="home.jsp" class="btn btn-secondary mx-auto">
                                    ← Back to Home Page
                                </a>
                            </div>
                        </div> <!-- end card-body -->
                    </div> <!-- end card -->
                </div> <!-- end container -->
            </c:when>
            <c:otherwise>
                <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
                    <h2 class="text-danger">Access Denied</h2>
                    <p class="text-danger">${AuthUtils.getAccessDeniedMessage("login.jsp")}</p>
                    <a href="${AuthUtils.getLoginURL()}" class="btn btn-primary mt-2">Login Now</a>
                </div><br>
            </c:otherwise>
        </c:choose>
        <jsp:include page="footer.jsp" />
    </body>
</html>
