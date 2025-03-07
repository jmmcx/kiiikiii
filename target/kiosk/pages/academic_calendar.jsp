<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Documentation</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            padding: 30px;
            background-color: #f8f9fa;
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

        .page-title {
            text-align: center;
            margin: 80px 0 20px;
            font-size: 65px;
            font-weight: bold;
            margin-top: 150px;
            margin-bottom: 90px;
        }

        .academic-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .year-box {
            background-color: #D9D9D9;
            border-radius: 30px;
            padding: 40px 30px;
            text-align: center;
            cursor: pointer;
            text-decoration: none;
            color: black;
            transition: transform 0.2s, box-shadow 0.2s;
            font-size:50px;
        }

        .year-box:hover {
            background: #E35205;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            color: white;
        }

        /* Specific styles for vertical screens (including 1080x1920) */
        @media screen and (orientation: portrait) and (min-width: 1080px) {
            body {
                padding: 40px;
            }

            .page-title {
                font-size: 65px;
            }

            .academic-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 80px;
                padding: 0 40px;
            }

            .year-box {
                padding: 60px 40px;
            }
        }

        /* Adjustments for smaller screens */
        @media (max-width: 768px) {
            .document-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }
        }

        @media (max-width: 480px) {
            .document-grid {
                grid-template-columns: 1fr;
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
    <h1 class="page-title">Academic Calendar</h1>

    <div class="academic-grid">
        <div class="year-box" onclick="goToDetail(2025)">2025</div>
        <div class="year-box" onclick="goToDetail(2568)">2568</div>
        <div class="year-box" onclick="goToDetail(2024)">2024</div>
        <div class="year-box" onclick="goToDetail(2567)">2567</div>
        <div class="year-box" onclick="goToDetail(2023)">2023</div>
        <div class="year-box" onclick="goToDetail(2566)">2566</div>
        <div class="year-box" onclick="goToDetail(2022)">2022</div>
        <div class="year-box" onclick="goToDetail(2565)">2565</div>
        <div class="year-box" onclick="goToDetail(2021)">2021</div>
        <div class="year-box" onclick="goToDetail(2564)">2564</div>
    </div>
    <%@ include file="menu.jsp" %>
    <script>
        function goToDetail(year) {
            window.location.href = 'academic_detail.jsp?year=' + year;
        }
    </script>
    <script type="text/javascript">
        // Function to redirect to the welcome page after 3 minutes (180000 milliseconds)
        function redirectToWelcomePage() {
            window.location.href = 'welcome.jsp'; 
        }
    
        // Set a timer to call the redirect function after 3 minutes
        setTimeout(redirectToWelcomePage, 180000);  // 180000 milliseconds = 3 minutes
      </script>
</body>
</html>


