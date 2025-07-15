<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Product</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/editProduct.css">
    </head>
    <body style="background-color: #f1f6fb;">
        <jsp:include page="header.jsp" />
        <br>

        <c:choose>
            <c:when test="${isLoggedIn and isAdmin}">
                <div class="container">
                    <h2 class="text-center mb-4">🛠 Manage Products</h2>

                    <c:if test="${not empty checkError}">
                        <div class="alert alert-danger">${checkError}</div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">${message}</div>
                    </c:if>

                    <div class="d-flex justify-content-between mb-3">
                        <a href="home.jsp" class="btn btn-outline-secondary rounded-pill">
                            <i class="bi bi-house-door-fill"></i> Home
                        </a>
                        <a href="productsUpdate.jsp" class="btn btn-success rounded-pill">
                            <i class="bi bi-plus-circle"></i> Add New Product
                        </a>
                    </div>

                    <c:if test="${not empty pageList}">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped text-center align-middle">
                                <thead class="table-primary">
                                    <tr>
                                        <th>No.</th>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Scale</th>
                                        <th>Brand</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${pageList}" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                            <td>${p.modelId}</td>
                                            <td>${p.modelName}</td>
                                            <td>${p.scaleId}</td>
                                            <td>${p.brandId}</td>
                                            <td>$<fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="2"/></td>
                                            <td>${p.quantity}</td>
                                            <td>
                                                <form action="MainController" method="post" class="d-inline">
                                                    <input type="hidden" name="action" value="editProduct"/>
                                                    <input type="hidden" name="modelId" value="${p.modelId}"/>
                                                    <button type="submit" class="btn btn-warning btn-sm"><i class="bi bi-pencil-fill"></i></button>
                                                </form>
                                                <form action="MainController" method="post" class="d-inline">
                                                    <input type="hidden" name="action" value="changeQuantity"/>
                                                    <input type="hidden" name="modelId" value="${p.modelId}"/>
                                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">
                                                        <i class="bi bi-trash-fill"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <nav class="mt-4 text-center">
                            <div class="pagination justify-content-center">
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <a href="MainController?action=listEdit&page=${i}" class="btn btn-sm ${i == currentPage ? 'btn-success' : 'btn-outline-success'} mx-1">
                                        ${i}
                                    </a>
                                </c:forEach>
                            </div>
                        </nav>
                    </c:if>
                    <c:if test="${empty pageList}">
                        <div class="alert alert-warning">No products found.</div>
                    </c:if>

                    <hr class="my-5">
                    <h2 class="text-center mb-4">🔧 Manage Accessories</h2>
                    <div class="d-flex justify-content-end mb-3">
                        <a href="accessoryUpdate.jsp" class="btn btn-success rounded-pill">
                            <i class="bi bi-plus-circle"></i> Add New Accessory
                        </a>
                    </div>

                    <c:if test="${not empty accessoryList}">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped text-center align-middle">
                                <thead class="table-primary">
                                    <tr>
                                        <th>No.</th>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Image</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="a" items="${accessoryList}" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                            <td>${a.accessoryId}</td>
                                            <td>${a.accessoryName}</td>
                                            <td>$<fmt:formatNumber value="${a.price}" type="number" maxFractionDigits="2"/></td>
                                            <td>${a.quantity}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty a.imageUrl}">
                                                        <img src="${a.imageUrl}" alt="Accessory Image" style="max-height: 60px;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No image</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <form action="MainController" method="post" class="d-inline">
                                                    <input type="hidden" name="action" value="editAccessory"/>
                                                    <input type="hidden" name="accessoryId" value="${a.accessoryId}"/>
                                                    <button type="submit" class="btn btn-warning btn-sm"><i class="bi bi-pencil-fill"></i></button>
                                                </form>
                                                <form action="MainController" method="post" class="d-inline">
                                                    <input type="hidden" name="action" value="changeAccessoryQuantity"/>
                                                    <input type="hidden" name="accessoryId" value="${a.accessoryId}"/>
                                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">
                                                        <i class="bi bi-trash-fill"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                    <c:if test="${empty accessoryList}">
                        <div class="alert alert-warning">No accessories found.</div>
                    </c:if>
                </div>
            </c:when>

            <c:otherwise>
                <div class="container access-denied text-center mt-5">
                    <h2 class="text-danger">Access Denied</h2>
                    <p>${accessDeniedMessage}</p>
                    <a href="${loginURL}" class="btn btn-primary mt-2">Login Now</a>
                </div><br>
            </c:otherwise>
        </c:choose>

        <jsp:include page="footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
