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
import model.Customer;
import utils.DBUtils;

/**
 *
 * @author hqthi
 */
public class CustomerDAO implements IDAO<Customer, String> {

    private static final String GET_ALL = "SELECT * FROM customer";
    private static final String GET_BY_ID = "SELECT * FROM customer WHERE customerId = ?";
    private static final String CREATE = "INSERT INTO customer(customerId, customerName, email, phone, address) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE customer SET customerName = ?, email = ?, phone = ?, address = ? WHERE customerId = ?";
    private static final String DELETE = "DELETE FROM customer WHERE customerId = ?";
    private static final String MAX = "SELECT MAX(customerId) FROM customer WHERE customerId LIKE 'C%'";
    private static final String COUNT = "SELECT COUNT(*) FROM customer";

    @Override
    public boolean create(Customer entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            entity.setCustomerId(generateCustomerID());
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, entity.getCustomerId());
            st.setString(2, entity.getCustomerName());
            st.setString(3, entity.getEmail());
            st.setString(4, entity.getPhone());
            st.setString(5, entity.getAddress());

            return st.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException e) {
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public boolean update(Customer entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE);
            st.setString(1, entity.getCustomerName());
            st.setString(2, entity.getEmail());
            st.setString(3, entity.getPhone());
            st.setString(4, entity.getAddress());
            st.setString(5, entity.getCustomerId());

            return st.executeUpdate() > 0;
        } catch (Exception e) {
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
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public List<Customer> getAll() {
        List<Customer> customer = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL);
            rs = st.executeQuery();
            while (rs.next()) {
                customer.add(mapResultSet(rs));
            }
        } catch (ClassNotFoundException | SQLException e) {
        } finally {
            closeResources(c, st, rs);
        }
        return customer;
    }

    @Override
    public Customer getById(String id) {
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
        } finally {
            closeResources(c, st, rs);
        }
        return null;
    }

    private Customer mapResultSet(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getString("customerId"));
        customer.setCustomerName(rs.getString("customerName"));
        customer.setEmail(rs.getString("email"));
        customer.setPhone(rs.getString("phone"));
        customer.setAddress(rs.getString("address"));
        return customer;
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

    public String generateCustomerID() {
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
            if(maxId != null && !maxId.isEmpty()) {
                int currentNum = Integer.parseInt(maxId.substring(1));
                nextNum = currentNum + 1;
            }
            return String.format("C%03d", nextNum);
        } catch (ClassNotFoundException | SQLException e) {
            return "C001";
        } finally {
            closeResources(c, st, rs);
        }
    }

    public Boolean isEmailExists(String email) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(COUNT + " WHERE email = ?");
            st.setString(1, email);
            rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (ClassNotFoundException | SQLException e) {
        } finally {
            closeResources(c, st, rs);
        }
        return false;
    }
}
