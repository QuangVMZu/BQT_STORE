/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ImageModel;
import utils.DBUtils;

/**
 *
 * @author ADMIN
 */
public class ImageModelDAO implements IDAO<ImageModel, String> {

    private static final String UPDATE = "UPDATE ImageModel SET imageId = ?, imageUrl = ?, caption = ?  WHERE modelId LIKE ?";

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

    public void deleteImagesByModelId(String modelId) throws SQLException, ClassNotFoundException {
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement("DELETE FROM ImageModel WHERE modelId = ?")) {
            ps.setString(1, modelId);
            ps.executeUpdate();
        }
    }

    @Override
    public boolean create(ImageModel image) {
        String modelId = image.getModelId();
        String sqlInsert = "INSERT INTO ImageModel (imageId, modelId, imageUrl, caption) VALUES (?, ?, ?, ?)";
        String sqlCount = "SELECT COUNT(*) FROM ImageModel WHERE modelId = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement psCount = conn.prepareStatement(sqlCount);  PreparedStatement psInsert = conn.prepareStatement(sqlInsert)) {

            // Đếm số ảnh hiện tại của modelId
            psCount.setString(1, modelId);
            ResultSet rs = psCount.executeQuery();

            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }

            // Tạo imageId mới
            String newImageId = modelId + "_0" + (count + 1);
            image.setImageId(newImageId); // optional: nếu bạn cần lưu lại imageId cho đối tượng hiện tại

            // Insert
            psInsert.setString(1, newImageId);
            psInsert.setString(2, modelId);
            psInsert.setString(3, image.getImageUrl());
            psInsert.setString(4, image.getCaption());

            return psInsert.executeUpdate() > 0;

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(ImageModelDAO.class.getName()).log(Level.SEVERE, "Error inserting image", ex);
        }

        return false;
    }

    @Override
    public boolean update(ImageModel image) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE);

            st.setString(1, image.getImageId());
            st.setString(2, image.getImageUrl());
            st.setString(3, image.getCaption());
            st.setString(4, image.getModelId());

            return st.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return false;
    }

    @Override
    public boolean delete(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ImageModel getById(String id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<ImageModel> getAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
