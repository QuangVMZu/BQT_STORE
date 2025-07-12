package controller;

import dao.CartDAO;
import dao.CustomerAccountDAO;
import dao.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Cart;
import model.CartItem;
import model.Customer;
import model.CustomerAccount;
import utils.AuthUtils;
import utils.PasswordUtils;

@WebServlet(name = "UserController", urlPatterns = {"/UserController"})
public class UserController extends HttpServlet {

    private static final String WELCOME_PAGE = "home.jsp";
    private static final String LOGIN_PAGE = "login.jsp";
    private static final String REGISTER_PAGE = "register.jsp";
    private static final String PROFILE_PAGE = "profileForm.jsp";
    private static final String EDIT_PAGE = "editProfile.jsp";

    private CartDAO cartDAO = new CartDAO();

    public static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = LOGIN_PAGE;
        if (url == null) {
            url = "login.jsp";
        }
        try {
            String action = request.getParameter("action");
            if (action != null) {
                switch (action) {
                    case "showLogin":
                        url = "login.jsp";
                        break;
                    case "showRegister":
                        url = "register.jsp";
                        break;
                    case "login":
                        url = handleLogin(request, response);
                        break;
                    case "register":
                        url = handleRegister(request, response);
                        break;
                    case "logout":
                        url = handleLogout(request, response);
                        break;
                    case "updateProfile":
                        url = handleProfileUpdating(request, response);
                        break;
                    case "viewProfile":
                        url = handleProfileViewing(request, response);
                        break;
                    case "editProfile":
                        url = handleProfileEditing(request, response);
                        break;
                    case "changePassword":
                        url = handlePasswordChanging(request, response);
                        break;
                    case "viewAllAccount":
                        url = handleViewAllAccount(request, response);
                        break;
                    case "updateRole":
                        url = handleUpdateRole(request, response);
                        break;
                    default:
                        request.setAttribute("message", "Invalid action: " + action);
                        url = LOGIN_PAGE;
                        break;
                }
            }
        } catch (Exception e) {
        } finally {
            if (url != null) {
                try {
                    request.getRequestDispatcher(url).forward(request, response);
                } catch (Exception ex) {
                    ex.printStackTrace(); // log lỗi
                    // KHÔNG gọi sendError ở đây nữa vì response có thể đã bị gửi
                }
            } else {
                // fallback an toàn nếu url null trước khi forward
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<h3>Unexpected error: No URL to forward.</h3>");
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private String handleLogin(HttpServletRequest request, HttpServletResponse response) {
        String url = LOGIN_PAGE;
        HttpSession session = request.getSession();

        String userName = request.getParameter("userName");
        String password = request.getParameter("password");

        if (isNullOrEmpty(userName) || isNullOrEmpty(password)) {
            request.setAttribute("message", "Please enter your User Name and Password!");
            return url;
        }

        try {
            CustomerAccountDAO accountDAO = new CustomerAccountDAO();
            CustomerDAO customerDAO = new CustomerDAO();

            CustomerAccount account = accountDAO.getByUserName(userName);
            if (account == null) {
                session.setAttribute("message", "Username or password is incorrect!");
                return url;
            }

            // Kiểm tra tài khoản bị ban
            if (account.getRole() == 0 || !accountDAO.isActiveUserByUserName(userName)) {
                session.setAttribute("message", "Your account has been banned.");
                return url;
            }

            // Xác thực đăng nhập (trả về boolean)
            boolean loginSuccess = accountDAO.login(userName, password);
            if (!loginSuccess) {
                session.setAttribute("message", "Username or password is incorrect!");
                return url;
            }

            // Đăng nhập thành công
            Customer customer = customerDAO.getById(account.getCustomerId());
            if (customer == null) {
                session.setAttribute("message", "Customer information not found!");
                return url;
            }

            session.setAttribute("user", account);
            session.setAttribute("account", account);
            session.setAttribute("customer", customer);
            session.setAttribute("userName", account.getUserName());
            session.setAttribute("customerId", account.getCustomerId());
            session.setAttribute("role", account.getRole());

            // Gộp giỏ hàng
            Cart savedCart = cartDAO.getCartByCustomerId(account.getCustomerId());
            Cart sessionCart = (Cart) session.getAttribute("cart");

            if (sessionCart != null && !sessionCart.getItems().isEmpty()) {
                for (CartItem item : sessionCart.getItems()) {
                    savedCart.addItem(item.getItemType(), item.getItemId(),
                            item.getItemName(), item.getUnitPrice(), item.getQuantity());
                }
                cartDAO.saveCart(account.getCustomerId(), savedCart);
            }

            session.setAttribute("cart", savedCart);

            // Redirect nếu có
            String redirectAfterLogin = (String) session.getAttribute("redirectAfterLogin");
            if (redirectAfterLogin != null) {
                session.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirectAfterLogin);
                return null; // đã redirect
            }

            return WELCOME_PAGE;

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "An error occurred during login.");
            return LOGIN_PAGE;
        }
    }

