package controller;

import dao.AccessoryDAO;
import dao.ModelCarDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import model.CustomerAccount;
import model.Order;
import model.OrderDetail;
import utils.AuthUtils;

@WebServlet(name = "OrderController", urlPatterns = {"/order", "/OrderController"})
public class OrderController extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        try {
            if (action == null) {
                action = "list";
            }
            switch (action) {
                case "list":
                    listOrders(request, response);
                    break;
                case "vieworder":
                    viewOrders(request, response);
                    break;
                case "viewAllOrders":
                    handleViewAllOrders(request, response);
                    break;
                case "updateOrderStatus":
                    handleUpdateOrderStatus(request, response);
                    break;
                case "cancel":
                    handleCancelOrder(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("orderlist.jsp").forward(request, response);
            return;
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

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");

        // Nếu chưa đăng nhập → redirect về login
        if (user == null) {
            // Gán thông báo lỗi (nếu cần) và redirect
            request.setAttribute("accessDeniedMessage", "You must be logged in to view your orders.");
            request.setAttribute("loginURL", "login.jsp");
            request.getRequestDispatcher("orderlist.jsp").forward(request, response);
            return;
        }

        try {
            String customerId = user.getCustomerId();

            // Lấy danh sách đơn hàng theo customerId
            List<Order> orders = orderDAO.getOrdersByCustomer(customerId);

            // Gửi danh sách đơn hàng và trạng thái đăng nhập cho JSP
            request.setAttribute("orders", orders);
            request.setAttribute("isLoggedIn", true);
            request.setAttribute("accessDeniedMessage", "");
            request.setAttribute("loginURL", "login.jsp");

            request.getRequestDispatcher("orderlist.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Unable to load orders at this time.");
            request.setAttribute("isLoggedIn", true); // Vẫn đăng nhập
            request.setAttribute("accessDeniedMessage", "");
            request.setAttribute("loginURL", "login.jsp");
            request.getRequestDispatcher("orderlist.jsp").forward(request, response);
        }
    }

    private void viewOrders(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String orderId = request.getParameter("orderId");

        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect("order?action=list");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect("order?action=list");
            return;
        }

        List<OrderDetail> details = orderDAO.getOrderDetails(orderId);

        // Gán các thông tin cơ bản
        request.setAttribute("order", order);
        request.setAttribute("details", details);

        // Lấy thông tin khách hàng (có thể null)
        try {
            String customerName = orderDAO.getCustomerNameByOrderId(orderId);
            request.setAttribute("customerName", customerName != null ? customerName : "Unknown");
        } catch (Exception e) {
            request.setAttribute("customerName", "Unknown");
            e.printStackTrace();
        }

        try {
            String phone = orderDAO.getCustomerPhoneByOrderId(orderId);
            request.setAttribute("phone", phone != null ? phone : "Unknown");
        } catch (Exception e) {
            request.setAttribute("phone", "Unknown");
            e.printStackTrace();
        }

        try {
            String address = orderDAO.getCustomerAddressByOrderId(orderId);
            request.setAttribute("address", address != null ? address : "Unknown");
        } catch (Exception e) {
            request.setAttribute("address", "Unknown");
            e.printStackTrace();
        }

        // Gán thêm các thuộc tính JSTL logic (bắt buộc dùng khi đã chuyển sang JSTL)
        request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
        request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
        request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
        request.setAttribute("loginURL", AuthUtils.getLoginURL());

        request.getRequestDispatcher("orderdetail.jsp").forward(request, response);
    }

