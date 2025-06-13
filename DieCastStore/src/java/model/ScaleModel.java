/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hqthi
 */
public class ScaleModel {

    private int scaleId;
    private String scaleLabel;

    public ScaleModel() {
    }

    public ScaleModel(int scaleId, String scaleLabel) {
        this.scaleId = scaleId;
        this.scaleLabel = scaleLabel;
    }

    public int getScaleId() {
        return scaleId;
    }

    public void setScaleId(int scaleId) {
        this.scaleId = scaleId;
    }

    public String getScaleLabel() {
        return scaleLabel;
    }

    public void setScaleLabel(String scaleLabel) {
        this.scaleLabel = scaleLabel;
    }

}
