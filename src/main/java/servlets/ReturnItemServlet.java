package servlets;

import model.TransactionModel;
import dao.TransactionDAO;
import dao.ItemDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.sql.Timestamp;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@WebServlet("/ReturnItemServlet")
public class ReturnItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LogManager.getLogger(ReturnItemServlet.class);

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        ObjectMapper objectMapper = new ObjectMapper();
        
        try {
            // Retrieve JSON string from request
            String selectedItemsJson = request.getParameter("selectedItems");
            
            if (selectedItemsJson == null || selectedItemsJson.isEmpty()) {
                logger.debug("No items selected");
                out.print("{\"status\":\"error\", \"message\":\"No items selected\"}");
                return;
            }
            
            // Convert JSON to Java objects
            TransactionModel[] selectedItems = objectMapper.readValue(selectedItemsJson, TransactionModel[].class);
            List<TransactionModel> transactionList = new ArrayList<>();
            Map<String, Integer> itemReturnCounts = new HashMap<>(); // Store counts per item name
            
            // Set return timestamp
            Timestamp returnTime = new Timestamp(System.currentTimeMillis());
            
            for (TransactionModel item : selectedItems) {
                if (item.getSerialNumber() == null || item.getSerialNumber().isEmpty()) {
                    logger.error("Missing serial number for item: " + item.getItemName());
                    out.print("{\"status\":\"error\", \"message\":\"Serial number missing for some items\"}");
                    return;
                }
                
                item.setReturnDate(returnTime); // Set return date
                item.setTransactionType("returned"); // Update status
                transactionList.add(item);
                
                // Count returned items by item name
                itemReturnCounts.put(item.getItemName(), itemReturnCounts.getOrDefault(item.getItemName(), 0) + 1);
            }

            // Call DAO to update return status
            TransactionDAO transactionDAO = new TransactionDAO();
            boolean isUpdated = transactionDAO.updateReturnStatus(transactionList);

            if (isUpdated) {
                // Update available quantity in inventory
                ItemDAO itemDAO = new ItemDAO();
                for (Map.Entry<String, Integer> entry : itemReturnCounts.entrySet()) {
                    itemDAO.restoreItemAvailableQuantity(entry.getKey(), entry.getValue());
                }

                logger.info("Updated return status and inventory successfully");
                out.print("{\"status\":\"success\", \"message\":\"Items returned successfully\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"Failed to update items\"}");
                logger.error("Failed to update returned items in database");
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("Failed to update returned items in database: " + e.getMessage());
            out.print("{\"status\":\"error\", \"message\":\"An error occurred\"}");
        }
    }
}