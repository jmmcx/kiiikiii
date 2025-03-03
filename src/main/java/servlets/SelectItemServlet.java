package servlets;

import dao.TransactionDAO;
import model.TransactionModel;
import model.SelectedItemsModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/SelectItemServlet")
public class SelectItemServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Clear previous selections
        SelectedItemsModel.clearItems();
        
        // Get selected serial numbers
        String[] selectedSerialNumbers = request.getParameterValues("selectedItems");
        
        if (selectedSerialNumbers != null) {
            TransactionDAO dao = new TransactionDAO();
            for (String serialNumber : selectedSerialNumbers) {
                TransactionModel item = dao.getTransactionBySerialNumber(serialNumber);
                if (item != null) {
                    SelectedItemsModel.addItem(item);
                }
            }
        }
        
        // Redirect to confirm page
        response.sendRedirect(request.getContextPath() + "/pages/others/return/ConfirmReturnItem.jsp");
    }
}