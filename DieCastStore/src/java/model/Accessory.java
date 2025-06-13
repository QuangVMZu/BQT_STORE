/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hqthi
 */
public class Accessory {

    private String accessoryId;
    private String accessoryName;
    private String detail;
    private double price;
    private int quantity;

    public Accessory() {
    }

    public Accessory(String accessoryId, String accessoryName, String detail, double price, int quantity) {
        this.accessoryId = accessoryId;
        this.accessoryName = accessoryName;
        this.detail = detail;
        this.price = price;
        this.quantity = quantity;
    }

    public String getAccessoryId() {
        return accessoryId;
    }

    public void setAccessoryId(String accessoryId) {
        this.accessoryId = accessoryId;
    }

    public String getAccessoryName() {
        return accessoryName;
    }

    public void setAccessoryName(String accessoryName) {
        this.accessoryName = accessoryName;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

}
