<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.QRCodeUtil"%>
<%@ page import="util.ConfigUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Calendar</title>
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
            font-size: 50px;
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }

        .subtitle {
            font-size: 35px;
            font-weight: 600px; /*semi-bold */
            text-align: center;
            margin: 0 0 30px 0; /* top 0, bottom 30 */
        }

        .content {
            padding: 25px 20px 90px 20px;
            max-width: 1000px;
            margin: 0 auto;
            text-align: center;
        }

        .pdf-viewer {
            width: 100%;
            height: 60vh;
            margin: 30px 0;
        }


        /* Media queries for responsiveness */
        /*@media screen and (min-width: 1920px) {
            .back-arrow {
                width: 30px;
                height: 30px;
            }

            .title {
                font-size: 30px;
            }

            .subtitle {
                font-size: 24px;
            }

            .qr-code {
                max-width: 400px;
            }
        }

        @media screen and (max-width: 1080px) and (min-height: 1920px) {
            .back-arrow-container {
                padding: 25px;
            }

            .back-arrow {
                width: 35px;
                height: 35px;
            }

            .content {
                padding: 100px 30px 140px 30px;
            }

            .title {
                font-size: 50px;
                margin-bottom: 20px;
            }

            .subtitle {
                font-size: 28px;
                margin-bottom: 40px;
            }

            .qr-code {
                max-width: 500px;
                margin: 50px auto;
            }

            .button {
                padding: 16px 32px;
                font-size: 20px;
                margin: 15px;
            }
        }*/

        @media screen and (max-width: 768px) {
            .content {
                padding: 50px 15px 80px 15px;
            }

            .title {
                font-size: 20px;
            }

            .subtitle {
                font-size: 16px;
            }

            .button {
                padding: 10px 20px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="back-button">
        <img src="../images/back_arrow.png" alt="Back" class="back-button img" onclick="history.back()">
    </div>
    <%
        String year = request.getParameter("year");
        String pdfPath = ConfigUtil.getProperty("academic.calendar." + year);
        %>
    <div class="title">Academic Calendar <%= year %></div>
    <div class="content">
                <div id="pdfContent">
                    <iframe src="https://docs.google.com/gview?embedded=true&url=<%= pdfPath %>" class="pdf-viewer"></iframe>
                </div>
    </div>
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