package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.HomeGallery;
import utils.DBUtils;

public class HomeGalleryDAO {

    private static final String GET_ALL = "SELECT * FROM home_gallery ORDER BY display_order ASC";
    private static final String INSERT = "INSERT INTO home_gallery (image_url, caption, display_order, description, type) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE home_gallery SET image_url = ?, caption = ?, display_order = ?, description = ? WHERE id = ?";
    private static final String DELETE = "DELETE FROM home_gallery WHERE id = ?";
    private static final String GET_LAST_DES = "SELECT TOP 1 description FROM home_gallery WHERE description IS NOT NULL ORDER BY created_at DESC";
    private static final String GET_GALLERY = "SELECT * FROM home_gallery WHERE type = 'gallery' ORDER BY display_order ASC";
    private static final String DELETE_BANNER = "DELETE FROM home_gallery WHERE type = 'banner'";
    private static final String INSERT_BANNER = "INSERT INTO home_gallery (image_url, caption, display_order, type) VALUES (?, ?, ?, ?)";
    private static final String GET_BANNER = "SELECT * FROM home_gallery WHERE type = 'banner' ORDER BY display_order ASC";
    private static final String DELETE_BY_TYPE = "DELETE FROM home_gallery WHERE type = ?";

    private void closeResources(Connection c, PreparedStatement st, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (st != null) {
                st.close();
            }
            if (c != null) {
                c.close();
            }
        } catch (Exception e) {
            System.err.println("Error closing resources: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Lấy tất cả ảnh, sắp xếp theo display_order ASC
    public List<HomeGallery> getAll() {
        List<HomeGallery> list = new ArrayList<>();

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL);
            rs = st.executeQuery();

            while (rs.next()) {
                HomeGallery img = new HomeGallery();
                img.setId(rs.getInt("id"));
                img.setImageUrl(rs.getString("image_url"));
                img.setCaption(rs.getString("caption"));
                img.setDisplayOrder(rs.getInt("display_order"));
                img.setDescription(rs.getString("description"));
                img.setCreatedAt(rs.getTimestamp("created_at"));
                img.setType(rs.getString("type"));
                list.add(img);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return list;
    }

    // Thêm mới ảnh vào gallery
    public boolean insert(HomeGallery item) {
        Connection c = null;
        PreparedStatement ps = null;

        try {
            c = DBUtils.getConnection();
            ps = c.prepareStatement(INSERT);

            ps.setString(1, item.getImageUrl());
            ps.setString(2, item.getCaption());
            ps.setInt(3, item.getDisplayOrder());
            ps.setString(4, item.getDescription());
            ps.setString(5, item.getType());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, ps, null);
        }

        return false;
    }

    // Cập nhật ảnh và mô tả
    public boolean update(HomeGallery item) {
        Connection c = null;
        PreparedStatement ps = null;

        try {
            c = DBUtils.getConnection();
            ps = c.prepareStatement(UPDATE);

            ps.setString(1, item.getImageUrl());
            ps.setString(2, item.getCaption());
            ps.setInt(3, item.getDisplayOrder());
            ps.setString(4, item.getDescription());
            ps.setInt(5, item.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa ảnh khỏi gallery
    public boolean delete(int id) {
        try ( Connection con = DBUtils.getConnection();  PreparedStatement ps = con.prepareStatement(DELETE)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy mô tả chung mới nhất
    public String getLatestDescription() {

        try ( Connection con = DBUtils.getConnection();  PreparedStatement ps = con.prepareStatement(GET_LAST_DES);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getString("description");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public List<HomeGallery> getGallery() throws SQLException, ClassNotFoundException {
        List<HomeGallery> list = new ArrayList<>();
        ResultSet rs = null;

        try ( Connection con = DBUtils.getConnection();  PreparedStatement ps = con.prepareStatement(GET_GALLERY)) {
            rs = ps.executeQuery();
            while (rs.next()) {
                HomeGallery item = new HomeGallery();
                item.setId(rs.getInt("id"));
                item.setImageUrl(rs.getString("image_url"));
                item.setCaption(rs.getString("caption"));
                item.setDisplayOrder(rs.getInt("display_order"));
                item.setDescription(rs.getString("description"));
                item.setType(rs.getString("type"));
                list.add(item);
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
        }

        return list;
    }

    public void deleteBanner() throws SQLException, ClassNotFoundException {
        try ( Connection con = DBUtils.getConnection();  PreparedStatement ps = con.prepareStatement(DELETE_BANNER)) {
            ps.executeUpdate();
        }
    }

    // ❗ Insert banner với type = 'banner'
    public void insertBanner(HomeGallery banner) throws SQLException, ClassNotFoundException {

        try ( Connection con = DBUtils.getConnection();  PreparedStatement ps = con.prepareStatement(INSERT_BANNER)) {
            ps.setString(1, banner.getImageUrl());
            ps.setString(2, banner.getCaption() != null ? banner.getCaption() : "");
            ps.setInt(3, banner.getDisplayOrder());
            ps.setString(4, "banner");
            ps.executeUpdate();
        }
    }

    public List<HomeGallery> getBanner() throws SQLException, ClassNotFoundException {
        List<HomeGallery> list = new ArrayList<>();
        ResultSet rs = null;

        try ( Connection con = DBUtils.getConnection();  PreparedStatement ps = con.prepareStatement(GET_BANNER)) {
            rs = ps.executeQuery();
            while (rs.next()) {
                HomeGallery item = new HomeGallery();
                item.setId(rs.getInt("id"));
                item.setImageUrl(rs.getString("image_url"));
                item.setCaption(rs.getString("caption"));
                item.setDisplayOrder(rs.getInt("display_order"));
                item.setType(rs.getString("type"));
                list.add(item);
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
        }

        return list;
    }

    // ❗ Xoá theo type (gallery hoặc banner)
    public void deleteByType(String type) throws ClassNotFoundException, SQLException {
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(DELETE_BY_TYPE)) {
            ps.setString(1, type);
            ps.executeUpdate();
        }
    }

    public List<HomeGallery> findByType(String type) {
        List<HomeGallery> list = new ArrayList<>();
        String sql = "SELECT * FROM home_gallery WHERE type = ? ORDER BY display_order ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, type);
            rs = ps.executeQuery();

            while (rs.next()) {
                HomeGallery item = new HomeGallery();
                item.setId(rs.getInt("id"));
                item.setImageUrl(rs.getString("image_url"));
                item.setCaption(rs.getString("caption"));
                item.setDisplayOrder(rs.getInt("display_order"));
                item.setDescription(rs.getString("description"));
                item.setType(rs.getString("type"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return list;
    }

    public void initDefaultDataIfEmpty() throws SQLException, ClassNotFoundException {
        if (getGallery().isEmpty()) {
            for (HomeGallery img : getDefaultGalleryItems()) {
                insert(img);
            }
        }
        if (getBanner().isEmpty()) {
            for (HomeGallery img : getDefaultBannerItems()) {
                insert(img);
            }
        }
    }

    private List<HomeGallery> getDefaultBannerItems() {
        List<HomeGallery> defaults = new ArrayList<>();
// banner
        defaults.add(new HomeGallery("assets/image/BQT_STORE.png", "Default Banner 1", "Default Description", 1, "banner"));
        defaults.add(new HomeGallery("assets/image/banner_2.png", "Default Banner 2", "Default Description", 2, "banner"));
        defaults.add(new HomeGallery("assets/image/banner.png", "Default Banner 3", "Default Description", 3, "banner"));
        defaults.add(new HomeGallery("assets/image/banner_3.png", "Default Banner 4", "Default Description", 4, "banner"));
        return defaults;
    }

    private List<HomeGallery> getDefaultGalleryItems() {
        List<HomeGallery> defaults = new ArrayList<>();
// gallery
        defaults.add(new HomeGallery("assets/img/AAT001/1.jpg", "Default Gallery 1", "Car models are exquisite miniature copies of famous car lines in the world.\n"
                + "                    With popular scales such as 1:18, 1:24, 1:64,... the models are produced by prestigious brands such as AutoArt, Bburago, Kyosho, Welly,...\n"
                + "                    They are not only aesthetic but also show the passion of model car players.\n"
                + "                    Collecting model cars is more than just a hobby — it is a way to preserve automotive history and craftsmanship in a compact, tangible form.\n"
                + "                    Each piece is meticulously crafted with attention to detail, from engine components to interior design, allowing collectors to experience the elegance and engineering of real vehicles.\n"
                + "                    Whether you are a seasoned enthusiast or just starting out, model cars offer a unique blend of art, nostalgia, and technical fascination.", 1, "gallery"));
        defaults.add(new HomeGallery("assets/img/AAT001/2.jpg", "Default Gallery 2", "Car models are exquisite miniature copies of famous car lines in the world.\n"
                + "                    With popular scales such as 1:18, 1:24, 1:64,... the models are produced by prestigious brands such as AutoArt, Bburago, Kyosho, Welly,...\n"
                + "                    They are not only aesthetic but also show the passion of model car players.\n"
                + "                    Collecting model cars is more than just a hobby — it is a way to preserve automotive history and craftsmanship in a compact, tangible form.\n"
                + "                    Each piece is meticulously crafted with attention to detail, from engine components to interior design, allowing collectors to experience the elegance and engineering of real vehicles.\n"
                + "                    Whether you are a seasoned enthusiast or just starting out, model cars offer a unique blend of art, nostalgia, and technical fascination.", 2, "gallery"));
        defaults.add(new HomeGallery("assets/img/AAT001/3.jpg", "Default Gallery 3", "Car models are exquisite miniature copies of famous car lines in the world.\n"
                + "                    With popular scales such as 1:18, 1:24, 1:64,... the models are produced by prestigious brands such as AutoArt, Bburago, Kyosho, Welly,...\n"
                + "                    They are not only aesthetic but also show the passion of model car players.\n"
                + "                    Collecting model cars is more than just a hobby — it is a way to preserve automotive history and craftsmanship in a compact, tangible form.\n"
                + "                    Each piece is meticulously crafted with attention to detail, from engine components to interior design, allowing collectors to experience the elegance and engineering of real vehicles.\n"
                + "                    Whether you are a seasoned enthusiast or just starting out, model cars offer a unique blend of art, nostalgia, and technical fascination.", 3, "gallery"));
        defaults.add(new HomeGallery("assets/img/AAT001/4.jpg", "Default Gallery 4", "Car models are exquisite miniature copies of famous car lines in the world.\n"
                + "                    With popular scales such as 1:18, 1:24, 1:64,... the models are produced by prestigious brands such as AutoArt, Bburago, Kyosho, Welly,...\n"
                + "                    They are not only aesthetic but also show the passion of model car players.\n"
                + "                    Collecting model cars is more than just a hobby — it is a way to preserve automotive history and craftsmanship in a compact, tangible form.\n"
                + "                    Each piece is meticulously crafted with attention to detail, from engine components to interior design, allowing collectors to experience the elegance and engineering of real vehicles.\n"
                + "                    Whether you are a seasoned enthusiast or just starting out, model cars offer a unique blend of art, nostalgia, and technical fascination.", 4, "gallery"));
        return defaults;
    }
}
