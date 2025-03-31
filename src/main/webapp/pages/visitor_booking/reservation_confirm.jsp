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
            width: 1080px;
            height: 1920px;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 0;
            margin: 0;
        }

        /* Back arrow styles - positioned appropriately for 1080x1920 */
        .back-button {
            position: fixed;
            top: 100px;
            left: 60px;
            z-index: 100;
        }

        .back-button img {
            width: 80px;
            height: 80px;
        }

        .container {
            width: 800px;
            background-color: white;
            border-radius: 20px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            padding: 50px;
            margin: 0 auto;
            text-align: center;
        }

        .title {
            font-size: 36px;
            font-weight: 600;
            padding: 30px 0;
            border-bottom: 2px solid #eee;
            color: #333;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 220px 1fr;
            gap: 30px;
            padding: 40px 0;
            text-align: left;
        }

        .info-item {
            display: contents;
        }

        .info-label {
            color: #333;
            font-size: 28px;
            font-weight: 500;
            padding: 10px 0;
        }

        .info-value {
            font-size: 30px;
            padding: 10px 0;
            color: #000;
            word-wrap: break-word;
        }

        .note {
            color: #666;
            font-size: 24px;
            margin-top: 40px;
            padding: 0 20px;
            line-height: 1.5;
        }

        .confirm-btn {
            display: inline-block;
            width: 500px;
            padding: 25px;
            background-color: #e35205;
            color: white;
            border: none;
            border-radius: 15px;
            font-size: 32px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            margin-top: 60px;
            transition: background-color 0.3s;
        }

        .confirm-btn:hover {
            background-color: #c94704;
        }
    </style>
</head>
<body>
    <div class="back-button">
        <a href="register.jsp">
            <img src="<%= request.getContextPath() %>/images/back_arrow.png" alt="Back" class="back-button img">
        </a>
    </div>

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
