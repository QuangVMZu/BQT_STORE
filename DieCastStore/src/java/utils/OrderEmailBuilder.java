/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.util.List;
import model.Accessory;
import model.Customer;
import model.ModelCar;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author hqthi
 */
public class OrderEmailBuilder {

    public static String buildOrderConfirmationEmail(
            Order order,
            Customer customer,
            List<OrderDetail> orderDetails,
            List<ModelCar> cars, // nếu có
            List<Accessory> accessories // nếu có
    ) {
        StringBuilder sb = new StringBuilder();
        sb.append("<h2>Order Successfully Placed!</h2>");
        sb.append("<p>Dear ").append(customer.getCustomerName()).append(",</p>");
        sb.append("<p>Thank you for placing your order at our store.</p>");
        sb.append("<p>Order ID: <b>").append(order.getOrderId()).append("</b></p>");
        sb.append("<p>Order Date: ").append(order.getOrderDate()).append("</p>");
        sb.append("<p>Shipping Address: ").append(customer.getAddress()).append("</p>");
        sb.append("<h3>Order Details:</h3>");
        sb.append("<table border='1' cellpadding='5' style='border-collapse:collapse;'>");
        sb.append("<tr><th>Product Name</th><th>Type</th><th>Quantity</th><th>Unit Price</th><th>Subtotal</th></tr>");
        for (OrderDetail detail : orderDetails) {
            sb.append("<tr>");
            sb.append("<td>").append(detail.getItemName()).append("</td>");
            sb.append("<td>").append(detail.getItemType()).append("</td>");
            sb.append("<td>").append(detail.getUnitQuantity()).append("</td>");
            sb.append("<td>").append(String.format("%.0f", detail.getUnitPrice())).append(" $</td>");
            sb.append("<td>").append(String.format("%.0f", detail.getUnitPrice() * detail.getUnitQuantity())).append(" $</td>");
            sb.append("</tr>");
        }
        sb.append("</table>");
        sb.append("<p><b>Total Amount: ").append(String.format("%.0f", order.getTotalAmount())).append(" $</b></p>");
        sb.append("<p><i>We will contact you soon to confirm your delivery.</i></p>");
        sb.append("<p>Best regards!</p>");
        return sb.toString();
    }
}
