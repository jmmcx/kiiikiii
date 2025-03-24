<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.StudentBookingModel" %>
<%@ page import="dao.StudentBookingDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RAI Common Area Booking - Confirm Booking</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
        
        html, body {
            height: 100%;
            width: 100%;
            background-color: #f5f5f5;
        }
        
        .container {
            width: 100%;
            min-height: 100%;
            padding: 20px;
            max-width: 100%;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .booking-confirmation {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            flex-grow: 1;
        }
        
        .confirmation-details {
            margin-bottom: 20px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: bold;
        }
        
        .info-value {
            text-align: right;
            word-break: break-word;
        }
        
        .booking-note {
            text-align: center;
            color: #777;
            font-size: 12px;
            margin: 20px 0;
        }
        
        .btn-container {
            margin-top: auto;
            padding-top: 20px;
        }
        
        .btn {
            width: 100%;
            padding: 15px;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            text-transform: uppercase;
            font-weight: bold;
            cursor: pointer;
            text-align: center;
            margin-top: 10px;
            display: block;
            text-decoration: none;
        }
        
        .btn-confirm {
            background-color: #e35205;
        }
        
        /* Responsive adjustments */
        @media (min-width: 768px) {
            .container {
                padding: 40px;
                max-width: 600px;
            }
            
            .booking-confirmation {
                padding: 30px;
            }
        }
        
        @media (min-width: 1200px) {
            .container {
                padding: 60px;
                max-width: 800px;
            }
        }
    </style>
</head>
<body>
    <%
        // Get parameters from the form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String locationId = request.getParameter("location_id");
        String locationString = request.getParameter("location_string");
        String selectedDate = request.getParameter("selected_date");
        String selectedTimeSlots = request.getParameter("selected_time_slots");
        String selectedRoom = request.getParameter("selected_room");
        String selectedSeats = request.getParameter("selected_seats");
        
        // Create formatter for displaying date
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat outputFormat = new SimpleDateFormat("EEE, d MMMM yyyy");
        
        // Parse and format the date
        String formattedDate = "";
        try {
            Date date = inputFormat.parse(selectedDate);
            formattedDate = outputFormat.format(date);
        } catch (Exception e) {
            formattedDate = selectedDate; // Fallback if parsing fails
        }
        
        // Format the time slots for display
        String formattedTimeSlot = "";
        if(selectedTimeSlots != null && !selectedTimeSlots.isEmpty()) {
            String[] slots = selectedTimeSlots.split(",");
            if(slots.length > 0) {
                // Find the start and end times for merged time slot display
                String[] firstSlot = slots[0].split("-");
                String[] lastSlot = slots[slots.length-1].split("-");
                
                if(firstSlot.length > 0 && lastSlot.length > 1) {
                    formattedTimeSlot = firstSlot[0] + " - " + lastSlot[1];
                }
            }
        }
        
        // Create StudentBooking model and populate with data
        StudentBookingModel booking = new StudentBookingModel();
        booking.setName(name);
        booking.setEmail(email);
        booking.setPhone(phone);
        booking.setLocation(locationString);

        booking.setBookingDate(selectedDate);
        booking.setTimeSlot(selectedTimeSlots);
        booking.setSeatCode(selectedSeats);
        
        // Store in session for next steps
        session.setAttribute("studentBooking", booking);
        
        // Make data available to JSTL
        pageContext.setAttribute("name", name);
        pageContext.setAttribute("email", email);
        pageContext.setAttribute("phone", phone);
        pageContext.setAttribute("locationString", locationString);
        pageContext.setAttribute("formattedDate", formattedDate);
        pageContext.setAttribute("formattedTimeSlot", formattedTimeSlot);
        pageContext.setAttribute("selectedRoom", selectedRoom);
        pageContext.setAttribute("selectedSeats", selectedSeats);
    %>
    <div class="container">
        <div class="booking-confirmation">
            <div class="confirmation-details">
                <div class="info-row">
                    <div class="info-label">Time</div>
                    <div class="info-value">${formattedTimeSlot}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Date</div>
                    <div class="info-value">${formattedDate}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Name</div>
                    <div class="info-value">${name}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Phone no.</div>
                    <div class="info-value">${phone}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Email</div>
                    <div class="info-value">${email}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Location</div>
                    <div class="info-value">${locationString}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">Zone/Seat</div>
                    <div class="info-value">
                        <%
                            String seatsDisplay = "";
                            if(selectedSeats != null && !selectedSeats.isEmpty()) {
                                String[] seatCodes = selectedSeats.split(",");
                                for(int i = 0; i < seatCodes.length; i++) {
                                    String seatCode = seatCodes[i];
                                    int lastDashIndex = seatCode.lastIndexOf('-');
                                    if(lastDashIndex > 0) {
                                        // Extract just the part after the last dash (S27)
                                        String seatNumber = seatCode.substring(lastDashIndex + 1);
                                        seatsDisplay += seatNumber;
                                        // Add '-' if not the last seat
                                        if(i < seatCodes.length - 1) {
                                            seatsDisplay += "-";
                                        }
                                    } else {
                                        // Fallback if format is unexpected
                                        seatsDisplay += seatCode;
                                        if(i < seatCodes.length - 1) {
                                            seatsDisplay += "-";
                                        }
                                    }
                                }
                            }
                            pageContext.setAttribute("seatsDisplay", seatsDisplay);
                        %>
                        ${selectedRoom}/${seatsDisplay}
                    </div>
                </div>
            </div>
            
            <div class="booking-note">
                Booking confirmation and details will be sent via email
            </div>
        </div>
        
        <div class="btn-container">
            <form id="finalBookingForm" action="complete_booking.jsp" method="post">
                <!-- Hidden inputs to pass data to the next step -->
                <input type="hidden" name="name" value="${name}">
                <input type="hidden" name="email" value="${email}">
                <input type="hidden" name="phone" value="${phone}">
                <input type="hidden" name="location_id" value="${param.location_id}">
                <input type="hidden" name="location_string" value="${locationString}">
                <input type="hidden" name="selected_date" value="${param.selected_date}">
                <input type="hidden" name="selected_time_slots" value="${param.selected_time_slots}">
                <input type="hidden" name="selected_room" value="${selectedRoom}">
                <input type="hidden" name="selected_seats" value="${selectedSeats}">
                <input type="hidden" name="formatted_time_slot" value="${formattedTimeSlot}">
                
                <button type="submit" class="btn btn-confirm">
                    CONFIRM
                </button>
            </form>
        </div>
    </div>

    <script>
        // Store booking data in session storage for access in next steps
        window.onload = function() {
            // Store all relevant booking data
            sessionStorage.setItem('bookingName', '${name}');
            sessionStorage.setItem('bookingEmail', '${email}');
            sessionStorage.setItem('bookingPhone', '${phone}');
            sessionStorage.setItem('bookingLocation', '${locationString}');
            sessionStorage.setItem('bookingDate', '${param.selected_date}');
            sessionStorage.setItem('bookingFormattedDate', '${formattedDate}');
            sessionStorage.setItem('bookingTimeSlots', '${param.selected_time_slots}');
            sessionStorage.setItem('bookingFormattedTimeSlot', '${formattedTimeSlot}');
            sessionStorage.setItem('bookingSelectedRoom', '${selectedRoom}');
            sessionStorage.setItem('bookingSelectedSeats', '${selectedSeats}');
        };
    </script>
</body>
</html>