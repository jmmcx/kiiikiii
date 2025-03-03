<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.QRCodeUtil"%>
<%@ page import="util.ConfigUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scholarship Detail</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            min-height: 100vh;
            background-color: #ffffff;
        }

        .back-arrow-container {
            position: fixed;
            top: 0;
            left: 0;
            padding: 15px;
            background-color: #ffffff;
            z-index: 1000;
        }

        .back-arrow {
            width: 30px;
            height: 30px;
            cursor: pointer;
        }

        .title {
            font-size: 30px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 30px;
        }

        .subtitle {
            font-size: 18px;
            font-weight: 600px; /*semi-bold */
            text-align: center;
            margin: 0 0 30px 0; /* top 0, bottom 30 */
        }

        .content {
            padding: 60px 20px 90px 20px;
            max-width: 1000px;
            margin: 0 auto;
            text-align: center;
        }

        .pdf-viewer {
            width: 100%;
            height: 70vh;
            margin: 20px 0;
        }

        .qr-code {
            max-width: 300px;
            margin: 30px auto;
        }

        .qr-code img {
            width: 100%;
            height: auto;
        }

        .button {
            display: inline-block;
            padding: 12px 24px;
            margin: 10px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .main-menu-btn {
            background-color: #FF5722;
            color: white;
        }

        .qr-btn {
            background-color: #4CAF50;
            color: white;
        }

        /* Media queries for responsiveness */
        @media screen and (min-width: 1920px) {
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
        }

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
    <div class="back-arrow-container">
        <img src="../images/back_arrow.png" alt="Back" class="back-arrow" onclick="history.back()">
    </div>

    <div class="content">
        <div class="title">Scholarship</div>
        <%
            String scholarshipUrl = ConfigUtil.getProperty("scholarship.url");
            String type = request.getParameter("type");
            if ("scholarship".equals(type)) {
                // For admission, redirect immediately to SIIE FB page
                response.sendRedirect(scholarshipUrl);
            } 
        %>
    </div>

</body>
</html>