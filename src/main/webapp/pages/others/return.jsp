<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.TransactionDAO" %>
<%@ page import="model.TransactionModel" %>
<%@ page import="model.SelectedItemsModel" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Item</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/theme/return.css">
</head>
<body>
    <form action="<%=request.getContextPath()%>/SelectItemServlet" method="POST" id="returnForm">
        <img src="<%=request.getContextPath()%>/images/back_arrow.png" class="back-button" onclick="window.history.back()">
        <div class="header">Return</div>
        
        <div class="search-container">
            <input type="text" class="search-box" placeholder="Items" oninput="filterItems(this.value)">
        </div>

        <div class="instruction">PLEASE SELECT ITEM YOU WOULD LIKE TO RETURN</div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ITEM ID</th>
                        <th>ITEM NAME</th>
                        <th>DATE BORROWED</th>
                        <th>STATUS</th>
                    </tr>
                </thead>
                <tbody id="itemTableBody">
                    <%
                        TransactionDAO dao = new TransactionDAO();
                        List<TransactionModel> transactions = dao.getBorrowedItemsByStudentId("64011527");
                        if (transactions == null || transactions.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="4" style="text-align: center; color: red;">No borrowed items found.</td>
                        </tr>
                    <%
                        } else {
                            for (TransactionModel t : transactions) {
                                boolean isSelected = SelectedItemsModel.getSelectedItems().stream()
                                    .anyMatch(item -> item.getSerialNumber().equals(t.getSerialNumber()));
                    %>
                        <tr class="selectable <%= isSelected ? "selected" : "" %>" 
                            data-id="<%= t.getSerialNumber() %>"
                            onclick="toggleSelection(this)">
                            <td><%= t.getSerialNumber() %></td>
                            <td><%= t.getItemName() %></td>
                            <td><%= t.getBorrowDate() %></td>
                            <td><%= t.getTransactionType() %></td>
                            <input type="hidden" name="selectedItems" value="<%= t.getSerialNumber() %>" disabled>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

        <button type="submit" class="confirm-button" id="confirm-button" disabled>CONFIRM</button>
    </form>

    <script>
        function toggleSelection(row) {
            row.classList.toggle('selected');
            const input = row.querySelector('input[name="selectedItems"]');
            input.disabled = !row.classList.contains('selected');
            updateButtonState();
        }

        function updateButtonState() {
            const selectedRows = document.querySelectorAll('tr.selected').length;
            const confirmButton = document.getElementById('confirm-button');
            confirmButton.disabled = selectedRows === 0;
            confirmButton.classList.toggle('active', selectedRows > 0);
        }

        function filterItems(searchText) {
            const rows = document.querySelectorAll('#itemTableBody tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchText.toLowerCase()) ? '' : 'none';
            });
        }
    </script>
</body>
</html>