package controller;

import dao.AccessoryDAO;
import dao.BrandDAO;
import dao.ImageModelDAO;
import dao.ModelCarDAO;
import dao.ScaleDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;
import model.Accessory;
import model.BrandModel;
import model.ImageModel;
import model.ModelCar;
import model.ScaleModel;
import utils.AuthUtils;
import utils.DBUtils;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "error.jsp";  // Default page in case of errors
        try {
            String action = request.getParameter("action");
            if (action != null) {
                switch (action) {
                    case "list":
                        url = handleList(request, response);
                        break;
                    case "listEdit":
                        url = handleListEdit(request, response);
                        break;
                    case "detail":
                        url = handleDetails(request, response);
                        break;
                    case "search":
                        url = handleSearch(request, response);
                        break;
                    case "searchID":
                        url = handleSearchID(request, response);
                        break;
                    case "showAddFormProduct":
                        url = handleShowAddFormProduct(request, response);
                        break;
                    case "productAdding":
                        url = handleProductAdding(request, response);
                        break;
                    case "changeQuantity":
                        url = handleChangeQuantity(request, response);
                        break;
                    case "productUpdateMain":
                        url = handleProductUpdateMain(request, response);
                        break;
                    case "productUpdateImages":
                        url = handleProductUpdateImages(request, response);
                        break;
                    case "editProduct":
                        url = handleEditProduct(request, response);
                        break;
                    case "sentContact":
                        url = handleSentContact(request, response);
                        break;
                    case "editProductPage":
                        url = handleEditProductPage(request, response);
                        break;
                    case "editAccessory":
                        url = handleEditAccessory(request, response);
                        break;
                    case "showAddFormAccessory":
                        url = handleShowAddFormAccessory(request, response);
                        break;
                    case "accessoryAdding":
                        url = handleAccessoryAdding(request, response);
                        break;
                    case "accessoryUpdate":
                        url = handleAccessoryUpdate(request, response);
                        break;
                    case "changeAccessoryQuantity":
                        url = handleChangeAccessoryQuantity(request, response);
                        break;
                    default:
                        request.setAttribute("message", "Invalid product action: " + action);
                        url = "MainController?action=list";
                        break;
                }
            } else {
                // Nếu không có action thì mặc định hiển thị danh sách
                url = handleList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Lỗi hệ thống: " + e.getMessage());
            url = "error.jsp";
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

    private String handleList(HttpServletRequest request, HttpServletResponse response) {
        ModelCarDAO dao = new ModelCarDAO();
        AccessoryDAO adao = new AccessoryDAO();
        List<ModelCar> list = dao.getAll();
        List<Accessory> accessoryList = adao.getAll();

        if (accessoryList.isEmpty() || accessoryList == null) {
            request.setAttribute("checkErorr", "No have list accessory");
            return "productList.jsp";
        }
        if (list.isEmpty() || list == null) {
            request.setAttribute("checkErorr", "No have list products");
            return "productList.jsp";
        }
        request.setAttribute("productList", list);
        request.setAttribute("accessoryList", accessoryList);

        return "productList.jsp";

    }

    private String handleSearch(HttpServletRequest request, HttpServletResponse response) {
        String keyword = request.getParameter("keyword");
        String pageParam = request.getParameter("page");
        int page = 1;
        int itemsPerPage = 16;

        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        ModelCarDAO dao = new ModelCarDAO();
        List<ModelCar> fullResults = dao.searchByName(keyword);

        if (fullResults.isEmpty() || fullResults == null) {
            request.setAttribute("checkError", "No matching results found for the keyword: " + keyword);
            return "productSearch.jsp";
        }

        int totalItems = fullResults.size();
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);

        int start = (page - 1) * itemsPerPage;
        int end = Math.min(start + itemsPerPage, totalItems);

        List<ModelCar> paginatedResults = fullResults.subList(start, end);

        request.setAttribute("searchResults", paginatedResults);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        return "productSearch.jsp";
    }

    private String handleDetails(HttpServletRequest request, HttpServletResponse response) {
        String url = "productDetail.jsp";
        AccessoryDAO adao = new AccessoryDAO();

        try {
            String modelId = request.getParameter("modelId");
            String modelName = request.getParameter("modelName");
            String accessoryId = request.getParameter("accessoryId");
            String accessoryName = request.getParameter("accessoryName");

            List<Accessory> accessoryList = adao.getAll();

            if (accessoryList.isEmpty() || accessoryList == null) {
                request.setAttribute("checkErorr", "No have list accessory");
                return "productList.jsp";
            }
            request.setAttribute("accessoryList", accessoryList);

            ModelCarDAO modelCarDAO = new ModelCarDAO();
            AccessoryDAO accessoryDAO = new AccessoryDAO();
            BrandDAO brandDAO = new BrandDAO();
            ScaleDAO scaleDAO = new ScaleDAO();

            // Ưu tiên hiển thị ModelCar nếu có thông tin
            if ((modelId != null && !modelId.trim().isEmpty()) || (modelName != null && !modelName.trim().isEmpty())) {
                ModelCar car = null;

                if (modelId != null && !modelId.trim().isEmpty()) {
                    car = modelCarDAO.getById(modelId);
                } else if (modelName != null && !modelName.trim().isEmpty()) {
                    car = modelCarDAO.getByName(modelName); // cần có getByName() trong DAO
                }

                if (car == null) {
                    request.setAttribute("checkError", "No ModelCar found with the given information.");
                    return "ProductController?action=list";
                }

                // Lưu model vào request
                request.setAttribute("productDetail", car);

                // Brand
                BrandModel brand = brandDAO.getById(car.getBrandId());
                if (brand != null) {
                    request.setAttribute("productBrand", brand);
                }

                // Scale
                ScaleModel scale = scaleDAO.getById(car.getScaleId());
                if (scale != null) {
                    request.setAttribute("productScale", scale);
                }

                // Gợi ý sản phẩm theo cùng scale
                List<ModelCar> productsByScale = modelCarDAO.getProductsByScaleId(car.getScaleId());
                if (productsByScale != null) {
                    productsByScale.removeIf(p -> p.getModelId().equals(modelId)); // loại bỏ chính nó
                }
                request.setAttribute("productsByScale", productsByScale);

                // 8 sản phẩm mới nhất
                List<ModelCar> newestProducts = modelCarDAO.getNewest8Products();
                request.setAttribute("newestProducts", newestProducts);

            } else if ((accessoryId != null && !accessoryId.trim().isEmpty()) || (accessoryName != null && !accessoryName.trim().isEmpty())) {
                Accessory accessory = null;

                if (accessoryId != null && !accessoryId.trim().isEmpty()) {
                    accessory = accessoryDAO.getById(accessoryId);
                } else if (accessoryName != null && !accessoryName.trim().isEmpty()) {
                    accessory = (Accessory) accessoryDAO.getByName(accessoryName); // cần có getByName() trong DAO
                }

                if (accessory == null) {
                    request.setAttribute("checkError", "No Accessory found with the given information.");
                    return "ProductController?action=list";
                }

                // Lưu accessory vào request
                request.setAttribute("accessoryDetail", accessory);

            } else {
                request.setAttribute("checkError", "Missing product information.");
                return "ProductController?action=list";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error loading product details: " + e.getMessage());
            url = "error.jsp";
        }

        return url;
    }

    private String handleListEdit(HttpServletRequest request, HttpServletResponse response) {
        // Kiểm tra quyền admin
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", false);
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());
            request.setAttribute("checkError", "Sorry, you do not have permission to access this page.");
            return "error.jsp";
        }

        final int ITEMS_PER_PAGE = 10;
        int currentPage = 1;
        String pageParam = request.getParameter("page");

        try {
            if (pageParam != null) {
                currentPage = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        HttpSession session = request.getSession();
        ModelCarDAO carDao = new ModelCarDAO();

        // Lấy danh sách sản phẩm từ session cache
        List<ModelCar> fullList = (List<ModelCar>) session.getAttribute("cachedProductListEdit");
        if (fullList == null) {
            fullList = carDao.getAll();
            session.setAttribute("cachedProductListEdit", fullList);
        }

        int totalItems = (fullList != null) ? fullList.size() : 0;
        int totalPages = (int) Math.ceil((double) totalItems / ITEMS_PER_PAGE);
        int start = (currentPage - 1) * ITEMS_PER_PAGE;
        int end = Math.min(start + ITEMS_PER_PAGE, totalItems);

        List<ModelCar> pageList = new ArrayList<>();
        if (fullList != null && start < totalItems) {
            pageList = fullList.subList(start, end);
        }

        // Lấy danh sách phụ kiện
        AccessoryDAO accDao = new AccessoryDAO();
        List<Accessory> accessoryList = accDao.getAll();

        // Gửi dữ liệu về JSP
        request.setAttribute("pageList", pageList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("accessoryList", accessoryList);

        // Các biến hỗ trợ cho JSTL
        request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
        request.setAttribute("isAdmin", true);
        request.setAttribute("accessDeniedMessage", "");
        request.setAttribute("loginURL", "login.jsp");

        return "editProduct.jsp";
    }

    private String handleSearchID(HttpServletRequest request, HttpServletResponse response) throws SQLException, ClassNotFoundException, ServletException, IOException {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "Sorry, you do not have permission to access this page.");
            return "error.jsp";
        }

        ModelCarDAO dao = new ModelCarDAO();
        String keyword = request.getParameter("keyword");
        List<ModelCar> list = dao.searchByModelId(keyword);
        if (list.isEmpty()) {
            request.setAttribute("checkError", "No have products.");
        }
        request.setAttribute("listToEdit", list);
        request.setAttribute("keyword", keyword);
        RequestDispatcher rd = request.getRequestDispatcher("editProduct.jsp");
        rd.forward(request, response);
        return "editProduct.jsp";
    }

    private String handleChangeQuantity(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "Sorry, you do not have permission to access this page.");
            return "error.jsp";
        }

        String modelId = request.getParameter("modelId");
        String keyword = request.getParameter("keyword");
        String pageParam = request.getParameter("page");

        int currentPage = 1;
        try {
            currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        ModelCarDAO dao = new ModelCarDAO();
        boolean success = dao.updateQuantity(modelId);

        // Lấy lại danh sách modelCar theo từ khóa tìm kiếm (có thể là rỗng)
        List<ModelCar> fullList = dao.searchByName(keyword != null ? keyword : "");
        if (fullList == null) {
            fullList = new ArrayList<>();
        }

        final int ITEMS_PER_PAGE = 10;
        int totalItems = fullList.size();
        int totalPages = (int) Math.ceil((double) totalItems / ITEMS_PER_PAGE);

        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }

        int start = (currentPage - 1) * ITEMS_PER_PAGE;
        int end = Math.min(start + ITEMS_PER_PAGE, totalItems);
        List<ModelCar> pageList = fullList.subList(start, end);

        // Lấy lại danh sách Accessory
        AccessoryDAO accessoryDAO = new AccessoryDAO();
        List<Accessory> accessoryList = accessoryDAO.getAll();
        if (accessoryList == null) {
            accessoryList = new ArrayList<>();
        }

        // Gửi dữ liệu ra view
        request.setAttribute("accessoryList", accessoryList);
        request.setAttribute("pageList", pageList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("keyword", keyword);

        request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
        request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
        request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
        request.setAttribute("loginURL", AuthUtils.getLoginURL());
        if (success) {
            HttpSession session = request.getSession();
            session.removeAttribute("cachedProductListEdit");
            request.setAttribute("messageChangeQuantity", "Quantity for product [" + modelId + "] has been updated to -1.");
        } else {
            request.setAttribute("checkErrorChangeQuantity", "Failed to update quantity. Check if productId exists.");
        }

        return "editProduct.jsp";
    }

    private String handleEditProduct(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "Sorry, you do not have permission to access this page.");
            return "error.jsp";
        }

        String modelId = request.getParameter("modelId");
        if (modelId == null || modelId.trim().isEmpty()) {
            request.setAttribute("checkErrorEditProduct", "Missing product ModelID.");
            return "error.jsp";
        }

        ModelCarDAO dao = new ModelCarDAO();
        ModelCar product = dao.getById(modelId);
        if (product == null) {
            request.setAttribute("checkErrorEditProduct", "No products found with ModelID: " + modelId);
            return "error.jsp";
        }

        // Gán thuộc tính cho JSTL điều kiện hiển thị trong JSP
        request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
        request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
        request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
        request.setAttribute("loginURL", AuthUtils.getLoginURL());

        request.setAttribute("product", product);
        return "productsUpdate.jsp";
    }

    private String handleShowAddFormProduct(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", false);
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());
            return "error.jsp";
        }

        request.setAttribute("isLoggedIn", true); // vì bạn đã là admin ở trên
        request.setAttribute("isAdmin", true);
        request.setAttribute("accessDeniedMessage", "");
        request.setAttribute("loginURL", "login.jsp");

        return "productsUpdate.jsp";
    }

    private String handleProductAdding(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "You do not have permission to add products.");
            return "error.jsp";
        }

        try {
            // Lấy dữ liệu từ form
            String modelId = request.getParameter("modelId");
            String modelName = request.getParameter("modelName");
            int scaleId = Integer.parseInt(request.getParameter("scale"));
            int brandId = Integer.parseInt(request.getParameter("brandId"));
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity < -1) {
                request.setAttribute("checkErrorAddProduct", "Quantity cannot be less than -1.");
                return "productsUpdate.jsp";
            }

            // Xử lý danh sách ảnh
            List<Part> imageParts = request.getParts().stream()
                    .filter(part -> "imageFiles".equals(part.getName()) && part.getSize() > 0)
                    .collect(Collectors.toList());

            String uploadDir = getServletContext().getRealPath("/assets/img/" + modelId + "/");
            new File(uploadDir).mkdirs();

            List<ImageModel> imageList = new ArrayList<>();
            int index = 1;

            for (Part imagePart : imageParts) {
                String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf('.'));
                String storedFileName = modelId + "_" + String.format("%01d", index++) + fileExtension;

                String imagePath = uploadDir + File.separator + storedFileName;
                imagePart.write(imagePath);

                ImageModel img = new ImageModel();
                img.setImageId(modelId + "_" + String.format("%02d", index - 1));
                img.setModelId(modelId);
                img.setImageUrl("assets/img/" + modelId + "/" + storedFileName);
                img.setCaption("");
                imageList.add(img);
            }

            // Tạo sản phẩm
            ModelCar newProduct = new ModelCar(modelId, modelName, scaleId, brandId, price, description, quantity, imageList);
            ModelCarDAO carDao = new ModelCarDAO();
            ImageModelDAO imageDao = new ImageModelDAO();

            boolean successProduct = carDao.create(newProduct);
            boolean successImages = true;

            for (ImageModel img : imageList) {
                successImages &= imageDao.create(img);
            }

            if (successProduct && successImages) {
                HttpSession session = request.getSession();
                session.removeAttribute("cachedProductListEdit");
                request.setAttribute("messageAddProduct", "New product and images added successfully.");
            } else {
                request.setAttribute("checkErrorAddProduct", "Failed to add product or images.");
            }

            request.setAttribute("product", newProduct); // Save form
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", true);
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());
            return "productsUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error while adding product: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleSentContact(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        // Kiểm tra dữ liệu đầu vào
        if (name == null || email == null || message == null
                || name.trim().isEmpty() || email.trim().isEmpty() || message.trim().isEmpty()) {

            return "error.jsp";
        }

        try ( Connection conn = DBUtils.getConnection()) {
            String sql = "INSERT INTO ContactMessages (name, email, message) VALUES (?, ?, ?)";
            try ( PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, message);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "error.jsp";
        }
        return "sendContact.jsp";
    }

    private String handleEditProductPage(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "Sorry, you do not have permission to access this page.");
            return "error.jsp";
        }

        final int ITEMS_PER_PAGE = 10;
        int currentPage = 1;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        ModelCarDAO dao = new ModelCarDAO();
        List<ModelCar> fullList = dao.getAll();

        // Cache toàn bộ danh sách
        request.getSession().setAttribute("cachedProductListEdit", fullList);

        int totalItems = fullList.size();
        int totalPages = (int) Math.ceil((double) totalItems / ITEMS_PER_PAGE);
        int start = (currentPage - 1) * ITEMS_PER_PAGE;
        int end = Math.min(start + ITEMS_PER_PAGE, totalItems);

        List<ModelCar> pageList = new ArrayList<>();
        if (start < totalItems) {
            pageList = fullList.subList(start, end);
        }

        // Gửi dữ liệu về JSP
        request.setAttribute("pageList", pageList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Thêm 3 biến JSTL để kiểm tra trạng thái đăng nhập trong JSP
        request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
        request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
        request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
        request.setAttribute("loginURL", AuthUtils.getLoginURL());

        return "editProduct.jsp";
    }

    private String handleProductUpdateMain(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            // Cần set đầy đủ các biến JSTL khi bị chặn truy cập
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", false);
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());
            request.setAttribute("checkError", "You do not have permission to update the product.");
            return "error.jsp";
        }

        try {
            String modelId = request.getParameter("modelId");
            String modelName = request.getParameter("modelName");
            String description = request.getParameter("description");
            String keyword = request.getParameter("keyword");

            int scaleId = Integer.parseInt(request.getParameter("scale"));
            int brandId = Integer.parseInt(request.getParameter("brandId"));
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Tạm lưu để trả về lại form khi có lỗi
            ModelCar tempProduct = new ModelCar(modelId, modelName, scaleId, brandId, price, description, quantity, null);
            request.setAttribute("product", tempProduct);
            request.setAttribute("keyword", keyword);

            // Validate input
            if (scaleId < 1 || scaleId > 2) {
                request.setAttribute("checkErrorUpdateProductMain", "Scale ID must be 1 or 2.");
                return returnUpdateWithAuthState(request);
            }
            if (brandId < 1 || brandId > 10) {
                request.setAttribute("checkErrorUpdateProductMain", "Brand ID must be between 1 and 10.");
                return returnUpdateWithAuthState(request);
            }
            if (price < 0) {
                request.setAttribute("checkErrorUpdateProductMain", "Price cannot be less than 0.");
                return returnUpdateWithAuthState(request);
            }
            if (quantity < -1) {
                request.setAttribute("checkErrorUpdateProductMain", "Quantity cannot be less than -1.");
                return returnUpdateWithAuthState(request);
            }

            // Cập nhật
            ModelCarDAO dao = new ModelCarDAO();
            boolean success = dao.update(tempProduct);

            if (success) {
                request.getSession().removeAttribute("cachedProductListEdit");
                request.setAttribute("messageUpdateProductMain", "Product information updated successfully.");
            } else {
                request.setAttribute("checkErrorUpdateProductMain", "Failed to update product information.");
            }

            // Reload sản phẩm cập nhật
            ModelCar refreshedProduct = dao.getById(modelId);
            request.setAttribute("product", refreshedProduct);
            request.setAttribute("keyword", keyword);

            return returnUpdateWithAuthState(request);

        } catch (NumberFormatException e) {
            request.setAttribute("checkError", "Invalid number format: " + e.getMessage());
            return returnUpdateWithAuthState(request);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Unexpected error: " + e.getMessage());

            // Cũng cần set auth state khi chuyển về error
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());

            return "error.jsp";
        }
    }

