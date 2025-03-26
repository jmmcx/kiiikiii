<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RAI Common Area Booking - Select Date</title>
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
        
        .booking-calendar {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        .calendar-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        
        .view-options {
            display: flex;
            background-color: #f5f5f5;
            border-radius: 5px;
            overflow: hidden;
        }
        
        .view-option {
            padding: 8px 15px;
            border: none;
            background: none;
            cursor: pointer;
        }
        
        .view-option.active {
            background-color: #fff;
            font-weight: bold;
        }
        
        .days-header {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            text-align: center;
            margin-bottom: 10px;
            background-color: #f5f5f5;
            padding: 10px 0;
        }
        
        .day-label {
            font-size: clamp(12px, 3vw, 14px);
        }
        
        .weekend {
            color: #e53935;
        }
        
        .month-container {
            margin-bottom: 20px;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid #eee;
        }
        
        .month-header {
            font-size: clamp(18px, 5vw, 24px);
            margin: 15px 10px;
            font-weight: bold;
        }
        
        .month-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 5px;
            padding: 0 10px 15px;
        }
        
        .date-cell {
            aspect-ratio: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border-radius: 50%;
            font-size: clamp(14px, 4vw, 16px);
        }
        
        .date-cell:hover:not(.disabled):not(.locked) {
            background-color: #f0f0f0;
        }
        
        .date-cell.selected {
            background-color: #333;
            color: white;
        }
        
        .date-cell.today {
            border: 2px solid #333;
        }
        
        .date-cell.disabled {
            color: #ccc;
            cursor: default;
        }
        
        .date-cell.locked {
            background-color: #ffe0e0;
            cursor: not-allowed;
            position: relative;
        }
        
        .date-cell.locked::after {
            content: "🔒";
            font-size: 10px;
            position: absolute;
            bottom: 3px;
            right: 3px;
        }
        
        .empty-cell {
            aspect-ratio: 1;
        }

        .date-cell.time-slot-locked {
            background-color: #fff0e0; /* Light orange to indicate partial lock */
            position: relative;
        }

        .date-cell.time-slot-locked::after {
            content: "⌛";
            font-size: 10px;
            position: absolute;
            bottom: 3px;
            right: 3px;
        }
                
        .btn-confirm {
            width: 100%;
            padding: clamp(12px, 3vh, 20px);
            background-color: #ccc;
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
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        /* Responsive adjustments */
        @media (min-width: 768px) {
            .container {
                padding: 3% 10%;
            }
            
            .month-grid {
                gap: 10px;
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
        <div class="booking-calendar">
            <div class="calendar-nav">
                <div class="view-options">
                    <button class="view-option active">Month</button>
                    <button class="view-option">Year</button>
                </div>
            </div>
            
            <div class="days-header">
                <div class="day-label">Mo</div>
                <div class="day-label">Tu</div>
                <div class="day-label">We</div>
                <div class="day-label">Th</div>
                <div class="day-label">Fr</div>
                <div class="day-label weekend">Sa</div>
                <div class="day-label weekend">Su</div>
            </div>
            
            <form id="dateSelectForm" action="select_timeslot.jsp" method="post">
                <!-- Hidden fields to carry over registration data -->
                <input type="hidden" name="name" value="${param.name}">
                <input type="hidden" name="email" value="${param.email}">
                <input type="hidden" name="phone" value="${param.phone}">
                <input type="hidden" name="location_id" value="${param.location}">
                
                <%-- Get the selected place information for location display --%>
                <jsp:useBean id="studentBookingDAO" class="dao.StudentBookingDAO" />
                <c:set var="places" value="${studentBookingDAO.getAllPlaces()}" />
                <c:forEach var="place" items="${places}">
                    <c:if test="${place.place_id eq param.location}">
                        <c:set var="selectedPlace" value="${place}" />
                        <c:set var="locationString" value="${place.building_name}, ${place.location_name}" />
                        <c:set var="placeCode" value="${place.place_code}" />
                        <input type="hidden" name="location_string" value="${locationString}">
                        <input type="hidden" name="place_code" value="${placeCode}">
                    </c:if>
                </c:forEach>
                
                <%-- Get lock dates for the selected location --%>
                <c:set var="lockDates" value="${studentBookingDAO.getLockDatesFromCurrentDate()}" />
                <c:set var="selectedPlaceCode" value="${selectedPlace.place_code}" />
                
                <input type="hidden" name="selected_date" id="selectedDateInput">
                
                <%
                    // Calculate calendar data
                    Calendar cal = Calendar.getInstance();
                    int currentYear = cal.get(Calendar.YEAR);
                    int currentMonth = cal.get(Calendar.MONTH);
                    int today = cal.get(Calendar.DAY_OF_MONTH);
                    
                    // Get current date as string for comparison
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    String currentDateStr = sdf.format(cal.getTime());
                %>
                
                <%-- Generate two months --%>
                <% 
                    for (int monthOffset = 0; monthOffset < 2; monthOffset++) {
                        cal.set(currentYear, currentMonth + monthOffset, 1);
                        int year = cal.get(Calendar.YEAR);
                        int month = cal.get(Calendar.MONTH);
                        String monthName = new SimpleDateFormat("MMMM").format(cal.getTime());
                        int firstDayOfMonth = cal.get(Calendar.DAY_OF_WEEK);
                        int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                        firstDayOfMonth = (firstDayOfMonth == 1) ? 7 : firstDayOfMonth - 1;

                        pageContext.setAttribute("monthName", monthName);
                        pageContext.setAttribute("year", year);
                        pageContext.setAttribute("month", month);
                        pageContext.setAttribute("firstDay", firstDayOfMonth);
                        pageContext.setAttribute("daysInMonth", daysInMonth);
                        pageContext.setAttribute("today", today);
                        pageContext.setAttribute("currentMonth", currentMonth);
                        pageContext.setAttribute("currentYear", currentYear);
                %>
                    <div class="month-container">
                        <div class="month-header">${monthName}</div>
                        <div class="month-grid">
                            <% 
                                // Empty cells before first day of month
                                for (int i = 1; i < firstDayOfMonth; i++) {
                            %>
                                <div class="empty-cell"></div>
                            <% } %>
                            
                            <% 
                                // Generate cells for days in month
                                for (int day = 1; day <= daysInMonth; day++) {
                                    cal.set(year, month, day);
                                    String dateStr = sdf.format(cal.getTime());
                                    
                                    boolean isToday = (day == today && month == currentMonth && year == currentYear);
                                    boolean isPast = dateStr.compareTo(currentDateStr) < 0;
                                    boolean isWeekend = (cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || 
                                                        cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY);
                                    
                                    pageContext.setAttribute("day", day);
                                    pageContext.setAttribute("dateStr", dateStr);
                                    pageContext.setAttribute("isToday", isToday);
                                    pageContext.setAttribute("isPast", isPast);
                                    pageContext.setAttribute("isWeekend", isWeekend);
                            %>
                            
                            <%-- Check if this date is locked for the selected location --%>
                            <c:set var="isLocked" value="false" />
                            <c:set var="hasTimeSlotLock" value="false" />
                            <c:forEach var="lockDate" items="${lockDates}">
                                <c:if test="${lockDate.place_code eq selectedPlaceCode && lockDate.LockDate eq dateStr}">
                                    <c:choose>
                                        <c:when test="${empty lockDate.start_time && empty lockDate.end_time}">
                                            <c:set var="isLocked" value="true" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="hasTimeSlotLock" value="true" />
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </c:forEach>

                            <div class="date-cell 
                                ${isToday ? 'today' : ''} 
                                ${isPast || isLocked ? 'disabled' : ''} 
                                ${isLocked ? 'locked' : ''} 
                                ${hasTimeSlotLock ? 'time-slot-locked' : ''}"
                                data-date="${dateStr}"
                                onclick="<c:if test='${!isPast && !isLocked}'>selectDate(this)</c:if>">
                                ${day}
                            </div>
                            <% } %>
                        </div> <%-- Close month-grid --%>
                    </div> <%-- Close month-container --%>
                <% } %> <%-- Close monthOffset loop --%>
                
                <button type="submit" id="confirmButton" class="btn-confirm disabled" disabled>CONFIRM</button>
            </form> <%-- Close form --%>
        </div> <%-- Close booking-calendar --%>
    </div> <%-- Close container --%>
    
    <script>
        let selectedDateCell = null;
        
        function selectDate(cell) {
            if (selectedDateCell) {
                selectedDateCell.classList.remove('selected');
            }
            cell.classList.add('selected');
            selectedDateCell = cell;
            document.getElementById('selectedDateInput').value = cell.dataset.date;
            const confirmButton = document.getElementById('confirmButton');
            confirmButton.classList.remove('disabled');
            confirmButton.disabled = false;
        }
        
        function storeFormData() {
            sessionStorage.setItem('bookingName', "${param.name}");
            sessionStorage.setItem('bookingEmail', "${param.email}");
            sessionStorage.setItem('bookingPhone', "${param.phone}");
            sessionStorage.setItem('bookingLocationId', "${param.location}");
            sessionStorage.setItem('bookingLocationString', "${locationString}");
            sessionStorage.setItem('bookingPlaceCode', "${placeCode}");
            sessionStorage.setItem('bookingDate', document.getElementById('selectedDateInput').value);
        }
        
        window.onload = function() {
            const storedDate = sessionStorage.getItem('bookingDate');
            if (storedDate) {
                const dateCells = document.querySelectorAll('.date-cell');
                for (let cell of dateCells) {
                    if (cell.dataset.date === storedDate && !cell.classList.contains('disabled')) {
                        selectDate(cell);
                        break;
                    }
                }
            }
        };
        
        const viewOptions = document.querySelectorAll('.view-option');
        viewOptions.forEach(option => {
            option.addEventListener('click', function() {
                viewOptions.forEach(opt => opt.classList.remove('active'));
                this.classList.add('active');
            });
        });
        
        document.getElementById('dateSelectForm').addEventListener('submit', function() {
            storeFormData();
        });
    </script>
</body>
</html>