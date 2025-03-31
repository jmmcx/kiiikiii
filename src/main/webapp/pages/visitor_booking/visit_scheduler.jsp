<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="dao.ReservationDAO" %> 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KMITL Robotics & AI Labs - Visit Booking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        :root {
            --primary-color: #0056b3;
            --secondary-color: #004085;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
        }
        body {
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            color: #333;
            margin: 0;
            padding: 0;
            background-color: #f5f7fa;
        }

        /* Back arrow styles - positioned appropriately */
        .back-button {
            position: fixed;
            top: 50px;
            left: 50px;
            z-index: 100;
        }
    
        .back-button img {
            width: 70px;
            height: 70px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 30px 0;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        header h1 {
            margin: 0;
            font-size: 2.5rem;
        }
        header p {
            margin: 10px 0 0;
            font-size: 1.2rem;
            opacity: 0.9;
        }
        .labs-info {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 40px;
        }
        .lab-card {
            flex: 1;
            min-width: 300px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .lab-card:hover {
            transform: translateY(-5px);
        }
        .lab-img {
            height: 200px;
            background-color: #ddd;
            background-position: center;
            background-size: cover;
        }
        .lab-content {
            padding: 20px;
        }
        .lab-content h2 {
            color: var(--primary-color);
            margin-top: 0;
        }
        .register-btn {
            display: inline-block;
            background-color: var(--primary-color);
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            margin-top: 15px;
            transition: background-color 0.3s;
        }
        .register-btn:hover {
            background-color: var(--secondary-color);
        }
        .calendar-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .calendar-nav {
            display: flex;
            gap: 10px;
        }
        .calendar-nav button {
            background-color: var(--light-color);
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px 15px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .calendar-nav button:hover {
            background-color: var(--primary-color);
            color: white;
        }
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 10px;
        }
        .calendar-day-header {
            font-weight: bold;
            text-align: center;
            padding: 10px;
            background-color: var(--light-color);
            border-radius: 4px;
        }
        .calendar-day {
            min-height: 100px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
            cursor: pointer;
            transition: background-color 0.3s;
            position: relative;
        }
        .calendar-day.empty {
            background-color: #f8f9fa;
        }
        .calendar-day.locked {
            cursor: not-allowed;
            background-color: #f8f9fa;
            opacity: 0.8;
        }
        .other-month {
            opacity: 0.5;
        }
        .calendar-date {
            position: absolute;
            top: 5px;
            right: 5px;
            width: 25px;
            height: 25px;
            border-radius: 50%;
            background-color: var(--light-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }
        .today .calendar-date {
            background-color: var(--primary-color);
            color: white;
        }
        .lab-status {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin-top: 20px;
        }
        .status-indicator {
            display: flex;
            align-items: center;
            font-size: 0.8rem;
            padding: 3px 0;
        }
        .status-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 5px;
        }
        .status-empty {
            background-color: var(--success-color); /* Change to green to match available */
        }
        .status-locked {
            background-color: #e9ecef; /* Same as empty - gray color */
        }
        .status-available {
            background-color: var(--success-color);
        }
        .status-nearly-full {
            background-color: var(--warning-color);
        }
        .status-full {
            background-color: var(--danger-color);
        }
        .legend {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 20px 0;
            flex-wrap: wrap;
        }
        .legend-item {
            display: flex;
            align-items: center;
            font-size: 0.9rem;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto; /* Enable scrolling if content exceeds viewport */
            background-color: rgba(0, 0, 0, 0.5);
        }
        .modal-content {
            background-color: white;
            margin: 5% auto; /* Reduced from 10% to give more vertical space */
            padding: 20px;
            border-radius: 8px;
            width: 90%; /* Increased from 80% for better fit */
            max-width: 600px;
            max-height: 80vh; /* Limit height to 80% of viewport */
            overflow-y: auto; /* Scroll if content exceeds max-height */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .close-btn {
            font-size: 1.5rem;
            cursor: pointer;
        }
        .time-slots-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            max-height: 60vh; /* Limit height to ensure it fits within modal */
            overflow-y: auto; /* Scroll if content exceeds */
        }
        .lab-slots {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
        }
        .lab-slots h3 {
            margin-top: 0;
            color: var(--primary-color);
        }
        .slots-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr)); /* Changed to auto-fit for responsiveness */
            gap: 10px;
            margin-top: 15px;
            width: 100%; /* Ensure it doesn't exceed container */
        }
        .time-slot {
            padding: 8px;
            border-radius: 4px;
            text-align: center;
            font-size: 0.9rem;
            white-space: nowrap; /* Prevent text wrapping */
            overflow: hidden; /* Hide overflow text */
            text-overflow: ellipsis; /* Add ellipsis for long text */
        }
        .slot-available {
            background-color: #e8f5e9;
            border: 1px solid var(--success-color);
            cursor: pointer;
        }
        .slot-available:hover {
            background-color: var(--success-color);
            color: white;
        }
        .slot-booked {
            background-color: #ffebee;
            border: 1px solid var(--danger-color);
            color: #777;
            text-decoration: line-through;
        }
        .proceed-btn {
            display: block;
            width: 100%;
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px;
            border-radius: 4px;
            margin-top: 20px;
            cursor: pointer;
            font-size: 1rem;
            transition: background-color 0.3s;
        }
        .proceed-btn:hover {
            background-color: var(--secondary-color);
        }
        .proceed-btn:disabled {
            background-color: #ddd;
            cursor: not-allowed;
        }
        .slot-locked {
            background-color: #f8f9fa;
            border: 1px solid #dc3545;
            color: #6c757d;
            position: relative;
        }
        .lock-icon, .time-icon {
            position: absolute;
            top: 2px;
            right: 2px;
            font-size: 10px;
        }
        .slot-past {
            background-color: #f8f9fa;
            border: 1px solid #6c757d;
            color: #6c757d;
            position: relative;
        }
        @media (max-width: 768px) {
            .calendar-grid {
                grid-template-columns: repeat(7, 1fr);
                gap: 5px;
            }
            .calendar-day {
                min-height: 70px;
                padding: 5px;
            }
            .lab-status {
                margin-top: 15px;
            }
            .modal-content {
                width: 95%; /* Wider on smaller screens */
                max-height: 70vh; /* Slightly less height on mobile */
            }
            .time-slots-container {
                max-height: 50vh; /* Adjust for smaller screens */
            }
            .slots-grid {
                grid-template-columns: repeat(2, 1fr); /* Fixed 2 columns on mobile */
            }
            .time-slot {
                font-size: 0.8rem; /* Smaller text on mobile */
            }
        }
    </style>
