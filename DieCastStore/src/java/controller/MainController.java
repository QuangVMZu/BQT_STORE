package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MainController", urlPatterns = {"", "/MainController"})
public class MainController extends HttpServlet {

    private static final String WELCOME = "home.jsp";

    private boolean isUserAction(String action) {
        return "login".equals(action)
                || "logout".equals(action)
                || "register".equals(action)
                || "updateProfile".equals(action)
                || "viewProfile".equals(action)
                || "editProfile".equals(action)
                || "changePassword".equals(action)
                || "showLogin".equals(action)
                || "showRegister".equals(action)
                || "viewAllAccount".equals(action)
                || "updateRole".equals(action);
    }

    private boolean isProductAction(String action) {
        return "list".equals(action)
                || "detail".equals(action)
                || "search".equals(action)
                || "productAdding".equals(action)
                || "listEdit".equals(action)
                || "editProduct".equals(action)
                || "changeQuantity".equals(action)
                || "productUpdateImages".equals(action)
                || "productUpdateMain".equals(action)
                || "sentContact".equals(action)
                || "accessoryAdding".equals(action)
                || "accessoryUpdate".equals(action)
                || "editAccessory".equals(action)
                || "changeAccessoryQuantity".equals(action);
    }

    private boolean isUploadAction(String action) {
        return "upload".equals(action)
                || "banner".equals(action);
    }

    private boolean isCartAction(String action) {
        return "view".equals(action)
                || "add".equals(action)
                || "update".equals(action)
                || "remove".equals(action)
                || "clear".equals(action)
                || "buyNow".equals(action);
    }

    private boolean isCheckoutAction(String action) {
        return "show".equals(action)
                || "process".equals(action)
                || "showSelected".equals(action);
    }

    private boolean isOrderAction(String action) {
        return "list".equals(action)
                || "vieworder".equals(action)
                || "cancel".equals(action)
                || "updateOrderStatus".equals(action)
                || "viewAllOrders".equals(action);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = WELCOME;
        try {
            String action = request.getParameter("action");
            if (action != null && !action.trim().isEmpty()) {
                if (isUserAction(action)) {
                    url = "/UserController";
                } else if (isProductAction(action)) {
                    url = "/ProductController";
                } else if (isUploadAction(action)) {
                    url = "/UploadHomeImgController";
                } else if (isCartAction(action)) {
                    url = "/CartController";
                } else if (isCheckoutAction(action)) {
                    url = "/CheckoutController";
                } else if (isOrderAction(action)) {
                    url = "/OrderController";
                } else {
                    request.setAttribute("message", "Invalid action: " + action);
                }
            }
        } catch (Exception e) {
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

}
