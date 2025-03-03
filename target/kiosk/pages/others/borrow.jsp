<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ItemDAO"%>
<%@ page import="model.ItemModel"%>
<%@ page import="model.TransactionModel"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Borrow Items</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .header {
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .back-button {
            text-decoration: none;
            color: black;
            font-size: 24px;
        }

        .back-icon, .basket-icon {
            width: 32px;
            height: 32px;
        }

        .title {
            font-size: 24px;
            font-weight: bold;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        .search-container {
            padding: 10px 20px;
        }

        .search-input {
            width: 100%;
            padding: 12px 20px;
            border: none;
            border-radius: 25px;
            background-color: #f5f5f5;
        }

        .categories {
            display: flex;
            justify-content: center;
            gap: 10px;
            padding: 10px 20px;
            overflow-x: auto;
        }

        .category {
            padding: 8px 20px;
            background-color: #f5f5f5;
            border-radius: 20px;
            white-space: nowrap;
            cursor: pointer;
        }

        .category.active {
            background-color: #9d9898;
            color: white;
        }

        .items-container {
            position: relative;
            flex-grow: 1;
            overflow: hidden;
        }

        .items-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 60px 20px;
            padding: 20px;
            position: absolute;
            width: 100%;
            height: 100%;
            overflow-y: auto;
            transition: transform 0.3s ease;
        }

        .item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            padding: 10px;
            position: relative;
        }

        .item-details {
            text-align: center;
            width: 100%;
        }

        .item-name {
            font-weight: bold;
        }

        .item-category {
            font-size: 0.8em;
            color: #666;
            margin-top: 5px;
        }

        .item-image {
            width: 60%;
            aspect-ratio: 1;
            object-fit: contain;
        }

        .status {
            font-weight: bold;
        }

        .available {
            color: #4CAF50;
        }

        .unavailable {
            color: #f44336;
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="../inventory.jsp">
            <img src="../../images/back_arrow.png" alt="back-button" class="back-icon">
        </a>
        <div class="title">Borrow</div>
        <a href="#" class="basket-link" onclick="goToOrderDetails()"> 
            <img src="../../images/basket.jpg" alt="Basket" class="basket-icon">
            <% if (request.getSession().getAttribute("selectedItems") != null) {
                List<TransactionModel> selectedItems = (List<TransactionModel>) request.getSession().getAttribute("selectedItems");
                if (!selectedItems.isEmpty()) { %>
                    <span class="basket-count"><%= selectedItems.size() %></span>
                <% }
            } %>
        </a>
    </div>

    <div class="search-container">
        <input type="text" class="search-input" placeholder="Search items" onkeyup="searchItems()">
    </div>

    <div class="categories">
        <div class="category" data-category="01" onclick="filterByCategory('01')">Electricals & Electronics</div>
        <div class="category" data-category="02" onclick="filterByCategory('02')">Robotics</div>
        <div class="category" data-category="03" onclick="filterByCategory('03')">Tools</div>
        <div class="category" data-category="04" onclick="filterByCategory('04')">Computers</div>
        <div class="category" data-category="05" onclick="filterByCategory('05')">Spatial Technologies</div>
        <div class="category" data-category="06" onclick="filterByCategory('06')">Miscellaneous</div>
    </div>

    <div class="items-container">
        <div class="items-grid">
            <%
                ItemDAO itemDAO = new ItemDAO();
                List<ItemModel> items = itemDAO.getAllItems();
                for(ItemModel item : items) {
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

                    boolean isAvailable = true;
                    try {
                        int quantityAvailable = Integer.parseInt(item.getQuantityAvailable());
                        isAvailable = quantityAvailable > 0;
                    } catch (NumberFormatException e) {
                        isAvailable = true; // For non-numeric quantity_available
                    }
            %>
                <div class="item" data-category="<%= item.getField5() %>" onclick="viewItemDetails('<%= item.getSerialNumber() %>')">
                    <div class="item-details">
                        <div class="item-name"><%= item.getItemName() %></div>
                        <div class="item-category"><%= category %></div>
                    </div>
                    <img src="../../images/inventory_items/<%= item.getSerialNumber() %>.png" 
                         onerror="this.onerror=null; this.src='../../images/inventory_items/image_icon.png'" 
                         class="item-image" alt="<%= item.getItemName() %>">
                    <div class="status <%= isAvailable ? "available" : "unavailable" %>">
                        <%= isAvailable ? "AVAILABLE" : "UNAVAILABLE" %>
                    </div>
                </div>
            <%
                }
            %>
        </div>

    <script>
        function searchItems() {
            var input = document.querySelector('.search-input').value.toLowerCase();
            var items = document.getElementsByClassName('item');

            for (var i = 0; i < items.length; i++) {
                var itemName = items[i].querySelector('.item-name').textContent.toLowerCase();
                var itemCategory = items[i].querySelector('.item-category').textContent.toLowerCase();
                
                if (itemName.includes(input) || itemCategory.includes(input)) {
                    items[i].style.display = "";
                } else {
                    items[i].style.display = "none";
                }
            }
        }

        function filterByCategory(category) {
            var items = document.getElementsByClassName('item');
            var categoryButtons = document.getElementsByClassName('category');

            // Remove active class from all category buttons
            for (var j = 0; j < categoryButtons.length; j++) {
                categoryButtons[j].classList.remove('active');
            }

            // Add active class to selected category
            event.target.classList.add('active');

            for (var i = 0; i < items.length; i++) {
                if (category === 'all' || items[i].getAttribute('data-category') === category) {
                    items[i].style.display = "";
                } else {
                    items[i].style.display = "none";
                }
            }
        }

        function viewItemDetails(serialNumber) {
            // Redirect the user to the ItemView.jsp page with the serialNumber parameter
            window.location.href = 'borrow/ItemView.jsp?serialNumber=' + serialNumber;
        }

        function goToOrderDetails() {
            // Retrieve selected items from session storage
            const selectedItems = JSON.parse(sessionStorage.getItem('selectedItems')) || [];

            // Send selected items to the servlet via a form submission
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '<%= request.getContextPath() %>/AddBorrowListServlet';

            selectedItems.forEach(item => {
                const serialInput = document.createElement('input');
                serialInput.type = 'hidden';
                serialInput.name = 'serialNumbers';
                serialInput.value = item.serialNumber;
                form.appendChild(serialInput);

                const quantityInput = document.createElement('input');
                quantityInput.type = 'hidden';
                quantityInput.name = 'quantities';
                quantityInput.value = item.quantity;
                form.appendChild(quantityInput);
            });

            document.body.appendChild(form);
            form.submit();
        }

    </script>
</body>
</html>