<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.StudentBookingModel" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RAI Common Area Booking - Booking Completed</title>
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
            align-items: center;
            text-align: center;
        }
        
        .booking-complete {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            flex-grow: 1;
            margin: 30px 0;
        }
        
        .success-icon {
            width: 80px;
            height: 80px;
            margin: 20px 0;
        }
        
        .booking-message {
            font-weight: bold;
            font-size: 20px;
            margin-bottom: 20px;
        }
        
        .booking-note {
            color: #777;
            font-size: 14px;
            max-width: 300px;
            margin: 10px auto;
            line-height: 1.4;
        }
        
        .btn-container {
            margin-top: auto;
            width: 100%;
            max-width: 300px;
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
        
        .btn-home {
            background-color: #e35205;
        }
        
        /* Responsive adjustments */
        @media (min-width: 768px) {
            .container {
                padding: 40px;
                max-width: 600px;
            }
            
            .success-icon {
                width: 100px;
                height: 100px;
            }
            
            .booking-message {
                font-size: 24px;
            }
            
            .booking-note {
                font-size: 16px;
                max-width: 400px;
            }
            
            .btn-container {
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
    <!-- Trigger the servlet on page load -->
    <script type="text/javascript">
        window.onload = function() {
            // Trigger the servlet on page load
            fetch('<%= request.getContextPath() + "/StudentBookingServlet" %>', {
                method: 'GET'
            })
            .then(response => response.text())  // You can process the response if needed
            .then(data => console.log(' StudentBookingServlet triggered:', data))
            .catch(error => console.error('Error triggering servlet:', error));
        }
    </script>    
    
    <div class="container">
        <div class="booking-complete">
            <h2 class="booking-message">Booking completed</h2>
            
            <img src="../../images/success.png" alt="Success" class="success-icon">
            
            <p class="booking-note">
                After approval, QR code will be send via email.
                Please check-in within 15 minutes from the time reserved.
                Late check-in will cause a penalty and auto cancellation.
            </p>
        </div>
        
        <div class="btn-container">
            <a href="<%= request.getContextPath() %>/pages/home.jsp" class="btn btn-home">Home</a>
        </div>
    </div>
</body>
</html>