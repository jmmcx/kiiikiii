package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ReservationDAO;

@WebServlet("/CheckLockDateServlet")
public class CheckLockDateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String dateStr = request.getParameter("date");
        String location = request.getParameter("location");
        
        // Default to empty response
        boolean isFullyLocked = false;
        List<String> lockedTimeSlots = new ArrayList<>();
        
        if (dateStr != null && !dateStr.isEmpty()) {
            ReservationDAO dao = new ReservationDAO();
            
            // Check if date is fully locked for this location
            isFullyLocked = dao.isDateLocked(dateStr, location);
            
            // If not fully locked and location is provided, get locked time slots
            if (!isFullyLocked && location != null && !location.isEmpty()) {
                lockedTimeSlots = dao.getLockedTimeSlots(dateStr, location);
            }
        }
        
        // Build JSON response
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{\"fullyLocked\":");
        jsonBuilder.append(isFullyLocked);
        jsonBuilder.append(",\"lockedTimeSlots\":[");
        
        for (int i = 0; i < lockedTimeSlots.size(); i++) {
            if (i > 0) jsonBuilder.append(",");
            jsonBuilder.append("\"").append(lockedTimeSlots.get(i)).append("\"");
        }
        
        jsonBuilder.append("]}");
        
        out.print(jsonBuilder.toString());
        out.flush();
    }
}
