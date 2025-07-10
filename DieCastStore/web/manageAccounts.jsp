<%@ page import="java.util.List" %>
<%@ page import="model.CustomerAccount" %>
<%@ page import="utils.AuthUtils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Manage Accounts</title>
        <link rel="stylesheet" href="assets/CSS/manageAccounts.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp" />

        <% 
            if (AuthUtils.isLoggedIn(request)) {
                if (AuthUtils.isAdmin(request)) {
        %>
        <div class="table-container">
            <h2 class="mb-4 text-center">🧑‍💻 Customer Account Management</h2>

            <!-- Global Message -->
            <%
                String checkError = (String) request.getAttribute("checkError");
                String message = (String) request.getAttribute("message");
                String updatedUserId = (String) request.getAttribute("updatedUserId");
            %>
            <% if (checkError != null && !checkError.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                <%= checkError %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } else if (message != null && !message.isEmpty() && updatedUserId == null) { %>
            <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <table class="table table-bordered table-hover bg-white">
                <thead class="table-primary">
                    <tr>
                        <th>Customer ID</th>
                        <th>Username</th>
                        <th>Password (hash)</th>
                        <th>Current Role</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<CustomerAccount> list = (List<CustomerAccount>) request.getAttribute("accounts");
                        if (list != null && !list.isEmpty()) {
                            for (CustomerAccount acc : list) {
                    %>
                    <tr>
                        <td><%= acc.getCustomerId() %></td>
                        <td><%= acc.getUserName() %></td>
                        <td><%= acc.getPassword() %></td>
                        <td>
                            <span class="badge bg-<%= acc.getRole() == 0 ? "danger" : (acc.getRole() == 1 ? "primary" : "secondary") %>">
                                <%= acc.getRole() == 0 ? "Banned" : (acc.getRole() == 1 ? "Admin" : "User") %>
                            </span>
                        </td>
                        <td>
                            <form method="post" action="MainController" class="d-flex align-items-center gap-2">
                                <input type="hidden" name="action" value="updateRole" />
                                <input type="hidden" name="customerId" value="<%= acc.getCustomerId() %>"/>
                                <select name="role" class="form-select form-select-sm w-auto">
                                    <option value="0" <%= acc.getRole() == 0 ? "selected" : "" %>>0 - Banned</option>
                                    <option value="1" <%= acc.getRole() == 1 ? "selected" : "" %>>1 - Admin</option>
                                    <option value="2" <%= acc.getRole() == 2 ? "selected" : "" %>>2 - User</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-outline-success">Update</button>
                            </form>

                            <% if (updatedUserId != null && updatedUserId.equals(acc.getCustomerId())) { %>
                            <div class="mt-1">
                                <% if (message != null) { %>
                                <div class="alert alert-success py-1 px-2 mb-0"><%= message %></div>
                                <% } else if (checkError != null) { %>
                                <div class="alert alert-danger py-1 px-2 mb-0"><%= checkError %></div>
                                <% } %>
                            </div>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="5" class="text-center text-danger">⚠️ No account data found!</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="text-center return-section mt-3">
                <a href="home.jsp" class="btn btn-secondary">← Return to Home</a>
            </div>
        </div>
        <% 
    } else { // not admin 
        %>
        <div class="container access-denied">
            <h2 style="color: #00695c">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% 
            } // end if admin
        } else { // not logged in
        %>
        <div class="container access-denied">
            <h2 style="color: #00695c">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% } %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="footer.jsp" />
    </body>
</html>
