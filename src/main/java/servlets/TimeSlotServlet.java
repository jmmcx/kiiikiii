package servlets;

import dao.ReservationDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
            this.dao = new ReservationDAO();  // Initialize safely inside try-catch
        } catch (Exception e) {
            e.printStackTrace(); // Log the error for debugging
            throw new RuntimeException("Failed to initialize GoogleSheetsDAO", e);
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

        try {
            availableSlots = dao.getAvailableTimeSlots(selectedDate, selectedLocation);
            isFullyBooked = dao.isDateFullyBooked(selectedDate, selectedLocation);
        } catch (Exception e) {
            e.printStackTrace();
            availableSlots = List.of(); // Return an empty list in case of error
            isFullyBooked = false;
        }

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("availableSlots", availableSlots);
        jsonResponse.put("isFullyBooked", isFullyBooked);

        String json = new Gson().toJson(jsonResponse);
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();

        logger.info("Returning JSON: {}", new Gson().toJson(jsonResponse));

    }
}