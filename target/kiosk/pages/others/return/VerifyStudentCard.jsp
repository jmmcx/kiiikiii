<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.TransactionModel"%>
<%@ page import="dao.TransactionDAO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Student Card</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #fff;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            position: relative;
            overflow: hidden;
        }

        .back-button {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 40px;
            height: 40px;
            cursor: pointer;
        }

        .header {
            font-size: 1.8em;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
        }

        .loading-container {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .loading-gif {
            width: 120px;
            height: 120px;
        }
    </style>
</head>
<body>

    <!-- Back Icon -->
    <a href="../../../pages/inventory.jsp">
        <img src="../../../images/back_arrow.png" alt="Back" class="back-button">
    </a>

    <!-- Header -->
    <div class="header">PLEASE SCAN YOUR STUDENT CARD</div>

    <!-- Loading GIF -->
    <div class="loading-container">
        <img src="../../../images/loading.gif" alt="Loading..." class="loading-gif">  
    </div>

    <%
        // Simulate card verification (hardcoded for now)
        boolean cardVerified = true;
        String studentName = "Patramon Tongsari";
        String studentId = "64011527";

        if (cardVerified) {
            // Create a transaction model to store student info
            TransactionModel transaction = new TransactionModel();
            transaction.setStudentName(studentName);
            transaction.setStudentId(studentId);
        
    %>

    <!-- JavaScript for delaying the redirection -->
    <script>
        setTimeout(function () {
            window.location.href = "../../../pages/others/return.jsp";
        }, 5000); // 5 seconds delay
    </script>

    <%
        } else {
            // If card verification fails
            out.println("<p>Card verification failed. Please try again.</p>");
        }
    %>
</body>
</html>