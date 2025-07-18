
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import model.ResetToken;
import utils.DBUtils;

/**
 *
 * @author hqthi
 */
public class ResetTokenDAO {

    public void createToken(String customerId, String token, Timestamp expiry) {
        String sql = "INSERT INTO reset_tokens (customerId, token, expiry) VALUES (?, ?, ?)";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customerId);
            ps.setString(2, token);
            ps.setTimestamp(3, expiry);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ResetToken findByToken(String token) {
        String sql = "SELECT * FROM reset_tokens WHERE token = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ResetToken rt = new ResetToken();
                rt.setId(rs.getInt("id"));
                rt.setCustomerId(rs.getString("customerId"));
                rt.setToken(rs.getString("token"));
                rt.setExpiry(rs.getTimestamp("expiry"));
                rt.setUsed(rs.getBoolean("used"));
                return rt;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void markUsed(String token) {
        String sql = "UPDATE reset_tokens SET used = 1 WHERE token = ?";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteExpiredTokens() {
        String sql = "DELETE FROM reset_tokens WHERE expiry < GETDATE() OR used = 1";
        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