// Hàm phụ trợ để set lại JSTL login/admin state
    private String returnUpdateWithAuthState(HttpServletRequest request) {
        request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
        request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
        request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
        request.setAttribute("loginURL", AuthUtils.getLoginURL());
        return "productsUpdate.jsp";
    }

    private String handleProductUpdateImages(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", false);
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());
            request.setAttribute("checkError", "You do not have permission to update product images.");
            return "error.jsp";
        }

        try {
            String modelId = request.getParameter("modelId");
            String keyword = request.getParameter("keyword");

            if (modelId == null || modelId.trim().isEmpty()) {
                return returnUpdateImageError(request, "Model ID is missing.");
            }

            String[] captions = request.getParameterValues("captionList");

            ImageModelDAO imageDao = new ImageModelDAO();
            imageDao.deleteImagesByModelId(modelId);

            Collection<Part> parts = request.getParts();
            String uploadPath = request.getServletContext().getRealPath("/assets/img/" + modelId + "/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                return returnUpdateImageError(request, "Failed to create upload directory.");
            }

            int imageIndex = 0;
            boolean success = true;

            for (Part part : parts) {
                if ("imageFileList".equals(part.getName()) && part.getSize() > 0) {
                    try {
                        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                        String imageId = modelId + "_" + String.format("%02d", imageIndex + 1);
                        String filePath = uploadPath + File.separator + fileName;

                        part.write(filePath);

                        String caption = (captions != null && imageIndex < captions.length) ? captions[imageIndex] : "";

                        ImageModel img = new ImageModel();
                        img.setImageId(imageId);
                        img.setModelId(modelId);
                        img.setImageUrl("assets/img/" + modelId + "/" + fileName);
                        img.setCaption(caption);

                        success &= imageDao.create(img);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        success = false;
                    }
                    imageIndex++;
                }
            }
            if (success) {
                request.getSession().removeAttribute("cachedProductListEdit");
                request.setAttribute("messageUpdateProductImage", "Product information updated successfully.");
            } else {
                request.setAttribute("checkErrorUpdateProductImage", "Failed to update product information.");
            }

            ModelCarDAO modelDao = new ModelCarDAO();
            ModelCar product = modelDao.getById(modelId);

            request.setAttribute("product", product);
            request.setAttribute("keyword", keyword);
            request.setAttribute("message", success ? "Product images uploaded successfully." : "Some images failed to upload.");

            setAuthAttributes(request);
            return "productsUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            return returnUpdateImageError(request, "Unexpected error occurred: " + e.getMessage());
        }
    }

