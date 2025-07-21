package filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.AuthUtils;

@WebFilter(filterName = "AdminAuthorizationFilter", urlPatterns = {
    "/accessoryUpdate.jsp",
    "/editHome.jsp",
    "/editProduct.jsp",
    "/manageAccounts.jsp",
    "/manageOrders.jsp",
    "/productsUpdate.jsp",
    "/MainController",
    "/UserController",
    "/CartController",
    "/CheckoutController",
    "/OrderController",
    "/ProductController",
    "/UploadImgController"
})
public class AdminAuthorizationFilter implements Filter {

    // Danh sách các action yêu cầu quyền Admin
    private static final List<String> ADMIN_ACTIONS = Arrays.asList(
            "updateRole", "searchToUpdate", "changeAccessoryQuantity", "editAccessory",
            "accessoryUpdate", "accessoryAdding", "productUpdateMain", "productUpdateImages",
            "changeQuantity", "editProduct", "productAdding", "listEdit",
            "upload", "banner", "updateOrderStatus", "viewAllOrders"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AdminAuthorizationFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String action = httpRequest.getParameter("action");

        if ("login".equals(action)
                || "logout".equals(action)
                || "register".equals(action)
                || "showRegister".equals(action)
                || "showLogin".equals(action)
                || "forgotPassword".equals(action)
                || "resetPassword".equals(action)
                || "showForgotPassword".equals(action)
                || "list".equals(action)
                || "search".equals(action)
                || "detail".equals(action)
                || "sentContact".equals(action)) {
            chain.doFilter(request, response);
            return;
        }

        // Nếu là admin → cho qua luôn
        if (AuthUtils.isAdmin(httpRequest)) {
            chain.doFilter(request, response);
            return;
        }

        // Nếu là user nhưng cố truy cập hành động yêu cầu admin
        if (ADMIN_ACTIONS.contains(action)) {
            httpRequest.setAttribute("checkError", "You do not have permission to access this page.");
            httpRequest.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // Còn lại thì cho qua
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("AdminAuthorizationFilter destroyed");
    }
}
