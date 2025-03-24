<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.StudentBookingDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RAI Common Area Booking - Select Seat</title>
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
        
        .room-selection-container {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        
        .room-diagram {
            width: 100%;
            aspect-ratio: 16/9;
            /* margin-bottom: 5px; */
            position: relative;
            background-color: white;
        }
        
        .room {
            position: absolute;
            background-color: #ddd;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            font-weight: bold;
        }
        /*
        .room.selected {
            background-color: #e35205;
            color: white;
        } */
        .selected {
            background-color: #e35205;
            color: white;
        }

        
        .total-seats {
            background-color: #ddd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .total-seats h3 {
            text-align: center;
            margin-bottom: 15px;
        }
        
        .room-seats {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .room-seat-item {
            background-color: white;
            padding: 10px;
            border-radius: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .seat-selection-container {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
            display: none;
        }
        
        .table-diagram {
            width: 100%;
            aspect-ratio: 16/9;
            position: relative;
            background-color: white;
            margin-bottom: 20px;
        }
        
        .table {
            position: absolute;
            background-color: #ddd;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: bold;
        }
        
        .seat {
            position: absolute;
            background-color: #ffff80;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 12px;
            cursor: pointer;
        }
        
        .seat.unavailable {
            background-color: #ffff80;
            cursor: not-allowed;
            position: relative;
        }
        
        .seat.unavailable::before,
        .seat.unavailable::after {
            content: '';
            position: absolute;
            width: 70%;
            height: 2px;
            background-color: #e74c3c;
            top: 50%;
            left: 15%;
        }
        
        .seat.unavailable::before {
            transform: rotate(45deg);
        }
        
        .seat.unavailable::after {
            transform: rotate(-45deg);
        }
        
        .seat.selected {
            background-color: #e35205;
            color: white;
        }
        
        .btn {
            width: 100%;
            padding: clamp(12px, 3vh, 20px);
            color: white;
            border: none;
            border-radius: 25px;
            font-size: clamp(14px, 4vw, 18px);
            text-transform: uppercase;
            cursor: pointer;
            text-align: center;
            margin-top: 20px;
        }
        
        .btn-confirm {
            background-color: #ccc;
        }
        
        .btn-confirm.enabled {
            background-color: #e35205;
        }
        
        .btn-check {
            background-color: #e35205;
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
        <%
            // Get parameters
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String locationId = request.getParameter("location_id");
            String locationString = request.getParameter("location_string");
            String placeCode = request.getParameter("place_code");
            String selectedDate = request.getParameter("selected_date");
            String selectedTimeSlots = request.getParameter("selected_time_slots");
            
            // Create DAO instance
            StudentBookingDAO bookingDAO = new StudentBookingDAO();
            
            // Get rooms by place code
            List<Map<String, Object>> rooms = bookingDAO.getRoomsByPlace(placeCode);
            
            // Set attributes for JSTL
            pageContext.setAttribute("rooms", rooms);
            pageContext.setAttribute("placeCode", placeCode);
        %>
        <!-- please ignore this error, the code really work ;-; -->
        <div class="room-selection-container">
            <div class="room-diagram">
                <c:forEach items="${rooms}" var="room">
                    <div class="room"
                        style="left: ${room.pos_x}%; 
                               top: ${room.pos_y}%; 
                               width: ${room.width}%; 
                               height: ${room.height}%;"
                        data-room-code="${room.room_code}"
                        onclick="selectRoom('${room.room_code}')">
                        ${room.room_code}
                    </div>
                </c:forEach>
            </div>
            
            <div class="total-seats">
                <h3>TOTAL SEAT</h3>
                <div class="room-seats">
                    <c:forEach items="${rooms}" var="room">
                        <%
                            Map<String, Object> roomMap = (Map<String, Object>)pageContext.getAttribute("room");
                            String roomCode = (String)roomMap.get("room_code");
                            int totalSeats = bookingDAO.getTotalSeatsByRoom(roomCode);
                            pageContext.setAttribute("totalSeats", totalSeats);
                        %>
                        <div class="room-seat-item">
                            <span>${room.room_code}</span>
                            <span>${totalSeats} seats</span>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <button type="button" id="checkAvailabilityBtn" class="btn btn-check" onclick="checkSeatAvailability()">
                CHECK SEAT AVAILABLE
            </button>
        </div>
        
        <div id="seatSelectionContainer" class="seat-selection-container">
            <div id="tableDiagram" class="table-diagram">
                <!-- Tables and seats will be loaded dynamically -->
            </div>
            
            <form id="seatSelectionForm" action="confirm_booking.jsp" method="post">
                <!-- Hidden fields to carry over data -->
                <input type="hidden" name="name" value="${param.name}">
                <input type="hidden" name="email" value="${param.email}">
                <input type="hidden" name="phone" value="${param.phone}">
                <input type="hidden" name="location_id" value="${param.location_id}">
                <input type="hidden" name="location_string" value="${param.location_string}">
                <input type="hidden" name="place_code" value="${param.place_code}">
                <input type="hidden" name="selected_date" value="${param.selected_date}">
                <input type="hidden" name="selected_time_slots" value="${param.selected_time_slots}">
                <input type="hidden" name="selected_room" id="selectedRoomInput">
                <input type="hidden" name="selected_seats" id="selectedSeatsInput">
                
                <button type="submit" id="confirmButton" class="btn btn-confirm">
                    CONFIRM
                </button>
            </form>
        </div>
    </div>
    
    <script>
        let selectedRoom = null;
        let selectedSeats = [];
        const MAX_SEATS = 5;
        
        // Initialize from session storage if available
        window.onload = function() {
            const storedRoom = sessionStorage.getItem('bookingSelectedRoom');
            if (storedRoom) {
                selectRoom(storedRoom);
                
                // If seats were previously selected
                const storedSeats = sessionStorage.getItem('bookingSelectedSeats');
                if (storedSeats) {
                    selectedSeats = storedSeats.split(',');
                    document.getElementById('selectedSeatsInput').value = storedSeats;
                    updateConfirmButton();
                }
            }
        };
        
        function selectRoom(roomCode) {
            // Clear previous selection
            const roomElements = document.querySelectorAll('.room');
            roomElements.forEach(room => {
                room.classList.remove('selected');
            });
            
            // Select new room
            selectedRoom = roomCode;
            document.getElementById('selectedRoomInput').value = roomCode;
            sessionStorage.setItem('bookingSelectedRoom', roomCode);
            
            // Highlight selected room
            const selectedRoomElement = document.querySelector(`[data-room-code="${roomCode}"]`);
            if (selectedRoomElement) {
                selectedRoomElement.classList.add('selected');
                selectedRoomElement.style.backgroundColor = "#e35205"; // Change to orange
                selectedRoomElement.style.color = "white"; // Change text color
            }
        }
        
        function checkSeatAvailability() {
            if (!selectedRoom) {
                alert('Please select a room first');
                return;
            }
            
            // Show seat selection container
            document.getElementById('seatSelectionContainer').style.display = 'block';
            
            // Get selected time slots from form/parameter
            const selectedTimeSlots = '${param.selected_time_slots}';
            const selectedDate = '${param.selected_date}';
            
            // AJAX call to get room details with seat availability
            fetch('<%= request.getContextPath() %>/pages/student_booking/get_room_detail.jsp?room_code=' + selectedRoom + '&date=' + selectedDate + '&time_slots=' + selectedTimeSlots)
                .then(response => response.json())
                .then(data => {
                    renderRoomDetails(data);
                })
                .catch(error => {
                    console.error('Error fetching room details:', error);
                    alert('Failed to load seat availability. Please try again.');
                });
        }
        
        function renderRoomDetails(data) {
            const tablesDiagram = document.getElementById('tableDiagram');
            tablesDiagram.innerHTML = '';
            
            // First render tables
            data.tables.forEach(table => {
                const tableElement = document.createElement('div');
                tableElement.className = 'table';
                tableElement.style.left = table.pos_x + '%';
                tableElement.style.top = table.pos_y + '%';
                tableElement.style.width = table.width + '%';
                tableElement.style.height = table.height + '%';
                tableElement.textContent = table.table_code;
                tablesDiagram.appendChild(tableElement);
            });
            
            // Then render seats
            data.seats.forEach(seat => {
                const seatElement = document.createElement('div');
                seatElement.className = 'seat';
                if (!seat.is_available) {
                    seatElement.classList.add('unavailable');
                } else if (selectedSeats.includes(seat.seat_code)) {
                    seatElement.classList.add('selected');
                }
                
                seatElement.style.left = seat.pos_x + '%';
                seatElement.style.top = seat.pos_y + '%';
                seatElement.style.width = (seat.radius * 1.5) + '%';   /* it is *2 beofre */
                seatElement.style.height = (seat.radius * 1.5) + '%';  /* it is *2 beofre */
                seatElement.textContent = 'S' + seat.seat_number;
                seatElement.dataset.seatCode = seat.seat_code;
                
                // Add click event only if seat is available
                if (seat.is_available) {
                    seatElement.addEventListener('click', function() {
                        toggleSeatSelection(this, seat.seat_code);
                    });
                }
                
                tablesDiagram.appendChild(seatElement);
            });
            
            // Scroll to seat selection container
            document.getElementById('seatSelectionContainer').scrollIntoView({
                behavior: 'smooth'
            });
        }
        
        function toggleSeatSelection(seatElement, seatCode) {
            if (seatElement.classList.contains('selected')) {
                // Deselect seat
                seatElement.classList.remove('selected');
                const index = selectedSeats.indexOf(seatCode);
                if (index > -1) {
                    selectedSeats.splice(index, 1);
                }
            } else {
                // Check if maximum seats are already selected
                if (selectedSeats.length >= MAX_SEATS) {
                    alert(`You can select a maximum of ${MAX_SEATS} seats.`);
                    return;
                }
                
                // Select seat
                seatElement.classList.add('selected');
                if (!selectedSeats.includes(seatCode)) {
                    selectedSeats.push(seatCode);
                }
            }
            
            // Update hidden input and session storage
            document.getElementById('selectedSeatsInput').value = selectedSeats.join(',');
            sessionStorage.setItem('bookingSelectedSeats', selectedSeats.join(','));
            
            // Update confirm button state
            updateConfirmButton();
        }
        
        function updateConfirmButton() {
            const confirmButton = document.getElementById('confirmButton');
            if (selectedSeats.length > 0) {
                confirmButton.classList.add('enabled');
            } else {
                confirmButton.classList.remove('enabled');
            }
        }
    </script>
</body>
</html>