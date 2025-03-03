package servlets;

import dao.ItemDAO;
import dao.TransactionDAO;
import model.TransactionModel;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@WebServlet("/AddBorrowListServlet")
public class AddBorrowListServlet extends HttpServlet {
    private static final Logger logger = LogManager.getLogger(AddBorrowListServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Reuse the logic from doPost if want the same behavior for GET requests
        doPost(request, response);  
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Retrieve selected items from the form
        String[] serialNumbers = request.getParameterValues("serialNumbers");
        String[] quantities = request.getParameterValues("quantities");

        // Initialize the list to hold selected transaction items
        List<TransactionModel> selectedItems = new ArrayList<>();

        try {
            if (serialNumbers != null && quantities != null) {
                for (int i = 0; i < serialNumbers.length; i++) {
                    String serialNumber = serialNumbers[i];
                    int quantity = Integer.parseInt(quantities[i]);

                    // Get the available field numbers for the current item
                    List<String> fieldNumbers = getAvailableFieldNumbers(serialNumber, quantity);

                    // Create a separate transaction for each field number
                    for (String fieldNumber : fieldNumbers) {
                        TransactionModel transaction = new TransactionModel();
                        transaction.setSerialNumber(serialNumber);
                        transaction.setQuantity(1); // Each transaction is for 1 unit
                        transaction.setFieldNumber(fieldNumber);
                        transaction.setTransactionType("requested"); 

                        // Add the transaction to the list
                        selectedItems.add(transaction);
                    }
                }
            }

            // Store the selected items in the session
            request.getSession().setAttribute("selectedItems", selectedItems);

            // Forward the request to the OrderDetail.jsp page
            request.setAttribute("selectedItems", selectedItems);
            request.getRequestDispatcher("/pages/others/borrow/OrderDetail.jsp").forward(request, response);
        } catch (RuntimeException e) {
            // Handle errors related to field number allocation
            request.setAttribute("error", "An error occurred while processing your request: " + e.getMessage());
            request.getRequestDispatcher("/pages/others/borrow/borrow.jsp").forward(request, response);
            logger.error("An error occurred while processing your request: " + e.getMessage());
        }
    }


    private List<String> getAvailableFieldNumbers(String serialNumber, int quantity) {
        ItemDAO item = new ItemDAO();
        TransactionDAO transaction = new TransactionDAO();
    
        // Retrieve the total quantity of the item from the inventory table
        String quantityItem = item.getItemQuantity(serialNumber);
    
        // If the item is 'bulk', return "001" as the default field number
        if (quantityItem.equalsIgnoreCase("bulk")) {
            return Collections.singletonList("001");
        }
    
        // Parse the quantity as an integer
        int totalQuantity = Integer.parseInt(quantityItem);
    
        // Retrieve existing field numbers from the transaction table
        Set<String> existingFieldNumbers = transaction.getExistingFieldNumbers(serialNumber);
    
        // Generate all possible field numbers based on the total quantity
        List<String> availableFieldNumbers = new ArrayList<>();
        for (int i = 1; i <= totalQuantity; i++) {
            String fieldNumber = String.format("%03d", i); // Format as 3 digits
            if (!existingFieldNumbers.contains(fieldNumber)) {
                availableFieldNumbers.add(fieldNumber); // Add only unused numbers
            }
        }
    
        // Check if there are enough available field numbers for the requested quantity
        if (availableFieldNumbers.size() < quantity) {
            throw new RuntimeException("Not enough available field numbers for the requested quantity.");
        }
    
        // Randomly select the required quantity of field numbers
        Collections.shuffle(availableFieldNumbers);
        return availableFieldNumbers.subList(0, quantity);
    }
    

}
