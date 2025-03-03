<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.SelectedItemsModel" %>
<%@ page import="model.TransactionModel" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Return</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/theme/ConfirmReturnItem.css">
</head>
<body>
    <img src="<%=request.getContextPath()%>/images/back_arrow.png" class="back-button" onclick="window.history.back()">
    <div class="header">Confirm Return</div>
    <div class="instruction">Please confirm the items you want to return</div>

    <form action="<%=request.getContextPath()%>/ReturnServlet" method="POST">
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Date Borrowed</th>
                        <th>Due Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<TransactionModel> selectedItems = SelectedItemsModel.getSelectedItems();
                        if (selectedItems.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="4" style="text-align: center; color: red;">No items selected for return.</td>
                        </tr>
                    <%
                        } else {
                            for (TransactionModel item : selectedItems) {
                    %>
                        <tr>
                            <td><%= item.getItemName() %></td>
                            <td><%= item.getBorrowDate() %></td>
                            <td><%= item.getDueDate() %></td>
                            <td><%= item.getTransactionType() %></td>
                            <input type="hidden" name="returnItems" value="<%= item.getSerialNumber() %>">
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

        <button type="submit" class="confirm-button" <%= selectedItems.isEmpty() ? "disabled" : "" %>>
            CONFIRM RETURN
        </button>
    </form>
</body>
</html>