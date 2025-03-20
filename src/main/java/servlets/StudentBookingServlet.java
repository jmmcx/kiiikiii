package servlets;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
// import java.text.ParseException;
// import java.text.SimpleDateFormat;
// import java.util.Date;
// import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import dao.StudentBookingDAO;
import model.StudentBookingModel;
import util.EmailUtil;

@WebServlet("/StudentBookingServlet")
public class StudentBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LogManager.getLogger(StudentBookingServlet.class);
    
    private StudentBookingDAO bookingDAO;
    
    public void init() {
        bookingDAO = new StudentBookingDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        StudentBookingModel booking = (StudentBookingModel) session.getAttribute("studentBooking");
        
        if (booking != null) {
            try {
                // Generate a unique student booking ID
                String bookingID = generateStudentBookingId(booking.getLocation(), booking.getBookingDate());
                booking.setBookingID(bookingID);
                
                // Create timestamp for booking creation
                Timestamp currentTime = new Timestamp(System.currentTimeMillis());
                booking.setCreatedAt(currentTime);
                
                // Set pending status
                booking.setStatus("pending");
                
                // Get booking date from session storage
                String selectedDate = request.getParameter("selected_date");
                if (selectedDate == null) {
                    // Try to get from session storage via JavaScript
                    selectedDate = (String) session.getAttribute("selected_date");
                }
                /*// for date format -- might not necessary if date format is correct from the begining
                if (selectedDate != null && !selectedDate.isEmpty()) {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    try {
                        Date bookingDate = dateFormat.parse(selectedDate);
                        booking.setBookingDate(bookingDate);
                    } catch (ParseException e) {
                        e.printStackTrace();
                    }
                } */
                /* // already set to model from confirm_booking jsp page
                // Get time slots from session
                String selectedTimeSlots = request.getParameter("selected_time_slots");
                if (selectedTimeSlots == null) {
                    selectedTimeSlots = (String) session.getAttribute("selected_time_slots");
                }
                booking.setTimeSlot(selectedTimeSlots);
                
                // Get merged time slot if available
                String mergedTimeSlot = request.getParameter("formatted_time_slot");
                if (mergedTimeSlot == null) {
                    mergedTimeSlot = (String) session.getAttribute("formatted_time_slot");
                }
                booking.setMergedTimeSlot(mergedTimeSlot);
                
                // Get selected seats
                String selectedSeats = request.getParameter("selected_seats");
                if (selectedSeats == null) {
                    selectedSeats = (String) session.getAttribute("selected_seats");
                }
                booking.setSeatCode(selectedSeats);
                */
                
                // Save booking to database
                boolean success = bookingDAO.createBooking(booking);
                
                if (success) {
                    // create inform email content
                    String emailBody = EmailUtil.createStudentBookingEmailContent(booking.getName(), booking.getBookingID(), booking.getLocation(), booking.getBookingDate(),
                                                                booking.getMergedTimeSlot(), booking.getPhone(), booking.getSeatCode());
                    // Send confirmation email
                    EmailUtil.sendEmail(booking.getEmail(), "RAI Department: Booking Common Area Request Received", emailBody);
                    
                    // Clear session attributes after successful booking
                    session.removeAttribute("studentBooking");
                    session.removeAttribute("selected_date");
                    session.removeAttribute("selected_time_slots");
                    session.removeAttribute("formatted_time_slot");
                    session.removeAttribute("selected_seats");

                    session.invalidate();

                    logger.info("Successfully create student booking in Database: " + bookingID);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String generateStudentBookingId(String location, String bookingDate) {
        // Format: RAI-STU-LOCATION-YYYYMMDD-HHMMSS
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
                locationCode = "E12TWF"; // E-12 Building, 12th Floor
            default:
                locationCode = "UNK";  // Fallback for unknown locations
                break;
        }

        return "RAI-" + "STU-" + locationCode + "-" + formattedDate + "-" + timeStamp;
    }
}