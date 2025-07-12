package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Accessory;
import model.Cart;
import model.CartItem;
import model.ModelCar;
import utils.DBUtils;

public class CartDAO {

    // Lấy cart từ database theo customerId
    public Cart getCartByCustomerId(String customerId) throws ClassNotFoundException, SQLException {
        Cart cart = new Cart();
        String sql = "SELECT * FROM customer_cart WHERE customer_id = ?";

        ModelCarDAO modelCarDAO = new ModelCarDAO();
        AccessoryDAO accessoryDAO = new AccessoryDAO();

        try ( Connection conn = new DBUtils().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerId);
            ResultSet rs = ps.executeQuery();

            List<CartItem> items = new ArrayList<>();
            while (rs.next()) {
                String itemType = rs.getString("item_type");
                String itemId = rs.getString("item_id");
                String itemName = rs.getString("item_name");
                double unitPrice = rs.getDouble("unit_price");
                int quantity = rs.getInt("quantity");

                CartItem item = new CartItem(itemType, itemId, itemName, unitPrice, quantity);

                // Set image URL
                String imageUrl = null;
                if ("MODEL".equalsIgnoreCase(itemType)) {
                    ModelCar model = modelCarDAO.getById(itemId);
                    if (model != null && model.getImages() != null && !model.getImages().isEmpty()) {
                        imageUrl = model.getImages().get(0).getImageUrl();
                    }
                } else if ("ACCESSORY".equalsIgnoreCase(itemType)) {
                    Accessory accessory = accessoryDAO.getById(itemId);
                    if (accessory != null) {
                        imageUrl = accessory.getImageUrl();
                    }
                }
                item.setImageUrl(imageUrl);
                items.add(item);
            }

            cart.setItems(items);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return cart;
    }

    // Lưu/cập nhật một item trong cart (SQL Server MERGE(vừa update vừa insert))
    public boolean saveCartItem(String customerId, CartItem item) {
        String sql = "MERGE customer_cart AS target "
                + "USING (VALUES (?, ?, ?, ?, ?, ?)) AS source "
                + "(customer_id, item_type, item_id, item_name, unit_price, quantity) "
                + "ON target.customer_id = source.customer_id "
                + "AND target.item_type = source.item_type "
                + "AND target.item_id = source.item_id "
                + "WHEN MATCHED THEN "
                + "UPDATE SET quantity = source.quantity, "
                + "           unit_price = source.unit_price, "
                + "           item_name = source.item_name, "
                + "           updated_at = GETDATE() "
                + "WHEN NOT MATCHED THEN "
                + "INSERT (customer_id, item_type, item_id, item_name, unit_price, quantity) "
                + "VALUES (source.customer_id, source.item_type, source.item_id, "
                + "        source.item_name, source.unit_price, source.quantity);";

        try ( Connection conn = new DBUtils().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerId);
            ps.setString(2, item.getItemType());
            ps.setString(3, item.getItemId());
            ps.setString(4, item.getItemName());
            ps.setDouble(5, item.getUnitPrice());
            ps.setInt(6, item.getQuantity());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật quantity của một item
    public boolean updateCartItemQuantity(String customerId, String itemType, String itemId, int newQuantity) {
        if (newQuantity <= 0) {
            return removeCartItem(customerId, itemType, itemId);
        }

        String sql = "UPDATE customer_cart SET quantity = ?, updated_at = GETDATE() "
                + "WHERE customer_id = ? AND item_type = ? AND item_id = ?";

        try ( Connection conn = new DBUtils().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newQuantity);
            ps.setString(2, customerId);
            ps.setString(3, itemType);
            ps.setString(4, itemId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa một item khỏi cart
    public boolean removeCartItem(String customerId, String itemType, String itemId) {
        String sql = "DELETE FROM customer_cart WHERE customer_id = ? AND item_type = ? AND item_id = ?";

        try ( Connection conn = new DBUtils().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerId);
            ps.setString(2, itemType);
            ps.setString(3, itemId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa toàn bộ cart của customer
    public boolean clearCart(String customerId) {
        String sql = "DELETE FROM customer_cart WHERE customer_id = ?";

        try ( Connection conn = new DBUtils().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerId);
            return ps.executeUpdate() >= 0; // >= 0 vì có thể cart đã trống

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lưu toàn bộ cart vào database (dùng khi logout)
    public boolean saveCart(String customerId, Cart cart) {
        // Xóa cart cũ trước
        clearCart(customerId);

        // Lưu từng item
        if (cart != null && !cart.getItems().isEmpty()) {
            for (CartItem item : cart.getItems()) {
                if (!saveCartItem(customerId, item)) {
                    return false;
                }
            }
        }
        return true;
    }
}
