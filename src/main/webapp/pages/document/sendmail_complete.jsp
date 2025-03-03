<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Completed</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            padding: 20px;
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

        .container {
            max-width: 765px;
            margin: 60px auto 0;
            text-align: center;
            padding: 20px;
        }

        .title {
            text-align: center;
            margin: 80px 0 20px;
            font-size: 50px;
            font-weight: bold;
            margin-top: 190px;
            margin-bottom:100px;
        }

        .document-type {
            display: inline-block;
            background-color: #ff5722;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            margin: 15px 0;
        }

        .completion-message {
            color: #666;
            line-height: 1.8;
            text-align-last: center;
            font-size:40px;
        }

        .main-menu-button {
            display: block;
            width: 100%;
            max-width: 100%;
            margin: 100px auto;
            padding: 15px;
            background-color: #ff5722;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 50px;
            cursor: pointer;
            text-decoration: none;
            text-transform: uppercase;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <a href="../other.jsp" class="back-button">
        <img src="../../images/back_arrow.png" alt="Back"  class="back-button img">
    </a>

    <div class="container">
        <h1 class="title">COMPLETED</h1>
        
        <p class="completion-message">
            The document have been sent via email. If there's any problem occurred or didn't receive the file please press contact button on the top right of the service.
        </p>

        <a href="../other.jsp" class="main-menu-button">
            BACK TO MAIN MENU
        </a>
    </div>
</body>
</html>