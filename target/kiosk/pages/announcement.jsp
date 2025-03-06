<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Announcement</title>
    <script type="text/javascript">
        // Function to redirect to the welcome page after 3 minutes (180000 milliseconds)
        function redirectToWelcomePage() {
            window.location.href = 'welcome.jsp'; // Change this to the path of your welcome page
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
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }

        .content {
            padding: 0 20px 90px 20px;
            max-width: 1000px;
            margin: 0 auto;
        }

        .info-box {
            background-color: #E6E6E6;
            padding: 50px;
            margin: 80px 0;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s;
            text-align: center;
            font-weight: bold;
            font-size: 42px;
        }

        .info-box:hover {
            background-color: #D6D6D6;
            transform: scale(1.02);
            background: #E35205;
            color: white;
        }

        /* Media queries for responsiveness */
        @media screen and (min-width: 1920px) {
            .back-button {
                width: 80px;
                height: 80px;
            }
        }
        @media screen and (max-width: 1080px) and (min-height: 1920px) {
            .title {
                text-align: center;
                margin: 80px 0 20px;
                font-weight: bold;
                margin-top: 190px;
                font-size: 65px;
            }

            .content {
                padding: 0 30px 140px 30px;
                max-width: 900px;
            }
        }

        @media screen and (max-width: 768px) {
            .title {
                font-size: 20px;
                margin-top: 50px;
                margin-bottom: 20px;
            }

            .content {
                padding: 0 15px 80px 15px;
            }

            .info-box {
                padding: 15px;
                font-size: 16px;
                margin: 12px 0;
            }
        }
    </style>
</head>
<body>
    <div class="back-button">
        <img src="../images/back_arrow.png" alt="Back" class="back-button img" onclick="window.location.href='other.jsp'">
    </div>

    <div class="title">Announcement</div>

    <div class="content">
        <div class="info-box" onclick="window.location.href='announcement_detail.jsp?type=pm25'">
            Studying Plan during PM 2.5
        </div>
        <div class="info-box" onclick="window.location.href='announcement_detail.jsp?type=engjobfair'">
            Engineering Job Fair
        </div>
    <!-- Include menu JSP file -->
     
    // Set a timer to call the redirect function after 3 minutes
    setTimeout(redirectToWelcomePage, 180000);  // 180000 milliseconds = 3 minutes
    <%@ include file="newmenu.jsp" %>
    </div>
</body>
</html>