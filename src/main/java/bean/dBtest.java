package bean;

import java.sql.Connection;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class dBtest {
    private static final Logger logger = LogManager.getLogger(dBtest.class);

    public static void main(String[] args) {
        try {
            // Test database connection
            logger.info("Attempting to connect to database...");
            Connection conn = dBConnection.getConnection();
            
            if (conn != null) {
                logger.info("Database connection successful!");
                
                // Print connection details
                logger.info("Database Product: " + conn.getMetaData().getDatabaseProductName());
                logger.info("Database Version: " + conn.getMetaData().getDatabaseProductVersion());
                
                conn.close();
                logger.info("Connection closed successfully.");
            }
            
        } catch (Exception e) {
            logger.error("Database connection failed!");
            logger.error("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
