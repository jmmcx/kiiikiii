<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="model.TransactionModel"%>
<%@ page import="model.ItemModel"%>
<%@ page import="dao.ItemDAO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/theme/orderdetail.css">
</head>
<body>
    <a href="<%= request.getContextPath() %>/pages/others/borrow.jsp" class="back-button">
        <img src="<%= request.getContextPath() %>/images/back_arrow.png" alt="Back" class="back-icon">
    </a>
    <div class="header">PLEASE CHECK YOUR ORDER</div>
    <div class="order-list">
        <%
            // Retrieve selected items from session
            List<TransactionModel> selectedItems = (List<TransactionModel>) session.getAttribute("selectedItems");
            ItemDAO itemDAO = new ItemDAO();
    
            if (selectedItems != null && !selectedItems.isEmpty()) {
                // Group items by serial number and calculate total quantity
                Map<String, Integer> itemQuantities = new HashMap<>();
                Map<String, String> itemNames = new HashMap<>();
    
                for (TransactionModel transaction : selectedItems) {
                    String serialNumber = transaction.getSerialNumber();
                    int quantity = transaction.getQuantity();
    
                    // Retrieve item name if not already retrieved
                    if (!itemNames.containsKey(serialNumber)) {
                        ItemModel item = itemDAO.getItemBySerialNumber(serialNumber);
                        String itemName = item != null ? item.getItemName() : "Unknown";
                        itemNames.put(serialNumber, itemName);
                    }
    
                    // Add to quantity for the serial number
                    itemQuantities.put(serialNumber, itemQuantities.getOrDefault(serialNumber, 0) + quantity);
                }
    
                // Display grouped items
                for (Map.Entry<String, Integer> entry : itemQuantities.entrySet()) {
                    String serialNumber = entry.getKey();
                    int totalQuantity = entry.getValue();
                    String itemName = itemNames.get(serialNumber);
        %>
        <div class="order-item">
            <span><%= totalQuantity %> X</span>
            <span><%= itemName %></span>
        </div>
        <%
                }
            } else {
        %>
        <div class="order-item">
            <p>No items selected. Please add items to your order.</p>
        </div>
        <% } %>
    </div>    
    <div class="add-more-items" onclick="window.location.href='<%= request.getContextPath() %>/pages/others/borrow.jsp';">ADD MORE ITEMS</div>
    <a href="<%= request.getContextPath() %>/pages/others/borrow/VerifyStudentCard.jsp" class="confirm-button">CONFIRM</a>
</body>
</html>