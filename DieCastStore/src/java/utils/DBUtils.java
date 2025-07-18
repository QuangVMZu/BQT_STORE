
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author hqthi
 */
public class DBUtils {

    private static final String DB_Name = "DieCastStore";
    private static final String DB_Username = "sa";
    private static final String DB_Password = "12345";
    protected static Connection c;

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:1433;databaseName=" + DB_Name;
        c = DriverManager.getConnection(url, DB_Username, DB_Password);
        return c;
    }
}