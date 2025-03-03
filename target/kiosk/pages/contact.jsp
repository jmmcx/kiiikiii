<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #ffffff;
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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
            flex-grow: 1; /* Allows the container to take only the necessary space */
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            min-height: unset; /* Resets any height restrictions */
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

        .contact-list {
            width: 90%;
            max-width: 900px;
            margin: 80px auto 0;
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
            margin-top: 65px;
            gap: 80px;
        }

        .contact-item {
            display: flex;
            align-items: center;
            background-color: #ffcc99;
            padding: 40px 50px;
            border-radius: 50px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            width: 100%;
            box-sizing: border-box;
        }

        .contact-item:hover {
            transform: scale(1.02);
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .contact-logo {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin-right: 20px;
            object-fit: cover;
        }

        .contact-name {
            font-size: 40px;
            font-weight: bold;
            color:white;
        }

        /* Specific styles for 1080x1920 screens */
        @media screen and (min-width: 1080px) and (min-height: 1920px) {
            .contact-list {
                width: 100%;
                margin-top: 65px; /* Increased top margin */
                gap: 80px; /* Increased space between contacts */
            }
            
            .title {
                font-size: 65px;
                margin-top: 190px;
                margin-bottom: 10px;
            }

            .contact-item {
                padding: 40px 50px;
            }
            
            .contact-logo {
                width: 120px;
                height: 120px;
                margin-right: 30px;
            }
            
            .contact-name {
                font-size: 40px;
            }
        }

        @media screen and (max-width: 768px) {
            .contact-list {
                width: 95%;
                margin-top: 60px;
            }
            
            .contact-item {
                padding: 15px 25px;
            }

            .title {
                font-size: 20px;
                margin-top: 50px;
                margin-bottom: 10px;
            }

            .back-icon {
                width: 25px;
            }
            
            .contact-logo {
                width: 50px;
                height: 50px;
            }
            
            .contact-name {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="back-button">
        <a href="other.jsp">
            <img src="../images/back_arrow.png" alt="Back" class="back-button img">
        </a>
    </div>
    <div class="title">Contact</div>
    <div class="container">
        <!-- Contact List -->
        <div class="contact-list">
            <div class="contact-item" onclick="window.location.href='contact_details.jsp?id=0'">
                <img src="../images/rai_logo.png" alt="Robotics and AI" class="contact-logo">
                <span class="contact-name">Robotics and AI</span>
            </div>
            <div class="contact-item" onclick="window.location.href='contact_details.jsp?id=1'">
                <img src="../images/kesa_logo.png" alt="KESA" class="contact-logo">
                <span class="contact-name">KESA</span>
            </div>
            <div class="contact-item" onclick="window.location.href='contact_details.jsp?id=2'">
                <img src="../images/siie_logo.png" alt="SIIE" class="contact-logo">
                <span class="contact-name">SIIE</span>
            </div>
            <div class="contact-item" onclick="window.location.href='contact_details.jsp?id=3'">
                <img src="../images/ia_logo.jpg" alt="IA.ENG" class="contact-logo">
                <span class="contact-name">IA.ENG</span>
            </div>
            <div class="contact-item" onclick="window.location.href='contact_details.jsp?id=4'">
                <img src="../images/oia_logo.png" alt="OIA" class="contact-logo">
                <span class="contact-name">OIA</span>
            </div>

        </div>
    </div>
</body>
</html>