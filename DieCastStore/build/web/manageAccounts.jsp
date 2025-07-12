<%@ page import="java.util.List" %>
<%@ page import="model.CustomerAccount" %>
<%@ page import="utils.AuthUtils"%>
<%@ page import="model.Customer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Manage Accounts</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/CSS/manageAccounts.css">
    </head>
    <body style="background: #e3f2fd;">
        <jsp:include page="header.jsp" />

        <%
            if (AuthUtils.isLoggedIn(request)) {
                if (AuthUtils.isAdmin(request)) {
        %>
        <div class="table-container">
            <h2 class="mb-4 text-center text-primary fw-bold">🧑‍💻 Customer Account Management</h2>

            <%
                String checkError = (String) request.getAttribute("checkError");
                String message = (String) request.getAttribute("message");
                String updatedUserId = (String) request.getAttribute("updatedUserId");
            %>

            <% if (updatedUserId != null) { %>
            <div class="alert alert-<%= (checkError != null) ? "danger" : "success" %> alert-dismissible fade show text-center shadow-sm rounded" role="alert">
                <%= (checkError != null) ? checkError : message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } else if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-success alert-dismissible fade show text-center shadow-sm rounded" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } else if (checkError != null && !checkError.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show text-center shadow-sm rounded" role="alert">
                <%= checkError %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <table class="table table-hover table-bordered bg-white align-middle">
                <thead class="table-primary">
                    <tr class="text-center">
                        <th>Customer ID</th>
                        <th>Customer Name</th>
                        <!--<th>Password (hash)</th>-->
                        <th>Address</th>
                        <th>Current Role</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<CustomerAccount> list = (List<CustomerAccount>) request.getAttribute("accounts");
                        List<Customer> customers = (List<Customer>) request.getAttribute("customers");
                        
                        if (list != null && !list.isEmpty()) {
                            for (CustomerAccount acc : list) {
                                String address = "Unknown";
                                String fullName = "Unknown";
                                if (customers != null) {
                                    for (Customer c : customers) {
                                        if (c.getCustomerId().equals(acc.getCustomerId())) {
                                            address = c.getAddress(); 
                                            fullName = c.getCustomerName();
                                            break;
                                        }
                                    }
                                }
                    %>
                    <tr>
                        <td class="text-center"><%= acc.getCustomerId() %></td>
                        <!--<td><%= acc.getUserName() %></td>-->
                        <td><%= fullName %></td>
                        <!--<td><%= acc.getPassword() %></td>-->
                        <td><%= address %></td>
                        <td class="text-center">
                            <span class="badge bg-<%= acc.getRole() == 0 ? "danger" : (acc.getRole() == 1 ? "primary" : "secondary") %>">
                                <%= acc.getRole() == 0 ? "Banned" : (acc.getRole() == 1 ? "Admin" : "User") %>
                            </span>
                        </td>
                        <td class="text-center">
                            <form method="post" action="MainController" class="d-flex align-items-center justify-content-center gap-2">
                                <input type="hidden" name="action" value="updateRole" />
                                <input type="hidden" name="customerId" value="<%= acc.getCustomerId() %>"/>
                                <select name="role" class="form-select form-select-sm w-auto rounded">
                                    <option value="0" <%= acc.getRole() == 0 ? "selected" : "" %>>0 - Banned</option>
                                    <option value="1" <%= acc.getRole() == 1 ? "selected" : "" %>>1 - Admin</option>
                                    <option value="2" <%= acc.getRole() == 2 ? "selected" : "" %>>2 - User</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-outline-success rounded px-3">Update</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6" class="text-center text-danger">⚠️ No account data found!</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="text-center mt-4">
                <a href="home.jsp" class="btn btn-secondary">← Back to Home</a>
            </div>
        </div>

        <%
            } else {
        %>
        <!-- Not Admin -->
        <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
            <h2 class="text-danger">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <%
            }
        } else {
        %>
        <!-- Not Logged In -->
        <div class="container access-denied text-center mt-5 shadow-sm p-4 bg-white rounded">
            <h2 class="text-danger">Access Denied</h2>
            <p><%= AuthUtils.getAccessDeniedMessage("login.jsp") %></p>
            <a href="<%= AuthUtils.getLoginURL() %>" class="btn btn-primary mt-2">Login Now</a>
        </div><br>
        <% } %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="footer.jsp" />
    </body>
</html>
