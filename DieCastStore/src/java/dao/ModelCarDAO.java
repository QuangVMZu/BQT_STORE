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
    private static final String GET_BY_ID = "SELECT * FROM modelCar WHERE modelId LIKE ?";
    private static final String GET_IMAGES_BY_MODEL_ID = "SELECT imageId, imageUrl, caption FROM imageModel WHERE modelId like ?";
    private static final String SEARCH_BY_NAME = "SELECT * FROM modelCar WHERE modelName LIKE ?";
    private static final String CREATE = "INSERT INTO modelCar (modelId, modelName, scaleId, brandId, price, description, quantity) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE ModelCar SET modelName = ?, scaleId = ?, brandId = ?, price = ?, description = ?, quantity = ?  WHERE modelId LIKE ?";
    private static final String UPDATE_QUANTITY = "UPDATE modelCar SET quantity = -1 WHERE modelId = ?";

    @Override
    public ModelCar getById(String id) {
        ModelCar car = null;

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_ID);
            st.setString(1, id);
            rs = st.executeQuery();

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
                try ( PreparedStatement imgStmt = c.prepareStatement(GET_IMAGES_BY_MODEL_ID)) {
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
        } finally {
            closeResources(c, st, rs);
        }

        return car;
    }

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

    @Override
    public List<ModelCar> getAll() {
        List<ModelCar> list = new ArrayList<>();

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL);
            rs = st.executeQuery();

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
                try ( PreparedStatement psImg = c.prepareStatement(GET_IMAGES_BY_MODEL_ID)) {
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
        } finally {
            closeResources(c, st, rs);
        }

        return list;
    }

    @Override
    public boolean create(ModelCar car) {

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, car.getModelId());
            st.setString(2, car.getModelName());
            st.setInt(3, car.getScaleId());
            st.setInt(4, car.getBrandId());
            st.setDouble(5, car.getPrice());
            st.setString(6, car.getDescription());
            st.setInt(7, car.getQuantity());

            return st.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return false;
    }

    @Override
    public boolean update(ModelCar car) {

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE);

            st.setString(1, car.getModelName());
            st.setInt(2, car.getScaleId());
            st.setInt(3, car.getBrandId());
            st.setDouble(4, car.getPrice());
            st.setString(5, car.getDescription());
            st.setInt(6, car.getQuantity());
            st.setString(7, car.getModelId());

            return st.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return false;
    }

    public void updateImages(List<ImageModel> images, String modelId) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        String deleteSql = "DELETE FROM Image WHERE modelId = ?";
        String insertSql = "INSERT INTO Image (imageId, modelId, imageUrl, caption) VALUES (?, ?, ?, ?)";

        try {
            c = DBUtils.getConnection();

            // Xóa toàn bộ ảnh cũ
            st = c.prepareStatement(deleteSql);
            st.setString(1, modelId);
            st.executeUpdate();
            st.close(); // Đóng trước khi tái sử dụng

            // Thêm ảnh mới
            st = c.prepareStatement(insertSql);
            for (ImageModel img : images) {
                st.setString(1, img.getImageId());
                st.setString(2, modelId);
                st.setString(3, img.getImageUrl());
                st.setString(4, img.getCaption());
                st.addBatch();
            }
            st.executeBatch();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
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

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(SEARCH_BY_NAME);
            st.setString(1, "%" + keyword + "%");
            rs = st.executeQuery();

            while (rs.next()) {
                ModelCar car = new ModelCar();
                car.setModelId(rs.getString("modelId"));
                car.setModelName(rs.getString("modelName"));
                car.setScaleId(rs.getInt("scaleId"));
                car.setBrandId(rs.getInt("brandId"));
                car.setPrice(rs.getDouble("price"));
                car.setDescription(rs.getString("description"));
                car.setQuantity(rs.getInt("quantity"));

                // Load images
                List<ImageModel> images = new ArrayList<>();
                PreparedStatement imgSt = null;
                ResultSet imgRs = null;
                try {
                    imgSt = c.prepareStatement(GET_IMAGES_BY_MODEL_ID);
                    imgSt.setString(1, car.getModelId());
                    imgRs = imgSt.executeQuery();
                    while (imgRs.next()) {
                        ImageModel img = new ImageModel();
                        img.setImageId(imgRs.getString("imageId"));
                        img.setImageUrl(imgRs.getString("imageUrl"));
                        img.setCaption(imgRs.getString("caption"));
                        images.add(img);
                    }
                } finally {
                    closeResources(null, imgSt, imgRs);
                }

                car.setImages(images);
                list.add(car);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return list;
    }

    public List<ModelCar> searchByModelId(String keyword) {
        List<ModelCar> list = new ArrayList<>();
        String sql = "SELECT * FROM ModelCar WHERE modelId LIKE ?";

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            rs = st.executeQuery();

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

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return list;
    }

    public boolean updateQuantity(String modelId) {

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE_QUANTITY);
            st.setString(1, modelId);

            return st.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return false;
    }

    public List<ModelCar> getNewest16Products() {
        List<ModelCar> list = new ArrayList<>();
        String sql = "SELECT TOP 20 * FROM modelCar ORDER BY modelId DESC";

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(sql);
            rs = st.executeQuery();

            while (rs.next()) {
                ModelCar car = new ModelCar();
                car.setModelId(rs.getString("modelId"));
                car.setModelName(rs.getString("modelName"));
                car.setScaleId(rs.getInt("scaleId"));
                car.setBrandId(rs.getInt("brandId"));
                car.setPrice(rs.getDouble("price"));
                car.setDescription(rs.getString("description"));
                car.setQuantity(rs.getInt("quantity"));

                // Load images
                List<ImageModel> images = new ArrayList<>();
                PreparedStatement imgSt = null;
                ResultSet imgRs = null;
                try {
                    imgSt = c.prepareStatement(GET_IMAGES_BY_MODEL_ID);
                    imgSt.setString(1, car.getModelId());
                    imgRs = imgSt.executeQuery();
                    while (imgRs.next()) {
                        ImageModel img = new ImageModel();
                        img.setImageId(imgRs.getString("imageId"));
                        img.setImageUrl(imgRs.getString("imageUrl"));
                        img.setCaption(imgRs.getString("caption"));
                        images.add(img);
                    }
                } finally {
                    closeResources(null, imgSt, imgRs); // chỉ đóng tài nguyên phụ
                }

                car.setImages(images);
                list.add(car);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return list;
    }

    public List<ModelCar> getNewest8Products() {
        List<ModelCar> list = new ArrayList<>();
        String sql = "SELECT TOP 8 * FROM modelCar ORDER BY modelId DESC"; // Sử dụng SQL Server

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(sql);
            rs = st.executeQuery();

            while (rs.next()) {
                ModelCar car = new ModelCar();
                car.setModelId(rs.getString("modelId"));
                car.setModelName(rs.getString("modelName"));
                car.setScaleId(rs.getInt("scaleId"));
                car.setBrandId(rs.getInt("brandId"));
                car.setPrice(rs.getDouble("price"));
                car.setDescription(rs.getString("description"));
                car.setQuantity(rs.getInt("quantity"));

                // Load images
                List<ImageModel> images = new ArrayList<>();
                PreparedStatement imgSt = null;
                ResultSet imgRs = null;
                try {
                    imgSt = c.prepareStatement(GET_IMAGES_BY_MODEL_ID);
                    imgSt.setString(1, car.getModelId());
                    imgRs = imgSt.executeQuery();
                    while (imgRs.next()) {
                        ImageModel img = new ImageModel();
                        img.setImageId(imgRs.getString("imageId"));
                        img.setImageUrl(imgRs.getString("imageUrl"));
                        img.setCaption(imgRs.getString("caption"));
                        images.add(img);
                    }
                } finally {
                    closeResources(null, imgSt, imgRs); // đóng tài nguyên phụ
                }

                car.setImages(images);
                list.add(car);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs); // đóng tài nguyên chính
        }

        return list;
    }

    public List<ModelCar> getProductsByScaleId(int scaleId) {
        List<ModelCar> list = new ArrayList<>();
        String sql = "SELECT * FROM modelCar WHERE scaleId = ? ORDER BY modelId DESC";

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(sql);
            st.setInt(1, scaleId);
            rs = st.executeQuery();

            while (rs.next()) {
                ModelCar car = new ModelCar();
                car.setModelId(rs.getString("modelId"));
                car.setModelName(rs.getString("modelName"));
                car.setScaleId(rs.getInt("scaleId"));
                car.setBrandId(rs.getInt("brandId"));
                car.setPrice(rs.getDouble("price"));
                car.setDescription(rs.getString("description"));
                car.setQuantity(rs.getInt("quantity"));

                // Load images
                List<ImageModel> images = new ArrayList<>();
                PreparedStatement imgSt = null;
                ResultSet imgRs = null;
                try {
                    imgSt = c.prepareStatement(GET_IMAGES_BY_MODEL_ID);
                    imgSt.setString(1, car.getModelId());
                    imgRs = imgSt.executeQuery();
                    while (imgRs.next()) {
                        ImageModel img = new ImageModel();
                        img.setImageId(imgRs.getString("imageId"));
                        img.setImageUrl(imgRs.getString("imageUrl"));
                        img.setCaption(imgRs.getString("caption"));
                        images.add(img);
                    }
                } finally {
                    closeResources(null, imgSt, imgRs); // đóng tài nguyên phụ
                }

                car.setImages(images);
                list.add(car);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs); // đóng tài nguyên chính
        }

        return list;
    }

}
