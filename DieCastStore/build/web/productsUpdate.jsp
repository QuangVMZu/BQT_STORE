<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><c:choose><c:when test="${not empty product}">Update Product</c:when><c:otherwise>Add New Product</c:otherwise></c:choose></title>
                <link rel="stylesheet" href="assets/CSS/productsUpdate.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            </head>
            <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp"/>

        <c:choose>
            <c:when test="${isLoggedIn and isAdmin}">
                <c:set var="isEdit" value="${not empty product}" />
                <c:set var="images" value="${product.images}" />
                <c:set var="numberOfImageInputs" value="4" />

                <div class="container mt-3">
                    <c:if test="${not empty checkError}">
                        <div class="alert alert-danger">${checkError}</div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">${message}</div>
                    </c:if>
                </div>

                <div class="form-image-container container">
                    <div class="product-form-box">
                        <div class="header mb-3">
                            <a href="ProductController?action=listEdit" class="back-link">&larr; Back to Products</a>
                        </div>

                        <h2><c:choose><c:when test="${isEdit}">Update Product</c:when><c:otherwise>Add New Product</c:otherwise></c:choose></h2>

                        <c:if test="${not isEdit}">
                            <form action="ProductController?action=productAdding" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="keyword" value="${keyword}" />
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <div class="card shadow-sm">
                                            <div class="card-header bg-success text-white"><h5 class="mb-0">Add Product</h5></div>
                                            <div class="card-body">
                                                <label>Model ID *</label>
                                                <input type="text" name="modelId" class="form-control mb-3" required />

                                                <label>Model Name *</label>
                                                <input type="text" name="modelName" class="form-control mb-3" required />

                                                <label>Scale ID *</label>
                                                <input type="number" name="scale" class="form-control mb-3" required min="1" max="2" step="1" />

                                                <label>Brand ID *</label>
                                                <input type="number" name="brandId" class="form-control mb-3" required min="1" max="10" step="1" />

                                                <label>Price *</label>
                                                <input type="number" step="0.01" name="price" class="form-control mb-3" required min="0" />

                                                <label>Quantity *</label>
                                                <input type="number" name="quantity" class="form-control mb-3" required min="-1" />

                                                <label>Description</label>
                                                <textarea name="description" rows="4" class="form-control"></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="card shadow-sm">
                                            <div class="card-header bg-primary text-white"><h5 class="mb-0">Upload Product Images</h5></div>
                                            <div class="card-body">
                                                <c:forEach begin="0" end="3" var="i">
                                                    <div class="mb-4 border rounded p-3 bg-light">
                                                        <label>Image File ${i + 1} *</label>
                                                        <input type="file" name="imageFiles" class="form-control mb-2" accept="image/*" required />

                                                        <label>Caption</label>
                                                        <input type="text" name="captionList" class="form-control" />
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-end mt-4">
                                    <button type="submit" class="btn btn-success">Add Product</button>
                                </div>
                            </form>
                        </c:if>

                        <c:if test="${isEdit}">
                            <div class="row g-4 mt-5">
                                <div class="col-md-6">
                                    <form action="ProductController?action=productUpdateMain" method="post">
                                        <div class="card shadow-sm">
                                            <div class="card-header bg-success text-white"><h5 class="mb-0">Update Product</h5></div>
                                            <div class="card-body">
                                                <input type="hidden" name="modelId" value="${product.modelId}" />
                                                <input type="hidden" name="keyword" value="${keyword}" />

                                                <label>Model Name *</label>
                                                <input type="text" name="modelName" class="form-control mb-3" value="${product.modelName}" required />

                                                <label>Scale ID *</label>
                                                <input type="number" name="scale" class="form-control mb-3" value="${product.scaleId}" required min="1" max="2" step="1" />

                                                <label>Brand ID *</label>
                                                <input type="number" name="brandId" class="form-control mb-3" value="${product.brandId}" required min="1" max="10" step="1" />

                                                <label>Price *</label>
                                                <input type="number" step="0.01" name="price" class="form-control mb-3" value="${product.price}" required min="0" />

                                                <label>Quantity *</label>
                                                <input type="number" name="quantity" class="form-control mb-3" value="${product.quantity}" required min="-1" />

                                                <label>Description</label>
                                                <textarea name="description" rows="4" class="form-control">${product.description}</textarea>

                                                <button type="submit" class="btn btn-success w-100 mt-3">Update Product</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <div class="col-md-6">
                                    <form action="ProductController?action=productUpdateImages" method="post" enctype="multipart/form-data">
                                        <div class="card shadow-sm">
                                            <div class="card-header bg-primary text-white"><h5 class="mb-0">Product Images</h5></div>
                                            <div class="card-body">
                                                <input type="hidden" name="modelId" value="${product.modelId}" />
                                                <input type="hidden" name="keyword" value="${keyword}" />

                                                <c:forEach begin="0" end="3" var="i">
                                                    <c:set var="img" value="${images[i]}" />
                                                    <div class="mb-4 border rounded p-3 bg-light">
                                                        <c:if test="${not empty img.imageId}">
                                                            <input type="hidden" name="imageIdList" value="${img.imageId}" />
                                                        </c:if>

                                                        <c:if test="${not empty img.imageUrl}">
                                                            <div class="mb-2">
                                                                <label>Current Image:</label><br />
                                                                <img src="${img.imageUrl}" alt="Current Image" style="max-width: 100px; height: auto; border: 1px solid #ccc;" />
                                                                <p class="small text-muted">${img.imageUrl}</p>
                                                            </div>
                                                        </c:if>

                                                        <label class="form-label">Upload New Image ${i + 1}</label>
                                                        <input type="file" name="imageFileList" class="form-control mb-2" accept="image/*" />

                                                        <label class="form-label">Caption</label>
                                                        <input type="text" name="captionList" class="form-control" value="${img.caption}" />
                                                    </div>
                                                </c:forEach>

                                                <button type="submit" class="btn btn-primary w-100">Upload Images</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="container access-denied">
                    <h2 class="text-danger">Access Denied</h2>
                    <p>${accessDeniedMessage}</p>
                    <a href="${loginURL}" class="btn btn-primary mt-2">Login Now</a>
                </div><br />
            </c:otherwise>
        </c:choose>

        <jsp:include page="footer.jsp" />
    </body>
</html>
