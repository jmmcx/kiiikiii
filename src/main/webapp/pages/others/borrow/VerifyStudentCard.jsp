<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.TransactionModel"%>
<%@ page import="dao.TransactionDAO"%>
<%@ page import="dao.ItemDAO"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.sql.Date"%>
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
            justify-content: center; /* Center content vertically */
            height: 100vh;
            position: relative; /* Makes body the reference for absolute elements */
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
    <a href="../../../pages/others/borrow.jsp">
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
            // Get the selected items from session
            List<TransactionModel> selectedItems = (List<TransactionModel>) session.getAttribute("selectedItems");

            // Update student info in transactions
            for (TransactionModel transaction : selectedItems) {
                transaction.setStudentName(studentName);
                transaction.setStudentId(studentId);
            }

            // Save transactions to the database
            TransactionDAO transactionDAO = new TransactionDAO();
            transactionDAO.saveTransactions(selectedItems);

            // Update inventory quantities
            ItemDAO itemDAO = new ItemDAO();
            for (TransactionModel transaction : selectedItems) {
                String serialNumber = transaction.getSerialNumber();
                int borrowedQuantity = transaction.getQuantity();

                // Get item quantity to determine if it's "bulk"
                int availableQuantity = itemDAO.getItemAvailableQuantity(serialNumber);

                if (availableQuantity >= 0) {
                    // Update inventory for non-bulk items
                    itemDAO.updateItemAvailableQuantity(serialNumber, borrowedQuantity);
                }
            }
    %>

    <!-- JavaScript for delaying the redirection -->
    <script>
        setTimeout(function () {
            window.location.href = "../../../pages/others/borrow/BorrowSummary.jsp";
        }, 5000); // 10 seconds delay
    </script>

    <%
        } else {
            // If card verification fails
            out.println("<p>Card verification failed. Please try again.</p>");
        }
    %>
</body>
</html>