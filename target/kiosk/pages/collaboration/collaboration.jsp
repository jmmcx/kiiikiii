<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String[][] collaborations = {
        {"Kyushu Institute of Technology", "../../images/collaboration/kyutech.png"},
        {"Fukuoka Institute of Technology", "../../images/collaboration/FIT.jpg"},
        {"Temasek Polytechnic", "../../images/collaboration/temasek.jpg"}
    };
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Collaboration</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            min-height: 100vh;
            background-color: #ffffff;
            overflow-y: auto; /* Enable vertical scrolling */
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
            margin: 80px 0 20px;
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }

        /* Main content container */
        .content {
            padding: 0 20px 90px 20px;
            max-width: 1000px;
            margin: 0 auto;
            text-align: center;
        }

        /* Collaboration section */
        .collab-section {
            margin-bottom: 60px;
            margin-top: 50px;
        }

        /* Collaboration label */
        .label {
            background-color: #ff5722;
            color: white;
            padding: 20px;
            border-radius: 20px;
            display: inline-block;
            font-size: 35px;
            font-weight: bold;
            margin-bottom: 30px;
        }

        /* Collaboration images */
        .collab-image {
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

            .label {
                font-size: 16px;
                padding: 8px;
            }
            .moreinfo-button {
                width: 90%;
            }
            .collab-image {
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
    <div class="page-title">Collaboration</div>
    <!-- Title -->
    <div class="content">
        <% for (String[] collab : collaborations) { %>
            <div class="collab-section">
                <div class="label"><%= collab[0] %></div>
                <img src="<%= collab[1] %>" alt="<%= collab[0] %>" class="collab-image">
            </div>
        <% } %>
        <a href="collaboration_detail.jsp" class="moreinfo-button">FOR MORE INFORMATION</a>
    </div>

</body>
</html>
