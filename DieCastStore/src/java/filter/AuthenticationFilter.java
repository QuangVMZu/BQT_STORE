package filter;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.AuthUtils;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
    "/*" // Lọc tất cả các request
})
public class AuthenticationFilter implements Filter {

    // Danh sách các URI/public pages KHÔNG cần đăng nhập
    private static final String[] PUBLIC_PATHS = {
        "/login.jsp",
        "/register.jsp",
        "/forgotPassword.jsp",
        "/resetPassword.jsp",
        "/sendContact.jsp",
        "/home.jsp",
        "/about.jsp",
        "/contact.jsp",
        "/productDetail.jsp",
        "/productList.jsp",
        "/productSearch.jsp",
        "/header.jsp",
        "/footer.jsp",
        "/MainController", // cần cho login/logout
        "/assets/", // cho phép static resources (ảnh, css, js...)
        "/images/"
    };

    private boolean isPublic(String uri) {
        for (String path : PUBLIC_PATHS) {
            if (uri.startsWith(path) || uri.contains(path)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void init(FilterConfig filterConfig) {
        System.out.println("AuthenticationFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI().replaceFirst(httpRequest.getContextPath(), "");
        String contextPath = httpRequest.getContextPath();
        String path = "/";
        try {
            path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        } catch (Exception e) {
            path = "/";
        }

        if (path.equals("/") || path.equals("/MainController") || path.startsWith("/assets")
                || path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png") || path.endsWith(".jpg")) {
            chain.doFilter(request, response);
            return;
        }

        // Nếu là trang public → cho qua
        if (isPublic(uri)) {
            chain.doFilter(request, response);
            return;
        }

        // Nếu là action login/logout → cho qua
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

        // Nếu chưa đăng nhập → chặn lại
        if (!AuthUtils.isLoggedIn(httpRequest)) {
            httpRequest.setAttribute("checkError", "You do not have permission to access this page.");
            httpRequest.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // Cho phép truy cập
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("AuthenticationFilter destroyed");
    }
}
