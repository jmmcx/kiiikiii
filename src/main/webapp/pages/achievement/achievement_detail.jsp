<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.QRCodeUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Achievement Detail</title>
    <script type="text/javascript">
        // Function to redirect to the welcome page after 3 minutes (180000 milliseconds)
        function redirectToWelcomePage() {
            window.location.href = '../welcome.jsp'; // Change this to the path of your welcome page
        }
    </script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
    
        body {
            min-height: 100vh;
            background-color: #ffffff;
        }
    
        .back-button {
            position: fixed;
            top: 90px;
            left: 70px;
            z-index: 100;
            transition: opacity 0.3s ease-in-out;
        }
    
        .back-button img {
            width: 80px;
            height: 80px;
        }
    
    
        .container {
            min-height: 100vh;
            width: 100%;
            max-width: 1080px;
            margin: 0 auto;
            padding: 20px 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
    
        .content-wrapper {
            width: 100%;
            max-width: 800px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 30px; /* Consistent spacing between elements */
        }
    
        .title {
            text-align: center;
            margin: 80px 0 20px;
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }
    
        .qr-code {
            width: 600px;
            height: 600px;
            margin: 20px 0;
        }
        .qr-code img {
            width: 100%;
            height: auto;
        }
        .menu-button {
            display: block;
            width: 100%;
            max-width: 900px;
            margin: 40px auto;
            padding: 20px;
            background-color: #ff5722;
            color: white;
            border: none;
            border-radius: 15px;
            cursor: pointer;
            font-size: 40px;
            font-weight: bold;
            transition: background-color 0.2s;
            text-decoration: none;
            text-align: center;
        }
    </style>
</head>
<body>
    <a onclick="window.history.back()" class="back-button">
        <img src="../../images/back_arrow.png" alt="Back" class="back-button img">
    </a>
    <div class="title">Achievement</div>
    // Set a timer to call the redirect function after 3 minutes
    setTimeout(redirectToWelcomePage, 180000);  // 180000 milliseconds = 3 minutes
    <div class="container">
        <div class="content-wrapper">
            <div class="qr-code">
                <img src="../../images/achievement/qr.png" alt="QR Code">
            </div>
            <a href="../home.jsp" class="menu-button">
                BACK TO MAIN MENU
            </a>
        </div>
    </div>
</body>
</html>