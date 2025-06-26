/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BrandDAO;
import dao.ModelCarDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.BrandModel;
import model.ImageModel;
import model.ModelCar;
import utils.AuthUtils;

/**
 *
 * @author ADMIN
 */
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
                    case "productUpdating":
                        url = handleProductUpdating(request, response);
                        break;
                    case "editProduct":
                        url = handleEditProduct(request, response);
                        break;
                    case "addToCart":
                        url = handleAddToCart(request, response);
                        break;
                    default:
                        request.setAttribute("message", "Invalid product action: " + action);
                        url = "productList.jsp";
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
        HttpSession session = request.getSession();

        try {
            String modelId = request.getParameter("modelId");

            if (modelId != null && !modelId.trim().isEmpty()) {
                ModelCarDAO modelCarDAO = new ModelCarDAO();
                BrandDAO brandDAO = new BrandDAO();

                ModelCar car = modelCarDAO.getById(modelId);

                if (car != null) {
                    request.setAttribute("productDetail", car);

                    // Get brand by brandId
                    BrandModel brand = brandDAO.getById(car.getBrandId());
                    if (brand != null) {
                        request.setAttribute("productBrand", brand);
                    }

                } else {
                    request.setAttribute("message", "No products found with ModelID: " + modelId);
                    url = "productList.jsp";
                }
            } else {
                request.setAttribute("message", "Missing product ModelID information.");
                url = "productList.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            url = "error.jsp";
            request.setAttribute("message", "Error loading product details: " + e.getMessage());
        }

        return url;
    }

    private String handleListEdit(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "Sorry, you do not have permission to access this page.");
            return "error.jsp";
        }
        ModelCarDAO dao = new ModelCarDAO();
        List<ModelCar> list = dao.getAll();
        request.setAttribute("productListEdit", list);
        return "editProduct.jsp";
    }

    private String handleSearchID(HttpServletRequest request, HttpServletResponse response) throws SQLException, ClassNotFoundException, ServletException, IOException {
        ModelCarDAO dao = new ModelCarDAO();
        String keyword = request.getParameter("keyword");
        List<ModelCar> list = dao.searchByModelId(keyword);
        request.setAttribute("listToEdit", list);
        request.setAttribute("keyword", keyword);
        RequestDispatcher rd = request.getRequestDispatcher("editProduct.jsp");
        rd.forward(request, response);
        return "editProduct.jsp";
    }

    private String handleChangeQuantity(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "Sorry, you do not have permission to access this page.");
            return "error.jsp";
        }
        ModelCarDAO dao = new ModelCarDAO();
        String productId = request.getParameter("productId");

        if (AuthUtils.isAdmin(request)) {
            dao.updateQuantity(productId);  // gọi hàm DAO đã fix ở trên
        }

        // Reload danh sách sản phẩm để hiển thị lại
        String keyword = request.getParameter("keyword"); // giữ lại keyword nếu có
        List<ModelCar> updatedList = dao.searchByName(keyword != null ? keyword : "");

        request.setAttribute("keyword", keyword);
        request.setAttribute("productListEdit", updatedList);

        return "editProduct.jsp"; // forward đến trang hiển thị
    }

    private String handleEditProduct(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "Sorry, you do not have permission to access this page.");
            return "error.jsp";
        }

        String modelId = request.getParameter("modelId");
        if (modelId == null || modelId.trim().isEmpty()) {
            request.setAttribute("message", "Missing product ModelID.");
            return "error.jsp";
        }

        ModelCarDAO dao = new ModelCarDAO();
        ModelCar product = dao.getById(modelId);
        if (product == null) {
            request.setAttribute("message", "No products found with ModelID: " + modelId);
            return "error.jsp";
        }

        request.setAttribute("product", product);
        return "productsUpdate.jsp";
    }

    private String handleProductUpdating(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "You do not have permission to edit the product.");
            return "error.jsp";
        }

        try {
            // Lấy dữ liệu từ form
            String modelId = request.getParameter("modelId");
            String modelName = request.getParameter("modelName");
            int scaleId = Integer.parseInt(request.getParameter("scale"));
            int brandId = Integer.parseInt(request.getParameter("brandId"));
            String description = request.getParameter("description");
            String keyword = request.getParameter("keyword");

            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity < -1) {
                request.setAttribute("message", "Quantity cannot be less than -1.");
                ModelCar existingProduct = new ModelCar(modelId, modelName, scaleId, brandId, price, description, quantity, null);
                request.setAttribute("product", existingProduct);
                request.setAttribute("keyword", request.getParameter("keyword"));
                return "productsUpdate.jsp";
            }
            // Lấy dữ liệu ảnh
            String[] imageIds = request.getParameterValues("imageId");
            String[] imageUrls = request.getParameterValues("imageUrl");
            String[] captions = request.getParameterValues("caption");

            List<ImageModel> imageList = new ArrayList<>();
            if (imageUrls != null) {
                for (int i = 0; i < imageUrls.length; i++) {
                    ImageModel img = new ImageModel();
                    if (imageIds != null && i < imageIds.length) {
                        img.setImageId(imageIds[i]);
                    }
                    img.setModelId(modelId); // chỉ dùng 1 modelId duy nhất
                    img.setImageUrl(imageUrls[i]);
                    if (captions != null && i < captions.length) {
                        img.setCaption(captions[i]);
                    }
                    imageList.add(img);
                }
            }

            // Tạo đối tượng ModelCar mới
            ModelCar updatedProduct = new ModelCar(modelId, modelName, scaleId, brandId, price, description, quantity, imageList);

            // Cập nhật vào DB
            ModelCarDAO dao = new ModelCarDAO();
            boolean success = dao.update(updatedProduct);
            dao.updateImages(imageList, modelId);

            if (success) {
                request.setAttribute("message", "Product update successful.");
            } else {
                request.setAttribute("message", "Unable to update product.");
            }

            // Lấy lại sản phẩm đã cập nhật để hiển thị
            ModelCar product = dao.getById(modelId);
            request.setAttribute("product", product);
            request.setAttribute("keyword", keyword);

            return "productsUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error while updating product: " + e.getMessage());
            return "error.jsp";
        }
    }

    private String handleProductAdding(HttpServletRequest request, HttpServletResponse response) {
        if (!AuthUtils.isAdmin(request)) {
            request.setAttribute("message", "You do not have permission to add products.");
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
                request.setAttribute("message", "Quantity cannot be less than -1.");
                request.setAttribute("product", null); // giữ lại form
                return "productsUpdate.jsp";
            }
            // Lấy dữ liệu ảnh
            String[] imageUrls = request.getParameterValues("imageUrl");
            String[] captions = request.getParameterValues("caption");

            List<ImageModel> imageList = new ArrayList<>();
            if (imageUrls != null) {
                for (int i = 0; i < imageUrls.length; i++) {
                    ImageModel img = new ImageModel();
                    img.setModelId(modelId); // modelId dùng làm khoá chính để liên kết
                    img.setImageUrl(imageUrls[i]);
                    if (captions != null && i < captions.length) {
                        img.setCaption(captions[i]);
                    }
                    imageList.add(img);
                }
            }

            // Tạo đối tượng sản phẩm mới
            ModelCar newProduct = new ModelCar(modelId, modelName, scaleId, brandId, price, description, quantity, imageList);

            // Thêm vào database
            ModelCarDAO dao = new ModelCarDAO();
            boolean success = dao.create(newProduct);
            dao.updateImages(imageList, modelId);// tương tự, cần hàm thêm ảnh

            if (success) {
                request.setAttribute("message", "New product added successfully.");
            } else {
                request.setAttribute("message", "Cannot add new products.");
            }

            request.setAttribute("product", null); // để hiển thị form trống nếu muốn thêm tiếp
            return "productsUpdate.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error adding product: " + e.getMessage());
            return "error.jsp";
        }
    }

}
