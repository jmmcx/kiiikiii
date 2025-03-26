<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>

<%
    LocalDate today = LocalDate.now();
    // If today is weekend, set default date to next Monday
    if (today.getDayOfWeek() == DayOfWeek.SATURDAY) {
        today = today.plusDays(2);
    } else if (today.getDayOfWeek() == DayOfWeek.SUNDAY) {
        today = today.plusDays(1);
    }
    
    // Get parameters from visitor_scheduler if available
    String bookingDate = request.getParameter("bookingDate");
    String bookingLocation = request.getParameter("bookingLocation");
    String bookingTimeSlot = request.getParameter("bookingTimeSlot");
    
    // Convert bookingDate to LocalDate if it exists
    LocalDate selectedDate = (bookingDate != null && !bookingDate.isEmpty()) 
                           ? LocalDate.parse(bookingDate) 
                           : today;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Robotics and AI, KMITL - Room Reservation</title>
    <link rel="stylesheet" href="../../theme/register.css">
    <style>
        /* Custom popup styles */
        .popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            text-align: center;
        }

        .popup-content {
            margin-bottom: 15px;
        }

        .popup-button {
            padding: 8px 20px;
            background-color: #ff6b00;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }

        /* Date input styles */
        input[type="date"]::-webkit-calendar-picker-indicator {
            cursor: pointer;
        }

        /* Disable weekend dates in the calendar */
        input[type="date"]::-webkit-calendar-picker-indicator:hover {
            opacity: 0.7;
        }

        .time-slot.weekend {
            background-color: #f0f0f0;
            color: #999;
            cursor: not-allowed;
        }
        
        /* Loading overlay styles */
        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.7);
            z-index: 2000;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }
        
        .loading-spinner {
            margin-bottom: 15px;
        }
        
        .loading-text {
            font-size: 16px;
            font-weight: bold;
            color: #333;
        }
        
        /* Button disabled style */
        button:disabled {
            background-color: #cccccc !important;
            cursor: not-allowed;
        }

        .time-slot.locked {
            background-color: #f8f9fa;
            border: 1px solid #dc3545;
            color: #6c757d;
            cursor: not-allowed;
        }

        .time-slot.past {
            background-color: #f8f9fa;
            border: 1px solid #6c757d;
            color: #6c757d;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Robotics and AI, KMITL</h2>
        <img src="../../images/rai_logo.png" alt="Logo">
        
        <form action="<%= request.getContextPath() %>/ReservationServlet" method="POST" id="reservationForm">
            <div class="form-group">
                <label>Name</label>
                <input type="text" name="fullName" placeholder="First Name Last Name" required>
            </div>            
            
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" placeholder="Your email" required>
            </div>
            
            <div class="form-group">
                <label>Phone no.</label>
                <input type="tel" name="phone" placeholder="Your phone no." required>
            </div>
            
            <div class="form-group">
                <label>Organization</label>
                <input type="text" name="organization" placeholder="Your organization" required>
            </div>
            
            <div class="form-group">
                <label>City / Province</label>
                <input type="text" name="city" placeholder="Your city or province" required>
            </div>
            
            <div class="form-group">
                <label>Country</label>
                <input type="text" name="country" placeholder="Your country" required>
            </div>            
        
            <div class="form-group">
                <label>Number of Visitors</label>
                <input type="number" name="numVisitors" id="numVisitors" 
                       placeholder="Enter number of visitors" min="1" max="10" required
                       onchange="updateVisitorFields(this.value)">
            </div>
        
            <div class="form-group">
                <label>Visitor Details</label>
                <div id="visitorDetails">
                    <!-- Visitor name and age fields will be added here dynamically -->
                </div>
            </div>       
            
            <div class="form-group">
                <label>Location</label>
                <select name="location" id="locationSelect" required>
                    <option value="" disabled selected>Select location preferred</option>
                    <option value="HM Building, Robotics Lab">HM Building, Robotics Lab</option>
                    <option value="E-12 Building, Future Lab">E-12 Building, Future Lab</option>
                </select>
            </div>
        
            <div class="form-group">
                <label>Date</label>
                <input type="date" name="date" id="dateSelect" 
                       value="<%= selectedDate %>" 
                       min="<%= today %>" 
                       required>
            </div>
        
            <div class="form-group">
                <label>Time Slot</label>
                <div id="timeSlots">
                    <!-- Time slots will be inserted here dynamically -->
                </div>
                <!-- Store the pre-selected time slot if passed from visitor_scheduler -->
                <input type="hidden" id="preSelectedTimeSlot" value="<%= (bookingTimeSlot != null) ? bookingTimeSlot : "" %>">
            </div>
        
            <button type="submit" id="confirmBtn">CONFIRM</button>
            <input type="hidden" name="action" value="reserve">
        </form>
    </div>

    <!-- Add popup elements -->
    <div class="overlay" id="overlay"></div>
    <div class="popup" id="messagePopup">
        <div class="popup-content" id="popupMessage"></div>
        <button class="popup-button" onclick="closePopup()">OK</button>
    </div>
    
    <!-- Loading overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <img src="../../images/loading.gif" alt="Loading..." width="50" height="50">
        </div>
        <div class="loading-text">Processing your reservation...</div>
    </div>

    <script>
        // Flag to track if form has been submitted
        let isSubmitting = false;
        
        // Add this at the beginning of your script section
        document.getElementById('reservationForm').addEventListener('submit', function(event) {
            const selectedTimeSlots = document.querySelectorAll('input[name="timeSlots"]:checked');
            
            if (selectedTimeSlots.length === 0) {
                event.preventDefault();
                showPopup('Please select at least one time slot');
                return false;
            }
            
            // Check if form is already being submitted
            if (isSubmitting) {
                event.preventDefault();
                return false;
            }
            
            // Prevent multiple submissions
            isSubmitting = true;
            
            // Disable the confirm button
            document.getElementById('confirmBtn').disabled = true;
            
            // Show loading overlay
            document.getElementById('loadingOverlay').style.display = 'flex';
            
            // Allow the form submission to proceed
            return true;
        });

        // Function to show custom popup
        function showPopup(message) {
            document.getElementById('popupMessage').textContent = message;
            document.getElementById('messagePopup').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
        }

        // Function to close popup
        function closePopup() {
            document.getElementById('messagePopup').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
        }

        // Function to check if a date is a weekend
        function isWeekend(date) {
            const day = new Date(date).getDay();
            return day === 0 || day === 6;
        }

        // Function to get next available weekday
        function getNextWeekday(date) {
            let nextDate = new Date(date);
            while (isWeekend(nextDate)) {
                nextDate.setDate(nextDate.getDate() + 1);
            }
            return nextDate.toISOString().split('T')[0];
        }

        // Add this function to check if a date is locked
        function isDateLocked(date, location) {
            return new Promise((resolve, reject) => {
                fetch('<%= request.getContextPath() %>/CheckLockDateServlet?date=' + encodeURIComponent(date) + '&location=' + encodeURIComponent(location))
                    .then(response => response.json())
                    .then(data => {
                        resolve(data.fullyLocked); // Use fullyLocked from the JSON response
                    })
                    .catch(error => {
                        console.error('Error checking locked date:', error);
                        reject(error);
                    });
            });
        }

        // Modified date input handler
        // Modify the date input handler to check for locked dates
        document.getElementById('dateSelect').addEventListener('change', async function(event) {
            const selectedDate = this.value;
            const selectedLocation = document.getElementById('locationSelect').value;
            
            if (!selectedLocation) {
                showPopup('Please select a location first.');
                this.value = ''; // Reset date if no location is selected
                return;
            }
            
            try {
                // First check if it's a weekend
                if (isWeekend(selectedDate)) {
                    const nextWeekday = getNextWeekday(selectedDate);
                    this.value = nextWeekday;
                    showPopup('Weekends are not available for booking. Date has been set to the next available weekday.');
                    await checkAndFetchTimeSlots(nextWeekday);
                } else {
                    // Then check if the date is locked for this location
                    const isLocked = await isDateLocked(selectedDate, selectedLocation);
                    if (isLocked) {
                        const nextAvailableDate = await getNextAvailableDate(selectedDate, selectedLocation);
                        this.value = nextAvailableDate;
                        showPopup('This date is not available for booking at this location. Date has been set to the next available date.');
                        await checkAndFetchTimeSlots(nextAvailableDate);
                    } else {
                        fetchTimeSlots();
                    }
                }
            } catch (error) {
                console.error('Error handling date change:', error);
                fetchTimeSlots(); // Fallback to regular fetch
            }
        });

        // Helper function to get the next available date
        async function getNextAvailableDate(startDate, location) {
            let nextDate = new Date(startDate);
            let isAvailable = false;
            
            // Try the next 30 days at most
            for (let i = 0; i < 30; i++) {
                nextDate.setDate(nextDate.getDate() + 1);
                
                if (isWeekend(nextDate)) {
                    continue;
                }
                
                const dateString = nextDate.toISOString().split('T')[0];
                const isLocked = await isDateLocked(dateString, location);
                
                if (!isLocked) {
                    isAvailable = true;
                    break;
                }
            }
            
            return isAvailable ? nextDate.toISOString().split('T')[0] : startDate;
        }

        // Helper function to check date and fetch time slots
        async function checkAndFetchTimeSlots(date) {
            const location = document.querySelector('select[name="location"]').value;
            
            if (!date || !location) {
                return; // Prevent fetching if either field is empty
            }
            
            try {
                const response = await fetch('<%= request.getContextPath() %>/TimeSlotServlet?date=' + 
                    encodeURIComponent(date) + '&location=' + encodeURIComponent(location));
                const data = await response.json();
                updateTimeSlots(data.availableSlots, data.isFullyBooked);
            } catch (error) {
                console.error('Error fetching time slots:', error);
            }
        }

        document.querySelector('select[name="location"]').addEventListener('change', function() {
            fetchTimeSlots(); // Fetch time slots when location changes
        });

        function fetchTimeSlots() {
            const date = document.getElementById('dateSelect').value;
            const location = document.querySelector('select[name="location"]').value;

            if (!date || !location) {
                return; // Prevent fetching if either field is empty
            }

            // Validate date is not in the past
            const selectedDate = new Date(date + 'T00:00:00');
            const today = new Date();
            today.setHours(0, 0, 0, 0); // Strip time component
            
            if (selectedDate < today) {
                document.getElementById('dateSelect').value = today.toISOString().split('T')[0];
                showPopup('Cannot select past dates. Please choose a current or future date.');
                return;
            }

            fetch('<%= request.getContextPath() %>/TimeSlotServlet?date=' + encodeURIComponent(date) + '&location=' + encodeURIComponent(location))
                .then(response => response.json())
                .then(data => {
                    updateTimeSlots(data.availableSlots, data.isFullyBooked, data.isDateLocked, data.lockedTimeSlots);
                })
                .catch(error => console.error('Error fetching time slots:', error));
        }

        // Modified time slots update function
        function updateTimeSlots(availableSlots, isFullyBooked, isDateLocked, lockedTimeSlots) {
            const allTimeSlots = [
                "09:00-09:30", "09:30-10:00", "10:00-10:30", "10:30-11:00", 
                "11:00-11:30", "11:30-12:00", "13:00-13:30", "13:30-14:00", 
                "14:00-14:30", "14:30-15:00", "15:00-15:30", "15:30-16:00"
            ];
            const timeSlotsContainer = document.getElementById('timeSlots');
            timeSlotsContainer.innerHTML = '';

            if (isDateLocked) {
                showPopup('This date is fully locked. Please select another date.');
                return;
            }

            if (isFullyBooked) {
                showPopup('This date is fully booked. Please select another date.');
                return;
            }

            const selectedDate = document.getElementById('dateSelect').value;
            const isWeekendDate = isWeekend(selectedDate);
            const preSelectedTimeSlot = document.getElementById('preSelectedTimeSlot').value;
            
            // Check for current time
            const today = new Date().toISOString().split('T')[0];
            const isToday = selectedDate === today;
            const currentTime = isToday ? new Date() : null;

            allTimeSlots.forEach(timeSlot => {
                const slotDiv = document.createElement('div');
                slotDiv.classList.add('time-slot');
                
                let isLocked = lockedTimeSlots && lockedTimeSlots.includes(timeSlot);
                let isPastTime = false;
                
                // Check if time slot is in the past (for today)
                if (isToday) {
                    const endTime = timeSlot.split('-')[1];
                    const [hours, minutes] = endTime.split(':');
                    const slotEndTime = new Date();
                    slotEndTime.setHours(parseInt(hours), parseInt(minutes), 0);
                    
                    isPastTime = currentTime > slotEndTime;
                }
                
                if (isWeekendDate) {
                    slotDiv.classList.add('weekend');
                    slotDiv.textContent = timeSlot;
                } else if (isLocked) {
                    slotDiv.classList.add('locked');
                    slotDiv.textContent = timeSlot + ' 🔒';
                } else if (isPastTime) {
                    slotDiv.classList.add('past');
                    slotDiv.textContent = timeSlot + ' ⏱️';
                } else if (availableSlots.includes(timeSlot)) {
                    slotDiv.classList.add('available');
                    
                    const checkbox = document.createElement('input');
                    checkbox.type = 'checkbox';
                    checkbox.name = 'timeSlots';
                    checkbox.value = timeSlot;
                    checkbox.style.display = 'none';

                    // Pre-select the time slot if it matches the one from visitor_scheduler
                    if (timeSlot === preSelectedTimeSlot) {
                        checkbox.checked = true;
                        slotDiv.classList.add('selected');
                    }

                    const timeText = document.createTextNode(timeSlot);
                    
                    slotDiv.appendChild(timeText);
                    slotDiv.appendChild(checkbox);
                    slotDiv.onclick = () => toggleTimeSlot(slotDiv);
                } else {
                    slotDiv.classList.add('unavailable');
                    slotDiv.textContent = timeSlot;
                }
                
                timeSlotsContainer.appendChild(slotDiv);
            });
        }

        function toggleTimeSlot(element) {
            if (!element.classList.contains('available')) return;
            element.classList.toggle('selected');
            const checkbox = element.querySelector('input[type="checkbox"]');
            if (checkbox) checkbox.checked = !checkbox.checked;
        }

        function updateVisitorFields(numVisitors) {
            const container = document.getElementById('visitorDetails');
            container.innerHTML = '';
            numVisitors = parseInt(numVisitors, 10);

            for (let i = 0; i < numVisitors; i++) {
                const div = document.createElement('div');
                div.classList.add('visitor-entry');

                const nameInput = document.createElement('input');
                nameInput.type = 'text';
                nameInput.name = 'visitorNames';
                nameInput.placeholder = `Visitor Name`;
                nameInput.required = true;
                
                const ageInput = document.createElement('input');
                ageInput.type = 'number';
                ageInput.name = 'visitorAges';
                ageInput.placeholder = `Age`;
                ageInput.min = '0';
                ageInput.required = true;
                
                div.appendChild(nameInput);
                div.appendChild(ageInput);
                container.appendChild(div);
            }
        }

        // Set initial location value if provided from visitor_scheduler
        function setInitialLocationValue() {
            const locationSelect = document.getElementById('locationSelect');
            const bookingLocation = '<%= bookingLocation != null ? bookingLocation : "" %>';
            
            if (bookingLocation) {
                // Find and select the option with matching value
                for (let i = 0; i < locationSelect.options.length; i++) {
                    if (locationSelect.options[i].value === bookingLocation) {
                        locationSelect.selectedIndex = i;
                        break;
                    }
                }
            }
        }

        // Load time slots for the default selected date on page load
        // Initialize the page with the next available weekday
        // Modified window.onload function
        window.onload = async function() {
            const dateInput = document.getElementById('dateSelect');
            const locationSelect = document.getElementById('locationSelect');
            let initialDate = dateInput.value;

            setInitialLocationValue();
            
            if (locationSelect.value) {
                if (isWeekend(initialDate)) {
                    initialDate = getNextWeekday(initialDate);
                    dateInput.value = initialDate;
                }
                
                try {
                    const isLocked = await isDateLocked(initialDate, locationSelect.value);
                    if (isLocked) {
                        initialDate = await getNextAvailableDate(initialDate, locationSelect.value);
                        dateInput.value = initialDate;
                        showPopup('The initial date is not available for booking. Date has been set to the next available date.');
                    }
                } catch (error) {
                    console.error('Error checking initial date:', error);
                }
            }
            
            document.getElementById('numVisitors').value = 1;
            updateVisitorFields(1);
            
            // Set initial location value if provided
            setInitialLocationValue();
            
            // Fetch time slots with the potentially updated date
            fetchTimeSlots();
            
            // Reset submission state when page loads (in case of back navigation)
            isSubmitting = false;
            document.getElementById('confirmBtn').disabled = false;
        };
        
        // Add event listener to re-enable the button if user navigates back
        window.addEventListener('pageshow', function(event) {
            // If the page is loaded from the cache (user pressed back button)
            if (event.persisted) {
                isSubmitting = false;
                document.getElementById('confirmBtn').disabled = false;
                document.getElementById('loadingOverlay').style.display = 'none';
            }
        });
    </script>
</body>
</html>
