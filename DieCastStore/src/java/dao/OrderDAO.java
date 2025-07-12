package dao;

import java.sql.*;
import model.Cart;
import model.CartItem;
import utils.DBUtils;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;

public class OrderDAO {

    private static final String GET_ALL
            = "SELECT o.*, c.address AS shippingAddress "
            + "FROM orders o "
            + "JOIN customer c ON o.customerId = c.customerId";

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

    public List<Order> getAll() {
        List<Order> list = new ArrayList<>();

        Connection c = null;
        PreparedStatement st = null;
        ResultSet rs = null;

        try {
            c = DBUtils.getConnection();
            st = c.prepareStatement(GET_ALL);
            rs = st.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getString("orderId"));
                order.setCustomerId(rs.getString("customerId"));
                order.setOrderDate(rs.getDate("orderDate"));
                order.setStatus(rs.getString("status"));
                order.setTotalAmount(rs.getDouble("total_amount"));

                // ✅ Lấy địa chỉ từ customer (join)
                order.setShippingAddress(rs.getString("shippingAddress"));

                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(c, st, rs);
        }

        return list;
    }

    public String createOrder(String customerId, double totalAmount, Cart cart) throws SQLException, ClassNotFoundException {
        String orderId = "ORD" + System.currentTimeMillis(); // Tạo orderId unique
        Connection conn = null;

        try {
            conn = DBUtils.getConnection();
            conn.setAutoCommit(false);

            // Tách thành 2 bước
            insertOrder(conn, orderId, customerId, totalAmount);
            insertOrderDetail(conn, orderId, cart);

            conn.commit();
            return orderId;

        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    private void insertOrder(Connection conn, String orderId, String customerId, double totalAmount) throws SQLException {
        String orderSql = "INSERT INTO orders (orderId, customerId, status, total_amount) VALUES (?, ?, ?, ?)";
        try {
            conn.setAutoCommit(false);
            PreparedStatement psOrder = conn.prepareStatement(orderSql);
            psOrder.setString(1, orderId);
            psOrder.setString(2, customerId);
            psOrder.setString(3, "PENDING");
            psOrder.setDouble(4, totalAmount);
            psOrder.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void insertOrderDetail(Connection conn, String orderId, Cart cart) throws SQLException {
        String detailSql = "INSERT INTO orderDetail (orderId, itemType, itemId, unitPrice, unitQuantity) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(detailSql);
            for (CartItem item : cart.getItems()) {
                ps.setString(1, orderId);
                ps.setString(2, item.getItemType());
                ps.setString(3, item.getItemId());
                ps.setDouble(4, item.getUnitPrice());
                ps.setInt(5, item.getQuantity());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updateCustomerInfo(String customerId, String customerName, String phone, String address) {
        String sql = "UPDATE customer SET customerName = ?, phone = ?, address = ? WHERE customerId = ?";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, customerName);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, customerId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // lấy tất cả đơn
    public List<Order> getOrdersByCustomer(String customerId) {
        List<Order> orderList = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE customerId = ? ORDER BY orderDate DESC";

        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order ord = new Order();
                ord.setOrderId(rs.getString("orderId"));
                ord.setCustomerId(rs.getString("customerId"));
                ord.setOrderDate(rs.getTimestamp("orderDate"));
                ord.setStatus(rs.getString("status"));
                ord.setTotalAmount(rs.getDouble("total_amount"));
                orderList.add(ord);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderList;
    }

    // lấy chi tiết 1 đơn
    public Order getOrderById(String orderId) {
        String sql = "SELECT * FROM orders WHERE orderId = ?";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getString("orderId"));
                o.setCustomerId(rs.getString("customerId"));
                o.setOrderDate(rs.getTimestamp("orderDate"));
                o.setStatus(rs.getString("status"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                return o;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderDetail> getOrderDetails(String orderId) {
        List<OrderDetail> detailList = new ArrayList<>();
        String sql = "SELECT * FROM orderDetail WHERE orderId = ?";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail ord = new OrderDetail();
                ord.setOrderId(rs.getString("orderId"));
                ord.setItemType(rs.getString("itemType"));
                ord.setItemId(rs.getString("itemId"));
                ord.setUnitPrice(rs.getDouble("unitPrice"));
                ord.setUnitQuantity(rs.getInt("unitQuantity"));
                detailList.add(ord);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detailList;
    }

    public boolean updateOrderStatus(String orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE orderId = ?";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, orderId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Order> getOrdersByCustomerId(String customerId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE customerId = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getString("orderId"));
                order.setCustomerId(rs.getString("customerId"));
                order.setOrderDate(rs.getDate("orderDate"));
                order.setStatus(rs.getString("status"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getActiveOrdersByCustomerId(String customerId) throws SQLException, ClassNotFoundException {
        List<Order> list = new ArrayList<>();

        String sql = "SELECT * FROM orders WHERE customerId = ? AND status != 'CANCELLED'";
        try ( Connection c = DBUtils.getConnection();  PreparedStatement st = c.prepareStatement(sql)) {
            st.setString(1, customerId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getString("orderId"));
                order.setCustomerId(rs.getString("customerId"));
                order.setOrderDate(rs.getDate("orderDate"));
                order.setStatus(rs.getString("status"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                list.add(order);
            }
        }
        return list;
    }

    public String getCustomerAddressByOrderId(String orderId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT c.address FROM [orders] o JOIN Customer c ON o.customerId = c.customerId WHERE o.orderId = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("address");
                }
            }
        }
        return null;
    }

    public String getCustomerPhoneByOrderId(String orderId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT c.phone FROM [orders] o JOIN Customer c ON o.customerId = c.customerId WHERE o.orderId = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("phone");
                }
            }
        }
        return null;
    }

    public String getCustomerNameByOrderId(String orderId) throws ClassNotFoundException, SQLException {
        String sql = "SELECT c.customerName FROM [orders] o JOIN Customer c ON o.customerId = c.customerId WHERE o.orderId = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("customerName");
                }
            }
        }
        return null;
    }
}