</head>
<body>
    <%
        // Get current date
        Calendar today = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String todayString = dateFormat.format(today.getTime());
        
        // Initialize DAO
        ReservationDAO bookingDAO = new ReservationDAO();
        
        // Get current date and set up calendar
        Calendar calendar = Calendar.getInstance();
        
        // Check if month and year parameters are passed
        String monthParam = request.getParameter("month");
        String yearParam = request.getParameter("year");
        
        if (monthParam != null && yearParam != null) {
            calendar.set(Calendar.MONTH, Integer.parseInt(monthParam));
            calendar.set(Calendar.YEAR, Integer.parseInt(yearParam));
        }
        
        calendar.set(Calendar.DAY_OF_MONTH, 1); // Set to first day of month
        
        int currentMonth = calendar.get(Calendar.MONTH);
        int currentYear = calendar.get(Calendar.YEAR);
        
        // Format for display
        SimpleDateFormat monthYearFormat = new SimpleDateFormat("MMMM yyyy");
        String monthYearDisplay = monthYearFormat.format(calendar.getTime());
        
        // Calculate first day of the month and last day
        int firstDayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
        int lastDay = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
        
        // Get booking data for the month
        SimpleDateFormat dbDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        String startDate = dbDateFormat.format(calendar.getTime());
        calendar.set(Calendar.DAY_OF_MONTH, lastDay);
        String endDate = dbDateFormat.format(calendar.getTime());
        
        // Retrieve booking status for the entire month
        Map<String, Map<String, String>> bookingStatusMap = bookingDAO.getBookingStatusByDateRange(startDate, endDate);
        
        // Prepare locked dates maps for specific locations
        Map<String, Boolean> roboticsLockedDatesMap = new HashMap<>();
        Map<String, Boolean> futureLockedDatesMap = new HashMap<>();

        // Populate locked dates for each location
        for (int day = 1; day <= lastDay; day++) {
            calendar.set(Calendar.DAY_OF_MONTH, day);
            String dateString = dbDateFormat.format(calendar.getTime());
            
            // Check if date is locked for specific locations
            roboticsLockedDatesMap.put(dateString, 
                bookingDAO.isDateLocked(dateString, "HM Building, Robotics Lab"));
            futureLockedDatesMap.put(dateString, 
                bookingDAO.isDateLocked(dateString, "E-12 Building, Future Lab"));
        }

        // Reset calendar for rendering
        calendar.set(Calendar.DAY_OF_MONTH, 1);
    %>

    <div class="back-button">
        <a href="../other.jsp">
            <img src="../../images/back_arrow_white.png" alt="Back" class="back-button img">
        </a>
    </div>

    <header>
        <div class="container">
            <h1>KMITL Robotics & AI Department</h1>
            <p>Discover Innovation: Visit KMITL's Robotics & AI Labs</p>
        </div>
    </header>

    <div class="container">
        <div class="labs-info">
            <div class="lab-card">
                <div class="lab-img" style="background-color: #0056b3;"></div>
                <div class="lab-content">
                    <h2>Robotics Lab</h2>
                    <p>See robots in action! Our Robotics Lab is where we build and test the latest in robotic technology. Come explore how robots are being developed for the future.</p>
                    <p><strong>What You'll Find:</strong> Robotic arms, self-driving robots, interactive systems, and more.</p>
                    <a href="#calendar" class="register-btn">Schedule a Visit</a>
                </div>
            </div>
            <div class="lab-card">
                <div class="lab-img" style="background-color: #17a2b8;"></div>
                <div class="lab-content">
                    <h2>Future Lab</h2>
                    <p>Step into the future! Our Future Lab is where we're exploring the latest tech, like smart systems and AI. See how these technologies are shaping the world around us.</p>
                    <p><strong>What We're Working On:</strong> Smart devices, AI projects, and computer vision experiments.</p>
                    <a href="#calendar" class="register-btn">Schedule a Visit</a>
                </div>
            </div>
        </div>

        <div class="calendar-container" id="calendar">
            <div class="calendar-header">
                <h2>Visit Availability Calendar</h2>
                <div class="calendar-nav">
                    <button onclick="changeMonth('<%= currentMonth - 1 %>', '<%= (currentMonth == 0) ? (currentYear - 1) : currentYear %>')">
                        <i class="fas fa-chevron-left"></i> Previous
                    </button>
                    <h3><%= monthYearDisplay %></h3>
                    <button onclick="changeMonth('<%= currentMonth + 1 %>', '<%= (currentMonth == 11) ? (currentYear + 1) : currentYear %>')">
                        Next <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>            
        
            <div class="legend">
                <div class="legend-item">
                    <div class="status-dot status-locked"></div>
                    <span>Locked</span>
                </div>
                <div class="legend-item">
                    <div class="status-dot status-available"></div>
                    <span>Available</span>
                </div>
                <div class="legend-item">
                    <div class="status-dot status-nearly-full"></div>
                    <span>Nearly Full</span>
                </div>
                <div class="legend-item">
                    <div class="status-dot status-full"></div>
                    <span>Fully Booked</span>
                </div>
            </div>
        
            <div class="calendar-grid">
                <div class="calendar-day-header">Mon</div>
                <div class="calendar-day-header">Tue</div>
                <div class="calendar-day-header">Wed</div>
                <div class="calendar-day-header">Thu</div>
                <div class="calendar-day-header">Fri</div>
                <div class="calendar-day-header">Sat</div>
                <div class="calendar-day-header">Sun</div>
                
                <%
                    // Add empty cells for days of the previous month
                    int emptyCells = firstDayOfWeek - 1;
                    if (emptyCells == 0) emptyCells = 7; // Sunday is 1 in Java
                            
                    for (int i = 1; i < emptyCells; i++) {
                        out.println("<div class=\"calendar-day empty other-month\"></div>");
                    }
                            
                    // Loop through days of the month
                    for (int day = 1; day <= lastDay; day++) {
                        calendar.set(Calendar.DAY_OF_MONTH, day);
                        String dateString = dbDateFormat.format(calendar.getTime());
                                
                        // Retrieve booking status
                        Map<String, String> dayStatus = bookingStatusMap.get(dateString);
                        
                        // Check locked status for specific locations
                        boolean isRoboticsLocked = roboticsLockedDatesMap.getOrDefault(dateString, false);
                        boolean isFutureLocked = futureLockedDatesMap.getOrDefault(dateString, false);
                        boolean isToday = dateString.equals(todayString);
                        
                        // Determine status for each location
                        String roboticsStatus = (dayStatus != null) 
                            ? dayStatus.get("HM Building, Robotics Lab") 
                            : "available";
                        String futureLabStatus = (dayStatus != null) 
                            ? dayStatus.get("E-12 Building, Future Lab") 
                            : "available";
        
                        // Override status if locked
                        if (isRoboticsLocked) {
                            roboticsStatus = "locked";
                        }
                        if (isFutureLocked) {
                            futureLabStatus = "locked";
                        }
        
                        // Determine clickability based on location-specific locks
                        String clickHandler = (isRoboticsLocked && isFutureLocked) 
                            ? "" 
                            : "onclick=\"showTimeSlots('" + dateString + "')\"";
                %>
                        
                <div class="calendar-day <%= isToday ? "today" : "" %> <%= (isRoboticsLocked && isFutureLocked) ? "locked" : "" %>" 
                    <%= clickHandler %>>
                <div class="calendar-date"><%= day %></div>
                <div class="lab-status">
                    <div class="status-indicator">
                        <div class="status-dot status-<%= roboticsStatus %>"></div>
                        <span>Robotics</span>
                    </div>
                    <div class="status-indicator">
                        <div class="status-dot status-<%= futureLabStatus %>"></div>
                        <span>Future</span>
                    </div>
                </div>
            </div>
                        
            <%
                }
                        
                // Add empty cells for days of the next month
                int daysDisplayed = emptyCells - 1 + lastDay;
                int remainingCells = 7 - (daysDisplayed % 7);
                if (remainingCells < 7) {
                    for (int i = 0; i < remainingCells; i++) {
                        out.println("<div class=\"calendar-day empty other-month\"></div>");
                    }
                }
            %>
        </div>
        </div>
    </div>

    <!-- Time Slots Modal -->
    <div id="timeSlotsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="selectedDate">Available Time Slots</h3>
                <span class="close-btn" onclick="closeModal()">&times;</span>
            </div>
            <div class="time-slots-container" id="timeSlotsContainer">
                <!-- Time slots will be loaded here -->
            </div>
            <form id="bookingForm" action="<%= request.getContextPath() %>/pages/visitor_booking/register.jsp" method="GET">
                <input type="hidden" id="bookingDate" name="bookingDate">
                <input type="hidden" id="bookingLocation" name="bookingLocation">
                <input type="hidden" id="bookingTimeSlot" name="bookingTimeSlot">
                <button type="submit" id="proceedBtn" class="proceed-btn" disabled>
                    Proceed to Registration
                </button>
            </form>
        </div>
    </div>

    <script>
        // Function to change month
        function changeMonth(month, year) {
            window.location.href = window.location.pathname + '?month=' + month + '&year=' + year + '#calendar';
        }
        
        // Selected time slots tracking
        let selectedTimeSlots = [];
        let selectedLab = "";
        
        // Function to show time slots modal
        function showTimeSlots(date) {
            // Validate date is not in the past
            const selectedDate = new Date(date);
            const today = new Date();
            today.setHours(0, 0, 0, 0); // Strip time component
            
            if (selectedDate < today) {
                showPopup('Cannot select past dates. Please choose a future date.');
                return;
            }
            
            // Reset selections
            selectedTimeSlots = [];
            selectedLab = "";
            document.getElementById('proceedBtn').disabled = true;
            
            // Set the selected date in the modal and form
            document.getElementById('selectedDate').textContent = 'Time Slots for ' + formatDate(date);
            document.getElementById('bookingDate').value = date;
            
            // Fetch available time slots via AJAX
            fetchTimeSlots(date);
            
            // Show the modal
            document.getElementById('timeSlotsModal').style.display = 'block';
        }
        
        // Function to close the modal
        function closeModal() {
            document.getElementById('timeSlotsModal').style.display = 'none';
        }
        
        // Function to fetch time slots
        function fetchTimeSlots(date) {
            // In a real application, this would be an AJAX call
            // For this example, we'll simulate with a direct JSP include
            
            fetch('<%= request.getContextPath() %>/pages/visitor_booking/getTimeSlots.jsp?date=' + date)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('timeSlotsContainer').innerHTML = html;
                    
                    // Add event listeners to the time slots
                    const availableSlots = document.querySelectorAll('.slot-available');
                    availableSlots.forEach(slot => {
                        slot.addEventListener('click', function() {
                            selectTimeSlot(this);
                        });
                    });
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('timeSlotsContainer').innerHTML = 
                        '<p>Error loading time slots. Please try again later.</p>';
                });
        }
        
        // Function to handle time slot selection
        function selectTimeSlot(slotElement) {
            const lab = slotElement.getAttribute('data-lab');
            const timeSlot = slotElement.getAttribute('data-slot');
            
            // If selecting a slot from a different lab, clear previous selections
            if (selectedLab && selectedLab !== lab) {
                selectedTimeSlots = [];
                
                // Reset UI for previously selected lab
                const previousSlots = document.querySelectorAll('.slot-available.selected');
                previousSlots.forEach(slot => {
                    slot.classList.remove('selected');
                    slot.style.backgroundColor = '';
                    slot.style.color = '';
                });
            }
            
            // Update selected lab
            selectedLab = lab;
            
            // Toggle selection
            if (selectedTimeSlots.includes(timeSlot)) {
                // Deselect
                selectedTimeSlots = selectedTimeSlots.filter(slot => slot !== timeSlot);
                slotElement.classList.remove('selected');
                slotElement.style.backgroundColor = '';
                slotElement.style.color = '';
            } else {
                // Select
                selectedTimeSlots.push(timeSlot);
                slotElement.classList.add('selected');
                slotElement.style.backgroundColor = '#0056b3';
                slotElement.style.color = 'white';
            }
            
            // Update form values
            document.getElementById('bookingLocation').value = selectedLab;
            document.getElementById('bookingTimeSlot').value = selectedTimeSlots.join(',');
            
            // Enable/disable proceed button
            document.getElementById('proceedBtn').disabled = selectedTimeSlots.length === 0;
        }
        
        // Function to format date for display
        function formatDate(dateString) {
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            const date = new Date(dateString);
            return date.toLocaleDateString('en-US', options);
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('timeSlotsModal');
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>