    private String handleRegister(HttpServletRequest request, HttpServletResponse response) {
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String customerName = request.getParameter("customerName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (isNullOrEmpty(userName)
                || isNullOrEmpty(password)
                || isNullOrEmpty(confirmPassword)
                || isNullOrEmpty(customerName)
                || isNullOrEmpty(email)
                || isNullOrEmpty(phone)
                || isNullOrEmpty(address)) {
            request.setAttribute("emptyError", "Please fill in all required information!");
            return REGISTER_PAGE;
        }
        if (password.length() < 6) {
            request.setAttribute("lengthError", "Password must be at least 6 characters!");
            return REGISTER_PAGE;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmError", "Password confirmation does not match!");
            return REGISTER_PAGE;
        }

        if (!AuthUtils.isValidEmail(email)) {
            request.setAttribute("emailError", "Incorrect email format! Please try again.");
            return REGISTER_PAGE;
        }
        if (!AuthUtils.isValidPhone(phone)) {
            request.setAttribute("phoneError", "Incorrect phone format! Please try again.");
            request.setAttribute("phoneMessage", "Phone number must start with 09|08|07|05|03 and follow by 8 number!");
            return REGISTER_PAGE;
        }

        try {
            CustomerDAO customerDAO = new CustomerDAO();
            CustomerAccountDAO accountDAO = new CustomerAccountDAO();

            if (accountDAO.isUserNameExists(userName)) {
                request.setAttribute("userNameError", "Username already exists! Please choose another one.");
                return REGISTER_PAGE;
            }
            if (customerDAO.isEmailExists(email)) {
                request.setAttribute("emailError", "Email already exists! Please use another email.");
                return REGISTER_PAGE;
            }
            if (customerDAO.isPhoneExists(phone)) {
                request.setAttribute("phoneError", "Phone number already exists! Please use another phone number.");
                return REGISTER_PAGE;
            }

            Customer customer = new Customer();
            CustomerAccount account = new CustomerAccount();

            customer.setCustomerName(customerName);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setAddress(address);

            boolean isCustomerCreated = customerDAO.create(customer);
            if (isCustomerCreated) {
                String customerId = customer.getCustomerId();

                account.setCustomerId(customerId);
                account.setUserName(userName);
                account.setPassword(password);
                account.setRole(2);

                boolean isAccountCreated = accountDAO.create(account);

                if (isAccountCreated) {
                    request.setAttribute("success", "Registration successful! Your Customer ID is: " + customerId);
                    return LOGIN_PAGE;
                } else {
                    request.setAttribute("error", "Failed to create account. Please try again later.");
                    return REGISTER_PAGE;
                }
            } else {
                request.setAttribute("error", "Failed to create customer. Please try again later.");
                return REGISTER_PAGE;

            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error occurred. Please try again later.");
            return REGISTER_PAGE;
        }
    }

    private String handleLogout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return WELCOME_PAGE;
    }

