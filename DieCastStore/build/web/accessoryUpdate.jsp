<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="utils.AuthUtils"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>
            <c:choose>
                <c:when test="${not empty accessory}">Update Accessory</c:when>
                <c:otherwise>Add New Accessory</c:otherwise>
            </c:choose>
        </title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/accessoryUpdate.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <c:choose>
            <c:when test="${AuthUtils.isLoggedIn(pageContext.request)}">
                <c:choose>
                    <c:when test="${AuthUtils.isAdmin(pageContext.request)}">
                        <c:set var="isEdit" value="${not empty accessory}" />

                        <div class="container mt-5">
                            <div class="form-wrapper">
                                <div class="form-container">
                                    <h2 class="text-center">
                                        <c:choose>
                                            <c:when test="${isEdit}">Update Accessory</c:when>
                                            <c:otherwise>Add New Accessory</c:otherwise>
                                        </c:choose>
                                    </h2>

                                    <c:if test="${not empty checkErrorAddAccessory}">
                                        <div class="alert alert-danger">${checkErrorAddAccessory}</div>
                                    </c:if>
                                    <c:if test="${not empty messageAddAccessory}">
                                        <div class="alert alert-success">${messageAddAccessory}</div>
                                    </c:if>

                                    <c:if test="${not empty checkErrorUpdateAccessory}">
                                        <div class="alert alert-danger">${checkErrorUpdateAccessory}</div>
                                    </c:if>
                                    <c:if test="${not empty messageUpdateAccessory}">
                                        <div class="alert alert-success">${messageUpdateAccessory}</div>
                                    </c:if>

                                    <form action="ProductController" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="action" value="${isEdit ? 'accessoryUpdate' : 'accessoryAdding'}" />
                                        <c:if test="${isEdit}">
                                            <input type="hidden" name="accessoryId" value="${accessory.accessoryId}" />
                                        </c:if>

                                        <div class="mb-3">
                                            <label class="form-label">Name *</label>
                                            <input type="text" name="name" class="form-control" required value="${isEdit ? accessory.accessoryName : ''}" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Price *</label>
                                            <input type="number" name="price" step="0.01" min="0" class="form-control" required value="${isEdit ? accessory.price : ''}" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Quantity *</label>
                                            <input type="number" name="quantity" min="-1" class="form-control" required value="${isEdit ? accessory.quantity : ''}" />
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Description</label>
                                            <textarea name="detail" class="form-control" rows="4">${isEdit ? accessory.detail : ''}</textarea>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Image</label>
                                            <c:if test="${isEdit && not empty accessory.imageUrl}">
                                                <div class="mb-2">
                                                    <img src="${accessory.imageUrl}" class="preview-img" />
                                                    <span class="small text-muted">${accessory.imageUrl}</span>
                                                </div>
                                            </c:if>
                                            <input type="file" name="imageFile" class="form-control" accept="image/*" />
                                        </div>

                                        <div class="text-center mt-4">
                                            <button type="submit" class="btn btn-primary">
                                                <c:choose>
                                                    <c:when test="${isEdit}">Update</c:when>
                                                    <c:otherwise>Add</c:otherwise>
                                                </c:choose>
                                                Accessory
                                            </button>
                                            <a href="ProductController?action=listEdit" class="btn btn-secondary">
                                                <i class="bi"></i>← Back to List
                                            </a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
                            <h2 class="text-danger">Access Denied</h2>
                            <p class="text-danger">${AuthUtils.getAccessDeniedMessage("login.jsp")}</p>
                            <a href="${AuthUtils.getLoginURL()}" class="btn btn-primary mt-2">Login Now</a>
                        </div><br>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
                    <h2 class="text-danger">Access Denied</h2>
                    <p class="text-danger">${AuthUtils.getAccessDeniedMessage("login.jsp")}</p>
                    <a href="${AuthUtils.getLoginURL()}" class="btn btn-primary mt-2">Login Now</a>
                </div>
            </c:otherwise>
        </c:choose>
        <br>
        <jsp:include page="footer.jsp" />
    </body>
</html>
