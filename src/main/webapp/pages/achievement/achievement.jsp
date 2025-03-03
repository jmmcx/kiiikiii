<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String[][] achievements = {
        {"School Satellite Competition 2024", "../../images/achievement/satellite.png"},
        {"Robocup Japan Open 2024", "../../images/achievement/robocupjp.png"},
        {"Robocup@Home Education Central Region Mini Challenge", "../../images/achievement/robocuphome.png"}
    };
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Achievement</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            min-height: 100vh;
            background-color: #ffffff;
            overflow-y: auto;
        }

        /* Back button styling */
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

        /* Title box styling */
        .page-title {
            text-align: center;
            margin: 80px 0 0;
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }

        /* Main content container */
        .content {
            max-width: 1080px;
            margin: 0 auto;
            text-align: center;
        }

        /* Collaboration section */
        .achievement-section {
            margin-bottom: 60px;
            margin-top: 50px;
        }

        /* Collaboration label */
        .subtitle-header {
            background-color: #e35205;
            color: white;
            padding: 30px;
            text-align: center;
            margin-bottom: 40px;
            font-size:35px;
        }

        /* Collaboration images */
        .achievement-image {
            width: 100%;
            max-width: 800px;
            border-radius: 30px;
            display: block;
            margin: 0 auto;
        }
        .moreinfo-button {
            display: block;
            width: 100%;
            max-width: 750px;
            margin: 40px auto;
            padding: 20px;
            background-color: #ff5722;
            color: white;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-size: 40px;
            font-weight: bold;
            transition: background-color 0.2s;
            text-decoration: none;
        }
        /* Responsive Design */
        @media screen and (max-width: 768px) {
            .back-arrow {
                width: 25px;
                height: 25px;
            }

            .title-box {
                font-size: 22px;
                padding: 10px;
            }
            .moreinfo-button {
                width: 90%;
            }
            .achievement-image {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <script>
        window.addEventListener("scroll", function () {
            let backButton = document.querySelector(".back-button");
            let currentScroll = window.pageYOffset || document.documentElement.scrollTop;
    
            if (currentScroll > 100) {
                backButton.style.opacity = "0"; // Hide button
                backButton.style.pointerEvents = "none"; // Prevent clicking when hidden
            } else {
                backButton.style.opacity = "1"; // Show button
                backButton.style.pointerEvents = "auto";
            }
        });
    </script>  
    <!-- Back button -->
    <a href="../other.jsp" class="back-button">
        <img src="../../images/back_arrow.png" alt="Back"  class="back-button img">
    </a>
    <div class="page-title">Achievement</div>
    <!-- Title -->
    <div class="content">
        <% for (String[] achieve : achievements) { %>
            <div class="achievement-section">
                <div class="subtitle-header"><%= achieve[0] %></div>
                <img src="<%= achieve[1] %>" alt="<%= achieve[0] %>" class="achievement-image">
            </div>
        <% } %>
        <a href="achievement_detail.jsp" class="moreinfo-button">FOR MORE INFORMATION</a>
    </div>

</body>
</html>
