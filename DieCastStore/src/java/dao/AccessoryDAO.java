/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Accessory;
import utils.DBUtils;

/**
 *
 * @author hqthi
 */
public class AccessoryDAO implements IDAO<Accessory, String> {

    private static final String GET_ALL = "SELECT * FROM accessory";
    private static final String GET_BY_ID = "SELECT * FROM accessory WHERE accessoryId = ?";
    private static final String GET_BY_NAME = "SELECT * FROM accessory WHERE accessoryName LIKE ?";
    private static final String CREATE = "INSERT INTO accessory(accessoryId, accessoryName, detail, price, quantity, imageUrl) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE accessory SET accessoryName = ?, detail = ?, price = ?, quantity = ?, imageUrl = ? WHERE accessoryId = ?";
    private static final String DELETE = "DELETE FROM accessory WHERE accessoryId = ?";
    private static final String MAX = "SELECT MAX(accessoryId) FROM accessory WHERE accessoryId LIKE 'ACS%'";
    private static final String UPDATE_QUANTITY = "UPDATE accessory SET quantity = - 1 WHERE accessoryId = ?";

    @Override
    public boolean create(Accessory entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();

            entity.setAccessoryId(generateAccessoryId());

            st = c.prepareStatement(CREATE);
            st.setString(1, entity.getAccessoryId());
            st.setString(2, entity.getAccessoryName());
            st.setString(3, entity.getDetail());
            st.setDouble(4, entity.getPrice());
            st.setInt(5, entity.getQuantity());
            st.setString(6, entity.getImageUrl());

            return st.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public boolean update(Accessory entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE);
            st.setString(1, entity.getAccessoryName());
            st.setString(2, entity.getDetail());
            st.setDouble(3, entity.getPrice());
            st.setInt(4, entity.getQuantity());
            st.setString(5, entity.getImageUrl());
            st.setString(6, entity.getAccessoryId());

            return st.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public boolean delete(String id) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(DELETE);
            st.setString(1, id);

            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public Accessory getById(String id) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_ID);
            st.setString(1, id);
            rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }
        return null;
    }

    public List<Accessory> getByName(String name) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_NAME);
            st.setString(1, name);
            rs = st.executeQuery();

            return (List<Accessory>) mapResultSet(rs); // Để mapResultSet xử lý toàn bộ ResultSet

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }
        return new ArrayList<>(); // Tránh trả về null
    }

    @Override
    public List<Accessory> getAll() {
        List<Accessory> list = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL);
            rs = st.executeQuery();

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }
        return list;
    }

    private Accessory mapResultSet(ResultSet rs) throws SQLException {
        Accessory acs = new Accessory();
        acs.setAccessoryId(rs.getString("accessoryId"));
        acs.setAccessoryName(rs.getString("accessoryName"));
        acs.setDetail(rs.getString("detail"));
        acs.setPrice(rs.getDouble("price"));
        acs.setQuantity(rs.getInt("quantity"));
        acs.setImageUrl(rs.getString("imageUrl"));
        return acs;
    }

    private String generateAccessoryId() {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(MAX);
            rs = st.executeQuery();
            String maxId = null;
            if (rs.next()) {
                maxId = rs.getString(1);
            }
            int nextNum = 1;
            if (maxId != null && !maxId.isEmpty()) {
                int currentNum = Integer.parseInt(maxId.substring(3));
                nextNum = currentNum + 1;
            }
            return String.format("ACS%03d", nextNum);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return "ACS001";
        } finally {
            closeResources(c, st, rs);
        }
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

    public void increaseQuantity(String accessoryId, int quantity) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE accessory SET quantity = quantity + ? WHERE accessoryId = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setString(2, accessoryId);
            ps.executeUpdate();
        }
    }

    public int countAccessories() throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM accessory";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public boolean updateQuantity(String accessoryId) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE_QUANTITY);
            st.setString(1, accessoryId);

            return st.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return false;
    }

    public List<Accessory> searchByName(String keyword) {
        List<Accessory> list = new ArrayList<>();

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_NAME);
            st.setString(1, "%" + keyword + "%");
            rs = st.executeQuery();

            while (rs.next()) {
                Accessory accessory = new Accessory();
                accessory.setAccessoryId(rs.getString("accessoryId"));
                accessory.setAccessoryName(rs.getString("accessoryName"));
                accessory.setDetail(rs.getString("detail"));
                accessory.setPrice(rs.getDouble("price"));
                accessory.setQuantity(rs.getInt("quantity"));
                accessory.setImageUrl(rs.getString("imageUrl"));

                list.add(accessory);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return list;
    }

}
