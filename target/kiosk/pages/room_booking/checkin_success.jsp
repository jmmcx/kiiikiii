<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check-In Success</title>
    <script>
        function goBackToMainMenu() {
            window.location.href = '../home.jsp'; // Redirect to home page
        }
    </script>
    <style>
        /* Reset and base styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #ffffff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        /* Container with exact 1080x1920 dimensions */
        .container {
            width: 1080px;
            height: 1920px;
            flex: 1;
            flex-direction: column;
            width: 100%;
            position: relative;
            padding-top: 40px;
        }

        /* Header section */
        .header {
            width: 100%;
            height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            padding-top: 40px;
        }

        /* Title styles - centered and properly sized */
        .title {
            text-align: center;
            margin: 80px 0 20px;
            font-size: 50px;
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }

        /* Back arrow styles - positioned appropriately */
        .back-button {
            position: fixed;
            top: 90px;
            left: 70px;
            z-index: 100;
        }
    
        .back-button img {
            width: 80px;
            height: 80px;
        }

        /* Main content area - centered vertically and horizontally */
        .content-area {
            flex: 1;
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 45px 0;
        }

        /* Success message styling */
        .success-message {
            font-size: 48px;
            font-weight: 700;
            color: #000;
            margin-bottom: 120px;
            text-align: center;
            line-height: 2.5;
        }

        /* Success icon - much larger */
        .success-icon {
            width: 400px;
            height: 400px;
            margin-bottom: 120px;
        }

        /* Animation for success icon */
        @keyframes pulse-success {
            0% { transform: scale(1); }
            50% { transform: scale(1.3); }
            100% { transform: scale(1); }
        }

        .success-icon {
            animation: pulse-success 6s ease-in-out;
        }

        /* Footer area */
        .footer {
            width: 100%;
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding-bottom: 60px;
        }

        /* Back to main menu button - larger and more prominent */
        .main-menu-btn {
            background-color: #e35205;
            color: white;
            padding: 15px;
            border: none;
            border-radius: 25px;
            width: 90%;
            max-width: 700px;
            margin: 0 auto 30px;
            cursor: pointer;
            font-size: 45px;
            display: block;
        }
    </style>
</head>
<body>
    <div class="back-button">
        <a onclick="window.history.back()">
            <img src="../../images/back_arrow.png" alt="Back" class="back-button img">
        </a>
    </div>
    <div class="title">Room Booking</div>
    <div class="container">
        <!-- Main content area - vertically centered -->
        <div class="content-area">
            <!-- Success Message and Icon - centered -->
            <div class="success-message">
                SCAN COMPLETED<br/>WELCOME TO RAI, KMITL
            </div>
            <img class="success-icon" src="../../images/success.png" alt="Success Icon" />
        </div>
        <button class="main-menu-btn" onclick="goBackToMainMenu()">
            BACK TO MAIN MENU
        </button>
    </div>
</body>
</html>