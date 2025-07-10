package model;

import java.sql.Timestamp;

public class HomeGallery {

    private int id;
    private String imageUrl;
    private String caption;
    private int displayOrder;
    private String description;
    private String type;
    private Timestamp createdAt;

    public HomeGallery() {
    }

    public HomeGallery(int id, String imageUrl, String caption, int displayOrder, String description, String type, Timestamp createdAt) {
        this.id = id;
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.displayOrder = displayOrder;
        this.description = description;
        this.type = type;
        this.createdAt = createdAt;
    }
    
    public HomeGallery(String imageUrl, String caption, int displayOrder, String description) {
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.displayOrder = displayOrder;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    
}
