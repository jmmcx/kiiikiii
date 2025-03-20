package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class ConfigUtil {
    private static final Properties configProperties = new Properties();
    private static final Properties mailProperties = new Properties();
    private static final Logger logger = LogManager.getLogger(ConfigUtil.class);

    static {
        loadProperties("config.properties", configProperties);
        loadProperties("mail.properties", mailProperties);
    }

    private static void loadProperties(String fileName, Properties properties) {
        try (InputStream input = ConfigUtil.class.getClassLoader().getResourceAsStream(fileName)) {
            if (input == null) {
                logger.error(fileName + " file not found");
                throw new IOException(fileName + " file not found");
            }
            properties.load(input);
            logger.info("Loaded " + fileName + " successfully.");
        } catch (IOException e) {
            logger.error("Failed to load " + fileName + ": " + e.getMessage(), e);
        }
    }

    public static String getProperty(String key) {
        return configProperties.getProperty(key);
    }

    public static String getMailConfig(String key) {
        return mailProperties.getProperty(key);
    }
}