    private void handleCancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException, SQLException, ClassNotFoundException {

        String orderId = request.getParameter("orderId");
        OrderDAO orderDAO = new OrderDAO();
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        ModelCarDAO modelCarDAO = new ModelCarDAO();
        AccessoryDAO accessoryDAO = new AccessoryDAO();

        boolean result = orderDAO.updateOrderStatus(orderId, "Cancelled");

        if (result) {
            // Trả hàng vào kho
            List<OrderDetail> items = orderDetailDAO.getItemsByOrderId(orderId);
            HttpSession session = request.getSession();
            session.removeAttribute("cachedProductListEdit");
            for (OrderDetail item : items) {
                if ("MODEL".equalsIgnoreCase(item.getItemType())) {
                    modelCarDAO.increaseQuantity(item.getItemId(), item.getUnitQuantity());
                } else if ("ACCESSORY".equalsIgnoreCase(item.getItemType())) {
                    accessoryDAO.increaseQuantity(item.getItemId(), item.getUnitQuantity());
                }
            }

            request.setAttribute("message", "Order cancelled and stock restored.");
        } else {
            request.setAttribute("message", "Failed to cancel order.");
        }

        // ✅ Lấy tài khoản khách hàng từ session
        CustomerAccount user = (CustomerAccount) request.getSession().getAttribute("user");
        if (user != null) {
            List<Order> userOrders = orderDAO.getOrdersByCustomerId(user.getCustomerId());
            request.setAttribute("orders", userOrders);
            request.setAttribute("isLoggedIn", true); // ✅ JSTL kiểm tra đăng nhập
        } else {
            request.setAttribute("orders", null);
            request.setAttribute("isLoggedIn", false);
        }

        // ✅ Cài thêm biến hỗ trợ JSTL trong orderlist.jsp
        request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
        request.setAttribute("loginURL", AuthUtils.getLoginURL());

        request.getRequestDispatcher("orderlist.jsp").forward(request, response);
    }

    private String handleUpdateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Kiểm tra quyền đăng nhập
        if (!AuthUtils.isLoggedIn(request)) {
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());
            request.getRequestDispatcher("manageOrders.jsp").forward(request, response);
            return null;
        }

        // ✅ Kiểm tra quyền admin
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("isLoggedIn", true);
            request.setAttribute("isAdmin", false);
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());
            request.getRequestDispatcher("manageOrders.jsp").forward(request, response);
            return null;
        }

        // ✅ Đã xác nhận là admin
        request.setAttribute("isLoggedIn", true);
        request.setAttribute("isAdmin", true);
        request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
        request.setAttribute("loginURL", AuthUtils.getLoginURL());

        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");

        OrderDAO orderDAO = new OrderDAO();
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        ModelCarDAO modelCarDAO = new ModelCarDAO();
        AccessoryDAO accessoryDAO = new AccessoryDAO();

        try {
            boolean result = orderDAO.updateOrderStatus(orderId, status);

            if (result) {
                request.setAttribute("message", "✅ Order status updated successfully.");

                if ("Cancelled".equalsIgnoreCase(status)) {
                    List<OrderDetail> items = orderDetailDAO.getItemsByOrderId(orderId);
                    for (OrderDetail item : items) {
                        if ("MODEL".equalsIgnoreCase(item.getItemType())) {
                            modelCarDAO.increaseQuantity(item.getItemId(), item.getUnitQuantity());
                        } else if ("ACCESSORY".equalsIgnoreCase(item.getItemType())) {
                            accessoryDAO.increaseQuantity(item.getItemId(), item.getUnitQuantity());
                        }
                    }
                }

            } else {
                request.setAttribute("message", "❌ Failed to update order status.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Error while updating order status: " + e.getMessage());
        }

        // Load lại danh sách đơn hàng
        try {
            List<Order> orders = orderDAO.getAll();
            request.setAttribute("orders", orders);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Error loading order list.");
        }

        request.getRequestDispatcher("manageOrders.jsp").forward(request, response);
        return null;
    }

    private String handleViewAllOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            OrderDAO orderDao = new OrderDAO();
            List<Order> orders = orderDao.getAll();

            request.setAttribute("orders", orders);
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Error loading order list: " + e.getMessage());
        }

        // Forward đến JSP luôn ở cuối
        request.getRequestDispatcher("manageOrders.jsp").forward(request, response);
        return null;
    }

}
