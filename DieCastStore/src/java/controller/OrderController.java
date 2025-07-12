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
        String customerId = null;
        if (user != null) {
            customerId = user.getCustomerId();
        }

        if (customerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Order> orders = orderDAO.getOrdersByCustomer(customerId);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("orderlist.jsp").forward(request, response);
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
        
        try {
            String name = orderDAO.getCustomerNameByOrderId(orderId);
            request.setAttribute("customerName", name);
        } catch (Exception e) {
            request.setAttribute("customerName", "Unknown");
            e.printStackTrace(); // Ghi log lỗi (có thể thay bằng Logger)
        }
        
        try {
            String phone = orderDAO.getCustomerPhoneByOrderId(orderId);
            request.setAttribute("phone", phone);
        } catch (Exception e) {
            request.setAttribute("phone", "Unknown");
            e.printStackTrace(); // Ghi log lỗi (có thể thay bằng Logger)
        }

        // ✅ Lấy địa chỉ giao hàng từ bảng Customer (qua Order)
        try {
            String address = orderDAO.getCustomerAddressByOrderId(orderId);
            request.setAttribute("address", address);
        } catch (Exception e) {
            request.setAttribute("address", "Unknown");
            e.printStackTrace(); // Ghi log lỗi (có thể thay bằng Logger)
        }

        request.setAttribute("order", order);
        request.setAttribute("details", details);
        request.getRequestDispatcher("orderdetail.jsp").forward(request, response);
    }

    private void handleCancelOrder(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException, SQLException, ClassNotFoundException {
        String orderId = request.getParameter("orderId");
        OrderDAO orderDAO = new OrderDAO();
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        ModelCarDAO modelCarDAO = new ModelCarDAO();
        AccessoryDAO accessoryDAO = new AccessoryDAO();

        boolean result = orderDAO.updateOrderStatus(orderId, "Cancelled");

        if (result) {
            // Trả hàng vào kho
            List<OrderDetail> items = orderDetailDAO.getItemsByOrderId(orderId);
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

        // Load lại danh sách đơn hàng của khách hàng
        CustomerAccount user = (CustomerAccount) request.getSession().getAttribute("user");
        if (user != null) {
            List<Order> userOrders = orderDAO.getOrdersByCustomerId(user.getCustomerId());
            request.setAttribute("orders", userOrders);
        }

        request.getRequestDispatcher("orderlist.jsp").forward(request, response);
    }

    private String handleUpdateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");

        OrderDAO orderDAO = new OrderDAO();
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        ModelCarDAO modelCarDAO = new ModelCarDAO();  // để cộng lại quantity nếu cần
        AccessoryDAO accessoryDAO = new AccessoryDAO();

        boolean result = orderDAO.updateOrderStatus(orderId, status);

        if (result) {
            request.setAttribute("message", "Order status updated successfully.");

            // ✅ Nếu status là Cancelled thì hoàn lại hàng vào kho
            if ("Cancelled".equalsIgnoreCase(status)) {
                try {
                    List<OrderDetail> items = orderDetailDAO.getItemsByOrderId(orderId);
                    System.out.println("Order has " + items.size() + " items.");
                    for (OrderDetail item : items) {
                        if ("MODEL".equalsIgnoreCase(item.getItemType())) {
                            modelCarDAO.increaseQuantity(item.getItemId(), item.getUnitQuantity());
                        } else if ("ACCESSORY".equalsIgnoreCase(item.getItemType())) {
                            accessoryDAO.increaseQuantity(item.getItemId(), item.getUnitQuantity());
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("message", "Order cancelled but failed to restock items.");
                }
            }
        } else {
            request.setAttribute("message", "Failed to update order status.");
        }

        // Load lại danh sách đơn hàng
        try {
            List<Order> orders = orderDAO.getAll();
            request.setAttribute("orders", orders);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error loading order list.");
        }

        request.getRequestDispatcher("manageOrders.jsp").forward(request, response);
        return null;
    }

    private String handleViewAllOrders(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            OrderDAO orderDao = new OrderDAO();
            List<Order> orders = orderDao.getAll();
            request.setAttribute("orders", orders);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error loading order list.");
        }

        // Forward trực tiếp tới trang JSP để hiển thị danh sách đơn hàng
        request.getRequestDispatcher("manageOrders.jsp").forward(request, response);

        // ✅ Không cần return vì đã forward rồi
        return null;
    }


}
