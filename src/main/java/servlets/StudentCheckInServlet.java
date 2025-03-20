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

import dao.StudentBookingDAO;
import model.StudentBookingModel;  // Assuming you have this model

@WebServlet("/StudentCheckInServlet")
public class StudentCheckInServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LogManager.getLogger(StudentBookingDAO.class);
    
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
            StudentBookingDAO studentBookingDAO = new StudentBookingDAO();
            StudentBookingModel studentBooking = studentBookingDAO.getStudentBookingByBookingID(qrValue);
            
            if (studentBooking != null) {
                // Update booking status to "check-in" if status is "confirmed"
                boolean updateSuccess = studentBookingDAO.updateBookingStatus(qrValue, "check-in");
                
                if (updateSuccess) {
                    // Store booking info in session for use on success page
                    HttpSession session = request.getSession();
                    session.setAttribute("studentBooking", studentBooking);
                    
                    // Redirect to check-in success page for students
                    response.sendRedirect(request.getContextPath() + "/pages/visitor_booking/checkin_success.jsp");
                } else {
                    // Handle status update failure
                    sendErrorResponse(response, "Failed to update booking status");
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
