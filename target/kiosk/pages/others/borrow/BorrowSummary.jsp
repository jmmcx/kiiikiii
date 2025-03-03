<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.TransactionModel" %>
<%@ page import="dao.ItemDAO" %>
<%@ page import="util.SendMail" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Borrow Summary</title>
    <link rel="stylesheet" href="../../../theme/borrowsummary.css">
    <script>
        // Clear session storage
        sessionStorage.clear();

        // Countdown script for "AUTO RETURN IN X"
        let countdown = 30;
        function startCountdown() {
            const countdownElement = document.getElementById("countdown");
            const interval = setInterval(() => {
                countdown--;
                countdownElement.textContent = countdown;
                if (countdown <= 0) {
                    clearInterval(interval);
                    window.location.href = "<%= request.getContextPath() %>/pages/inventory.jsp"; // Redirect to borrow page
                }
            }, 1000);
        }
        window.onload = startCountdown;
    </script>
</head>
<body>
    <a href="../../../pages/others/borrow/VerifyStudentCard.jsp" class="back-button">
        <img src="../../../images/back_arrow.png" alt="Back" class="back-icon">
    </a>
    <div class="header">BORROWED REQUEST SENT</div>

    <!-- Item List Header -->
    <div class="section-header">
        <h2>ITEM LIST</h2>
    </div>
    <div class="item-list">
        <div class="item-details">
            <%-- Retrieve selected items from session --%>
            <%
                List<TransactionModel> selectedItems = (List<TransactionModel>) session.getAttribute("selectedItems");
                if (selectedItems != null && !selectedItems.isEmpty()) {
                    ItemDAO itemDAO = new ItemDAO();  // Assuming you have this class to get items
                    for (TransactionModel transaction : selectedItems) {
                        String serialNumber = transaction.getSerialNumber();
                        String itemName = itemDAO.getItemBySerialNumber(serialNumber).getItemName(); 
                        int quantity = transaction.getQuantity();
            %>
            <div class="item">
                <div class="item-left">
                    <!-- Changed the order and grouped quantity with item name -->
                    <span class="quantity"><%= quantity %> X</span>
                    <span class="item-name"><%= itemName %></span>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="item">
                <p>No items to display.</p>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <!-- Student Info Header -->
    <div class="section-header">
        <h2>STUDENT INFO</h2>
    </div>
    <div class="student-info">
        <%
            // Declare student info variables outside of the if block
            String studentId = "";
            String studentName = "";
            String borrowDate = "";
            String dueDate = "";
            StringBuilder itemDetails = new StringBuilder();
            
            // Retrieve student info from the transaction model
            TransactionModel firstTransaction = selectedItems != null && !selectedItems.isEmpty() ? selectedItems.get(0) : null;
            if (firstTransaction != null) {
                studentId = firstTransaction.getStudentId();  
                studentName = firstTransaction.getStudentName();  

                // Format the borrowDate and dueDate using SimpleDateFormat
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                if (firstTransaction.getBorrowDate() != null) {
                    borrowDate = sdf.format(firstTransaction.getBorrowDate());
                }

                if (firstTransaction.getDueDate() != null) {
                    dueDate = sdf.format(firstTransaction.getDueDate());
                }

                // Build item details string for email
                ItemDAO itemDAO = new ItemDAO();
                for (TransactionModel transaction : selectedItems) {
                    String serialNumber = transaction.getSerialNumber();
                    String itemName = itemDAO.getItemBySerialNumber(serialNumber).getItemName();
                    int quantity = transaction.getQuantity();
                    itemDetails.append(quantity).append(" x ").append(itemName).append("<br>");
                }

                // Send confirmation email
                try {
                    SendMail.sendBorrowConfirmation(
                        studentId,
                        studentName,
                        itemDetails.toString(),
                        borrowDate,
                        dueDate
                    );
                } catch (RuntimeException e) {
                    // The error is already logged in SendMail.java
                    %>
                    <script>
                        alert("Failed to send confirmation email. Please contact support if needed.");
                    </script>
                    <%
                }
            }
        %>
        <p>STUDENT ID: <span><%= studentId %></span></p>
        <p>STUDENT NAME: <span><%= studentName %></span></p>
        <p>BORROW DATE: <span><%= borrowDate %></span></p>
        <p>DUE DATE: <span><%= dueDate %></span></p>
    </div>

    <div class="terms">
        <p>The Borrowing terms and conditions have been sent to your email.<br>
           Please note that returning items late will cause a penalty.</p>
    </div>

    <div class="auto-return">
        AUTO RETURN IN <span id="countdown">5</span>
    </div>

    <a href="../../../pages/others/borrow.jsp" class="main-menu-button">BACK TO MAIN MENU</a>  <!--change to inventory page dee mai?-->
</body>
</html>