    private String handleProfileUpdating(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isLoggedIn(request)) {
            request.setAttribute("error", "Please login first!");
            return LOGIN_PAGE;
        }
        CustomerAccount account = AuthUtils.getCurrentUser(request);

        String customerName = request.getParameter("customerName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        try {
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getById(account.getCustomerId());

            if (isNullOrEmpty(customerName)) {
                request.setAttribute("nameError", "Customer name is required!");
                return EDIT_PAGE;
            }
            if (isNullOrEmpty(email)) {
                request.setAttribute("emailError", "Email is required!");
                return EDIT_PAGE;
            }
            if (isNullOrEmpty(phone)) {
                request.setAttribute("phoneError", "Phone is required!");
                return EDIT_PAGE;
            }
            if (isNullOrEmpty(address)) {
                request.setAttribute("addressError", "Address is required!");
                return EDIT_PAGE;
            }
            if (!email.equals(customer.getEmail())) {
                boolean check = customerDAO.isEmailExists(email);
                if (check) {
                    request.setAttribute("emailError", "Email already exists! Please use another email.");
                    return EDIT_PAGE;
                }
            }
            if (!AuthUtils.isValidEmail(email)) {
                request.setAttribute("emailError", "Incorrect email format! Please try again.");
                return EDIT_PAGE;
            }
            if (!phone.equals(customer.getPhone())) {
                boolean check = customerDAO.isPhoneExists(phone);
                if (check) {
                    request.setAttribute("phoneError", "Phone number already exists! Please use another phone number.");
                    return EDIT_PAGE;
                }
            }
            if (!AuthUtils.isValidPhone(phone)) {
                request.setAttribute("phoneError", "Incorrect phone format! Please try again.");
                request.setAttribute("phoneMessage", "Phone number must start with 09|08|07|05|03 and follow by 8 number!");
                return EDIT_PAGE;
            }

            customer.setCustomerName(customerName);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setAddress(address);

            boolean isCustomerUpdated = customerDAO.update(customer);

            if (!isCustomerUpdated) {
                request.setAttribute("updateError", "Failed to update profile. Please try again later.");
                return EDIT_PAGE;
            }

            String mess = "Profile updated successfully!";

            request.setAttribute("success", mess);

            Customer updatedCustomer = customerDAO.getById(account.getCustomerId());
            request.setAttribute("customer", updatedCustomer);

            HttpSession session = request.getSession();
            session.setAttribute("customer", updatedCustomer);

            return EDIT_PAGE;
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error occurred. Please try again later.");
            return PROFILE_PAGE;
        }
    }

    private String handleProfileViewing(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isLoggedIn(request)) {
            request.setAttribute("error", "Please login first!");
            return LOGIN_PAGE;
        }
        CustomerAccount account = AuthUtils.getCurrentUser(request);

        try {
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getById(account.getCustomerId());

            if (customer != null) {
                request.setAttribute("account", account);
                request.setAttribute("customer", customer);
                return PROFILE_PAGE;
            } else {
                request.setAttribute("error", "Customer information not found!");
                return LOGIN_PAGE;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return LOGIN_PAGE;
        }
    }

    private String handleProfileEditing(HttpServletRequest request, HttpServletResponse response) {
        CustomerAccount account = AuthUtils.getCurrentUser(request);
        if (account == null) {
            request.setAttribute("error", "Session expired. Please login again!");
            return LOGIN_PAGE;
        }

        try {
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getById(account.getCustomerId());

            if (customer != null) {
                request.setAttribute("account", account);
                request.setAttribute("customer", customer);
                return EDIT_PAGE;
            } else {
                request.setAttribute("error", "Customer information not found!");
                return LOGIN_PAGE;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error occurred. Please try again later.");
            return LOGIN_PAGE;
        }
    }

    private String handlePasswordChanging(HttpServletRequest request, HttpServletResponse response) {
        CustomerAccount account = AuthUtils.getCurrentUser(request);
        if (account == null) {
            request.setAttribute("error", "Session expired. Please login again!");
            return LOGIN_PAGE;
        }
        CustomerAccountDAO accountDAO = new CustomerAccountDAO();

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (isNullOrEmpty(oldPassword)
                && isNullOrEmpty(newPassword)
                && isNullOrEmpty(confirmPassword)) {
            request.setAttribute("passwordMessage", "All password fields are empty. No changes made.");
            return EDIT_PAGE;
        }
        if (isNullOrEmpty(oldPassword)) {
            request.setAttribute("oldPasswordError", "Please enter your current password!");
            return EDIT_PAGE;
        }
        if (isNullOrEmpty(newPassword)) {
            request.setAttribute("passwordError", "Please enter your new password!");
            return EDIT_PAGE;
        }
        if (isNullOrEmpty(confirmPassword)) {
            request.setAttribute("confirmError", "Please enter confirm password!");
            return EDIT_PAGE;
        }
        if (!PasswordUtils.verifyPassword(oldPassword, account.getPassword())) {
            request.setAttribute("oldPasswordError", "Current password is incorrect!");
            return EDIT_PAGE;
        }
        if (oldPassword.equals(newPassword)) {
            request.setAttribute("passwordError", "New password must be different from current password!");
            return EDIT_PAGE;
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("passwordError", "New password and confirm password do not match!");
            return EDIT_PAGE;
        }

        try {
            account.setPassword(newPassword);
            boolean isPasswordChanged = accountDAO.changePassword(account);

            if (!isPasswordChanged) {
                request.setAttribute("changeError", "Failed to change password. Please try again later.");
                return EDIT_PAGE;
            }

            account.setPassword(PasswordUtils.encryptSHA256(newPassword));
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            request.setAttribute("successChanging", "Password has been changed successfully!");
            return EDIT_PAGE;

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("changeError", "System error occurred. Please try again later.");
            return EDIT_PAGE;
        }
    }

    private String handleViewAllAccount(HttpServletRequest request, HttpServletResponse response) {
        try {
            CustomerAccountDAO accountDAO = new CustomerAccountDAO();
            CustomerDAO customerDAO = new CustomerDAO();

            List<CustomerAccount> accounts = accountDAO.getAll();
            List<Customer> customers = customerDAO.getAll();

            // Gửi dữ liệu chính
            request.setAttribute("accounts", accounts);
            request.setAttribute("customers", customers);
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", AuthUtils.isAdmin(request));

            // Gửi dữ liệu phụ cho hiển thị alert
            String checkError = (String) request.getAttribute("checkError");
            String message = (String) request.getAttribute("message");
            String updatedUserId = (String) request.getAttribute("updatedUserId");

            request.setAttribute("checkError", checkError);
            request.setAttribute("message", message);
            request.setAttribute("updatedUserId", updatedUserId);

            // Gửi các thông điệp hỗ trợ khi bị chặn truy cập (dùng trong JSTL)
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());

            return "manageAccounts.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "❌ Error while getting account list: " + e.getMessage());
            return "manageAccounts.jsp";
        }
    }

    private String handleUpdateRole(HttpServletRequest request, HttpServletResponse response) {
        CustomerDAO customerDAO = new CustomerDAO();
        List<Customer> customers = customerDAO.getAll();

        try {
            String customerId = request.getParameter("customerId");
            int role = Integer.parseInt(request.getParameter("role"));

            CustomerAccountDAO dao = new CustomerAccountDAO();
            boolean updated = dao.setUserRole(customerId, role);

            List<CustomerAccount> accounts = dao.getAll();
            request.setAttribute("accounts", accounts);
            request.setAttribute("customers", customers);
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());

            // Chỉ báo cho đúng user vừa cập nhật
            if (updated) {
                request.setAttribute("updatedUserId", customerId);
                request.setAttribute("message", "✅ Permissions updated successfully.");
            } else {
                request.setAttribute("updatedUserId", customerId);
                request.setAttribute("checkError", "❌ Unable to update permissions.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "❌ Error updating permissions: " + e.getMessage());
        }

        return "manageAccounts.jsp";
    }
}
