<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Page</title>
    <link rel="stylesheet" href="../theme/menu.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
            overflow: hidden;
        }

        .header {
            padding: 30px 20px;
            position: relative;
            margin-top: 50px;
        }

        .back-button {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 24px;
            text-decoration: none;
            color: black;
        }

        .title {
            text-align: center;
            font-size: 2.5em;
            font-weight: bold;
        }

        .container {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 40px;
            padding: 20px;
            align-items: center;
            justify-content: center;
            max-height: calc(100vh - 200px); /* Adjust based on header and menu height */
        }

        .option-box {
            width: 80%;
            aspect-ratio: 1;
            max-width: 400px;
            border-radius: 25px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            color: black;
            transition: transform 0.2s;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .option-box:hover {
            transform: scale(1.02);
        }

        .option-box img {
            width: 40%;
            height: auto;
            margin-bottom: 20px;
        }

        .option-box span {
            font-size: 1.8em;
            font-weight: 600;
        }

        .borrow {
            background-color: #E6F3FF;
        }

        .return {
            background-color: #FFE6F3;
        }

        /* Media query for kiosk screens (1080x1920) */
        @media screen and (min-width: 1080px) and (min-height: 1920px) {
            .header {
                padding: 40px 20px;
            }

            .title {
                font-size: 3em;
            }

            .container {
                gap: 60px;
                padding: 40px;
            }

            .option-box {
                width: 70%;
                max-width: 500px;
                border-radius: 30px;
            }

            .option-box img {
                width: 45%;
                margin-bottom: 30px;
            }

            .option-box span {
                font-size: 2.2em;
            }
        }

        /* Media query for smaller screens */
        @media screen and (max-height: 800px) {
            .container {
                gap: 30px;
                padding: 15px;
            }

            .option-box {
                max-width: 300px;
            }

            .option-box span {
                font-size: 1.5em;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="title">Inventory</div>
    </div>

    <div class="container">
        <a href="others/borrow.jsp" class="option-box borrow">
            <img src="../images/borrow.png" alt="Borrow">
            <span>Borrow</span>
        </a>

        <a href="others/return/VerifyStudentCard.jsp" class="option-box return">
            <img src="../images/return.png" alt="Return">
            <span>Return</span>
        </a>
    </div>
    <!-- Include Menu -->
    <jsp:include page="menu.jsp">
        <jsp:param name="activePage" value="inventory" />
    </jsp:include>
</body>
</html>