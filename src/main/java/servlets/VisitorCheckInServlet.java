package servlets;

import java.io.BufferedReader;
import java.io.IOException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.ReservationDAO;
import model.ReservationModel;

@WebServlet("/VisitorCheckInServlet")
public class VisitorCheckInServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LogManager.getLogger(ReservationDAO.class);
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Parse the incoming JSON
            StringBuilder buffer = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                buffer.append(line);
            }
            
            // Use Gson to parse the request
            Gson gson = new Gson();
            JsonObject jsonRequest = gson.fromJson(buffer.toString(), JsonObject.class);
            
            String qrValue = jsonRequest.get("qrValue").getAsString();
            
            // Process the QR code (assuming QR contains booking ID)
            ReservationDAO reservationDAO = new ReservationDAO();
            ReservationModel reservation = reservationDAO.getReservationByBookingID(qrValue);
            
            if (reservation != null) {
                // Update reservation status to "check-in"
                boolean updateSuccess = reservationDAO.updateReservationStatus(qrValue, "check-in");
                
                if (updateSuccess) {
                    // Store reservation info in session for use on success page
                    HttpSession session = request.getSession();
                    session.setAttribute("reservation", reservation);
                    
                    // Redirect to check-in success page
                    response.sendRedirect(request.getContextPath() + "/pages/room_booking/checkin_success.jsp");
                } else {
                    // Handle status update failure
                    sendErrorResponse(response, "Failed to update reservation status");
                }
            } else {
                // Handle invalid QR code
                sendErrorResponse(response, "Invalid booking ID");
            }
            
        } catch (Exception e) {
            logger.error("Error processing QR code", e);
            sendErrorResponse(response, e.getMessage());
        }
    }
    
    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("success", false);
        errorResponse.addProperty("error", errorMessage);
        
        response.getWriter().write(new Gson().toJson(errorResponse));
    }
}