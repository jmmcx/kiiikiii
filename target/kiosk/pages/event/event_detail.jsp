<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%
    // Get the 'type' parameter from the URL
    String type = request.getParameter("type");

    // Set default values for title and image
    String title = "Event";
    String imagePath = "";

    if ("fukuoka".equals(type)) {
        imagePath = "../../images/event/fukuoka.png";
    } else if ("AIEng".equals(type)) {
        imagePath = "../../images/event/AIEng.png";
    } else if ("enginnopitch".equals(type)) {
        imagePath = "../../images/event/enginnopitch.png";
    } else if ("ros".equals(type)) {
        imagePath = "../../images/event/ros.png";
    } else if ("genai".equals(type)) {
        imagePath = "../../images/event/genai.png";
    } else if ("zhending".equals(type)) {
        imagePath = "../../images/event/zhending.png";
    } else if ("smartpolice".equals(type)) {
        imagePath = "../../images/event/smartpolice.png";
    } else if ("raicoop".equals(type)) {
        imagePath = "../../images/event/raicoop.png";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title %></title>
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
            display: flex;
            flex-direction: column;
            align-items: center;
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
    
        .container {
            width: 100%;
            max-width: 900px;
            margin-top: 20px;
            text-align: center;
        }
    
        .title {
            text-align: center;
            margin: 80px 0 20px;
            font-size: 65px;
            font-weight: bold;
            margin-top: 190px;
        }

        .event-image {
            width: 100%;
            max-width: 900px;
            border-radius: 10px;
            margin: 20px 0;
        }
    
        .mainmenu-button {
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
        }

        .mainmenu-button:hover {
            background-color: #f4511e;
        }
        @media screen and (max-width: 768px) {
            .event-image {
                max-width: 100%;
            }

            .mainmenu-button {
                width: 90%;
            }
        }
    </style>
</head>
<body>

    <a class="back-button" onclick="window.history.back()">
        <img src="../../images/back_arrow.png" alt="Back">
    </a>
    
    // Set a timer to call the redirect function after 3 minutes
    setTimeout(redirectToWelcomePage, 180000);  // 180000 milliseconds = 3 minutes
    <div class="title">Event</div>
    <div class="container">
        <% if (!imagePath.isEmpty()) { %>
            <img src="<%= imagePath %>" alt="<%= title %>" class="event-image">
        <% } else { %>
            <p>No event available.</p>
        <% } %>
        <a href="../home.jsp" class="mainmenu-button">BACK TO MAIN MENU</a>
    </div>
</body>
</html>
