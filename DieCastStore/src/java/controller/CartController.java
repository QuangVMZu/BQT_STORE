package controller;

import dao.AccessoryDAO;
import dao.CartDAO;
import dao.ModelCarDAO;
import dao.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Accessory;
import model.Cart;
import model.CartItem;
import model.CustomerAccount;
import model.ModelCar;

@WebServlet(name = "CartController", urlPatterns = {"/cart", "/CartController"})
public class CartController extends HttpServlet {

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
        String url = "cart.jsp";
        String action = request.getParameter("action");

        try {
            if (action == null) {
                action = "view";
            }

            switch (action) {
                case "view":
                    viewCart(request, response);
                    break;
                case "add":
                    addToCart(request, response);
                    break;
                case "update":
                    updateCart(request, response);
                    break;
                case "remove":
                    removeFromCart(request, response);
                    break;
                case "clear":
                    clearCart(request, response);
                    break;
                case "buyNow":
                    handleBuyNow(request, response);
                    break;
                default:
                    viewCart(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            // Nếu có lỗi, forward đến trang cart để hiển thị lỗi
            request.getRequestDispatcher(url).forward(request, response);
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

    private void viewCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            updateSessionCart(session, cart);
        }

        addInventoryStatusToCart(cart);

        request.setAttribute("cart", cart);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            HttpSession session = request.getSession();
            CustomerAccount user = (CustomerAccount) session.getAttribute("user");

            if (user == null) {
                session.setAttribute("checkErrorAddToCart", "Please login to add products to cart");

                String referer = request.getHeader("Referer");
                if (referer != null) {
                    session.setAttribute("redirectAfterLogin", referer);
                }

                response.sendRedirect("login.jsp");
                return;
            }

            String itemType = request.getParameter("itemType");
            String itemId = request.getParameter("itemId");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity <= 0) {
                session.setAttribute("errorMessage", "Quantity must be greater than 0");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            String itemName = "";
            double unitPrice = 0.0;
            int availableQuantity = 0;

            if ("MODEL".equals(itemType)) {
                ModelCar model = modelCarDAO.getById(itemId);
                if (model != null) {
                    itemName = model.getModelName();
                    unitPrice = model.getPrice();
                    availableQuantity = model.getQuantity();
                } else {
                    session.setAttribute("errorMessage", "Product does not exist");
                    response.sendRedirect(request.getHeader("Referer"));
                    return;
                }
            } else if ("ACCESSORY".equals(itemType)) {
                Accessory accessory = accessoryDAO.getById(itemId);
                if (accessory != null) {
                    itemName = accessory.getAccessoryName();
                    unitPrice = accessory.getPrice();
                    availableQuantity = accessory.getQuantity();
                } else {
                    session.setAttribute("errorMessage", "Product does not exist");
                    response.sendRedirect(request.getHeader("Referer"));
                    return;
                }
            } else {
                session.setAttribute("errorMessage", "Invalid product type");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            if (availableQuantity <= 0) {
                session.setAttribute("errorMessage", "Product is out of stock");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
            }

            cart.addItem(itemType, itemId, itemName, unitPrice, quantity);
            CartItem newItem = new CartItem(itemType, itemId, itemName, unitPrice, quantity);

            boolean saved = cartDAO.saveCartItem(user.getCustomerId(), newItem);
            if (!saved) {
                cart.removeItem(itemType, itemId);
                session.setAttribute("cart", cart);
                session.setAttribute("errorMessage", "Cannot save to database");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            updateSessionCart(session, cart);

            if (quantity > availableQuantity) {
                session.setAttribute("successMessage", "Product added to cart. But requested quantity (" + quantity
                        + ") exceeds inventory (" + availableQuantity + ")");
            } else {
                session.setAttribute("successMessage", "Product added to cart successfully.");
            }

//            response.sendRedirect("cart?action=view");
            response.sendRedirect(request.getHeader("Referer"));
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Invalid quantity");
            response.sendRedirect(request.getHeader("Referer"));
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getHeader("Referer"));
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String itemType = request.getParameter("itemType");
            String itemId = request.getParameter("itemId");
            int newQuantity = Integer.parseInt(request.getParameter("quantity"));

            HttpSession session = request.getSession();
            CustomerAccount user = (CustomerAccount) session.getAttribute("user");
            Cart cart = (Cart) session.getAttribute("cart");

            if (cart != null) {
                if (newQuantity <= 0) {
                    cart.removeItem(itemType, itemId);
                    // Xóa khỏi database
                    if (user != null) {
                        cartDAO.removeCartItem(user.getCustomerId(), itemType, itemId);
                    }
                    updateSessionCart(session, cart);
                    session.setAttribute("successMessage", "Product removed from cart");
                } else {
                    int currentAvailableQuantity = getCurrentInventoryQuantity(itemType, itemId);

                    CartItem currrentItem = null;
                    for (CartItem item : cart.getItems()) {
                        if (item.getItemType().equals(itemType) && item.getItemId().equals(itemId)) {
                            currrentItem = item;
                            break;
                        }
                    }
                    if (currrentItem == null) {
                        session.setAttribute("errorMessage", "Product does not exist in cart");
                    } else if (currentAvailableQuantity < 0) {
                        cart.removeItem(itemType, itemId);
                        if (user != null) {
                            cartDAO.removeCartItem(user.getCustomerId(), itemType, itemId);
                        }
                        updateSessionCart(session, cart);
                        session.setAttribute("errorMessage", "The product no longer exists and has been removed from the cart.");
                    } else if (currentAvailableQuantity == 0) {
                        session.setAttribute("errorMessage", "The product is out of stock. Please choose another product or remove from cart.");
                    } else if (newQuantity > currentAvailableQuantity) {
                        session.setAttribute("errorMessage", "Only" + currentAvailableQuantity
                                + " items left in stock. Please adjust the quantity.");
                    } else {
                        int oldQuantity = currrentItem.getQuantity();
                        cart.updateQuantity(itemType, itemId, newQuantity);

                        if (user != null) {
                            boolean updateSuccess = cartDAO.updateCartItemQuantity(user.getCustomerId(), itemType, itemId, newQuantity);
                            if (updateSuccess) {
                                updateSessionCart(session, cart);
                                session.setAttribute("successMessage", "Product quantity updated");
                            } else {
                                cart.updateQuantity(itemType, itemId, newQuantity);
                                updateSessionCart(session, cart);
                                session.setAttribute("errorMessage", "Unable to update quantity. Please try again.");
                            }
                        } else {
                            updateSessionCart(session, cart);
                            session.setAttribute("successMessage", "Product quantity updated");
                        }
                    }
                }
            } else {
                session.setAttribute("errorMessage", "Cart is empty");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid quantity");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }

        response.sendRedirect("cart?action=view");
    }

    private void updateSessionCart(HttpSession session, Cart cart) {
        session.setAttribute("cart", cart);
        session.setAttribute("cartSize", cart.getTotalQuantity());
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String itemType = request.getParameter("itemType");
        String itemId = request.getParameter("itemId");

        HttpSession session = request.getSession();
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null) {
            cart.removeItem(itemType, itemId);
            updateSessionCart(session, cart);

            // Xóa khỏi database
            if (user != null) {
                cartDAO.removeCartItem(user.getCustomerId(), itemType, itemId);
            }
            request.setAttribute("success", "Product removed from cart");
        }

        response.sendRedirect("cart?action=view");
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        CustomerAccount user = (CustomerAccount) session.getAttribute("user");

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart != null) {
            cart.clearCart();
            updateSessionCart(session, cart);
            // Xóa khỏi database
            if (user != null) {
                cartDAO.clearCart(user.getCustomerId());
            }
            request.setAttribute("success", "Entire cart cleared");
        }

        response.sendRedirect("cart?action=view");
    }

    private void handleBuyNow(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {

            HttpSession session = request.getSession();
            CustomerAccount user = (CustomerAccount) session.getAttribute("user");

            if (user == null) {
                session.setAttribute("checkErrorPurchase", "Please login to purchase");
                String referer = request.getHeader("Referer");
                if (referer != null) {
                    session.setAttribute("redirectAfterLogin", referer);
                }
                response.sendRedirect("login.jsp");
                return;
            }
            String itemType = request.getParameter("itemType");
            String itemId = request.getParameter("itemId");
            String quantityStr = request.getParameter("quantity");

            if (itemType == null || itemId == null || quantityStr == null) {
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            int quantity = Integer.parseInt(quantityStr);

            if (quantity <= 0) {
                session.setAttribute("errorMessage", "Quantity must be greater than 0");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            String itemName = "";
            double unitPrice = 0.0;
            int availableQuantity = 0;

            if ("MODEL".equals(itemType)) {
                ModelCar model = modelCarDAO.getById(itemId);
                if (model != null) {
                    itemName = model.getModelName();
                    unitPrice = model.getPrice();
                    availableQuantity = model.getQuantity();
                } else {
                    session.setAttribute("errorMessage", "Product does not exist");
                    response.sendRedirect(request.getHeader("Referer"));
                    return;
                }
            } else if ("ACCESSORY".equals(itemType)) {
                Accessory accessory = accessoryDAO.getById(itemId);
                if (accessory != null) {
                    itemName = accessory.getAccessoryName();
                    unitPrice = accessory.getPrice();
                    availableQuantity = accessory.getQuantity();
                } else {
                    session.setAttribute("errorMessage", "Product does not exist");
                    response.sendRedirect(request.getHeader("Referer"));
                    return;
                }
            } else {
                session.setAttribute("errorMessage", "Invalid product type");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            if (availableQuantity <= 0) {
                session.setAttribute("errorMessage", "Product is out of stock");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            if (quantity > availableQuantity) {
                session.setAttribute("errorMessage", "Only " + availableQuantity + " products in stock");
                response.sendRedirect(request.getHeader("Referer"));
                return;
            }

            Cart buyNowCart = new Cart();
            buyNowCart.addItem(itemType, itemId, itemName, unitPrice, quantity);

            session.setAttribute("buyNowCart", buyNowCart);
            session.setAttribute("cartSize", buyNowCart.getTotalQuantity());
            session.setAttribute("isBuyNow", true);

            response.sendRedirect("checkout?action=show");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getHeader("Referer"));
        }
    }

    private void addInventoryStatusToCart(Cart cart) {
        if (cart == null || cart.getItems().isEmpty()) {
            return;
        }

        for (CartItem item : cart.getItems()) {
            int availableQuantity = 0;
            boolean itemExists = true;
            String imageUrl = "assets/images/default.png"; // fallback mặc định

            if ("MODEL".equals(item.getItemType())) {
                ModelCar model = modelCarDAO.getById(item.getItemId());
                if (model != null) {
                    availableQuantity = model.getQuantity();

                    // Lấy ảnh đầu tiên nếu có
                    if (model.getImages() != null && !model.getImages().isEmpty()) {
                        imageUrl = model.getImages().get(0).getImageUrl();
                    }
                } else {
                    itemExists = false;
                    imageUrl = "assets/images/notfound.png"; // fallback nếu không tìm thấy
                }
            } else if ("ACCESSORY".equals(item.getItemType())) {
                Accessory accessory = accessoryDAO.getById(item.getItemId());
                if (accessory != null) {
                    availableQuantity = accessory.getQuantity();
                    if (accessory.getImageUrl() != null && !accessory.getImageUrl().isEmpty()) {
                        imageUrl = accessory.getImageUrl();
                    }
                } else {
                    itemExists = false;
                    imageUrl = "assets/images/notfound.png"; // fallback nếu không tìm thấy
                }
            }

            item.setAvailableQuantity(availableQuantity);
            item.setItemExists(itemExists);
            item.setInStock(availableQuantity >= item.getQuantity());
            item.setImageUrl(imageUrl);
        }
    }

    private int getCurrentInventoryQuantity(String itemType, String itemId) {
        try {
            if ("MODEL".equals(itemType)) {
                ModelCar model = modelCarDAO.getById(itemId);
                return model != null ? model.getQuantity() : -1;
            } else if ("ACCESSORY".equals(itemType)) {
                Accessory accessory = accessoryDAO.getById(itemId);
                return accessory != null ? accessory.getQuantity() : -1;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
}
