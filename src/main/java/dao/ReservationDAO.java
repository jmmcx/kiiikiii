package dao;

// Import necessary packages
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
            
            String sql = "SELECT * FROM visitor_bookings WHERE BookingID = ?";
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
            
            String sql = "UPDATE visitor_bookings SET Status = ?, CheckedInAt = ? WHERE BookingID = ?";
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
            
            String sql = "SELECT Status FROM visitor_bookings WHERE BookingID = ?";
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

    // migrate romm booking register 2025/03/10

    // Create new reservation
    public void saveReservation(ReservationModel reservation) throws Exception {
        String query = "INSERT INTO visitor_bookings (BookingID, Name, Email, Phone, Organization, City, Country, " +
               "NumVisitors, VisitorsName, VisitorsAge, Location, BookingDate, TimeSlot, MergedTimeSlot, " +
               "Status, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";


        try (Connection connection = dBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setString(1, reservation.getBookingId());
            stmt.setString(2, reservation.getName());
            stmt.setString(3, reservation.getEmail());
            stmt.setString(4, reservation.getPhone());
            stmt.setString(5, reservation.getOrganization());
            stmt.setString(6, reservation.getCity());
            stmt.setString(7, reservation.getCountry());
            stmt.setInt(8, reservation.getNumVisitors());
            stmt.setString(9, String.join(", ", reservation.getVisitorNames()));
            stmt.setString(10, String.join(", ", reservation.getVisitorAges()));
            stmt.setString(11, reservation.getLocation());
            stmt.setString(12, reservation.getBookingDate());
            stmt.setString(13, reservation.getTimeSlot());
            stmt.setString(14, reservation.getMergedTimeSlot()); 
            stmt.setString(15, reservation.getStatus());
            stmt.setString(16,reservation.getCreatedAt());
            stmt.setString(17, reservation.getUpdatedAt());
            
            stmt.executeUpdate();
            logger.info("Reservation saved successfully!");
        }
        dBConnection.shutdown();
    }

    // Get reservation by ID
    public ReservationModel getReservationById(String bookingId) throws Exception {
        String query = "SELECT * FROM visitor_bookings WHERE BookingID = ?";
        try (Connection connection = dBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setString(1, bookingId);
            ResultSet resultSet = stmt.executeQuery();

            if (resultSet.next()) {
                return mapRowToReservation(resultSet);
            }
        }
        dBConnection.shutdown();
        return null;
    }

    // Get reservations for a specific date
    public List<ReservationModel> getReservationsByDate(String date) throws Exception {
        String query = "SELECT * FROM visitor_bookings WHERE BookingDate = ?";
        List<ReservationModel> reservations = new ArrayList<>();
        
        try (Connection connection = dBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {

            stmt.setString(1, date);
            ResultSet resultSet = stmt.executeQuery();

            while (resultSet.next()) {
                reservations.add(mapRowToReservation(resultSet));
            }
        }
        dBConnection.shutdown();
        return reservations;
    }

    // Get all reservations
    public List<ReservationModel> getAllReservations() throws Exception {
        String query = "SELECT * FROM visitor_bookings";
        List<ReservationModel> reservations = new ArrayList<>();
        
        try (Connection connection = dBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {

            ResultSet resultSet = stmt.executeQuery();

            while (resultSet.next()) {
                reservations.add(mapRowToReservation(resultSet));
            }
        }
        dBConnection.shutdown();
        return reservations;
    }

    private String getCurrentTimestamp() {
        return new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
    }

    private ReservationModel mapRowToReservation(ResultSet resultSet) throws SQLException {
        ReservationModel reservation = new ReservationModel();
        reservation.setBookingId(resultSet.getString("BookingID"));
        reservation.setName(resultSet.getString("Name"));
        reservation.setEmail(resultSet.getString("Email"));
        reservation.setPhone(resultSet.getString("Phone"));
        reservation.setOrganiztion(resultSet.getString("Organization"));
        reservation.setCity(resultSet.getString("City"));
        reservation.setCountry(resultSet.getString("Country"));
        reservation.setNumVisitors(resultSet.getInt("NumVisitors"));
        reservation.setVisitorNames(Arrays.asList(resultSet.getString("VisitorsName").split(", ")));
        reservation.setVisitorAges(Arrays.asList(resultSet.getString("VisitorsAges").split(", ")));
        reservation.setLocation(resultSet.getString("Location"));
        reservation.setBookingDate(resultSet.getString("BookingDate"));
        reservation.setTimeSlot(resultSet.getString("TimeSlot"));
        reservation.setMergedTimeSlot(resultSet.getString("MergedTimeSlot"));
        reservation.setStatus(resultSet.getString("Status"));
        reservation.setCreatedAt(resultSet.getString("CreatedAt"));
        reservation.setUpdatedAt(resultSet.getString("UpdatedAt"));
        return reservation;
    }

    // Get available time slots for a date and location
    public List<String> getAvailableTimeSlots(String date, String location) throws Exception {
        logger.info("Fetching available time slots for date: {}, location: {}", date, location);
        List<String> availableSlots = new ArrayList<>();
        List<String> bookedSlots = new ArrayList<>();
    
        String query = "SELECT TimeSlot FROM visitor_bookings WHERE Location = ? AND BookingDate = ? AND Status != 'cancelled'";
    
        try (Connection connection = dBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
    
            stmt.setString(1, location.trim());
            stmt.setString(2, date);
    
            ResultSet resultSet = stmt.executeQuery();
            
            while (resultSet.next()) {
                String bookedTimeSlot = resultSet.getString("TimeSlot");
                for (String slot : bookedTimeSlot.split(",")) {
                    bookedSlots.add(slot.trim()); // Trim spaces
                }
            }
        }
    
        List<String> allTimeSlots = Arrays.asList(
            "09:00-09:30", "09:30-10:00", "10:00-10:30", "10:30-11:00",
            "11:00-11:30", "11:30-12:00", "13:00-13:30", "13:30-14:00",
            "14:00-14:30", "14:30-15:00", "15:00-15:30", "15:30-16:00"
        );
    
        for (String slot : allTimeSlots) {
            if (!bookedSlots.contains(slot)) {
                availableSlots.add(slot);
            }
        }
    
        logger.info("Available time slots for date: {}, location: {} -> {}", date, location, availableSlots);
        return availableSlots;
    }

    public boolean isDateFullyBooked(String date, String location) throws Exception {
        List<String> availableSlots = getAvailableTimeSlots(date, location);
        dBConnection.shutdown();
        return availableSlots.isEmpty();
    }

    /**
     * Gets booking status for a date range for both labs
     * @param startDate The start date of the range (inclusive)
     * @param endDate The end date of the range (inclusive)
     * @return Map with dates as keys and nested maps containing booking status for each lab
     */
    public Map<String, Map<String, String>> getBookingStatusByDateRange(String startDate, String endDate) throws Exception {
        logger.info("Fetching booking status from {} to {}", startDate, endDate);
        Map<String, Map<String, String>> bookingStatusMap = new HashMap<>();
        
        // Get all bookings within date range that are not cancelled
        String query = "SELECT BookingDate, Location, TimeSlot FROM visitor_bookings WHERE BookingDate BETWEEN ? AND ? AND Status != 'canceled'";
        
        try (Connection connection = dBConnection.getConnection();
            PreparedStatement stmt = connection.prepareStatement(query)) {
            
            stmt.setString(1, startDate);
            stmt.setString(2, endDate);
            
            ResultSet resultSet = stmt.executeQuery();
            
            // Track bookings per date and location
            Map<String, Map<String, Integer>> bookingsCountMap = new HashMap<>();
            
            while (resultSet.next()) {
                String date = resultSet.getString("BookingDate");
                String location = resultSet.getString("Location").trim();
                String timeSlots = resultSet.getString("TimeSlot");
                
                // Count booked slots
                int bookedSlotsCount = timeSlots.split(",").length;
                
                // Initialize maps if needed
                if (!bookingsCountMap.containsKey(date)) {
                    bookingsCountMap.put(date, new HashMap<>());
                }
                
                // Add booked slots count
                Map<String, Integer> locationMap = bookingsCountMap.get(date);
                locationMap.put(location, locationMap.getOrDefault(location, 0) + bookedSlotsCount);
            }
            
            // Determine status for each date and location
            for (Map.Entry<String, Map<String, Integer>> entry : bookingsCountMap.entrySet()) {
                String date = entry.getKey();
                Map<String, Integer> locationBookings = entry.getValue();
                
                // Initialize status map for this date
                Map<String, String> statusMap = new HashMap<>();
                
                // Determine status for Robotics Lab
                int roboticsLabBookings = locationBookings.getOrDefault("HM Building, Robotics Lab", 0);
                statusMap.put("HM Building, Robotics Lab", getStatusByBookingCount(roboticsLabBookings));
                
                // Determine status for Future Lab
                int futureLabBookings = locationBookings.getOrDefault("E-12 Building, Future Lab", 0);
                statusMap.put("E-12 Building, Future Lab", getStatusByBookingCount(futureLabBookings));
                
                // Add to main map
                bookingStatusMap.put(date, statusMap);
            }
            
            // Add empty status for dates with no bookings in the range
            addEmptyDatesInRange(bookingStatusMap, startDate, endDate);
        }
        
        return bookingStatusMap;
    }

    /**
     * Helper method to determine booking status based on booked slots count
     */
    private String getStatusByBookingCount(int bookedSlotsCount) {
        int totalSlots = 12; // Total available time slots
        
        double occupancyRate = (double) bookedSlotsCount / totalSlots;
        
        if (occupancyRate >= 0.9) {
            return "full"; // 90% or more slots booked
        } else if (occupancyRate >= 0.6) {
            return "nearly-full"; // 60-90% slots booked
        } else {
            return "available"; // No bookings or less than 60% booked
        }
    }

    /**
     * Helper method to add all dates in range to the map with empty status if not already present
     */
    private void addEmptyDatesInRange(Map<String, Map<String, String>> bookingStatusMap, String startDate, String endDate) throws Exception {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date start = sdf.parse(startDate);
            Date end = sdf.parse(endDate);
            
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(start);
            
            while (!calendar.getTime().after(end)) {
                String dateStr = sdf.format(calendar.getTime());
                
                if (!bookingStatusMap.containsKey(dateStr)) {
                    Map<String, String> emptyStatus = new HashMap<>();
                    emptyStatus.put("HM Building, Robotics Lab", "empty");
                    emptyStatus.put("E-12 Building, Future Lab", "empty");
                    bookingStatusMap.put(dateStr, emptyStatus);
                }
                
                calendar.add(Calendar.DATE, 1);
            }
        } catch (ParseException e) {
            logger.error("Error parsing dates", e);
            throw new Exception("Invalid date format");
        }
    }

    /**
     * Gets detailed booking information for a specific date
     * @param date The date to get booking info for
     * @return Map with labs as keys and list of booked time slots as values
     */
    public Map<String, List<String>> getDetailedBookingByDate(String date) throws Exception {
        logger.info("Fetching detailed booking info for date: {}", date);
        Map<String, List<String>> bookingDetails = new HashMap<>();
        
        // Initialize with empty lists for both labs
        bookingDetails.put("HM Building, Robotics Lab", new ArrayList<>());
        bookingDetails.put("E-12 Building, Future Lab", new ArrayList<>());
        
        String query = "SELECT Location, TimeSlot FROM visitor_bookings WHERE BookingDate = ? AND Status != 'canceled'";
        
        try (Connection connection = dBConnection.getConnection();
            PreparedStatement stmt = connection.prepareStatement(query)) {
            
            stmt.setString(1, date);
            
            ResultSet resultSet = stmt.executeQuery();
            
            while (resultSet.next()) {
                String location = resultSet.getString("Location").trim();
                String timeSlots = resultSet.getString("TimeSlot");
                
                List<String> bookedSlots = bookingDetails.get(location);
                for (String slot : timeSlots.split(",")) {
                    bookedSlots.add(slot.trim());
                }
            }
        }
        
        return bookingDetails;
    }

    /**
     * Retrieves all lock dates for a specific month and year where BookingType is 'visitor'
     *
     * @param year The year (e.g., 2025)
     * @param month The month (1-12)
     * @return List of Maps containing lock date details, or an empty list if none found or an error occurs
     */
    public List<Map<String, Object>> getLockDatesByMonth(int year, int month) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> lockDatesList = new ArrayList<>();
        
        try {
            conn = dBConnection.getConnection();
            
            // Calculate the first and last day of the specified month
            LocalDate firstDayOfMonth = LocalDate.of(year, month, 1);
            LocalDate lastDayOfMonth = firstDayOfMonth.plusMonths(1).minusDays(1);
            
            // Format the dates as strings
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            String startDate = firstDayOfMonth.format(formatter);
            String endDate = lastDayOfMonth.format(formatter);
            
            String sql = "SELECT LockID, place_code, LockDate, LockReason, BookingType " +
                        "FROM lock_dates " +
                        "WHERE LockDate >= ? AND LockDate <= ? AND BookingType = 'visitor'";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> lockDate = new HashMap<>();
                lockDate.put("LockID", rs.getString("LockID"));
                lockDate.put("place_code", rs.getString("place_code"));
                lockDate.put("LockDate", rs.getDate("LockDate"));
                lockDate.put("LockReason", rs.getString("LockReason"));
                lockDate.put("BookingType", rs.getString("BookingType"));
                lockDatesList.add(lockDate);
            }
            
            logger.info("Retrieved {} visitor lock dates for {}-{}", 
                    lockDatesList.size(), year, month);
            
        } catch (SQLException e) {
            logger.error("Error retrieving visitor lock dates for month {}-{}", year, month, e);
        } catch (Exception e) {
            logger.error("Unexpected error while fetching visitor lock dates: {}", e.getMessage(), e);
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
        
        return lockDatesList;
    }

    /**
     * Checks if a specific date is locked for visitor bookings
     *
     * @param dateString The date to check in 'yyyy-MM-dd' format
     * @return true if the date is locked, false otherwise
     */
    public boolean isDateLocked(String dateString) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isLocked = false;
        
        try {
            conn = dBConnection.getConnection();
            
            String sql = "SELECT 1 FROM lock_dates " +
                        "WHERE LockDate = ? AND BookingType = 'visitor'";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dateString);
            
            rs = pstmt.executeQuery();
            
            isLocked = rs.next(); // If any record exists, date is locked
            
        } catch (SQLException e) {
            logger.error("Error checking if date {} is locked", dateString, e);
        } catch (Exception e) {
            logger.error("Unexpected error while checking locked date: {}", e.getMessage(), e);
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                logger.error("Error closing database resources", e);
            }
        }
        
        return isLocked;
    }
}