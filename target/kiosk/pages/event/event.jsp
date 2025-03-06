<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event</title>
    <script type="text/javascript">
        // Function to redirect to the welcome page after 3 minutes (180000 milliseconds)
        function redirectToWelcomePage() {
            window.location.href = '../welcome.jsp'; // Change this to the path of your welcome page
        }
    </script>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            min-height: 100vh;
            background-color: #ffffff;
        }

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

        .title {
            text-align: center;
            margin: 80px 0 20px;
            font-size: 65px;
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }

        .container {
            display: flex;
            flex-direction: column;
            gap: 120px;
            padding: 65px;
            align-items: center;
            justify-content: center;
        }

        .option-box {
            background-color: #d6d6d6;
            width: 90%;
            max-width: 700px;
            border-radius: 25px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            color: black;
            transition: transform 0.2s, background 0.3s;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
        }

        .option-box:hover {
            background: #E35205;
            transform: scale(1.02);
            color: white;
        }

        .option-box img {
            width: 48%;
            height: auto;
            margin-bottom: 20px;
        }

        .option-box span {
            font-size: 40px;
            font-weight: 600;
        }

        @media screen and (max-width: 600px) {
            .option-box {
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <div class="back-button">
        <img src="../../images/back_arrow.png" alt="Back" class="back-button img" onclick="window.location.href='../other.jsp'">
    </div>

    <div class="title">Event</div>
    // Set a timer to call the redirect function after 3 minutes
    setTimeout(redirectToWelcomePage, 180000);  // 180000 milliseconds = 3 minutes
    <div class="container">
        <a href="event_type.jsp?status=ongoing" class="option-box">
            <img src="../../images/ongoing.png" alt="Ongoing">
            <span>Ongoing</span>
        </a>

        <a href="event_type.jsp?status=finished" class="option-box">
            <img src="../../images/finished.png" alt="Finished">
            <span>Finished</span>
        </a>
    </div>
</body>
</html>
