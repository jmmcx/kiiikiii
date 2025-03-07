<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event</title>
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
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }

        .content {
            padding: 0 20px 90px 20px;
            max-width: 900px;
            margin: 0 auto;
        }

        .info-box {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 30px;
            padding: 40px 40px;
            margin: 80px 0;
            cursor: pointer;
            font-size: 35px;
            text-align: center;
            font-weight: bold;
            transition: transform 0.2s, box-shadow 0.2s, background-color 0.2s;
        }

        .info-box:hover {
            transform: translateX(5px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            background: #E35205;
            color: white;
        }
        .subtitle-header {
            background-color: #e35205;
            color: white;
            padding: 30px;
            text-align: center;
            margin-bottom: 60px;
            margin-top: 30px;
            font-size: 43px;
        }

        .subtitle-header h2 {
            margin: 0;
            font-size: 43px;
        }
    </style>
</head>
<body>
    <div class="back-button">
        <img src="../../images/back_arrow.png" alt="Back" class="back-button img" onclick="window.history.back()">
    </div>
    <%
        String status = request.getParameter("status");
        Map<String, String> ongoingEvents = new LinkedHashMap<>();
        ongoingEvents.put("fukuoka", "Fukuoka Institute of Technology Webinar");
        ongoingEvents.put("AIEng", "AI Engineering & Entrepreneurship Webinar");
        ongoingEvents.put("enginnopitch", "Engineering Innovation Pitch 2025");
        ongoingEvents.put("ros", "ROS and Smart Robot Competition 2025");

        Map<String, String> finishedEvents = new LinkedHashMap<>();
        finishedEvents.put("genai", "Generative AI Chatbot Online Workshop");
        finishedEvents.put("zhending", "Zhen Ding Tech Group Workshop");
        finishedEvents.put("smartpolice", "Smart Police Webinar");
        finishedEvents.put("raicoop", "Robotics and AI Coop Project Exhibition");

        Map<String, String> events = "finished".equals(status) ? finishedEvents : ongoingEvents;
    %>

    <div class="title">Event</div>
    <div class="subtitle-header">
        <%= "finished".equals(status) ? "Finished" : "Ongoing" %>
    </div>
    <div class="content">
        <% for (Map.Entry<String, String> entry : events.entrySet()) { %>
            <div class="info-box" onclick="window.location.href='event_detail.jsp?type=<%= entry.getKey() %>'">
                <%= entry.getValue() %>
            </div>
        <% } %>
    </div>
    <script type="text/javascript">
        // Function to redirect to the welcome page after 3 minutes (180000 milliseconds)
        function redirectToWelcomePage() {
            window.location.href = '../welcome.jsp'; 
        }
    
        // Set a timer to call the redirect function after 3 minutes
        setTimeout(redirectToWelcomePage, 180000);  // 180000 milliseconds = 3 minutes
    </script>
</body>
</html>
