package model;

import java.util.ArrayList;
import java.util.List;

public class Cart {

    private List<CartItem> items;
    private double totalAmount;
//    private Map<String, Integer> previousQuantities = new HashMap<>();
    private String shippingAddress;

    public Cart() {
        this.items = new ArrayList<>();
        this.totalAmount = 0.00;
    }

    // Thêm sản phẩm vào giỏ hàng
    public void addItem(String itemType, String itemId, String itemName, double unitPrice, int quantity) {
        // Kiểm tra xem sản phẩm đã có trong cart chưa
        CartItem existingItem = findItem(itemType, itemId);

        if (existingItem != null) {
            // Nếu đã có, tăng số lượng
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            // Nếu chưa có, thêm mới
            CartItem newItem = new CartItem(itemType, itemId, itemName, unitPrice, quantity);
            items.add(newItem);
        }

        calculateTotal();
    }

    // Tìm sản phẩm trong cart
    private CartItem findItem(String itemType, String itemId) {
        for (CartItem item : items) {
            if (item.getItemType().equals(itemType) && item.getItemId().equals(itemId)) {
                return item;
            }
        }
        return null;
    }

    // Cập nhật số lượng sản phẩm
    public void updateQuantity(String itemType, String itemId, int newQuantity) {
        for (CartItem item : items) {
            if (item.getItemType().equals(itemType) && item.getItemId().equals(itemId)) {
                item.setQuantity(newQuantity);
                break;
            }
        }
        calculateTotal();
    }

    // Xóa sản phẩm khỏi giỏ hàng
    public boolean removeItem(String itemType, String itemId) {
        CartItem item = findItem(itemType, itemId);
        if (item != null) {
            items.remove(item);
            calculateTotal();
            return true;
        }
        return false;
    }

    // Xóa toàn bộ giỏ hàng
    public void clearCart() {
        items.clear();
        totalAmount = 0.00;
    }

    // Tính tổng tiền
    private void calculateTotal() {
        totalAmount = 0.00;
        for (CartItem item : items) {
            totalAmount += item.getSubTotal();
        }
    }

    // Kiểm tra giỏ hàng có trống không
    public boolean isEmpty() {
        return items.isEmpty();
    }

    // Lấy số lượng items
    public int getItemCount() {
        return items.size();
    }

    // Lấy tổng số sản phẩm (tính cả quantity)
    public int getTotalQuantity() {
        int total = 0;
        for (CartItem item : items) {
            total += item.getQuantity();
        }
        return total;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
        calculateTotal();
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }
}
