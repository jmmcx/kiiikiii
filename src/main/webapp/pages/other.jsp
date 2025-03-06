<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script type="text/javascript">
        // Function to redirect to the welcome page after 3 minutes (180000 milliseconds)
        function redirectToWelcomePage() {
            window.location.href = 'welcome.jsp'; // Change this to the path of your welcome page
        }
    </script>
    <style>
        body {
            min-height: 100vh;
            background-color: #f8f9fa;
            padding: 20px;
            margin: 0;
        }

        .grid-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            row-gap: 30px;
            column-gap: 20px;
            width: 100%;
            max-width: 10800px;
            margin-top: 80px;
            padding: 20px;
        }

        .grid-item {
            background-color: #beb7b3;
            text-align: center;
            padding: 20px;
            height: 325px;
            border-radius: 20px;
            cursor: pointer;
            font-weight: bold;
            font-size: 30px;
            text-decoration: none;
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            aspect-ratio: 1;
        }

        .grid-item img {
            width: 120px;
            height: 120px;
            margin-bottom: 10px;
        }

        .grid-item:hover {
            background-color: #e35205;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
        }

        /* Tablet Portrait and Landscape */
        /*@media (max-width: 1024px) {
            .grid-container {
                grid-template-columns: repeat(3, 1fr);
                gap: 10px;
                padding: 10px;
            }
            
            .grid-item {
                padding: 15px;
            }
        }

        /* Mobile Landscape */
        /*@media (max-width: 768px) {
            .grid-container {
                grid-template-columns: repeat(2, 1fr);
                max-width: 100%;
            }
        }

        /* Mobile Portrait */
        /*@media (max-width: 480px) {
            .grid-container {
                grid-template-columns: 1fr;
            }
        }

        /* Desktop and Large Screens */
        /*@media (min-width: 1025px) {
            .grid-container {
                max-width: 1080px;
            }
        }

        /* iPad Air and Similar Tablets in Landscape */
        /*@media (min-width: 1024px) and (max-height: 768px) {
            body {
                height: auto;
                min-height: 100vh;
            }
            
            .grid-container {
                margin: 0 auto;
            }
            
            .grid-item {
                aspect-ratio: 1.2;
                padding: 15px;
            }
        }*/
    </style>
</head>
<body>
    <div class="grid-container">
        <a href="contact.jsp" class="grid-item"><img src="../images/icon/contact2.png" alt="Contact">CONTACT</a>
        <a href="room_booking/room_booking.jsp" class="grid-item"><img src="../images/icon/roombooking.png" alt="Room">ROOM BOOKING</a>
        <a href="document/document.jsp" class="grid-item"><img src="../images/icon/document.png" alt="Document">DOCUMENT</a>
        <a href="information.jsp" class="grid-item"><img src="../images/icon/information.png" alt="Info">INFORMATION</a>
        <a href="emergency.jsp" class="grid-item"><img src="../images/icon/emergency.png" alt="Emergency">EMERGENCY</a>
        <a href="curriculum.jsp" class="grid-item"><img src="../images/icon/curriculum.png" alt="Curriculum">CURRICULUM</a>
        <a href="academic_calendar.jsp" class="grid-item"><img src="../images/icon/academiccalendar.png" alt="Calendar">ACADEMIC CALENDAR</a>
        <a href="event/event.jsp" class="grid-item"><img src="../images/icon/event.png" alt="Event">EVENT</a>
        <a href="scholarship.jsp" class="grid-item"><img src="../images/icon/scholarship.png" alt="Scholarship">SCHOLARSHIP</a>
        <a href="collaboration/collaboration.jsp" class="grid-item"><img src="../images/icon/collaboration.png" alt="Collaboration">COLLABORATION</a>
        <a href="achievement/achievement.jsp" class="grid-item"><img src="../images/icon/achievement.png" alt="Project">ACHIEVEMENT</a>
        <a href="announcement.jsp" class="grid-item"><img src="../images/icon/announcement.png" alt="Announcement">ANNOUNCEMENT</a>
        // Set a timer to call the redirect function after 3 minutes
        setTimeout(redirectToWelcomePage, 180000);  // 180000 milliseconds = 3 minutes
        <%@ include file="menu.jsp" %>
    </div>
</body>
</html>