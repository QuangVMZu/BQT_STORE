/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.regex.Pattern;
import model.CustomerAccount;

/**
 *
 * @author hqthi
 */
public class AuthUtils {
    private static String EMAIL_REGEX = "^[A-Za-z0-9_+&*-]+@[A-Za-z0-9]+\\.[a-zA-Z]{2,4}$";
    private static String PHONE_REGEX = "^(09|08|07|05|03)\\d{8}$";
    
    public static boolean isValidEmail(String email) {
        if(email == null || email.isEmpty()) {
            return false;
        }
        return Pattern.matches(EMAIL_REGEX, email);
    }
    
    public static boolean isValidPhone(String phone) {
        return Pattern.matches(PHONE_REGEX, phone);
    }
    
    public static CustomerAccount getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession();
        if(session != null) {
            return (CustomerAccount) session.getAttribute("account");
        }
        return null;
    } 
    
    public static boolean isLoggedin(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }
    
    public static boolean hasRole(HttpServletRequest request, int role) {
        CustomerAccount account = getCurrentUser(request);
        if(account != null) {
            return account.getRole() == role;
        }
        return false;
    }
    
    public static boolean isAdmin(HttpServletRequest request) {
        return hasRole(request, 1);
    }
    public static boolean isMember(HttpServletRequest request) {
        return hasRole(request, 2);
    }
    public static boolean isBanned(HttpServletRequest request) {
        return hasRole(request, 0);
    }
    public static String getAccessDeniedMessage(String action) {
        return "You can not access to " + action + ". Please contact administrator";
    }
}
