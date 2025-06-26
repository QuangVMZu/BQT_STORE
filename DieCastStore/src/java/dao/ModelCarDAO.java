package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ImageModel;
import model.ModelCar;
import utils.DBUtils;

public class ModelCarDAO implements IDAO<ModelCar, String> {

    private static final String GET_ALL = "SELECT * FROM modelCar";
    private static final String GET_BY_ID = "SELECT * FROM modelCar WHERE modelId like ?";
    private static final String GET_IMAGES_BY_MODEL_ID = "SELECT imageId, imageUrl, caption FROM imageModel WHERE modelId like ?";
    private static final String SEARCH_BY_NAME = "SELECT * FROM modelCar WHERE modelName LIKE ?";

    @Override
    public ModelCar getById(String id) {
        ModelCar car = null;

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(GET_BY_ID)) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                car = new ModelCar();
                car.setModelId(rs.getString("modelId"));
                car.setModelName(rs.getString("modelName"));
                car.setScaleId(rs.getInt("scaleId"));
                car.setBrandId(rs.getInt("brandId"));
                car.setPrice(rs.getDouble("price"));
                car.setDescription(rs.getString("description"));
                car.setQuantity(rs.getInt("quantity"));

                // Load images
                List<ImageModel> images = new ArrayList<>();
                try ( PreparedStatement imgStmt = conn.prepareStatement(GET_IMAGES_BY_MODEL_ID)) {
                    imgStmt.setString(1, id);
                    ResultSet imgRs = imgStmt.executeQuery();
                    while (imgRs.next()) {
                        ImageModel img = new ImageModel();
                        img.setImageId(imgRs.getString("imageId"));
                        img.setImageUrl(imgRs.getString("imageUrl"));
                        img.setCaption(imgRs.getString("caption"));
                        images.add(img);
                    }
                }
                car.setImages(images);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return car;
    }

    @Override
    public List<ModelCar> getAll() {
        List<ModelCar> list = new ArrayList<>();

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(GET_ALL);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ModelCar car = new ModelCar();
                car.setModelId(rs.getString("modelId"));
                car.setModelName(rs.getString("modelName"));
                car.setScaleId(rs.getInt("scaleId"));
                car.setBrandId(rs.getInt("brandId"));
                car.setPrice(rs.getDouble("price"));
                car.setDescription(rs.getString("description"));
                car.setQuantity(rs.getInt("quantity"));

                // Load images for this car
                List<ImageModel> images = new ArrayList<>();
                try ( PreparedStatement psImg = conn.prepareStatement(GET_IMAGES_BY_MODEL_ID)) {
                    psImg.setString(1, car.getModelId());
                    ResultSet rsImg = psImg.executeQuery();
                    while (rsImg.next()) {
                        ImageModel img = new ImageModel();
                        img.setImageId(rsImg.getString("imageId"));
                        img.setImageUrl(rsImg.getString("imageUrl"));
                        img.setCaption(rsImg.getString("caption"));
                        images.add(img);
                    }
                }
                car.setImages(images);

                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public boolean create(ModelCar car) {
        String sql = "INSERT INTO modelCar (modelId, modelName, scaleId, brandId, price, description, quantity) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, car.getModelId());
            ps.setString(2, car.getModelName());
            ps.setInt(3, car.getScaleId());
            ps.setInt(4, car.getBrandId());
            ps.setDouble(5, car.getPrice());
            ps.setString(6, car.getDescription());
            ps.setInt(7, car.getQuantity());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(ModelCar car) {
        String sql = "UPDATE ModelCar SET modelName = ?, scaleId = ?, brandId = ?, price = ?, description = ?, quantity = ? WHERE modelId = ?";
        try (Connection conn = DBUtils.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, car.getModelName());
            stmt.setInt(2, car.getScaleId());
            stmt.setInt(3, car.getBrandId());
            stmt.setDouble(4, car.getPrice());
            stmt.setString(5, car.getDescription());
            stmt.setInt(6, car.getQuantity());
            stmt.setString(7, car.getModelId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void updateImages(List<ImageModel> images, String modelId) {
        try ( Connection conn = DBUtils.getConnection()) {
            // Xóa toàn bộ ảnh cũ
            String deleteSql = "DELETE FROM Image WHERE modelId = ?";
            try ( PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setString(1, modelId);
                ps.executeUpdate();
            }

            // Thêm ảnh mới
            String insertSql = "INSERT INTO Image (imageId, modelId, imageUrl, caption) VALUES (?, ?, ?, ?)";
            try ( PreparedStatement ps = conn.prepareStatement(insertSql)) {
                for (ImageModel img : images) {
                    ps.setString(1, img.getImageId());
                    ps.setString(2, modelId);
                    ps.setString(3, img.getImageUrl());
                    ps.setString(4, img.getCaption());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean delete(String id) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public List<ModelCar> getLatestProducts(int limit) throws SQLException {
        List<ModelCar> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM modelCar ORDER BY modelId DESC";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ModelCar car = new ModelCar();
                car.setModelId(rs.getString("modelId"));
                car.setModelName(rs.getString("modelName"));
                car.setScaleId(rs.getInt("scaleId"));
                car.setBrandId(rs.getInt("brandId"));
                car.setPrice(rs.getDouble("price"));
                car.setDescription(rs.getString("description"));
                car.setQuantity(rs.getInt("quantity"));

                // Load images for this car
                List<ImageModel> images = new ArrayList<>();
                try ( PreparedStatement psImg = conn.prepareStatement(GET_IMAGES_BY_MODEL_ID)) {
                    psImg.setString(1, car.getModelId());
                    ResultSet rsImg = psImg.executeQuery();
                    while (rsImg.next()) {
                        ImageModel img = new ImageModel();
                        img.setImageId(rsImg.getString("imageId"));
                        img.setImageUrl(rsImg.getString("imageUrl"));
                        img.setCaption(rsImg.getString("caption"));
                        images.add(img);
                    }
                }
                car.setImages(images);

                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ModelCar> searchByName(String keyword) {
        List<ModelCar> list = new ArrayList<>();

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(SEARCH_BY_NAME)) {

            ps.setString(1, "%" + keyword + "%"); // tìm kiếm gần đúng
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ModelCar car = new ModelCar();
                car.setModelId(rs.getString("modelId"));
                car.setModelName(rs.getString("modelName"));
                car.setScaleId(rs.getInt("scaleId"));
                car.setBrandId(rs.getInt("brandId"));
                car.setPrice(rs.getDouble("price"));
                car.setDescription(rs.getString("description"));
                car.setQuantity(rs.getInt("quantity"));

                // Load images for this car
                List<ImageModel> images = new ArrayList<>();
                try ( PreparedStatement psImg = conn.prepareStatement(GET_IMAGES_BY_MODEL_ID)) {
                    psImg.setString(1, car.getModelId());
                    ResultSet rsImg = psImg.executeQuery();
                    while (rsImg.next()) {
                        ImageModel img = new ImageModel();
                        img.setImageId(rsImg.getString("imageId"));
                        img.setImageUrl(rsImg.getString("imageUrl"));
                        img.setCaption(rsImg.getString("caption"));
                        images.add(img);
                    }
                }
                car.setImages(images);

                list.add(car);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<ModelCar> searchByModelId(String keyword) throws SQLException, ClassNotFoundException {
        List<ModelCar> list = new ArrayList<>();
        String sql = "SELECT * FROM ModelCar WHERE modelId LIKE ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(SEARCH_BY_NAME)) {
            ps.setString(1, "%" + keyword + "%"); // tìm kiếm gần đúng
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ModelCar model = new ModelCar();
                model.setModelId(rs.getString("modelId"));
                model.setModelName(rs.getString("modelName"));
                model.setScaleId(rs.getInt("scaleId"));
                model.setBrandId(rs.getInt("brandId"));
                model.setPrice(rs.getDouble("price"));
                model.setDescription(rs.getString("description"));
                model.setQuantity(rs.getInt("quantity"));
                list.add(model);
            }
        }
        return list;
    }

    public boolean updateQuantity(String modelId) {
        String sql = "UPDATE modelCar SET quantity = -1 WHERE modelId = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, modelId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
