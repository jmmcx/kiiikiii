<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ItemDAO"%>
<%@ page import="model.ItemModel"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Details</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #f9f9f9;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            height: 100vh;
            overflow-y: auto;
            padding: 20px;
        }

        .back-button {
            position: absolute;
            top: 20px;
            left: 20px;
            text-decoration: none;
            display: flex;
            align-items: center;
        }

        .back-icon {
            width: 32px;
            height: 32px;
        }

        .item-details {
            width: 90%;
            max-width: 500px;
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .item-name {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 10px;
        }

        .item-category {
            font-size: 16px;
            color: #666;
            margin-bottom: 20px;
            text-align: center;
        }

        .item-image {
            width: 80%;
            max-height: 300px;
            object-fit: contain;
            margin-bottom: 20px;
        }

        .quantity-container {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .quantity-button {
            width: 40px;
            height: 40px;
            background-color: #ddd;
            border: none;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            cursor: pointer;
            color: #333;
        }

        .quantity-value {
            font-size: 18px;
            font-weight: bold;
            padding: 5px 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-align: center;
            width: 60px;
        }

        .add-to-list {
            width: 100%;
            padding: 15px;
            background-color: #e35205;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
            cursor: pointer;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <a href="../borrow.jsp" class="back-button">
        <img src="../../../images/back_arrow.png" alt="Back" class="back-icon">
    </a>
    
    <%
        String serialNumber = request.getParameter("serialNumber");
        ItemDAO itemDAO = new ItemDAO();
        ItemModel item = itemDAO.getItemBySerialNumber(serialNumber);
        
        String category = "";
        switch(item.getField5()) {
            case "01": category = "Electricals & Electronics"; break;
            case "02": category = "Robotics"; break;
            case "03": category = "Tools"; break;
            case "04": category = "Computers"; break;
            case "05": category = "Spatial Technologies"; break;
            case "06": category = "Miscellaneous"; break;
            default: category = "Unknown";
        }
    %>
    
    <div class="item-details">
        <div class="item-name"><%= item.getItemName() %></div>
        <div class="item-category"><%= category %></div>
        <img src="../../../images/inventory_items/<%= item.getSerialNumber() %>.png" 
             onerror="this.onerror=null; this.src='../../../images/inventory_items/image_icon.png'" 
             class="item-image" alt="<%= item.getItemName() %>">
        
        <div class="quantity-container">
            <button class="quantity-button" onclick="changeQuantity(-1)">-</button>
            <input type="number" id="quantity" class="quantity-value" value="1" min="1" max="<%= item.getQuantityAvailable() %>">
            <button class="quantity-button" onclick="changeQuantity(1)">+</button>
        </div>
        
        <button class="add-to-list" onclick="addToBorrowList('<%= item.getSerialNumber() %>', document.getElementById('quantity').value)">
            Add to Borrow List
        </button>
    </div>
    
    <script>
        function changeQuantity(delta) {
            const quantityInput = document.getElementById("quantity");
            let currentValue = parseInt(quantityInput.value) || 1;
            let newValue = currentValue + delta;

            if (newValue >= parseInt(quantityInput.min) && newValue <= parseInt(quantityInput.max)) {
                quantityInput.value = newValue;
            }
        }

        function addToBorrowList(serialNumber, quantity) {
            // Retrieve the existing list of selected items from session storage
            let selectedItems = JSON.parse(sessionStorage.getItem('selectedItems')) || [];

            // Find the selected item in the list
            let selectedItem = selectedItems.find(item => item.serialNumber === serialNumber);
            if (selectedItem) {
                // Update the quantity of the existing item
                selectedItem.quantity = parseInt(quantity);
            } else {
                // Add a new item to the list
                selectedItems.push({ serialNumber, quantity: parseInt(quantity) });
            }

            // Save the updated list of selected items to session storage
            sessionStorage.setItem('selectedItems', JSON.stringify(selectedItems));

            // Redirect the user back to the borrow.jsp page
            window.location.href = '../borrow.jsp';
        }

    </script>
</body>
</html>