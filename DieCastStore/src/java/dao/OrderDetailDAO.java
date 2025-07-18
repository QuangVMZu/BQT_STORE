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
import model.OrderDetail;
import utils.DBUtils;

/**
 *
 * @author ADMIN
 */
public class OrderDetailDAO {

    public List<OrderDetail> getItemsByOrderId(String orderId) throws SQLException, ClassNotFoundException {
        List<OrderDetail> items = new ArrayList<>();
        String sql = "SELECT \n"
                + "    od.orderId, \n"
                + "    od.itemType, \n"
                + "    od.itemId, \n"
                + "    od.unitPrice, \n"
                + "    od.unitQuantity,\n"
                + "    ISNULL(mc.modelName, ac.accessoryName) AS itemName,\n"
                + "    ISNULL(img.imageURL, ac.imageURL) AS itemImage\n"
                + "FROM orderDetail od\n"
                + "LEFT JOIN ModelCar mc \n"
                + "    ON od.itemType = 'model' AND od.itemId = mc.modelId\n"
                + "LEFT JOIN (\n"
                + "    SELECT modelId, MIN(imageURL) AS imageURL\n"
                + "    FROM imageModel\n"
                + "    GROUP BY modelId\n"
                + ") img \n"
                + "    ON od.itemType = 'model' AND od.itemId = img.modelId\n"
                + "LEFT JOIN Accessory ac \n"
                + "    ON od.itemType = 'accessory' AND od.itemId = ac.accessoryId\n"
                + "WHERE od.orderId = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail item = new OrderDetail();
                    item.setOrderId(rs.getString("orderId"));
                    item.setItemType(rs.getString("itemType"));
                    item.setItemId(rs.getString("itemId"));
                    item.setUnitPrice(rs.getDouble("unitPrice"));
                    item.setUnitQuantity(rs.getInt("unitQuantity"));
                    item.setItemName(rs.getString("itemName"));
                    item.setItemImage(rs.getString("itemImage"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    public String getCustomerAddressByOrderId(String orderId) throws SQLException, ClassNotFoundException {
        String address = "Unknown";
        String sql = "SELECT c.address FROM [Order] o JOIN Customer c ON o.customerId = c.customerId WHERE o.orderId = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, orderId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    address = rs.getString("address");
                }
            }
        }
        return address;
    }

}
