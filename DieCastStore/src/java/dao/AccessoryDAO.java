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
    private static final String GET_BY_NAME = "SELECT * FROM accessory WHERE accessoryName = ?";
    private static final String CREATE = "INSERT INTO accessory(accessoryId, accessoryName, detail, price, quantity) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE accessory SET accessoryName = ?, detail = ?, price = ?, quantity = ? WHERE accessoryId = ?";
    private static final String DELETE = "DELETE FROM accessory WHERE accessoryId = ?";
    private static final String MAX = "SELECT MAX(accessoryId) FROM accessory WHERE accessoryId LIKE 'ACS%'";
    private static final String COUNT = "SELECT COUNT(*) FROM accessory";

    @Override
    public boolean create(Accessory entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            entity.setAccessoryId(generateAccessoryId());

            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, entity.getAccessoryId());
            st.setString(2, entity.getAccessoryName());
            st.setString(3, entity.getDetail());
            st.setDouble(4, entity.getPrice());
            st.setInt(5, entity.getQuantity());

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
            st.setString(5, entity.getAccessoryId());

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

    public Accessory getByName(String name) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_NAME);
            st.setString(1, name);
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

}
