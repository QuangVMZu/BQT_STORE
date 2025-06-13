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
import model.BrandModel;
import utils.DBUtils;

/**
 *
 * @author hqthi
 */
public class BrandDAO implements IDAO<BrandModel, Integer> {

    private static final String GET_ALL = "SELECT * FROM brandModel";
    private static final String GET_BY_ID = "SELECT * FROM brandModel WHERE brandId = ?";
    private static final String GET_BY_BRAND_NAME = "SELECT * FROM brandModel WHERE brandName = ?";
    private static final String CREATE = "INSERT INTO brandModel(brandName) VALUES (?)";
    private static final String UPDATE = "UPDATE brandModel SET brandName = ? WHERE brandId = ?";
    private static final String DELETE = "DELETE FROM brandModel WHERE brandId = ?";
    private static final String COUNT = "SELECT COUNT(*) FROM brandModel";

    @Override
    public boolean create(BrandModel entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, entity.getBrandName());

            return st.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public boolean update(BrandModel entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE);
            st.setString(1, entity.getBrandName());
            st.setInt(2, entity.getBrandId());

            return st.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public boolean delete(Integer id) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(DELETE);
            st.setInt(1, id);

            return st.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public BrandModel getById(Integer id) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_ID);
            st.setInt(1, id);
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

    public BrandModel getByBrandName(String name) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_BRAND_NAME);
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
    public List<BrandModel> getAll() {
        List<BrandModel> brand = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL);
            rs = st.executeQuery();

            while (rs.next()) {
                brand.add(mapResultSet(rs));
            }
        } catch (ClassNotFoundException | SQLException e) {
        } finally {
            closeResources(c, st, rs);
        }
        return brand;
    }

    private BrandModel mapResultSet(ResultSet rs) throws SQLException {
        BrandModel brand = new BrandModel();
        brand.setBrandId(rs.getInt("brandId"));
        brand.setBrandName(rs.getString("brandName"));
        return brand;
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
