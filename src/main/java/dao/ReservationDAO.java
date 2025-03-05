package dao;

// Import necessary packages
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import model.ReservationModel;
import bean.dBConnection;

public class ReservationDAO {
    
    private static final Logger logger = LogManager.getLogger(ReservationDAO.class);
    
    /**
     * Retrieves a reservation by its booking ID
     * 
     * @param bookingID The booking ID to search for
     * @return ReservationModel object if found, null otherwise
     */
    public ReservationModel getReservationByBookingID(String bookingID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ReservationModel reservation = null;
        
        try {
            conn = dBConnection.getConnection();
            
            String sql = "SELECT * FROM room_bookings WHERE BookingID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bookingID);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Parse visitors names and ages from stored format (comma-separated)
                String visitorsNameStr = rs.getString("VisitorsName");
                String visitorsAgeStr = rs.getString("VisitorsAge");
                List<String> visitorsNameList = new ArrayList<>();
                List<String> visitorsAgeList = new ArrayList<>();
                
                if (visitorsNameStr != null && !visitorsNameStr.isEmpty()) {
                    visitorsNameList = Arrays.asList(visitorsNameStr.split(","));
                }
                if (visitorsAgeStr != null && !visitorsAgeStr.isEmpty()) {
                    visitorsAgeList = Arrays.asList(visitorsAgeStr.split(","));
                }
                
                // Create a new ReservationModel with the retrieved data
                reservation = new ReservationModel(
                    rs.getString("BookingID"),
                    rs.getString("Name"),
                    rs.getString("Email"),
                    rs.getString("Phone"),
                    rs.getString("Organization"),
                    rs.getString("City"),
                    rs.getString("Country"),
                    rs.getInt("NumVisitors"),
                    visitorsNameList,
                    visitorsAgeList,
                    rs.getString("Location"),
                    rs.getString("BookingDate"),
                    rs.getString("TimeSlot"),
                    rs.getString("MergedTimeSlot"),
                    rs.getString("Status"),
                    rs.getString("CreatedAt"),
                    rs.getString("UpdatedAt")
                );
                
                logger.info("Retrieved reservation with booking ID: " + bookingID);
            } else {
                logger.info("No reservation found with booking ID: " + bookingID);
            }
            
        } catch (SQLException e) {
            logger.error("Error retrieving reservation with booking ID: " + bookingID, e);
        } catch (Exception e) {
            logger.error("Unexpected Error while fetching existing field numbers: {}", e.getMessage(), e);
        } finally {
            // Close resources in reverse order of creation
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                logger.error("Error closing database resources", e);
            }
        }
        
        return reservation;
    }
    
    /**
     * Updates a reservation status
     * 
     * @param bookingID The booking ID to update
     * @param newStatus The new status to set
     * @return true if successful, false otherwise
     */
    public boolean updateReservationStatus(String bookingID, String newStatus) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = dBConnection.getConnection();
            
            String sql = "UPDATE room_bookings SET Status = ?, CheckedInAt = ? WHERE BookingID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setString(2, getCurrentTimestamp());
            pstmt.setString(3, bookingID);
            
            int rowsAffected = pstmt.executeUpdate();
            success = (rowsAffected > 0);
            
            if (success) {
                logger.info("Successfully updated reservation status to '" + newStatus + "' for booking ID: " + bookingID);
            } else {
                logger.warn("Failed to update reservation status. No reservation found with booking ID: " + bookingID);
            }
            
        } catch (SQLException e) {
            logger.error("Error updating reservation status for booking ID: " + bookingID, e);
        } catch (Exception e) {
            logger.error("Unexpected Error while fetching existing field numbers: {}", e.getMessage(), e);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                logger.error("Error closing database resources", e);
            }
        }
        
        return success;
    }

    private String getCurrentTimestamp() {
        return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
    }
    
    /**
     * Retrieves the status of a reservation by its booking ID
     * 
     * @param bookingID The booking ID to search for
     * @return String containing the status if found, null otherwise
     */
    public String getStatusByBookingID(String bookingID) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String status = null;
        
        try {
            conn = dBConnection.getConnection();
            
            String sql = "SELECT Status FROM room_bookings WHERE BookingID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bookingID);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                status = rs.getString("Status");
                logger.info("Retrieved status for booking ID: " + bookingID + " - Status: " + status);
            } else {
                logger.info("No reservation found with booking ID: " + bookingID);
            }
            
        } catch (SQLException e) {
            logger.error("Error retrieving status for booking ID: " + bookingID, e);
        } catch (Exception e) {
            logger.error("Unexpected Error while fetching status: {}", e.getMessage(), e);
        } finally {
            // Close resources in reverse order of creation
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                logger.error("Error closing database resources", e);
            }
        }
        
        return status;
    }
}