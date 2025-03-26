<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RAI Common Area Booking - Select Time Slots</title>
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
            height: 100%;
            padding: 5% 5%;
            max-width: 100%;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
        }
        
        .time-slots-container {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        .date-header {
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .time-slots-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .time-slot {
            padding: 15px;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
            background-color: #f9f9f9;
        }
        
        .time-slot:hover:not(.booked):not(.locked) {
            background-color: #f0f0f0;
        }
        
        .time-slot.selected {
            background-color: #e35205;
            color: white;
        }
        
        .time-slot.booked {
            background-color: #ffe0e0;
            cursor: not-allowed;
            color: #999;
        }

        .time-slot.locked {
            background-color: #ffe0e0;
            cursor: not-allowed;
            color: #999;
            position: relative;
        }

        .time-slot.locked::after {
            content: "🔒";
            font-size: 10px;
            position: absolute;
            top: 5px;
            right: 5px;
        }
                
        .btn-confirm {
            width: 100%;
            padding: clamp(12px, 3vh, 20px);
            background-color: #e35205;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: clamp(14px, 4vw, 18px);
            text-transform: uppercase;
            cursor: pointer;
            text-align: center;
            margin-top: 20px;
        }
        
        .btn-confirm:hover {
            background-color: #e35205;
        }
        
        .btn-confirm.disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        
        /* Responsive adjustments */
        @media (min-width: 768px) {
            .container {
                padding: 3% 10%;
            }
        }
        
        @media (min-width: 1200px) {
            .container {
                padding: 2% 20%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="time-slots-container">
            <%
                // Format selected date from parameter
                String selectedDate = request.getParameter("selected_date");
                SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
                SimpleDateFormat outputFormat = new SimpleDateFormat("EEE d'th' MMM");
                
                String formattedDate = "";
                try {
                    Date date = inputFormat.parse(selectedDate);
                    formattedDate = outputFormat.format(date);
                } catch (Exception e) {
                    formattedDate = "Selected Date";
                }
                
                pageContext.setAttribute("formattedDate", formattedDate);
                pageContext.setAttribute("selectedDate", selectedDate);
            %>
            
            <jsp:useBean id="studentBookingDAO" class="dao.StudentBookingDAO" />
            <c:set var="placeCode" value="${param.place_code}" />
            <c:set var="lockDates" value="${studentBookingDAO.getLockDatesFromCurrentDate()}" />
            <c:set var="lockedTimeSlots" value="${[]}"/>
            
            <%-- Process lock information for the selected date and place --%>
            <c:forEach var="lockDate" items="${lockDates}">
                <c:if test="${lockDate.place_code eq placeCode && lockDate.LockDate eq selectedDate && lockDate.start_time != null && lockDate.end_time != null}">
                    <% 
                        // We'll store the locked time ranges to check against our slots
                        Map<String, Object> lockInfo = (Map<String, Object>)pageContext.getAttribute("lockDate");
                        if (lockInfo.get("start_time") != null && lockInfo.get("end_time") != null) {
                            java.sql.Time startTime = (java.sql.Time)lockInfo.get("start_time");
                            java.sql.Time endTime = (java.sql.Time)lockInfo.get("end_time");
                            
                            // Format to compare with our time slot format
                            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                            String startTimeStr = timeFormat.format(startTime);
                            String endTimeStr = timeFormat.format(endTime);
                            
                            pageContext.setAttribute("lockStartTime", startTimeStr);
                            pageContext.setAttribute("lockEndTime", endTimeStr);
                        }
                    %>
                </c:if>
            </c:forEach>
            
            <div class="date-header">${formattedDate}</div>
            
            <form id="timeSlotForm" action="select_seat.jsp" method="post">
                <!-- Hidden fields to carry over registration and date data -->
                <input type="hidden" name="name" value="${param.name}">
                <input type="hidden" name="email" value="${param.email}">
                <input type="hidden" name="phone" value="${param.phone}">
                <input type="hidden" name="location_id" value="${param.location_id}">
                <input type="hidden" name="location_string" value="${param.location_string}">
                <input type="hidden" name="place_code" value="${param.place_code}">
                <input type="hidden" name="selected_date" value="${param.selected_date}">
                <input type="hidden" name="selected_time_slots" id="selectedTimeSlotsInput">
                
                <div class="time-slots-grid">
                    <!-- Morning slots -->
                    <div class="time-slot" data-time="08:00-08:30" data-start="08:00" data-end="08:30" onclick="toggleTimeSlot(this)">8:00 - 8:30</div>
                    <div class="time-slot" data-time="12:30-13:00" data-start="12:30" data-end="13:00" onclick="toggleTimeSlot(this)">12:30 - 13:00</div>
                    
                    <div class="time-slot" data-time="08:30-09:00" data-start="08:30" data-end="09:00" onclick="toggleTimeSlot(this)">8:30 - 9:00</div>
                    <div class="time-slot" data-time="13:00-13:30" data-start="13:00" data-end="13:30" onclick="toggleTimeSlot(this)">13:00 - 13:30</div>
                    
                    <div class="time-slot" data-time="09:00-09:30" data-start="09:00" data-end="09:30" onclick="toggleTimeSlot(this)">9:00 - 9:30</div>
                    <div class="time-slot" data-time="13:30-14:00" data-start="13:30" data-end="14:00" onclick="toggleTimeSlot(this)">13:30 - 14:00</div>
                    
                    <div class="time-slot" data-time="09:30-10:00" data-start="09:30" data-end="10:00" onclick="toggleTimeSlot(this)">9:30 - 10:00</div>
                    <div class="time-slot" data-time="14:00-14:30" data-start="14:00" data-end="14:30" onclick="toggleTimeSlot(this)">14:00 - 14:30</div>
                    
                    <div class="time-slot" data-time="10:00-10:30" data-start="10:00" data-end="10:30" onclick="toggleTimeSlot(this)">10:00 - 10:30</div>
                    <div class="time-slot" data-time="14:30-15:00" data-start="14:30" data-end="15:00" onclick="toggleTimeSlot(this)">14:30 - 15:00</div>
                    
                    <div class="time-slot" data-time="10:30-11:00" data-start="10:30" data-end="11:00" onclick="toggleTimeSlot(this)">10:30 - 11:00</div>
                    <div class="time-slot" data-time="15:00-15:30" data-start="15:00" data-end="15:30" onclick="toggleTimeSlot(this)">15:00 - 15:30</div>
                    
                    <div class="time-slot" data-time="11:00-11:30" data-start="11:00" data-end="11:30" onclick="toggleTimeSlot(this)">11:00 - 11:30</div>
                    <div class="time-slot" data-time="15:30-16:00" data-start="15:30" data-end="16:00" onclick="toggleTimeSlot(this)">15:30 - 16:00</div>
                    
                    <div class="time-slot" data-time="11:30-12:00" data-start="11:30" data-end="12:00" onclick="toggleTimeSlot(this)">11:30 - 12:00</div>
                    <div class="time-slot" data-time="16:00-16:30" data-start="16:00" data-end="16:30" onclick="toggleTimeSlot(this)">16:00 - 16:30</div>
                    
                    <div class="time-slot" data-time="12:00-12:30" data-start="12:00" data-end="12:30" onclick="toggleTimeSlot(this)">12:00 - 12:30</div>
                    <div class="time-slot" data-time="16:30-17:00" data-start="16:30" data-end="17:00" onclick="toggleTimeSlot(this)">16:30 - 17:00</div>
                </div>
                
                <button type="submit" id="confirmButton" class="btn-confirm disabled">CONFIRM</button>
            </form>
        </div>
    </div>
    
    <script>
        let selectedTimeSlots = [];
        
        // Process the locked time slots from the server
        function checkAndMarkLockedTimeSlots() {
            // Get all time slots
            const slots = document.querySelectorAll('.time-slot');
            
            <c:forEach var="lockDate" items="${lockDates}">
                <c:if test="${lockDate.place_code eq placeCode && lockDate.LockDate eq selectedDate && not empty lockDate.start_time && not empty lockDate.end_time}">
                    const lockStartTime = "${lockDate.start_time}".substring(0, 5); // Format to HH:MM
                    const lockEndTime = "${lockDate.end_time}".substring(0, 5); // Format to HH:MM
                    
                    // Check each time slot to see if it overlaps with the locked range
                    slots.forEach(slot => {
                        const slotStart = slot.dataset.start;
                        const slotEnd = slot.dataset.end;
                        
                        // Logic to check for overlap: slot starts before lock ends AND slot ends after lock starts
                        if (slotStart < lockEndTime && slotEnd > lockStartTime) {
                            slot.classList.add('locked');
                        }
                    });
                </c:if>
            </c:forEach>
        }
        
        function toggleTimeSlot(slot) {
            // Skip if slot is already booked or locked
            if (slot.classList.contains('booked') || slot.classList.contains('locked')) {
                return;
            }
            
            // Toggle selection
            slot.classList.toggle('selected');
            
            // Update selected time slots array
            const timeSlotValue = slot.dataset.time;
            
            if (slot.classList.contains('selected')) {
                // Add to array if not already present
                if (!selectedTimeSlots.includes(timeSlotValue)) {
                    selectedTimeSlots.push(timeSlotValue);
                }
            } else {
                // Remove from array
                const index = selectedTimeSlots.indexOf(timeSlotValue);
                if (index > -1) {
                    selectedTimeSlots.splice(index, 1);
                }
            }
            
            // Update hidden input
            document.getElementById('selectedTimeSlotsInput').value = selectedTimeSlots.join(',');
            
            // Enable/disable confirm button based on selection
            const confirmButton = document.getElementById('confirmButton');
            if (selectedTimeSlots.length > 0) {
                confirmButton.classList.remove('disabled');
                confirmButton.disabled = false;
            } else {
                confirmButton.classList.add('disabled');
                confirmButton.disabled = true;
            }
        }
        
        // Store all form data in sessionStorage
        function storeFormData() {
            // Store previously saved data
            const previousData = {
                name: sessionStorage.getItem('bookingName'),
                email: sessionStorage.getItem('bookingEmail'),
                phone: sessionStorage.getItem('bookingPhone'),
                locationId: sessionStorage.getItem('bookingLocationId'),
                locationString: sessionStorage.getItem('bookingLocationString'),
                placeCode: sessionStorage.getItem('bookingPlaceCode'),
                date: sessionStorage.getItem('bookingDate')
            };
            
            // Store everything again plus the time slots
            sessionStorage.setItem('bookingName', previousData.name || "${param.name}");
            sessionStorage.setItem('bookingEmail', previousData.email || "${param.email}");
            sessionStorage.setItem('bookingPhone', previousData.phone || "${param.phone}");
            sessionStorage.setItem('bookingLocationId', previousData.locationId || "${param.location_id}");
            sessionStorage.setItem('bookingLocationString', previousData.locationString || "${param.location_string}");
            sessionStorage.setItem('bookingPlaceCode', previousData.placeCode || "${param.place_code}");
            sessionStorage.setItem('bookingDate', previousData.date || "${param.selected_date}");
            sessionStorage.setItem('bookingTimeSlots', selectedTimeSlots.join(','));
        }
        
        // Restore values from sessionStorage if available
        window.onload = function() {
            // First mark locked time slots
            checkAndMarkLockedTimeSlots();
            
            const storedTimeSlots = sessionStorage.getItem('bookingTimeSlots');
            if (storedTimeSlots) {
                const timeSlotArray = storedTimeSlots.split(',');
                
                // Mark slots as selected
                timeSlotArray.forEach(timeSlot => {
                    const slots = document.querySelectorAll('.time-slot');
                    for (let slot of slots) {
                        if (slot.dataset.time === timeSlot && !slot.classList.contains('locked')) {
                            slot.classList.add('selected');
                            selectedTimeSlots.push(timeSlot);
                        }
                    }
                });
                
                // Update hidden input
                document.getElementById('selectedTimeSlotsInput').value = selectedTimeSlots.join(',');
                
                // Enable confirm button
                if (selectedTimeSlots.length > 0) {
                    document.getElementById('confirmButton').classList.remove('disabled');
                    document.getElementById('confirmButton').disabled = false;
                }
            }
        };
        
        // Store form data when submitting the form
        document.getElementById('timeSlotForm').addEventListener('submit', function(e) {
            // Only proceed if at least one time slot is selected
            if (selectedTimeSlots.length === 0) {
                e.preventDefault();
                alert('Please select at least one time slot');
                return;
            }
            
            storeFormData();
        });
    </script>
</body>
</html>