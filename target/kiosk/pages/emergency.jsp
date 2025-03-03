<!-- emergency.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Emergency</title>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Lato', sans-serif;
            min-height: 100vh;
            position: relative;
        }

        .back-arrow {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 30px;
            height: 30px;
            cursor: pointer;
        }

        .emergency-title {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            top: 42px;
            font-weight: 700;
            font-size: 20px;
            line-height: 24px;
            color: #000000;
            text-align: center;
        }

        .emergency-button-container {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .emergency-button {
            width: 200px;
            height: 200px;
            background-color: #FF0000;
            border-radius: 50%;
            border: 15px solid #CC0000;
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: transform 0.2s;
        }

        .emergency-button:hover {
            transform: scale(1.05);
        }

        .emergency-button:active {
            transform: scale(0.95);
        }

        .button-text {
            color: white;
            font-weight: bold;
            font-size: 24px;
            text-align: center;
        }

        /* Responsive Design */
        @media screen and (min-width: 1080px) {
            .emergency-button {
                width: 300px;
                height: 300px;
                border-width: 20px;
            }

            .button-text {
                font-size: 32px;
            }

            .emergency-title {
                margin-top: 30px;
                font-size: 40px;
            }
        }

        @media screen and (max-width: 768px) {
            .emergency-button {
                width: 150px;
                height: 150px;
                border-width: 12px;
            }

            .button-text {
                font-size: 18px;
            }
        }
    </style>
</head>
<body>
    <img src="../images/back_arrow.png" class="back-arrow" onclick="window.location.href='other.jsp'">
    <div class="emergency-title">Emergency</div>
    
    <div class="emergency-button-container">
        <div class="emergency-button">
            <div class="button-text">PRESS HERE</div>
        </div>
    </div>

    <jsp:include page="menu.jsp" />

    <script>
        document.querySelector('.emergency-button').addEventListener('click', function() {
            // Add emergency button click handling logic here
            alert('Emergency button pressed');
        });
    </script>
</body>
</html>