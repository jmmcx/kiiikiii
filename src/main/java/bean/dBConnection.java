/* For connecting to DBeaver (Local Database) */
/*
package bean;

import java.sql.Connection;
import java.sql.DriverManager;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class dBConnection {
    private static final Logger logger = LogManager.getLogger(dBConnection.class);

    private static final String URL = "jdbc:mysql://192.168.191.182/kiosk";
    private static final String USER = "admin";
    private static final String PASSWORD = "adminHoge1234!";

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void shutdown() {
        try {
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
        } catch (Exception e) {
            logger.error("Error shutting down MySQL cleanup thread: " + e.getMessage());
        }
    }
} */
/* **For connecting to phpMyAdmin ** */
package bean;

import java.sql.Connection;
import java.sql.DriverManager;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import util.ConfigUtil;

public class dBConnection {
    private static final Logger logger = LogManager.getLogger(dBConnection.class);
    
    public static Connection getConnection() throws Exception {
        String driver = ConfigUtil.getDBConfig("db.driver");
        String url = ConfigUtil.getDBConfig("db.url");
        String user = ConfigUtil.getDBConfig("db.user");
        String password = ConfigUtil.getDBConfig("db.password");
        
        Class.forName(driver);
        return DriverManager.getConnection(url, user, password);
    }
    
    public static void shutdown() {
        try {
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
        } catch (Exception e) {
            logger.error("Error shutting down MySQL cleanup thread: " + e.getMessage());
        }
    }
} 
