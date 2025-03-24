package servlets;

import dao.ReservationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@WebServlet("/TimeSlotServlet")
public class TimeSlotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LogManager.getLogger(TimeSlotServlet.class);
    private ReservationDAO dao;

    public TimeSlotServlet() {
        try {
            this.dao = new ReservationDAO();
        } catch (Exception e) {
            logger.error("Failed to initialize ReservationDAO", e);
            throw new RuntimeException("Failed to initialize ReservationDAO", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String selectedDate = request.getParameter("date");
        String selectedLocation = request.getParameter("location");
        List<String> availableSlots;
        boolean isFullyBooked;
        boolean isDateLocked = false;
        List<String> lockedTimeSlots = new ArrayList<>();

        try {
            // Check if date is before today
            LocalDate date = LocalDate.parse(selectedDate);
            LocalDate today = LocalDate.now();
            
            if (date.isBefore(today)) {
                // Past date, no slots available
                availableSlots = List.of();
                isFullyBooked = true;
            } else {
                // Check if date is locked
                isDateLocked = dao.isDateLocked(selectedDate);
                
                if (isDateLocked) {
                    // Date is fully locked
                    availableSlots = List.of();
                    isFullyBooked = true;
                } else {
                    // Get time-specific locks
                    lockedTimeSlots = dao.getLockedTimeSlots(selectedDate, selectedLocation);
                    
                    // Get available slots (includes time lock and current time checking)
                    availableSlots = dao.getAvailableTimeSlots(selectedDate, selectedLocation);
                    isFullyBooked = dao.isDateFullyBooked(selectedDate, selectedLocation);
                }
            }
        } catch (Exception e) {
            logger.error("Error fetching time slots", e);
            availableSlots = List.of();
            isFullyBooked = false;
        }

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("availableSlots", availableSlots);
        jsonResponse.put("isFullyBooked", isFullyBooked);
        jsonResponse.put("isDateLocked", isDateLocked);
        jsonResponse.put("lockedTimeSlots", lockedTimeSlots);

        String json = new Gson().toJson(jsonResponse);
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();

        logger.info("Returning JSON: {}", json);
    }
}
