<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.StudentBookingDAO" %>
<%@ page import="com.google.gson.Gson" %>
<%
    // Get parameters
    String roomCode = request.getParameter("room_code");
    String date = request.getParameter("date");
    String timeSlots = request.getParameter("time_slots");
    
    // Create DAO instance
    StudentBookingDAO bookingDAO = new StudentBookingDAO();
    
    // Get room details with availability
    Map<String, Object> roomDetails = bookingDAO.getRoomDetailsWithAvailability(roomCode, date, timeSlots);
    
    // Convert to JSON and send response
    Gson gson = new Gson();
    String jsonResponse = gson.toJson(roomDetails);
    
    // Set content type and write response
    response.setContentType("application/json");
    response.getWriter().write(jsonResponse);
%>