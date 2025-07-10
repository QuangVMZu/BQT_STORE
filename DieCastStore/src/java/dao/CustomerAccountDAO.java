package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.CustomerAccount;
import utils.DBUtils;
import utils.PasswordUtils;

/**
 *
 * @author hqthi
 */
public class CustomerAccountDAO implements IDAO<CustomerAccount, String> {

    private static final String GET_ALL = "SELECT * FROM customerAccount";
    private static final String GET_BY_ID = "SELECT * FROM customerAccount WHERE customerId LIKE ?";
    private static final String GET_BY_USER_NAME = "SELECT * FROM customerAccount WHERE userName LIKE ?";
    private static final String CREATE = "INSERT INTO customerAccount(userName, customerId, password, role) VALUES (?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE customerAccount SET userName = ?, password = ?, role = ? WHERE customerId LIKE ?";
    private static final String CHANGE_PASSWORD = "UPDATE customerAccount SET password = ? WHERE customerId LIKE ?";
    private static final String DELETE = "DELETE FROM customerAccount WHERE customerId LIKE ?";
    private static final String COUNT = "SELECT COUNT(*) FROM customerAccount";

    @Override
    public boolean create(CustomerAccount entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CREATE);
            st.setString(1, entity.getUserName());
            st.setString(2, entity.getCustomerId());
            st.setString(3, PasswordUtils.encryptSHA256(entity.getPassword()));
            st.setInt(4, entity.getRole() != 0 ? entity.getRole() : 2);

            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    @Override
    public boolean update(CustomerAccount entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(UPDATE);
            st.setString(1, entity.getUserName());
            st.setString(2, entity.getPassword());
            st.setInt(3, entity.getRole());
            st.setString(4, entity.getCustomerId());

            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

    public boolean changePassword(CustomerAccount entity) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(CHANGE_PASSWORD);
            st.setString(1, PasswordUtils.encryptSHA256(entity.getPassword()));
            st.setString(2, entity.getCustomerId());

            return st.executeUpdate() > 0;
        } catch (Exception e) {
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
    public List<CustomerAccount> getAll() {
        List<CustomerAccount> account = new ArrayList<>();
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL);
            rs = st.executeQuery();

            while (rs.next()) {
                account.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }
        return account;
    }

    @Override
    public CustomerAccount getById(String id) {
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

    private CustomerAccount mapResultSet(ResultSet rs) throws SQLException {
        CustomerAccount account = new CustomerAccount();
        account.setUserName(rs.getString("userName"));
        account.setCustomerId(rs.getString("customerId"));
        account.setPassword(rs.getString("password"));
        account.setRole(rs.getInt("role"));
        return account;
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

    public CustomerAccount getByUserName(String userName) {
        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_BY_USER_NAME);
            st.setString(1, userName);
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

    public boolean isUserNameExists(String userName) {
        return getByUserName(userName) != null;
    }

    public boolean login(String userName, String password) {
        CustomerAccount account = getByUserName(userName);
        if (account != null) {
            if (account.getRole() == 0) {
                return false;
            }
            return PasswordUtils.verifyPassword(password, account.getPassword());
        }
        return false;
    }

    public boolean isActiveUser(String customerId) {
        CustomerAccount account = getById(customerId);
        if (account != null) {
            return account.getRole() != 0;
        }
        return false;
    }

    public boolean isActiveUserByUserName(String userName) {
        CustomerAccount account = getByUserName(userName);
        if (account != null) {
            return account.getRole() != 0;
        }
        return false;
    }

    public boolean setUserRole(String customerId, int role) {
        Connection c = null;
        PreparedStatement st = null;
        try {
            c = DBUtils.getConnection();
            String sql = "UPDATE customerAccount SET role = ? WHERE customerId = ?";
            st = c.prepareStatement(sql);
            st.setInt(1, role);
            st.setString(2, customerId);

            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(c, st, null);
        }
    }

}
