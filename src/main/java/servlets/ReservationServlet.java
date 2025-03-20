package servlets;

import model.ReservationModel;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import dao.*;
import util.EmailUtil;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LogManager.getLogger(ReservationServlet.class);
    private ReservationDAO dao;

    public ReservationServlet() {
        try {
            this.dao = new ReservationDAO();  // Initialize DAO
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String organization = request.getParameter("organization");
            String city = request.getParameter("city");
            String country = request.getParameter("country");
            String location = request.getParameter("location");
            String bookingDate = request.getParameter("date");
            
            // Get time slot values
            String[] timeSlotArray = request.getParameterValues("timeSlots");
            String timeSlot = timeSlotArray != null ? String.join(",", timeSlotArray) : "";
        
            // Get number of visitors, visitor names, and ages
            int numVisitors = Integer.parseInt(request.getParameter("numVisitors"));
            String[] visitorNamesArray = request.getParameterValues("visitorNames");
            String[] visitorAgesArray = request.getParameterValues("visitorAges");
        
            List<String> visitorNames = visitorNamesArray != null ? Arrays.asList(visitorNamesArray) : new ArrayList<>();
            List<String> visitorAges = visitorAgesArray != null ? Arrays.asList(visitorAgesArray) : new ArrayList<>();
        
            String bookingId = generateBookingId(location, bookingDate);
            ReservationModel reservation = new ReservationModel(
                bookingId, 
                fullName, 
                email, 
                phone, 
                organization,
                city,
                country,
                numVisitors, 
                visitorNames, 
                visitorAges,
                location, 
                bookingDate, 
                timeSlot, 
                "", // Keeping mergedTimeSlots empty since you handle merging elsewhere
                "pending",
                LocalDateTime.now().toString(),
                LocalDateTime.now().toString()
            );
            reservation.setTimeSlot(timeSlot);
            dao.saveReservation(reservation);
            String emailBody = EmailUtil.createInformContent(
                fullName, bookingId, location, bookingDate, reservation.getMergedTimeSlot(), 
                organization, phone, numVisitors, visitorNames, visitorAges
            );
            EmailUtil.sendEmail(email, "RAI Department: Booking Request Received", emailBody);
            request.setAttribute("reservation", reservation);
            request.getRequestDispatcher("/pages/visitor_booking/reservation_confirm.jsp").forward(request, response);
            logger.info("Successfully saved reservation in Database");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your reservation.");
            request.getRequestDispatcher("/pages/visitor_booking/register.jsp").forward(request, response);
            logger.error("An error occurred while process saving reservation");
        }
}

    private String generateBookingId(String location, String bookingDate) {
        // Format: RAI-LOCATION-YYYYMMDD-HHMMSS
        String formattedDate = bookingDate.replace("-", "");  // Convert date to YYYYMMDD format
        String timeStamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("HHmmss"));  // Get current time in HHMMSS format
        
        // Map full location names to short codes
        String locationCode;
        switch (location) {
            case "HM Building, Robotics Lab":
                locationCode = "HMRBL";  // HM Building, Robotics Lab
                break;
            case "E-12 Building, Future Lab":
                locationCode = "E12FLB"; // E-12 Building, Future Lab
                break;
            case "E-12 Building, 12th Floor":
                locationCode = "E12FLR"; // E-12 Building, 12th Floor
            default:
                locationCode = "UNK";  // Fallback for unknown locations
                break;
        }

        return "RAI-" + locationCode + "-" + formattedDate + "-" + timeStamp;
    }

}