// Helper: set trạng thái đăng nhập
    private void setAuthAttributes(HttpServletRequest request) {
        request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
        request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
        request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
        request.setAttribute("loginURL", AuthUtils.getLoginURL());
    }

// Helper: return với lỗi và gán các JSTL login variables
    private String returnUpdateImageError(HttpServletRequest request, String errorMessage) {
        request.setAttribute("checkError", errorMessage);
        setAuthAttributes(request);
        return "productsUpdate.jsp";
    }

    private String handleShowAddFormAccessory(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", false);
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());
            return "error.jsp";
        }

        request.setAttribute("isLoggedIn", true); // vì bạn đã là admin ở trên
        request.setAttribute("isAdmin", true);
        request.setAttribute("accessDeniedMessage", "");
        request.setAttribute("loginURL", "login.jsp");

        return "accessoryUpdate.jsp";
    }

    private String handleAccessoryAdding(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "You do not have permission to add accessories.");
            return "error.jsp";
        }

        try {
            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            String detail = request.getParameter("detail");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity < -1) {
                request.setAttribute("checkErrorAddAccessory", "Quantity cannot be less than -1.");
                return "accessoryUpdate.jsp";
            }

            // Tạo Accessory ID đơn giản (tùy bạn có thể tạo theo format khác)
            AccessoryDAO dao = new AccessoryDAO();
            int count = dao.countAccessories();
            String accessoryId = String.format("ACS%03d", count + 1);

            // Xử lý ảnh (chỉ 1 ảnh)
            Part imagePart = request.getPart("imageFile");
            String imageUrl = null;

            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadDir = getServletContext().getRealPath("/assets/img/ACS/");
                new File(uploadDir).mkdirs();

                String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf('.'));
                String storedFileName = accessoryId + fileExtension;

                String imagePath = uploadDir + File.separator + storedFileName;
                imagePart.write(imagePath);

                imageUrl = "assets/img/ACS/" + storedFileName;
            }

            // Tạo accessory
            Accessory accessory = new Accessory();
            accessory.setAccessoryId(accessoryId);
            accessory.setAccessoryName(name);
            accessory.setDetail(detail);
            accessory.setPrice(price);
            accessory.setQuantity(quantity);
            accessory.setImageUrl(imageUrl);

            boolean success = dao.create(accessory);

            if (success) {
                request.setAttribute("messageAddAccessory", "New accessory added successfully.");
            } else {
                request.setAttribute("checkErrorAddAccessory", "Failed to add accessory.");
            }

            request.setAttribute("accessory", accessory);
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());
            return "accessoryUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error while adding accessory: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleAccessoryUpdate(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "You do not have permission to update the accessory.");
            return "error.jsp";
        }

        try {
            // Lấy dữ liệu từ form
            String accessoryId = request.getParameter("accessoryId");
            String name = request.getParameter("name");
            String detail = request.getParameter("detail");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Lưu lại form tạm thời nếu lỗi
            Accessory tempAcc = new Accessory();
            tempAcc.setAccessoryId(accessoryId);
            tempAcc.setAccessoryName(name);
            tempAcc.setPrice(price);
            tempAcc.setQuantity(quantity);
            tempAcc.setDetail(detail);
            request.setAttribute("accessory", tempAcc);

            // Kiểm tra logic
            if (price < 0) {
                request.setAttribute("checkErrorUpdateAccessory", "Price cannot be negative.");
                return "accessoryUpdate.jsp";
            }

            if (quantity < -1) {
                request.setAttribute("checkErrorUpdateAccessory", "Quantity cannot be less than -1.");
                return "accessoryUpdate.jsp";
            }

            AccessoryDAO dao = new AccessoryDAO();
            Accessory existingAcc = dao.getById(accessoryId);
            if (existingAcc == null) {
                request.setAttribute("checkErrorUpdateAccessory", "Accessory not found.");
                return "accessoryUpdate.jsp";
            }

            // Cập nhật ảnh nếu có
            Part imagePart = request.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadDir = getServletContext().getRealPath("/assets/img/ACS/");
                new File(uploadDir).mkdirs();

                String originalFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf('.'));
                String storedFileName = accessoryId + fileExtension;

                String imagePath = uploadDir + File.separator + storedFileName;
                imagePart.write(imagePath);

                String imageUrl = "assets/img/ACS/" + storedFileName;
                existingAcc.setImageUrl(imageUrl);
            }

            // Cập nhật các thông tin khác
            existingAcc.setAccessoryName(name);
            existingAcc.setPrice(price);
            existingAcc.setQuantity(quantity);
            existingAcc.setDetail(detail);

            boolean success = dao.update(existingAcc);

            if (success) {
                request.setAttribute("messageUpdateAccessory", "Accessory updated successfully.");
            } else {
                request.setAttribute("checkErrorUpdateAccessory", "Failed to update accessory.");
            }

            // Lấy lại bản cập nhật mới nhất để hiển thị
            Accessory refreshedAcc = dao.getById(accessoryId);
            request.setAttribute("accessory", refreshedAcc);
            request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
            request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
            request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
            request.setAttribute("loginURL", AuthUtils.getLoginURL());

        } catch (NumberFormatException e) {
            request.setAttribute("checkError", "Invalid number format: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Unexpected error: " + e.getMessage());
            return "error.jsp";
        }

        return "accessoryUpdate.jsp";
    }

    private String handleEditAccessory(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "Sorry, you do not have permission to access this page.");
            return "error.jsp";
        }

        String accessoryId = request.getParameter("accessoryId");
        if (accessoryId == null || accessoryId.trim().isEmpty()) {
            request.setAttribute("checkError", "Missing accessory AccessoryId.");
            return "error.jsp";
        }

        AccessoryDAO adao = new AccessoryDAO();
        Accessory acc = adao.getById(accessoryId);
        if (acc == null) {
            request.setAttribute("checkError", "No products found with ModelID: " + accessoryId);
            return "error.jsp";
        }

        request.setAttribute("accessory", acc);
        request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
        request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
        request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
        request.setAttribute("loginURL", AuthUtils.getLoginURL());
        return "accessoryUpdate.jsp";
    }

    private String handleChangeAccessoryQuantity(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "You do not have permission to access this page.");
            return "error.jsp";
        }

        String accessoryId = request.getParameter("accessoryId");
        String keyword = request.getParameter("keyword");
        String pageParam = request.getParameter("page");
        int currentPage = 1;

        try {
            currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        if (accessoryId == null || accessoryId.trim().isEmpty()) {
            request.setAttribute("checkError", "Missing accessory ID.");
            return "editProduct.jsp";
        }

        AccessoryDAO accessoryDAO = new AccessoryDAO();
        boolean success = accessoryDAO.updateQuantity(accessoryId);
        List<Accessory> accessoryList = accessoryDAO.getAll();
        if (accessoryList == null) {
            accessoryList = new ArrayList<>();
        }

        // ModelCar với keyword, phân trang
        ModelCarDAO modelCarDAO = new ModelCarDAO();
        List<ModelCar> fullList = modelCarDAO.searchByName(keyword != null ? keyword : "");
        if (fullList == null) {
            fullList = new ArrayList<>();
        }

        final int ITEMS_PER_PAGE = 10;
        int totalItems = fullList.size();
        int totalPages = (int) Math.ceil((double) totalItems / ITEMS_PER_PAGE);
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }

        int start = (currentPage - 1) * ITEMS_PER_PAGE;
        int end = Math.min(start + ITEMS_PER_PAGE, totalItems);
        List<ModelCar> pageList = fullList.subList(start, end);

        // Set attributes
        request.setAttribute("accessoryList", accessoryList);
        request.setAttribute("pageList", pageList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);

        if (success) {
            request.getSession().removeAttribute("cachedProductListEdit");
            request.setAttribute("messageChangeQuantityAccessory", "Quantity for accessory [" + accessoryId + "] has been updated to -1.");
        } else {
            request.setAttribute("checkErrorChangeQuantityAccessory", "Failed to update quantity. Please check the ID.");
        }

        request.setAttribute("isLoggedIn", AuthUtils.isLoggedIn(request));
        request.setAttribute("isAdmin", AuthUtils.isAdmin(request));
        request.setAttribute("accessDeniedMessage", AuthUtils.getAccessDeniedMessage("login.jsp"));
        request.setAttribute("loginURL", AuthUtils.getLoginURL());

        return "editProduct.jsp";
    }

}
