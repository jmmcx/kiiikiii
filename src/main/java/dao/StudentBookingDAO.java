package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
// import java.util.UUID;
import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import bean.dBConnection;
import model.StudentBookingModel;

public class StudentBookingDAO {
    private static final Logger logger = LogManager.getLogger(StudentBookingDAO.class);

    // ** this DAO contain all method relate to student booking room website **

    /**
     * Retrieves all places from the database
     * 
     * @return List of Maps containing place details, or an empty list if none found or an error occurs
     */
    public List<Map<String, Object>> getAllPlaces() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> placesList = new ArrayList<>();
        
        try {
            conn = dBConnection.getConnection();
            
            String sql = "SELECT place_id, place_code, building_name, location_name, created_at, updated_at FROM places";
            pstmt = conn.prepareStatement(sql);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> place = new HashMap<>();
                place.put("place_id", rs.getInt("place_id"));
                place.put("place_code", rs.getString("place_code"));
                place.put("building_name", rs.getString("building_name"));
                place.put("location_name", rs.getString("location_name"));
                place.put("created_at", rs.getTimestamp("created_at"));
                place.put("updated_at", rs.getTimestamp("updated_at"));
                placesList.add(place);
            }
            
            logger.info("Retrieved {} places from the database", placesList.size());
            
        } catch (SQLException e) {
            logger.error("Error retrieving places from the database", e);
        } catch (Exception e) {
            logger.error("Unexpected error while fetching places: {}", e.getMessage(), e);
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
        
        return placesList;
    }

    /**
     * Retrieves all lock dates that are greater than or equal to the current date
     * 
     * @return List of Maps containing lock date details, or an empty list if none found or an error occurs
     */
    public List<Map<String, Object>> getLockDatesFromCurrentDate() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> lockDatesList = new ArrayList<>();
        
        try {
            conn = dBConnection.getConnection();
            
            // Get current date in 'YYYY-MM-DD' format
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String currentDate = dateFormat.format(new Date());
            
            String sql = "SELECT LockID, place_code, LockDate, LockReason, BookingType " +
             "FROM lock_dates " +
             "WHERE LockDate >= ? AND BookingType = 'student'";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, currentDate);
            
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
            
            logger.info("Retrieved {} lock dates from the current date: {}", lockDatesList.size(), currentDate);
            
        } catch (SQLException e) {
            logger.error("Error retrieving lock dates from the current date", e);
        } catch (Exception e) {
            logger.error("Unexpected error while fetching lock dates: {}", e.getMessage(), e);
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
    
    // Get available time slots for a date and location  ** from student_bookings table
    public List<String> getAvailableTimeSlots(String date, String location) throws Exception {
        logger.info("Fetching available time slots for date: {}, location: {}", date, location);
        List<String> availableSlots = new ArrayList<>();
        List<String> bookedSlots = new ArrayList<>();
    
        String query = "SELECT TimeSlot FROM student_bookings WHERE Location = ? AND BookingDate = ? AND Status != 'cancelled'";
    
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
            "08:00-08:30", "08:30-09:00", "09:00-09:30", "09:30-10:00", "10:00-10:30", 
            "10:30-11:00", "11:00-11:30", "11:30-12:00", "13:00-13:30", "13:30-14:00",
            "14:00-14:30", "14:30-15:00", "15:00-15:30", "15:30-16:00", "16:00-16:30", "16:30-17:00"
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
     * Checks if all seats at a specific location are fully booked for a given date
     * 
     * @param date The date to check in yyyy-MM-dd format
     * @param placeCode The place code (e.g., "RB", "ST")
     * @return true if all seats are booked, false otherwise
     */
    public boolean areAllSeatsBooked(String date, String placeCode) {
        Connection conn = null;
        PreparedStatement pstmtBookings = null;
        PreparedStatement pstmtAllSeats = null;
        ResultSet rsBookings = null;
        ResultSet rsAllSeats = null;
        boolean allBooked = false;
        
        try {
            conn = dBConnection.getConnection();
            
            // Step 1: Get all booked seat codes for the specified date and place code prefix
            String bookingsQuery = "SELECT SeatCode FROM student_bookings WHERE BookingDate = ? AND SeatCode LIKE ? AND Status != 'cancelled'";
            pstmtBookings = conn.prepareStatement(bookingsQuery);
            pstmtBookings.setString(1, date);
            pstmtBookings.setString(2, placeCode + "%");
            
            rsBookings = pstmtBookings.executeQuery();
            
            // Create a set of booked seat codes
            Set<String> bookedSeatCodes = new HashSet<>();
            while (rsBookings.next()) {
                bookedSeatCodes.add(rsBookings.getString("SeatCode"));
            }
            
            logger.info("Found {} booked seats for date: {} and place code: {}", bookedSeatCodes.size(), date, placeCode);
            
            // Step 2: Get all available seat codes for the place
            String allSeatsQuery = "SELECT seat_code FROM seats WHERE seat_code LIKE ?";
            pstmtAllSeats = conn.prepareStatement(allSeatsQuery);
            pstmtAllSeats.setString(1, placeCode + "%");
            
            rsAllSeats = pstmtAllSeats.executeQuery();
            
            // Create a set of all seat codes
            Set<String> allSeatCodes = new HashSet<>();
            while (rsAllSeats.next()) {
                allSeatCodes.add(rsAllSeats.getString("seat_code"));
            }
            
            logger.info("Total seats available for place code {}: {}", placeCode, allSeatCodes.size());
            
            // Check if all seats are booked
            if (!allSeatCodes.isEmpty()) {
                allBooked = bookedSeatCodes.size() >= allSeatCodes.size();
            }
            
        } catch (SQLException e) {
            logger.error("Error checking seat availability", e);
        } catch (Exception e) {
            logger.error("Unexpected error while checking seat availability: {}", e.getMessage(), e);
        } finally {
            // Close resources in reverse order of creation
            try {
                if (rsAllSeats != null) rsAllSeats.close();
                if (pstmtAllSeats != null) pstmtAllSeats.close();
                if (rsBookings != null) rsBookings.close();
                if (pstmtBookings != null) pstmtBookings.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                logger.error("Error closing database resources", e);
            }
        }
        
        return allBooked;
    }

        /**
     * Retrieves all rooms by place code
     * 
     * @param placeCode The place code (e.g., "RB")
     * @return List of Maps containing room details, or an empty list if none found or an error occurs
     */
    public List<Map<String, Object>> getRoomsByPlace(String placeCode) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> roomsList = new ArrayList<>();
        
        try {
            conn = dBConnection.getConnection();
            
            String sql = "SELECT r.room_id, r.room_code, r.room_name, r.pos_x, r.pos_y, r.width, r.height " +
                         "FROM rooms r " +
                         "JOIN places p ON r.place_id = p.place_id " +
                         "WHERE p.place_code = ? OR SUBSTRING(r.room_code, 1, 2) = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, placeCode);
            pstmt.setString(2, placeCode);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> room = new HashMap<>();
                room.put("room_id", rs.getInt("room_id"));
                room.put("room_code", rs.getString("room_code"));
                room.put("room_name", rs.getString("room_name"));
                room.put("pos_x", rs.getDouble("pos_x"));
                room.put("pos_y", rs.getDouble("pos_y"));
                room.put("width", rs.getDouble("width"));
                room.put("height", rs.getDouble("height"));
                roomsList.add(room);
            }
            
            logger.info("Retrieved {} rooms for place code: {}", roomsList.size(), placeCode);
            
        } catch (SQLException e) {
            logger.error("Error retrieving rooms by place code", e);
        } catch (Exception e) {
            logger.error("Unexpected error while fetching rooms: {}", e.getMessage(), e);
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
        
        return roomsList;
    }
    
    /**
     * Retrieves the total number of seats in a room
     * 
     * @param roomCode The room code (e.g., "RB1")
     * @return Total number of seats in the room
     */
    public int getTotalSeatsByRoom(String roomCode) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int totalSeats = 0;
        
        try {
            conn = dBConnection.getConnection();
            
            String sql = "SELECT COUNT(s.seat_id) as total_seats " +
                         "FROM seats s " +
                         "JOIN room_tables rt ON s.table_id = rt.table_id " +
                         "JOIN rooms r ON rt.room_id = r.room_id " +
                         "WHERE r.room_code = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, roomCode);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                totalSeats = rs.getInt("total_seats");
            }
            
            logger.info("Retrieved total {} seats for room: {}", totalSeats, roomCode);
            
        } catch (SQLException e) {
            logger.error("Error retrieving total seats by room code", e);
        } catch (Exception e) {
            logger.error("Unexpected error while fetching total seats: {}", e.getMessage(), e);
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
        
        return totalSeats;
    }
    
    /**
     * Retrieves tables and their details for a specific room
     * 
     * @param roomCode The room code (e.g., "RB1")
     * @return List of Maps containing table details, or an empty list if none found or an error occurs
     */
    public List<Map<String, Object>> getTablesByRoom(String roomCode) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> tablesList = new ArrayList<>();
        
        try {
            conn = dBConnection.getConnection();
            
            String sql = "SELECT rt.table_id, rt.table_code, rt.table_name, rt.pos_x, rt.pos_y, rt.width, rt.height " +
                         "FROM room_tables rt " +
                         "JOIN rooms r ON rt.room_id = r.room_id " +
                         "WHERE r.room_code = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, roomCode);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> table = new HashMap<>();
                table.put("table_id", rs.getInt("table_id"));
                table.put("table_code", rs.getString("table_code"));
                table.put("table_name", rs.getString("table_name"));
                table.put("pos_x", rs.getDouble("pos_x"));
                table.put("pos_y", rs.getDouble("pos_y"));
                table.put("width", rs.getDouble("width"));
                table.put("height", rs.getDouble("height"));
                tablesList.add(table);
            }
            
            logger.info("Retrieved {} tables for room: {}", tablesList.size(), roomCode);
            
        } catch (SQLException e) {
            logger.error("Error retrieving tables by room code", e);
        } catch (Exception e) {
            logger.error("Unexpected error while fetching tables: {}", e.getMessage(), e);
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
        
        return tablesList;
    }
    
    /**
     * Retrieves seats and their details for a specific room
     * 
     * @param roomCode The room code (e.g., "RB1")
     * @return List of Maps containing seat details, or an empty list if none found or an error occurs
     */
    public List<Map<String, Object>> getSeatsByRoom(String roomCode) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> seatsList = new ArrayList<>();
        
        try {
            conn = dBConnection.getConnection();
            
            String sql = "SELECT s.seat_id, s.seat_code, s.seat_number, s.pos_x, s.pos_y, s.radius, rt.table_code " +
                         "FROM seats s " +
                         "JOIN room_tables rt ON s.table_id = rt.table_id " +
                         "JOIN rooms r ON rt.room_id = r.room_id " +
                         "WHERE r.room_code = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, roomCode);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> seat = new HashMap<>();
                seat.put("seat_id", rs.getInt("seat_id"));
                seat.put("seat_code", rs.getString("seat_code"));
                seat.put("seat_number", rs.getInt("seat_number"));
                seat.put("pos_x", rs.getDouble("pos_x"));
                seat.put("pos_y", rs.getDouble("pos_y"));
                seat.put("radius", rs.getDouble("radius"));
                seat.put("table_code", rs.getString("table_code"));
                seatsList.add(seat);
            }
            
            logger.info("Retrieved {} seats for room: {}", seatsList.size(), roomCode);
            
        } catch (SQLException e) {
            logger.error("Error retrieving seats by room code", e);
        } catch (Exception e) {
            logger.error("Unexpected error while fetching seats: {}", e.getMessage(), e);
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
        
        return seatsList;
    }
    
    /**
     * Checks seat availability for a specific room, date, and time slots
     * 
     * @param roomCode The room code (e.g., "RB1")
     * @param date The selected date in 'YYYY-MM-DD' format
     * @param timeSlots Comma-separated time slots (e.g., "08:00-08:30,08:30-09:00")
     * @return List of Maps containing seat details with availability status
     */
    public List<Map<String, Object>> checkSeatAvailability(String roomCode, String date, String timeSlots) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> seatsWithAvailability = new ArrayList<>();
        
        try {
            conn = dBConnection.getConnection();
            
            // First get all seats for the room
            List<Map<String, Object>> allSeats = getSeatsByRoom(roomCode);
            
            // Split time slots selected by the user
            String[] userTimeSlotArray = timeSlots.split(",");
            
            // For each seat, check if it's booked for any of the selected time slots
            for (Map<String, Object> seat : allSeats) {
                String seatCode = (String) seat.get("seat_code");
                boolean isAvailable = true;
                
                // Modified SQL to handle comma-separated time slots in the database
                String sql = "SELECT BookingDate, TimeSlot " +
                            "FROM student_bookings " +
                            "WHERE SeatCode = ? AND BookingDate = ? " +
                            "AND Status != 'canceled'";
                
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, seatCode);
                pstmt.setString(2, date);
                
                rs = pstmt.executeQuery();
                
                // Check each booking record
                while (rs.next() && isAvailable) {
                    String dbTimeSlots = rs.getString("TimeSlot");
                    String[] dbTimeSlotArray = dbTimeSlots.split(",");
                    
                    // Check for any overlap between user-selected time slots and db time slots
                    for (String userTimeSlot : userTimeSlotArray) {
                        for (String dbTimeSlot : dbTimeSlotArray) {
                            if (userTimeSlot.trim().equals(dbTimeSlot.trim())) {
                                isAvailable = false;
                                break;
                            }
                        }
                        if (!isAvailable) break;
                    }
                }
                
                // Add availability status to seat info
                seat.put("is_available", isAvailable);
                seatsWithAvailability.add(seat);
            }
            
            logger.info("Checked availability for {} seats in room {} for date {} and {} time slots", 
                    allSeats.size(), roomCode, date, userTimeSlotArray.length);
            
        } catch (SQLException e) {
            logger.error("Error checking seat availability", e);
        } catch (Exception e) {
            logger.error("Unexpected error while checking availability: {}", e.getMessage(), e);
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
        
        return seatsWithAvailability;
    }
    
    /**
     * Gets all information needed for the seat selection view, including room tables and seats with availability
     * 
     * @param roomCode The room code (e.g., "RB1")
     * @param date The selected date in 'YYYY-MM-DD' format
     * @param timeSlots Comma-separated time slots (e.g., "08:00-08:30,08:30-09:00")
     * @return Map containing tables and seats with availability information
     */
    public Map<String, Object> getRoomDetailsWithAvailability(String roomCode, String date, String timeSlots) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Get tables in the room
            List<Map<String, Object>> tables = getTablesByRoom(roomCode);
            result.put("tables", tables);
            
            // Get seats with availability
            List<Map<String, Object>> seatsWithAvailability = checkSeatAvailability(roomCode, date, timeSlots);
            result.put("seats", seatsWithAvailability);
            
            logger.info("Retrieved complete room details with availability for room: {}", roomCode);
            
        } catch (Exception e) {
            logger.error("Error getting room details with availability: {}", e.getMessage(), e);
        }
        
        return result;
    }

    public boolean createBooking(StudentBookingModel booking) throws Exception {
        String sql = "INSERT INTO student_bookings (BookingID, Name, Email, Phone, Location, " +
                     "BookingDate, TimeSlot, MergedTimeSlot, SeatCode, Status, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            // Set the current timestamp for creation time
            Timestamp currentTime = new Timestamp(System.currentTimeMillis());
            booking.setCreatedAt(currentTime);
            
            // Set initial status to pending
            //booking.setStatus("pending");
            
            // Set parameters for the prepared statement
            pstmt.setString(1, booking.getBookingID());
            pstmt.setString(2, booking.getName());
            pstmt.setString(3, booking.getEmail());
            pstmt.setString(4, booking.getPhone());
            pstmt.setString(5, booking.getLocation());
            //pstmt.setDate(6, new java.sql.Date(booking.getBookingDate().getTime()));
            pstmt.setString(6, booking.getBookingDate());
            pstmt.setString(7, booking.getTimeSlot());
            pstmt.setString(8, booking.getMergedTimeSlot());
            pstmt.setString(9, booking.getSeatCode());
            pstmt.setString(10, booking.getStatus());
            pstmt.setTimestamp(11, booking.getCreatedAt());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            logger.error("Error in saving student booking to Database" + e.getMessage());
            return false;
        }
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
            
            String sql = "SELECT Status FROM student_bookings WHERE BookingID = ?";
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

    /**
     * Retrieves a booking by its booking ID
     * 
     * @param bookingID The booking ID to search for
     * @return StudentBookingModel object if found, null otherwise
          * @throws Exception 
          */
        public StudentBookingModel getStudentBookingByBookingID(String bookingID) throws Exception {
        StudentBookingModel booking = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dBConnection.getConnection(); 
            
            String sql = "SELECT * FROM student_bookings WHERE BookingID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, bookingID);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                booking = new StudentBookingModel();
                booking.setBookingID(rs.getString("bookingID"));
                booking.setName(rs.getString("name"));
                booking.setEmail(rs.getString("email"));
                booking.setPhone(rs.getString("phone"));
                booking.setLocation(rs.getString("location"));
                booking.setBookingDate(rs.getString("bookingDate"));
                booking.setTimeSlot(rs.getString("timeSlot"));
                booking.setSeatCode(rs.getString("seatCode"));
                booking.setStatus(rs.getString("status"));
                booking.setCreatedAt(rs.getTimestamp("createdAt"));
                booking.setConfirmedAt(rs.getTimestamp("confirmedAt"));
                booking.setCanceledAt(rs.getTimestamp("canceledAt"));
                booking.setCheckedInAt(rs.getTimestamp("checkedInAt"));
                booking.setUpdatedAt(rs.getTimestamp("updatedAt"));
            }
        } catch (SQLException e) {
            logger.error("Error retrieving student booking by ID: " + bookingID, e);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                logger.error("Error closing database resources", e);
            }
        }
        
        return booking;
    }

    public boolean updateBookingStatus(String bookingID, String newStatus) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = dBConnection.getConnection();
            
            String sql = "UPDATE student_bookings SET Status = ?, CheckedInAt = ? WHERE BookingID = ?";
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
}