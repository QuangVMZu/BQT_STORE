/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccessoryDAO;
import dao.CartDAO;
import dao.ModelCarDAO;
import dao.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Accessory;
import model.Cart;
import model.CartItem;
import model.CustomerAccount;
import model.ModelCar;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout", "/CheckoutController"})
public class CheckoutController extends HttpServlet {

    private ModelCarDAO modelCarDAO;
    private AccessoryDAO accessoryDAO;
    private OrderDAO orderDAO;
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        modelCarDAO = new ModelCarDAO();
        accessoryDAO = new AccessoryDAO();
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        try {
            if (action == null) {
                action = "show";
            }

            switch (action) {
                case "show":
                    showCheckout(request, response);
                    break;
                case "process":
                    processCheckout(request, response);
                    break;
                case "showSelected":
                    showCheckoutSelected(request, response);
                    break;
                default:
                    showCheckout(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("cart.jsp").forward(request, response);
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

    private void showCheckout(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();

        // Kiểm tra đăng nhập 
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");
        if (user == null) {
            request.setAttribute("error", "Please login to pay");
            response.sendRedirect("login.jsp");
            return;
        }

        Cart checkoutCart = null;
        boolean isBuyNow = Boolean.TRUE.equals(session.getAttribute("isBuyNow"));

        // Merge buyNowCart vào cart chính
        if (isBuyNow) {
            // Sử dụng buyNowCart trực tiếp, không merge vào cart chính
            checkoutCart = (Cart) session.getAttribute("buyNowCart");
            if (checkoutCart == null || checkoutCart.getItems().isEmpty()) {
                session.setAttribute("errorMessage", "No products found to buy");
                response.sendRedirect("cart?action=view");
                return;
            }
        } else {
            // Sử dụng cart chính cho checkout thông thường
            checkoutCart = (Cart) session.getAttribute("cart");
            if (checkoutCart == null || checkoutCart.getItems().isEmpty()) {
                session.setAttribute("errorMessage", "Cart is empty");
                response.sendRedirect("cart?action=view");
                return;
            }
        }

        // Validate inventory trước khi hiển thị checkout
        List<String> inventoryWarnings = validateCartInventory(checkoutCart);
        if (!inventoryWarnings.isEmpty()) {
            request.setAttribute("inventoryWarnings", inventoryWarnings);

            // Nếu có lỗi nghiêm trọng, không cho phép checkout
            boolean hasBlockingError = false;
            for (String warning : inventoryWarnings) {
                if (warning.contains("no longer exists") || warning.contains("out of stock")) {
                    hasBlockingError = true;
                    break;
                }
            }

            if (hasBlockingError) {
                session.setAttribute("errorMessage", "Some products are out of stock. Please update your cart.");
                if (isBuyNow) {
                    // Nếu là buy now, redirect về trang sản phẩm
                    session.removeAttribute("buyNowCart");
                    session.removeAttribute("isBuyNow");
                    response.sendRedirect(request.getHeader("Referer"));
                } else {
                    response.sendRedirect("cart?action=view");
                }
                return;
            }
        }

        request.setAttribute("cart", checkoutCart);
        session.setAttribute("cartSize", checkoutCart.getTotalQuantity());
        request.setAttribute("totalAmount", checkoutCart.getTotalAmount());
        request.setAttribute("isBuyNow", isBuyNow);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    private List<String> validateCartInventory(Cart cart) {
        List<String> warnings = new ArrayList<>();

        if (cart == null || cart.getItems().isEmpty()) {
            return warnings;
        }

        for (CartItem item : cart.getItems()) {
            int availableQuantity = 0;
            boolean itemExists = true;

            if ("MODEL".equals(item.getItemType())) {
                ModelCar model = modelCarDAO.getById(item.getItemId());
                if (model != null) {
                    availableQuantity = model.getQuantity();
                } else {
                    itemExists = false;
                }
            } else if ("ACCESSORY".equals(item.getItemType())) {
                Accessory accessory = accessoryDAO.getById(item.getItemId());
                if (accessory != null) {
                    availableQuantity = accessory.getQuantity();
                } else {
                    itemExists = false;
                }
            }

            if (!itemExists) {
                warnings.add(item.getItemName() + " no longer exists");
            } else if (availableQuantity <= 0) {
                warnings.add(item.getItemName() + " out of stock");
            } else if (item.getQuantity() > availableQuantity) {
                warnings.add(item.getItemName() + " only " + availableQuantity + " product (you have selected " + item.getQuantity() + ")");
            }
        }
        return warnings;
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Kiểm tra đăng nhập
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");
        if (user == null) {
            request.setAttribute("error", "Please login to pay");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Xác định loại checkout
        boolean isBuyNow = Boolean.TRUE.equals(session.getAttribute("isBuyNow"));
        boolean isSelectedCheckout = Boolean.TRUE.equals(session.getAttribute("isSelectedCheckout"));

        Cart checkoutCart = isBuyNow
                ? (Cart) session.getAttribute("buyNowCart")
                : isSelectedCheckout
                        ? (Cart) session.getAttribute("selectedCart")
                        : (Cart) session.getAttribute("cart");

        if (checkoutCart == null || checkoutCart.getItems().isEmpty()) {
            session.setAttribute("errorMessage", "There are no products to checkout.");
            response.sendRedirect("cart?action=view");
            return;
        }

        // Lấy thông tin từ form
        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate thông tin đầu vào
        if (customerName == null || customerName.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()) {

            setCheckoutAttributes(request, response, checkoutCart, isBuyNow, "Please fill in all information!");
            return;
        }

        if (!phone.matches("^[0-9]{10,11}$")) {
            setCheckoutAttributes(request, response, checkoutCart, isBuyNow, "Invalid phone number!");
            return;
        }

        try {
            // Kiểm tra hàng tồn kho
            List<String> outOfStockMessages = new ArrayList<>();
            for (CartItem item : checkoutCart.getItems()) {
                int availableQuantity = 0;
                boolean exists = true;

                if ("MODEL".equals(item.getItemType())) {
                    ModelCar model = modelCarDAO.getById(item.getItemId());
                    if (model != null) {
                        availableQuantity = model.getQuantity();
                    } else {
                        exists = false;
                    }
                } else if ("ACCESSORY".equals(item.getItemType())) {
                    Accessory acc = accessoryDAO.getById(item.getItemId());
                    if (acc != null) {
                        availableQuantity = acc.getQuantity();
                    } else {
                        exists = false;
                    }
                }

                if (!exists) {
                    outOfStockMessages.add(item.getItemName() + " does not exist");
                } else if (availableQuantity <= 0) {
                    outOfStockMessages.add(item.getItemName() + " is out of stock");
                } else if (item.getQuantity() > availableQuantity) {
                    outOfStockMessages.add(item.getItemName() + " only has " + availableQuantity + " left");
                }
            }

            if (!outOfStockMessages.isEmpty()) {
                setCheckoutAttributes(request, response, checkoutCart, isBuyNow,
                        "Some products are out of stock or insufficient:\n" + String.join("\n", outOfStockMessages));
                return;
            }

            // Đặt hàng
            double totalAmount = checkoutCart.getTotalAmount();
            String customerId = user.getCustomerId();

            orderDAO.updateCustomerInfo(customerId, customerName.trim(), phone.trim(), address.trim());
            String orderId = orderDAO.createOrder(customerId, totalAmount, checkoutCart);

            // Trừ hàng trong kho
            for (CartItem item : checkoutCart.getItems()) {
                if ("MODEL".equals(item.getItemType())) {
                    modelCarDAO.updateQuantityForCart(item.getItemId(),
                            modelCarDAO.getById(item.getItemId()).getQuantity() - item.getQuantity());
                } else if ("ACCESSORY".equals(item.getItemType())) {
                    Accessory acc = accessoryDAO.getById(item.getItemId());
                    acc.setQuantity(acc.getQuantity() - item.getQuantity());
                    accessoryDAO.update(acc);
                }
            }

            // Cập nhật session/cart
            if (isBuyNow) {
                session.removeAttribute("buyNowCart");
                session.removeAttribute("isBuyNow");
                session.setAttribute("cartSize", checkoutCart.getTotalQuantity());
            } else if (isSelectedCheckout) {
                Cart mainCart = (Cart) session.getAttribute("cart");
                if (mainCart != null) {
                    for (CartItem selected : checkoutCart.getItems()) {
                        mainCart.removeItem(selected.getItemType(), selected.getItemId());
                        cartDAO.removeCartItem(customerId, selected.getItemType(), selected.getItemId());
                    }
                    session.setAttribute("cart", mainCart);
                    session.setAttribute("cartSize", mainCart.getTotalQuantity());
                }
                session.removeAttribute("selectedCart");
                session.removeAttribute("isSelectedCheckout");
            } else {
                Cart mainCart = (Cart) session.getAttribute("cart");
                if (mainCart != null) {
                    mainCart.clearCart();
                    session.setAttribute("cart", mainCart);
                    session.setAttribute("cartSize", mainCart.getTotalQuantity());
                }
                cartDAO.clearCart(customerId);
            }

            // Thành công → forward tới trang thông báo
            request.setAttribute("orderId", orderId);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("success", "Order successful!");
            request.setAttribute("isLoggedIn", true); // cần thiết nếu trang orderSuccess dùng JSTL
            request.getRequestDispatcher("orderSuccess.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            setCheckoutAttributes(request, response, checkoutCart, isBuyNow, "An error occurred while processing your order.");
        }
    }

// Hàm hỗ trợ để tránh lặp lại các đoạn gán giá trị
    private void setCheckoutAttributes(HttpServletRequest request, HttpServletResponse response, Cart cart, boolean isBuyNow, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.setAttribute("cart", cart);
        request.setAttribute("totalAmount", cart.getTotalAmount());
        request.setAttribute("isBuyNow", isBuyNow);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    private void showCheckoutSelected(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();

        // Kiểm tra đăng nhập
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");
        if (user == null) {
            request.setAttribute("error", "Please login to pay");
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy danh sách sản phẩm được chọn
        String[] selectedItems = request.getParameterValues("selectedItems");
        if (selectedItems == null || selectedItems.length == 0) {
            request.setAttribute("error", "Please select at least one product to checkout");
            response.sendRedirect("cart?action=view");
            return;
        }

        // Lấy cart từ session
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            request.setAttribute("error", "Cart is empty");
            response.sendRedirect("cart?action=view");
            return;
        }

        // Tạo cart mới chỉ chứa các sản phẩm được chọn
        Cart selectedCart = new Cart();

        for (String selectedItem : selectedItems) {
            String[] parts = selectedItem.split("_", 2); // Split thành itemType và itemId
            if (parts.length == 2) {
                String itemType = parts[0];
                String itemId = parts[1];

                // Tìm item trong cart gốc
                for (CartItem item : cart.getItems()) {
                    if (item.getItemType().equals(itemType) && item.getItemId().equals(itemId)) {
                        selectedCart.addItem(item.getItemType(), item.getItemId(),
                                item.getItemName(), item.getUnitPrice(), item.getQuantity());
                        break;
                    }
                }
            }
        }

        if (selectedCart.getItems().isEmpty()) {
            request.setAttribute("error", "No selected products found");
            response.sendRedirect("cart?action=view");
            return;
        }

        // Lưu selectedCart vào session để sử dụng trong processCheckout
        session.setAttribute("selectedCart", selectedCart);
        session.setAttribute("isSelectedCheckout", true);

        request.setAttribute("cart", selectedCart);
        request.setAttribute("totalAmount", selectedCart.getTotalAmount());
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }
}
