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
}