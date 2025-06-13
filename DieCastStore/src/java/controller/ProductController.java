/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BrandDAO;
import dao.ModelCarDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BrandModel;
import model.ModelCar;

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
                        if (action == null || action.equals("list")) {
                            url = handleList(request, response);
                        }
                        break;
                    case "detail":
                        url = handleDetails(request, response);
                        break;
                    case "search":
                        url = handleSearch(request, response);
                        break;
                    case "addToCart":
                        url = handleAddToCart(request, response);
                        break;
                    case "new":
                        url = handleNewProducts(request, response);
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
                    request.setAttribute("message", "Không tìm thấy sản phẩm với ID: " + modelId);
                    url = "productList.jsp";
                }
            } else {
                request.setAttribute("message", "Thiếu thông tin mã sản phẩm.");
                url = "productList.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            url = "error.jsp";
            request.setAttribute("message", "Lỗi khi tải chi tiết sản phẩm: " + e.getMessage());
        }

        return url;
    }

    private String handleNewProducts(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        ModelCarDAO dao = new ModelCarDAO();
        List<ModelCar> newProducts = dao.getLatestProducts(4);  // Lấy 4 sản phẩm mới
        request.setAttribute("productListNew", newProducts);
        return "productCarousel.jsp";  // Trả về tên JSP chứ không forward tại đây
    }
}
