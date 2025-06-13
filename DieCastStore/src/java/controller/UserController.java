/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerAccountDAO;
import dao.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.CustomerAccount;

/**
 *
 * @author hqthi
 */
@WebServlet(name = "UserController", urlPatterns = {"/UserController"})
public class UserController extends HttpServlet {

    private static final String WELCOME_PAGE = "home.jsp";
    private static final String LOGIN_PAGE = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = LOGIN_PAGE;
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
                        url = handleUpdateProfile(request, response);
                        break;
                    case "viewProfile":
                        url = handleViewProfile(request, response);
                        break;
                    case "changePassword":
                        url = handleChangePassword(request, response);
                        break;
                    default:
                        request.setAttribute("message", "Invalid action: " + action);
                        url = LOGIN_PAGE;
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();  // Bắt lỗi và in ra log server để biết
            request.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
            url = "register.jsp";
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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

        String userName = request.getParameter("strUserID");
        String password = request.getParameter("strPassword");

        CustomerAccountDAO customerAcDAO = new CustomerAccountDAO();
        CustomerAccount account = customerAcDAO.getByUserName(userName);

        if (account != null) {
            if (account.getRole() == 0) {
                // Tài khoản bị ban
                url = LOGIN_PAGE;
                session.setAttribute("message", "Your account has been banned.");
            } else {
                CustomerAccount loginResult = customerAcDAO.login(userName, password);
                if (loginResult != null) {
                    // Đăng nhập thành công
                    url = WELCOME_PAGE;
                    session.setAttribute("user", loginResult);
                } else {
                    // Mật khẩu sai
                    url = LOGIN_PAGE;
                    session.setAttribute("message", "UserID or Password incorrect!");
                }
            }
        } else {
            // Không tìm thấy tài khoản
            url = LOGIN_PAGE;
            session.setAttribute("message", "UserID or Password incorrect!");
        }

        return url;
    }

    private String handleRegister(HttpServletRequest request, HttpServletResponse response) {
        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        HttpSession session = request.getSession();
        CustomerDAO customerDAO = new CustomerDAO();
        CustomerAccountDAO accountDAO = new CustomerAccountDAO();

        // Kiểm tra xác nhận mật khẩu
        if (!password.equals(confirmPassword)) {
            session.setAttribute("message", "Mật khẩu không khớp!");
            return "register.jsp";
        }

        // Kiểm tra username đã tồn tại chưa
        if (accountDAO.isUserNameExists(userName)) {
            session.setAttribute("message", "Tên đăng nhập đã tồn tại!");
            return "register.jsp";
        }

        // Tạo mã customerId theo dạng C00x
        String customerId = customerDAO.generateCustomerID();
        if (customerId == null || customerId.isEmpty()) {
            session.setAttribute("message", "Lỗi tạo mã khách hàng!");
            return "register.jsp";
        }

        // Tạo và lưu Customer
        Customer customer = new Customer();
        customer.setCustomerId(customerId);
        customer.setCustomerName(fullName);
        customer.setEmail(email);
        customer.setPhone(phone);
        customer.setAddress(null); // nếu bạn chưa dùng địa chỉ

        boolean isCustomerCreated = customerDAO.create(customer);
        if (!isCustomerCreated) {
            session.setAttribute("message", "Đăng ký thất bại khi lưu thông tin khách hàng.");
            return "register.jsp";
        }

        // Tạo và lưu tài khoản đăng nhập
        CustomerAccount account = new CustomerAccount();
        account.setUserName(userName);
        account.setPassword(password); // Bạn có thể mã hóa bằng SHA-256 ở đây
        account.setCustomerId(customerId);
        account.setRole(2); // mặc định là khách hàng

        boolean isAccountCreated = accountDAO.create(account);
        if (isAccountCreated) {
            session.setAttribute("message", "Tạo tài khoản thành công! Mời đăng nhập.");
            return "login.jsp";
        } else {
            session.setAttribute("message", "Tạo tài khoản thất bại khi lưu thông tin đăng nhập!");
            return "register.jsp";
        }
    }

    private String handleLogout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "home.jsp";
    }

    private String handleUpdateProfile(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private String handleViewProfile(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private String handleChangePassword(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
