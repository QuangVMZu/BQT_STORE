package controller;

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
                    case "addToCart":
                        url = handleAddToCart(request, response);
                        break;
                    case "sentContact":
                        url = handleSentContact(request, response);
                        break;
                    case "editProductPage":
                        url = handleEditProductPage(request, response);
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
        List<ModelCar> list = dao.getAll();
        if (list.isEmpty() || list == null) {
            request.setAttribute("checkErorr", "No have list products");
            return "productList.jsp";
        }
        request.setAttribute("productList", list);
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

    private String handleAddToCart(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private String handleDetails(HttpServletRequest request, HttpServletResponse response) {
        String url = "productDetail.jsp";

        try {
            String modelId = request.getParameter("modelId");

            if (modelId == null || modelId.trim().isEmpty()) {
                request.setAttribute("checkError", "Missing product ModelID information.");
                return "productList.jsp";
            }

            ModelCarDAO modelCarDAO = new ModelCarDAO();
            BrandDAO brandDAO = new BrandDAO();
            ScaleDAO scaleDAO = new ScaleDAO();

            // Lấy thông tin chi tiết sản phẩm
            ModelCar car = modelCarDAO.getById(modelId);

            if (car == null) {
                request.setAttribute("checkError", "No product found with ModelID: " + modelId);
                return "productList.jsp";
            }

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

            // Lấy danh sách 8 sản phẩm mới nhất cho phần “Recommended”
            List<ModelCar> newestProducts = modelCarDAO.getNewest8Products();
            request.setAttribute("newestProducts", newestProducts);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Error loading product details: " + e.getMessage());
            url = "error.jsp";
        }

        return url;
    }

    private String handleListEdit(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "Sorry, you do not have permission to access this page.");
            return "error.jsp";
        }

        final int ITEMS_PER_PAGE = 10;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        HttpSession session = request.getSession();

        // Luôn lấy danh sách đầy đủ từ DAO khi là admin vào trang (có thể thay đổi tùy yêu cầu)
        ModelCarDAO dao = new ModelCarDAO();
        List<ModelCar> fullList = (List<ModelCar>) session.getAttribute("cachedProductListEdit");
        if (fullList == null) {
            fullList = dao.getAll();
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

        // Truyền danh sách phân trang và thông tin phân trang ra view
        request.setAttribute("pageList", pageList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

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

        ModelCarDAO dao = new ModelCarDAO();
        boolean success = dao.updateQuantity(modelId);

        List<ModelCar> updatedList = dao.searchByName(keyword != null ? keyword : "");

        if (updatedList.isEmpty()) {
            request.setAttribute("checkError", "No have product.");
        }

        request.setAttribute("keyword", keyword);
        request.setAttribute("pageList", updatedList);
        request.setAttribute("totalPages", 1);
        request.setAttribute("currentPage", 1);

        if (success) {
            request.setAttribute("message", "Quantity for product [" + modelId + "] has been updated to -1.");
        } else {
            request.setAttribute("checkError", "❌ Failed to update quantity. Check if productId exists.");
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
            request.setAttribute("checkError", "Missing product ModelID.");
            return "error.jsp";
        }

        ModelCarDAO dao = new ModelCarDAO();
        ModelCar product = dao.getById(modelId);
        if (product == null) {
            request.setAttribute("checkError", "No products found with ModelID: " + modelId);
            return "error.jsp";
        }

        request.setAttribute("product", product);
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
                request.setAttribute("checkError", "Quantity cannot be less than -1.");
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
                request.setAttribute("message", "New product and images added successfully.");
            } else {
                request.setAttribute("checkError", "Failed to add product or images.");
            }

            request.setAttribute("product", newProduct); // Save form
            return "productsUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error while adding product: " + e.getMessage());
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
            if (pageParam != null) {
                currentPage = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        ModelCarDAO dao = new ModelCarDAO();
        List<ModelCar> fullList = dao.getAll();

        request.getSession().setAttribute("cachedProductListEdit", fullList);

        int totalItems = fullList.size();
        int totalPages = (int) Math.ceil((double) totalItems / ITEMS_PER_PAGE);
        int start = (currentPage - 1) * ITEMS_PER_PAGE;
        int end = Math.min(start + ITEMS_PER_PAGE, totalItems);

        List<ModelCar> pageList = new ArrayList<>();
        if (start < totalItems) {
            pageList = fullList.subList(start, end);
        }

        request.setAttribute("pageList", pageList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        return "editProduct.jsp";
    }

    private String handleProductUpdateMain(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "You do not have permission to update the product.");
            return "error.jsp";
        }

        try {
            // Lấy tham số
            String modelId = request.getParameter("modelId");
            String modelName = request.getParameter("modelName");
            String description = request.getParameter("description");
            String keyword = request.getParameter("keyword");

            int scaleId = Integer.parseInt(request.getParameter("scale"));
            int brandId = Integer.parseInt(request.getParameter("brandId"));
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // Tạo sản phẩm tạm để giữ lại dữ liệu nếu có lỗi
            ModelCar tempProduct = new ModelCar(modelId, modelName, scaleId, brandId, price, description, quantity, null);
            request.setAttribute("product", tempProduct);
            request.setAttribute("keyword", keyword);

            // Kiểm tra logic
            if (scaleId < 1 || scaleId > 2) {
                request.setAttribute("checkError", "Scale ID must be 1 or 2.");
                return "productsUpdate.jsp";
            }

            if (brandId < 1 || brandId > 10) {
                request.setAttribute("checkError", "Brand ID must be between 1 and 10.");
                return "productsUpdate.jsp";
            }

            if (price < 0) {
                request.setAttribute("checkError", "Price cannot be less than 0.");
                return "productsUpdate.jsp";
            }

            if (quantity < -1) {
                request.setAttribute("checkError", "Quantity cannot be less than -1.");
                return "productsUpdate.jsp";
            }

            // Nếu hợp lệ thì cập nhật
            ModelCarDAO dao = new ModelCarDAO();
            boolean success = dao.update(tempProduct);

            if (success) {
                request.setAttribute("message", "Product information updated successfully.");
            } else {
                request.setAttribute("checkError", "Failed to update product information.");
            }

            // Lấy bản cập nhật mới nhất để hiển thị lại
            ModelCar refreshedProduct = dao.getById(modelId);
            request.setAttribute("product", refreshedProduct);
            return "productsUpdate.jsp";

        } catch (NumberFormatException e) {
            request.setAttribute("checkError", "Invalid number format: " + e.getMessage());
            return "productsUpdate.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Unexpected error: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleProductUpdateImages(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("checkError", "You do not have permission to update product images.");
            return "error.jsp";
        }

        try {
            String modelId = request.getParameter("modelId");
            String keyword = request.getParameter("keyword");

            if (modelId == null || modelId.trim().isEmpty()) {
                request.setAttribute("checkError", "Model ID is missing.");
                return "error.jsp";
            }

            // Xóa ảnh cũ
            ImageModelDAO imageDao = new ImageModelDAO();
            try {
                imageDao.deleteImagesByModelId(modelId);
            } catch (SQLException | ClassNotFoundException ex) {
                ex.printStackTrace();
                request.setAttribute("checkError", "Failed to delete old images: " + ex.getMessage());
                return "error.jsp";
            }

            Collection<Part> fileParts;
            try {
                fileParts = request.getParts();
            } catch (IOException | ServletException ex) {
                ex.printStackTrace();
                request.setAttribute("checkError", "Failed to retrieve uploaded files: " + ex.getMessage());
                return "error.jsp";
            }

            int imageIndex = 1;
            boolean success = true;

            for (Part part : fileParts) {
                try {
                    if ("imageFileList".equals(part.getName()) && part.getSize() > 0) {
                        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                        String imageId = modelId + "_" + String.format("%02d", imageIndex++);

                        // Đảm bảo thư mục uploads tồn tại
                        String uploadPath = request.getServletContext().getRealPath("/assets/img/" + modelId + "/");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                            request.setAttribute("checkError", "Failed to create upload directory.");
                            return "error.jsp";
                        }

                        // Ghi file
                        String filePath = uploadPath + File.separator + fileName;
                        try {
                            part.write(filePath);
                        } catch (IOException ex) {
                            ex.printStackTrace();
                            success = false;
                            continue; // tiếp tục xử lý ảnh tiếp theo
                        }

                        // Lưu vào DB
                        String imageUrl = "assets/img/" + modelId + "/" + fileName;

                        ImageModel img = new ImageModel();
                        img.setImageId(imageId);
                        img.setModelId(modelId);
                        img.setImageUrl(imageUrl);
                        img.setCaption(""); // có thể mở rộng
                        success &= imageDao.create(img);
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                    success = false;
                }
            }

            // Load lại sản phẩm
            ModelCarDAO modelDao = new ModelCarDAO();
            ModelCar product = modelDao.getById(modelId);
            request.setAttribute("product", product);

            request.setAttribute("keyword", keyword);
            request.setAttribute("message", success ? "Product images uploaded successfully." : "Some images failed to upload.");
            return "productsUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("checkError", "Unexpected error occurred: " + e.getMessage());
            return "error.jsp";
        }
    }

}
