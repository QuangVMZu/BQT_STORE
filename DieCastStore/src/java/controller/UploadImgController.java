package controller;

import dao.HomeGalleryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import model.HomeGallery;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 20
)
@WebServlet(name = "UploadHomeImgController", urlPatterns = {"/UploadHomeImgController"})
public class UploadImgController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            String action = request.getParameter("action");
            String type = request.getParameter("type");
            String url = "error.jsp";

            if ("upload".equals(action)) {
                if ("gallery".equals(type)) {
                    url = handleGalleryUpload(request, response);
                } else if ("banner".equals(type)) {
                    url = handleBannerUpload(request, response);
                } else {
                    request.setAttribute("message", "❌ Invalid upload type.");
                    url = "editHome.jsp";
                }
            } else {
                url = "home.jsp"; // hoặc trang mặc định
            }

            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

    private String handleGalleryUpload(HttpServletRequest request, HttpServletResponse response) {
        String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "home";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String description = request.getParameter("description");
        List<HomeGallery> galleryItems = new ArrayList<>();

        try {
            Collection<Part> parts = request.getParts();

            for (int i = 1; i <= 4; i++) {
                String imagePartName = "image" + i;
                Part imagePart = request.getPart(imagePartName);
                if (imagePart != null && imagePart.getSize() > 0) {
                    String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                    String newFileName = System.currentTimeMillis() + "_" + fileName;
                    String fullPath = uploadPath + File.separator + newFileName;

                    imagePart.write(fullPath);
                    String imageUrl = "assets/home/" + newFileName;

                    String caption = request.getParameter("caption" + i);

                    HomeGallery img = new HomeGallery();
                    img.setImageUrl(imageUrl);
                    img.setCaption(caption != null ? caption : "");
                    img.setDisplayOrder(i);
                    img.setDescription(description);
                    img.setType("gallery");

                    galleryItems.add(img);
                }
            }

            HomeGalleryDAO dao = new HomeGalleryDAO();
            dao.deleteByType("gallery");
            for (HomeGallery img : galleryItems) {
                dao.insert(img);
            }

            request.setAttribute("selectedType", "gallery");
            request.setAttribute("message", "✅ Upload gallery Successfully.");
            return "editHome.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Upload gallery Unsuccessfully: " + e.getMessage());
            return "editHome.jsp";
        }
    }

    private String handleBannerUpload(HttpServletRequest request, HttpServletResponse response) {
        String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "home";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        List<HomeGallery> bannerItems = new ArrayList<>();

        try {
            Collection<Part> parts = request.getParts();
            int imageIndex = 1;

            for (Part part : parts) {
                if (part.getSubmittedFileName() != null && part.getName().startsWith("image")) {
                    String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    String newFileName = System.currentTimeMillis() + "_" + fileName;
                    String fullPath = uploadPath + File.separator + newFileName;

                    part.write(fullPath);
                    String imageUrl = "assets/home/" + newFileName;

                    HomeGallery img = new HomeGallery();
                    img.setImageUrl(imageUrl);
                    img.setDisplayOrder(imageIndex++);
                    img.setCaption("Image " + imageIndex);
                    img.setDescription(null);
                    img.setType("banner");

                    bannerItems.add(img);
                }
            }

            HomeGalleryDAO dao = new HomeGalleryDAO();
            dao.deleteByType("banner");
            for (HomeGallery img : bannerItems) {
                dao.insert(img);
            }

            request.setAttribute("selectedType", "banner");
            request.setAttribute("message", "✅ Upload banner Successfully.");
            return "editHome.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Upload banner Unsuccessfully: " + e.getMessage());
            return "editHome.jsp";
        }
    }
}
