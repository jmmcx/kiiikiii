<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RAI Common Area Booking</title>
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
        
        .booking-form {
            background-color: white;
            border-radius: 10px;
            padding: 5%;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        h1 {
            text-align: center;
            margin-bottom: 4vh;
            font-size: clamp(18px, 5vw, 28px);
            font-weight: bold;
        }
        
        .logo {
            text-align: center;
            margin-bottom: 5vh;
        }
        
        .logo img {
            width: clamp(120px, 30%, 180px);
            height: auto;
        }
        
        .form-group {
            margin-bottom: 4vh;
        }
        
        label {
            display: block;
            margin-bottom: 1.5vh;
            font-weight: 500;
            font-size: clamp(14px, 4vw, 18px);
        }
        
        input, select {
            width: 100%;
            padding: clamp(10px, 3vh, 18px);
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: clamp(14px, 4vw, 18px);
        }
        
        input::placeholder {
            color: #aaa;
        }
        
        input:focus, select:focus {
            outline: none;
            border-color: #888;
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
            margin-top: auto;
            margin-bottom: 2vh;
        }
        
        .btn-confirm:hover {
            background-color: #e35205;
        }
        
        /* Responsive adjustments */
        @media (min-width: 768px) {
            .container {
                padding: 3% 10%;
            }
            
            .booking-form {
                padding: 4% 8%;
            }
        }
        
        @media (min-width: 1200px) {
            .container {
                padding: 2% 20%;
            }
            
            .booking-form {
                padding: 3% 6%;
            }
            
            .form-group {
                margin-bottom: 3vh;
            }
        }
        
        /* Landscape orientation adjustments */
        @media (max-height: 500px) and (orientation: landscape) {
            .container {
                padding: 2% 15%;
            }
            
            h1 {
                margin-bottom: 2vh;
            }
            
            .logo {
                margin-bottom: 2vh;
            }
            
            .logo img {
                width: clamp(100px, 15%, 150px);
            }
            
            .form-group {
                margin-bottom: 2vh;
            }
            
            label {
                margin-bottom: 0.5vh;
            }
            
            .btn-confirm {
                margin-top: 2vh;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="booking-form">
            <h1>RAI COMMON AREA BOOKING</h1>
            
            <div class="logo">
                <img src="../../images/rai_logo.png" alt="RAI Logo">
            </div>
            
            <form id="bookingForm" action="select_date.jsp" method="post">
                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" placeholder="Your name" value="${param.name}" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="Your email" value="${param.email}" required>
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone no.</label>
                    <input type="tel" id="phone" name="phone" placeholder="Your phone no." value="${param.phone}" required>
                </div>
                
                <div class="form-group">
                    <label for="location">Location</label>
                    <select id="location" name="location" required>
                        <option value="" disabled ${empty param.location ? 'selected' : ''}>Select location preferred</option>
                        
                        <%-- Call the DAO to get all places --%>
                        <jsp:useBean id="studentBookingDAO" class="dao.StudentBookingDAO" />
                        <c:set var="places" value="${studentBookingDAO.getAllPlaces()}" />
                        
                        <c:forEach var="place" items="${places}">
                            <option value="${place.place_id}" ${param.location eq place.place_id ? 'selected' : ''}>
                                ${place.building_name}, ${place.location_name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <button type="submit" class="btn-confirm">CONFIRM</button>
            </form>
        </div>
    </div>
    
    <script>
        // Store form data in sessionStorage when form is submitted
        document.getElementById('bookingForm').addEventListener('submit', function() {
            sessionStorage.setItem('bookingName', document.getElementById('name').value);
            sessionStorage.setItem('bookingEmail', document.getElementById('email').value);
            sessionStorage.setItem('bookingPhone', document.getElementById('phone').value);
            sessionStorage.setItem('bookingLocation', document.getElementById('location').value);
        });
        
        // Restore form data from sessionStorage when page loads
        window.onload = function() {
            // Only restore from sessionStorage if not already set by server-side (param values)
            if (!document.getElementById('name').value) {
                document.getElementById('name').value = sessionStorage.getItem('bookingName') || '';
            }
            if (!document.getElementById('email').value) {
                document.getElementById('email').value = sessionStorage.getItem('bookingEmail') || '';
            }
            if (!document.getElementById('phone').value) {
                document.getElementById('phone').value = sessionStorage.getItem('bookingPhone') || '';
            }
            
            const locationSelect = document.getElementById('location');
            const storedLocation = sessionStorage.getItem('bookingLocation');
            
            if (storedLocation && !locationSelect.value) {
                for (let i = 0; i < locationSelect.options.length; i++) {
                    if (locationSelect.options[i].value === storedLocation) {
                        locationSelect.selectedIndex = i;
                        break;
                    }
                }
            }
        };
    </script>
</body>
</html>
