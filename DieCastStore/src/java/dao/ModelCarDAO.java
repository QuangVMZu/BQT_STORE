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
    private static final String GET_IMAGES_BY_MODEL_ID = "SELECT imageUrl FROM imageModel WHERE modelId like ?";
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
                        img.setImageUrl(imgRs.getString("imageUrl"));
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
                        img.setImageUrl(rsImg.getString("imageUrl"));
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

//    @Override
//    public List<ModelCar> getAll() {
//        List<ModelCar> list = new ArrayList<>();
//
//        ModelCar testCar = new ModelCar();
//        testCar.setModelId("T001");
//        testCar.setModelName("Test Car");
//        testCar.setPrice(10.5);
//        testCar.setDescription("This is a test.");
//        testCar.setQuantity(1);
//        testCar.setScaleId(1);
//        testCar.setBrandId(1);
//        list.add(testCar);
//
//        return list;
//    }
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
    public boolean update(ModelCar entity) {
        throw new UnsupportedOperationException("Not supported yet.");
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
                        img.setImageUrl(rsImg.getString("imageUrl"));
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
                        img.setImageUrl(rsImg.getString("imageUrl"));
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
}
