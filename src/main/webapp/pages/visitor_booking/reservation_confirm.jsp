<%@ page import="model.ReservationModel" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Details</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }
    
        body {
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px 10px; /* Padding for small screens and top area for "Back" button */
        }
    
        .container {
            width: 100%;
            max-width: 400px; /* Matches the card width in the image */
            background-color: white;
            border-radius: 10px; /* Rounded corners */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow for card effect */
            padding: 20px;
            margin: 0 auto;
            text-align: center;
        }
    
        .title {
            font-size: 17px;
            font-weight: 600;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            color: #333;
        }
    
        .info-grid {
            display: grid;
            grid-template-columns: 1fr; /* Single column for mobile */
            gap: 10px;
            padding: 15px 0;
            text-align: left;
        }
    
        .info-item {
            display: contents; /* Allows child elements to behave as grid items */
        }
    
        .info-label {
            color: #333;
            font-size: 14px;
            font-weight: 500;
            padding: 5px 0;
        }
    
        .info-value {
            font-size: 16px;
            padding: 5px 0;
            color: #000;
            word-wrap: break-word; /* Ensures long text wraps */
        }
    
        .note {
            color: #666;
            font-size: 12px;
            margin-top: 20px;
            padding: 0 10px;
            line-height: 1.5;
        }
    
        .confirm-btn {
            display: inline-block;
            width: 100%;
            max-width: 300px;
            padding: 12px;
            background-color: #e35205;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            margin-top: 25px;
            transition: background-color 0.3s;
        }
    
        .confirm-btn:hover {
            background-color: #c94704; /* Darker shade on hover */
        }
    
        /* Tablet and larger screens */
        @media (min-width: 768px) {
            .container {
                max-width: 500px;
                padding: 30px;
            }
    
            .title {
                font-size: 20px;
                padding: 15px 0;
            }
    
            .info-grid {
                grid-template-columns: 120px 1fr; /* Two columns for labels and values */
                gap: 15px;
                padding: 20px 0;
            }
    
            .info-label, .info-value {
                font-size: 16px;
            }
    
            .note {
                font-size: 13px;
                margin-top: 30px;
            }
    
            .confirm-btn {
                max-width: 350px;
                font-size: 18px;
                padding: 14px;
            }
        }
    
        /* Desktop and larger screens */
        @media (min-width: 1024px) {
            .container {
                max-width: 600px;
                padding: 40px;
            }
    
            .title {
                font-size: 22px;
                padding: 20px 0;
            }
    
            .info-grid {
                grid-template-columns: 150px 1fr;
                gap: 20px;
                padding: 25px 0;
            }
    
            .info-label, .info-value {
                font-size: 18px;
            }
    
            .note {
                font-size: 14px;
                margin-top: 35px;
            }
    
            .confirm-btn {
                max-width: 400px;
                font-size: 20px;
                padding: 16px;
            }
        }
    
        /* Handle horizontal orientation and smaller screens */
        @media (max-width: 480px) and (orientation: landscape) {
            .container {
                max-width: 90%;
                padding: 15px;
            }
    
            .info-grid {
                gap: 8px;
            }
    
            .info-label, .info-value {
                font-size: 12px;
            }
    
            .note {
                font-size: 10px;
                margin-top: 15px;
            }
    
            .confirm-btn {
                font-size: 14px;
                padding: 10px;
                margin-top: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="title">Reservation</div>
    
        <%
            ReservationModel reservation = (ReservationModel) request.getAttribute("reservation");
            if (reservation != null) {
                String[] dateParts = reservation.getBookingDate().split("-");
                String month = java.time.Month.of(Integer.parseInt(dateParts[1])).toString();
                String formattedDate = dateParts[2] + " " + month;
    
                // Process time slots to merge continuous ones (your existing logic)
                String rawTimeSlots = reservation.getTimeSlot();
                String[] slots = rawTimeSlots.split(",");
                List<String> mergedSlots = new ArrayList<>();
                String startTime = null;
                String endTime = null;
    
                for (String slot : slots) {
                    String[] times = slot.split("-");
                    if (times.length < 2) continue;
                    String currentStart = times[0].trim();
                    String currentEnd = times[1].trim();
    
                    if (startTime == null) {
                        startTime = currentStart;
                        endTime = currentEnd;
                    } else if (currentStart.equals(endTime)) {
                        endTime = currentEnd;
                    } else {
                        mergedSlots.add(startTime + " - " + endTime);
                        startTime = currentStart;
                        endTime = currentEnd;
                    }
                }
                if (startTime != null) {
                    mergedSlots.add(startTime + " - " + endTime);
                }
    
                String formattedTimeSlot = String.join(", ", mergedSlots);
        %>
    
        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Time</div>
                <div class="info-value"><%= formattedTimeSlot %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Date</div>
                <div class="info-value">
                    <%= java.time.LocalDate.parse(reservation.getBookingDate())
                           .format(java.time.format.DateTimeFormatter.ofPattern("E, dd MMM yyyy")) %>
                </div>
            </div>
            <div class="info-item">
                <div class="info-label">Name</div>
                <div class="info-value"><%= reservation.getName() %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Phone no.</div>
                <div class="info-value"><%= reservation.getPhone() %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Email</div>
                <div class="info-value"><%= reservation.getEmail() %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Location</div>
                <div class="info-value"><%= reservation.getLocation() %></div>
            </div>
        </div>
    
        <p class="note">Booking confirmation and details will be sent via email</p>
    
        <a href="<%= request.getContextPath() %>/pages/visitor_booking/complete.jsp" class="confirm-btn">CONFIRM</a>
    
        <% } %>
    </div>
</body>
</html>