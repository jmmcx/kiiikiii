<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="dao.ReservationDAO" %> 
<%
    // Get selected date from request
    String selectedDate = request.getParameter("date");
    
    if (selectedDate == null || selectedDate.isEmpty()) {
        out.println("<p>Error: No date selected</p>");
        return;
    }
    
    try {
        // Initialize DAO
        ReservationDAO bookingDAO = new ReservationDAO();
        
        // Get all time slots
        List<String> allTimeSlots = Arrays.asList(
            "09:00-09:30", "09:30-10:00", "10:00-10:30", "10:30-11:00",
            "11:00-11:30", "11:30-12:00", "13:00-13:30", "13:30-14:00",
            "14:00-14:30", "14:30-15:00", "15:00-15:30", "15:30-16:00"
        );
        
        // Get current time for today's slots
        LocalDate today = LocalDate.now();
        LocalDate selectedLocalDate = LocalDate.parse(selectedDate);
        LocalTime currentTime = LocalTime.now();
        boolean isToday = selectedLocalDate.equals(today);
        
        // Check if entire dates are locked for each location
        boolean isRoboticsFullyLocked = bookingDAO.isDateLocked(selectedDate, "HM Building, Robotics Lab");
        boolean isFutureLabFullyLocked = bookingDAO.isDateLocked(selectedDate, "E-12 Building, Future Lab");
        
        // Get booked slots for both labs
        Map<String, List<String>> bookingDetails = bookingDAO.getDetailedBookingByDate(selectedDate);
        
        // Get locked time slots for each lab
        List<String> roboticsLockedSlots = bookingDAO.getLockedTimeSlots(selectedDate, "HM Building, Robotics Lab");
        List<String> futureLabLockedSlots = bookingDAO.getLockedTimeSlots(selectedDate, "E-12 Building, Future Lab");
        
        // Robotics Lab slots
        List<String> roboticsBookedSlots = bookingDetails.get("HM Building, Robotics Lab");
        
        // Future Lab slots
        List<String> futureLabBookedSlots = bookingDetails.get("E-12 Building, Future Lab");
%>
    <!-- Robotics Lab Time Slots -->
    <div class="lab-slots">
        <h3>Robotics Lab</h3>
        <div class="slots-grid">
            <% for (String slot : allTimeSlots) { 
                // Determine slot status
                boolean isFullyLocked = isRoboticsFullyLocked;
                boolean isBooked = roboticsBookedSlots.contains(slot);
                boolean isPartiallyLocked = roboticsLockedSlots.contains(slot);
                
                // Check if slot is in the past for today
                boolean isPastTime = false;
                if (isToday) {
                    String endTime = slot.split("-")[1];
                    LocalTime slotEndTime = LocalTime.parse(endTime);
                    isPastTime = currentTime.isAfter(slotEndTime);
                }
                
                // Combine lock conditions
                boolean isLocked = isFullyLocked || isPartiallyLocked;
                
                // Determine availability
                boolean isAvailable = !isBooked && !isLocked && !isPastTime;
            %>
                <div class="time-slot <%= isBooked ? "slot-booked" : (isLocked ? "slot-locked" : (isPastTime ? "slot-past" : "slot-available")) %>" 
                     <%= isAvailable ? "data-lab=\"HM Building, Robotics Lab\" data-slot=\"" + slot + "\"" : "" %>>
                    <%= slot %>
                    <% if (isLocked) { %><span class="lock-icon">🔒</span><% } %>
                    <% if (isPastTime && !isBooked && !isLocked) { %><span class="time-icon">⏱️</span><% } %>
                </div>
            <% } %>
        </div>
    </div>
    
    <!-- Future Lab Time Slots -->
    <div class="lab-slots">
        <h3>Future Lab</h3>
        <div class="slots-grid">
            <% for (String slot : allTimeSlots) { 
                // Determine slot status
                boolean isFullyLocked = isFutureLabFullyLocked;
                boolean isBooked = futureLabBookedSlots.contains(slot);
                boolean isPartiallyLocked = futureLabLockedSlots.contains(slot);
                
                // Check if slot is in the past for today
                boolean isPastTime = false;
                if (isToday) {
                    String endTime = slot.split("-")[1];
                    LocalTime slotEndTime = LocalTime.parse(endTime);
                    isPastTime = currentTime.isAfter(slotEndTime);
                }
                
                // Combine lock conditions
                boolean isLocked = isFullyLocked || isPartiallyLocked;
                
                // Determine availability
                boolean isAvailable = !isBooked && !isLocked && !isPastTime;
            %>
                <div class="time-slot <%= isBooked ? "slot-booked" : (isLocked ? "slot-locked" : (isPastTime ? "slot-past" : "slot-available")) %>" 
                     <%= isAvailable ? "data-lab=\"E-12 Building, Future Lab\" data-slot=\"" + slot + "\"" : "" %>>
                    <%= slot %>
                    <% if (isLocked) { %><span class="lock-icon">🔒</span><% } %>
                    <% if (isPastTime && !isBooked && !isLocked) { %><span class="time-icon">⏱️</span><% } %>
                </div>
            <% } %>
        </div>
    </div>
<%
    } catch (Exception e) {
        out.println("<p>Error loading time slots: " + e.getMessage() + "</p>");
    }
%>