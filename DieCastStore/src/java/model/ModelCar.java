/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author hqthi
 */
public class ModelCar {

    private String modelId;
    private String modelName;
    private int scaleId;
    private int brandId;
    private double price;
    private String description;
    private int quantity;
    private List<ImageModel> images;

    public ModelCar() {
    }

    public ModelCar(String modelId, String modelName, int scaleId, int brandId, double price, String description, int quantity, List<ImageModel> images) {
        this.modelId = modelId;
        this.modelName = modelName;
        this.scaleId = scaleId;
        this.brandId = brandId;
        this.price = price;
        this.description = description;
        this.quantity = quantity;
        this.images = images;
    }

    public String getModelId() {
        return modelId;
    }

    public void setModelId(String modelId) {
        this.modelId = modelId;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public int getScaleId() {
        return scaleId;
    }

    public void setScaleId(int scaleId) {
        this.scaleId = scaleId;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public List<ImageModel> getImages() {
        return images;
    }

    public void setImages(List<ImageModel> images) {
        this.images = images;
    }

}
