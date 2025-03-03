package dao;

import model.ItemModel;
import bean.dBConnection;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.mysql.cj.util.StringUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {
    private static final Logger logger = LogManager.getLogger(ItemDAO.class);

    // Method to get all items
    public List<ItemModel> getAllItems() {
        List<ItemModel> items = new ArrayList<>();
        String query = "SELECT * FROM KIOSK.inventory";
        Connection conn = null;

        try {
            // Get connection
            conn = dBConnection.getConnection();

            // Prepare and execute query
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    ItemModel item = new ItemModel(
                        rs.getInt("No"),
                        rs.getString("Item_Name"),
                        rs.getString("Abb_by_LLM"),
                        rs.getBoolean("Duplicate_flag"),
                        rs.getString("Duplicate"),
                        rs.getString("Unique_flag"),
                        rs.getString("Brand"),
                        rs.getString("Location"),
                        rs.getString("Quantity"),
                        rs.getString("Quantity_Available"),
                        rs.getString("Subcat_by_LLM"),
                        rs.getString("Field_1"),
                        rs.getString("Field_2"),
                        rs.getString("Field_3"),
                        rs.getString("Field_4"),
                        rs.getString("Field_5"),
                        rs.getString("Field_6"),
                        rs.getString("Field_7"),
                        rs.getString("Serial_Number"),
                        rs.getString("Entrusted_Commend")
                    );
                    items.add(item);
                }
                logger.info("Fetched all items successfully. Total items: {}", items.size());
            }
        } catch (SQLException e) {
            logger.error("SQL Error while fetching items: {}", e.getMessage(), e);
        } catch (Exception e) {
            logger.error("Unexpected Error while fetching items: {}", e.getMessage(), e);
        } finally {
            // Close connection and call shutdown
            if (conn != null) {
                try {
                    conn.close();
                    //logger.info("Database connection closed successfully.");
                } catch (SQLException e) {
                    logger.error("Error closing the database connection: {}", e.getMessage(), e);
                }
            }
            // Call dBConnection shutdown method
            dBConnection.shutdown();
        }

        return items;
    }

    // Method to get an item by serial number
    public ItemModel getItemBySerialNumber(String serialNumber) {
        String query = "SELECT * FROM Inventory WHERE Serial_Number = ?";
        Connection conn = null;

        try {
            // Get connection
            conn = dBConnection.getConnection();

            // Prepare and execute query
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, serialNumber);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        ItemModel item = new ItemModel(
                            rs.getInt("No"),
                            rs.getString("Item_Name"),
                            rs.getString("Abb_by_LLM"),
                            rs.getBoolean("Duplicate_flag"),
                            rs.getString("Duplicate"),
                            rs.getString("Unique_flag"),
                            rs.getString("Brand"),
                            rs.getString("Location"),
                            rs.getString("Quantity"),
                            rs.getString("Quantity_Available"),
                            rs.getString("Subcat_by_LLM"),
                            rs.getString("Field_1"),
                            rs.getString("Field_2"),
                            rs.getString("Field_3"),
                            rs.getString("Field_4"),
                            rs.getString("Field_5"),
                            rs.getString("Field_6"),
                            rs.getString("Field_7"),
                            rs.getString("Serial_Number"),
                            rs.getString("Entrusted_Commend")
                        );
                        return item;
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("SQL Error while fetching item by serial number: {}", e.getMessage(), e);
        } catch (Exception e) {
            logger.error("Unexpected Error while fetching item by serial number: {}", e.getMessage(), e);
        } finally {
            // Close connection and call shutdown
            if (conn != null) {
                try {
                    conn.close();
                    //logger.info("Database connection closed successfully.");
                } catch (SQLException e) {
                    logger.error("Error closing the database connection: {}", e.getMessage(), e);
                }
            }
            // Call dBConnection shutdown method
            dBConnection.shutdown();
        }

        return null; // Return null if item not found
    }

    public int getItemAvailableQuantity(String serialNumber) {
        String query = "SELECT Quantity_Available FROM Inventory WHERE Serial_Number = ?";
        Connection conn = null;

        try {
            conn = dBConnection.getConnection();

            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, serialNumber);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        String quantityAvailable = rs.getString("Quantity_Available");
                        if (StringUtils.isStrictlyNumeric(quantityAvailable)) {
                            return Integer.parseInt(quantityAvailable);
                        } else {
                            return -1; // 'bulk' quantity
                        }
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("SQL Error while fetching item available quantity: {}", e.getMessage(), e);
        } catch (Exception e) {
            logger.error("Unexpected Error while fetching item available quantity: {}", e.getMessage(), e);
        } finally {
            // Close connection and call shutdown
            if (conn != null) {
                try {
                    conn.close();
                    //logger.info("Database connection closed successfully.");
                } catch (SQLException e) {
                    logger.error("Error closing the database connection: {}", e.getMessage(), e);
                }
            }
            dBConnection.shutdown();
        }

        return -1; // Default to -1 if the item is not found or the quantity is not a valid integer
    }

    public String getItemQuantity(String serialNumber) {
        String query = "SELECT Quantity FROM KIOSK.inventory WHERE Serial_Number = ?";
        Connection conn = null;
        String quantity = null;
    
        try {
            conn = dBConnection.getConnection();
    
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, serialNumber);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        quantity = rs.getString("Quantity");
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("SQL Error while fetching item quantity: {}", e.getMessage(), e);
        } catch (Exception e) {
            logger.error("Unexpected Error while fetching item quantity: {}", e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    //logger.info("Database connection closed successfully.");
                } catch (SQLException e) {
                    logger.error("Error closing the database connection: {}", e.getMessage(), e);
                }
            }
            dBConnection.shutdown();
        }
    
        return quantity; // Returns the quantity as a string ("Bulk" or an integer value as a string)
    }

    public void updateItemAvailableQuantity(String serialNumber, int quantityBorrowed) {
        String query = "UPDATE KIOSK.inventory SET Quantity_Available = Quantity_Available - ? WHERE Serial_Number = ? AND (Quantity_Available != 'bulk' OR Quantity_Available != 'Bulk')";
        Connection conn = null;
    
        try {
            conn = dBConnection.getConnection();
    
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, quantityBorrowed);
                stmt.setString(2, serialNumber);
    
                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    logger.info("Inventory quantity updated successfully for Serial Number: {}", serialNumber);
                } else {
                    logger.warn("No inventory update occurred for Serial Number: {}. Check if item is 'bulk' or does not exist.", serialNumber);
                }
            }
        } catch (SQLException e) {
            logger.error("SQL Error while updating item quantity: {}", e.getMessage(), e);
        } catch (Exception e) {
            logger.error("Unexpected Error while updating item quantity: {}", e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    //logger.info("Database connection closed successfully.");
                } catch (SQLException e) {
                    logger.error("Error closing the database connection: {}", e.getMessage(), e);
                }
            }
            dBConnection.shutdown();
        }
    }
    
    public void restoreItemAvailableQuantity(String serialNumber, int quantityReturned) {
        String query = "UPDATE KIOSK.inventory SET Quantity_Available = Quantity_Available + ? WHERE Serial_Number = ? AND (Quantity_Available != 'bulk' OR Quantity_Available != 'Bulk')";
        Connection conn = null;
    
        try {
            conn = dBConnection.getConnection();
    
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, quantityReturned);
                stmt.setString(2, serialNumber);
    
                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    logger.info("Inventory quantity restored successfully for Serial Number: {}", serialNumber);
                } else {
                    logger.warn("No inventory restore occurred for Serial Number: {}. Check if item is 'bulk' or does not exist.", serialNumber);
                }
            }
        } catch (SQLException e) {
            logger.error("SQL Error while restoring item quantity: {}", e.getMessage(), e);
        } catch (Exception e) {
            logger.error("Unexpected Error while restoring item quantity: {}", e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    //logger.info("Database connection closed successfully.");
                } catch (SQLException e) {
                    logger.error("Error closing the database connection: {}", e.getMessage(), e);
                }
            }
            dBConnection.shutdown();
        }
    }
    

    // Additional methods like addItem, updateItem, deleteItem can be added here
}