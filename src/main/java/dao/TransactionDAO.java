package dao;

import bean.dBConnection;
import model.TransactionModel;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class TransactionDAO {
    private static final Logger logger = LogManager.getLogger(TransactionDAO.class);

    public Set<String> getExistingFieldNumbers(String serialNumber) {
        // ** might cahnge logic later **
        String query = "SELECT Field_7 FROM KIOSK.transactions WHERE Serial_Number = ? AND (Transaction_Type = 'borrowed' OR Transaction_Type = 'requested')";  
        Connection conn = null;
        Set<String> existingFieldNumbers = new HashSet<>();

        try {
            conn = dBConnection.getConnection();

            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, serialNumber);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        existingFieldNumbers.add(rs.getString("Field_7"));
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("SQL Error while fetching existing field numbers: {}", e.getMessage(), e);
        } catch (Exception e) {
            logger.error("Unexpected Error while fetching existing field numbers: {}", e.getMessage(), e);
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

        return existingFieldNumbers;
    }

    public void saveTransactions(List<TransactionModel> transactions) {
        ItemDAO item = new ItemDAO();

        String query = "INSERT INTO KIOSK.transactions (Serial_Number, Field_7, Student_ID, Student_Name, Transaction_Type, Quantity, Borrow_Date, Due_Date) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
    
        try {
            conn = dBConnection.getConnection();
    
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                for (TransactionModel transaction : transactions) {

                    String quantity = item.getItemQuantity(transaction.getSerialNumber());
                    java.sql.Date dueDate;

                    // Calculate due date based on quantity
                    if (quantity != null && (quantity.equalsIgnoreCase("bulk") || quantity.equalsIgnoreCase("Bulk"))) {
                        dueDate = java.sql.Date.valueOf("0001-01-01"); // No due date
                    } else {
                        // Add 14 days to today's date for items with integer quantities
                        LocalDate today = LocalDate.now();
                        LocalDate due = today.plusWeeks(2);
                        dueDate = java.sql.Date.valueOf(due);
                    }

                    transaction.setDueDate(dueDate);
                    transaction.setBorrowDate(new java.sql.Timestamp(System.currentTimeMillis()));

                    stmt.setString(1, transaction.getSerialNumber());
                    stmt.setString(2, transaction.getFieldNumber());
                    stmt.setString(3, transaction.getStudentId());
                    stmt.setString(4, transaction.getStudentName());
                    stmt.setString(5, transaction.getTransactionType());
                    stmt.setInt(6, transaction.getQuantity());
                    stmt.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis()));
                    stmt.setDate(8, dueDate);
                    stmt.addBatch();
                }
                stmt.executeBatch();
            }
        } catch (SQLException e) {
            logger.error("SQL Error while saving transactions: {}", e.getMessage(), e);
        } catch (Exception e) {
            logger.error("Unexpected Error while saving transactions: {}", e.getMessage(), e);
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
    }

    public List<TransactionModel> getBorrowedItemsByStudentId(String studentId) {
        List<TransactionModel> borrowedItems = new ArrayList<>();
        String query = "SELECT * FROM transactions WHERE student_id = ? AND transaction_type = 'borrowed'";
        Connection conn = null;
    
        logger.info("Fetching borrowed items for student ID: " + studentId);

        try {
            conn = dBConnection.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, studentId);
                try (ResultSet rs = stmt.executeQuery()) {
                    ItemDAO itemDAO = new ItemDAO(); // Instance to get item details
    
                    while (rs.next()) {
                        String serialNumber = rs.getString("Serial_Number");
    
                        // Retrieve item quantity using ItemDAO
                        String itemQuantity = itemDAO.getItemQuantity(serialNumber);
    
                        // Skip adding this item if it's "Bulk"
                        if ("Bulk".equalsIgnoreCase(itemQuantity) || "bulk".equalsIgnoreCase(itemQuantity)) {
                            continue; // Skip this item and move to the next one
                        }
    
                        TransactionModel transaction = new TransactionModel();
                        transaction.setTransactionId(rs.getString("Transaction_ID"));
                        transaction.setSerialNumber(serialNumber);
                        transaction.setFieldNumber(rs.getString("Field_7"));
                        transaction.setStudentId(rs.getString("Student_ID"));
                        //transaction.setStudentName(rs.getString("Student_Name"));
                        transaction.setTransactionType(rs.getString("Transaction_Type"));
                        transaction.setQuantity(rs.getInt("Quantity"));
                        transaction.setBorrowDate(rs.getTimestamp("Borrow_Date"));
                        transaction.setDueDate(rs.getDate("Due_Date"));
    
                        // Retrieve item name using Serial Number
                        transaction.setItemName(itemDAO.getItemBySerialNumber(serialNumber).getItemName());
    
                        borrowedItems.add(transaction);
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("SQL Error while fetching borrowed items: {}", e.getMessage(), e);
        } catch (Exception e) {
            logger.error("Unexpected Error while fetching borrowed items: {}", e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    logger.error("Error closing the database connection: {}", e.getMessage(), e);
                }
            }
            dBConnection.shutdown();
        }
        return borrowedItems;
    }

    public boolean updateReturnStatus(List<TransactionModel> returnItems) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = dBConnection.getConnection();
            conn.setAutoCommit(false); // Enable transaction
            
            String query = "UPDATE transaction SET Return_Date = ?, Transaction_Type = ? WHERE Serial_Number = ? AND Borrow_Date = ?";
            pstmt = conn.prepareStatement(query);
            
            for (TransactionModel item : returnItems) {
                pstmt.setTimestamp(1, item.getReturnDate());
                pstmt.setString(1, item.getTransactionType());
                pstmt.setString(2, item.getSerialNumber());
                pstmt.setTimestamp(3, item.getBorrowDate());
                pstmt.addBatch(); // Add to batch
            }
            
            pstmt.executeBatch(); // Execute all updates
            conn.commit(); // Commit transaction
            
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } catch (Exception e) {  
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public TransactionModel getTransactionBySerialNumber(String serialNumber) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        TransactionModel transaction = null;
        
        try {
            conn = dBConnection.getConnection();
            ItemDAO itemDAO = new ItemDAO();
            
            String sql = "SELECT * FROM transactions " +
                        "WHERE Serial_Number = ? AND Transaction_Type = 'borrowed'";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, serialNumber);
            
            logger.info("Executing query to get borrowing transaction by serial number: " + serialNumber);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                transaction = new TransactionModel();
                transaction.setSerialNumber(rs.getString("Serial_Number"));
                transaction.setBorrowDate(rs.getTimestamp("Borrow_Date"));
                transaction.setDueDate(rs.getDate("Due_Date"));
                transaction.setTransactionType(rs.getString("Transaction_Type"));
                transaction.setItemName(itemDAO.getItemBySerialNumber(serialNumber).getItemName());
            }
            
        } catch (SQLException e) {
            logger.error("SQL Exception while getting transaction by serial number: " + serialNumber, e);
            throw new RuntimeException("Database error occurred", e);
        } catch (Exception e) {
            logger.error("Exception while getting transaction by serial number: " + serialNumber, e);
            throw new RuntimeException("Error occurred while fetching transaction", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
                logger.debug("Database resources closed successfully");
            } catch (SQLException e) {
                logger.error("Error closing database resources", e);
            }
        }
        
        return transaction;
    }
}