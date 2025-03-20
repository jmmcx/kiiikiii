package util;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;
import java.util.Properties;

public class EmailUtil {
    private static final Logger logger = LogManager.getLogger(EmailUtil.class);

    public static void sendEmail(String recipient, String subject, String body) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", ConfigUtil.getMailConfig("mail.smtp.host"));
            props.put("mail.smtp.port", ConfigUtil.getMailConfig("mail.smtp.port"));
            props.put("mail.smtp.auth", ConfigUtil.getMailConfig("mail.smtp.auth"));
            props.put("mail.smtp.socketFactory.port", ConfigUtil.getMailConfig("mail.smtp.socketFactory.port"));
            props.put("mail.smtp.socketFactory.class", ConfigUtil.getMailConfig("mail.smtp.socketFactory.class"));

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(
                            ConfigUtil.getMailConfig("mail.username"),
                            ConfigUtil.getMailConfig("mail.password")
                    );
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(ConfigUtil.getMailConfig("mail.username")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);

            // Set the content directly without attachment handling
            message.setContent(body, "text/html; charset=utf-8");
            
            Transport.send(message);
            logger.info("Email sent successfully to " + recipient);
        } catch (MessagingException e) {
            logger.error("Failed to send email: " + e.getMessage(), e);
        }
    }
    
    public static String createInformContent(String fullName, String bookingId, String location, 
                                            String date, String timeSlot, String organization,
                                            String phone, int numVisitors, List<String> visitorNames, 
                                            List<String> visitorAges) {
        StringBuilder visitorDetails = new StringBuilder();
        for (int i = 0; i < visitorNames.size() && i < visitorAges.size(); i++) {
            visitorDetails.append("<tr>")
            .append("<td style='padding: 8px; border: 1px solid #ddd;'>").append(i+1).append("</td>")
            .append("<td style='padding: 8px; border: 1px solid #ddd;'>").append(visitorNames.get(i)).append("</td>")
            .append("<td style='padding: 8px; border: 1px solid #ddd;'>").append(visitorAges.get(i)).append("</td>")
            .append("</tr>");
        }

        // Format time slots to display each on a new line if multiple slots exist
        String formattedTimeSlot = timeSlot;
            if (timeSlot != null && timeSlot.contains(",")) {
            formattedTimeSlot = timeSlot.replace(", ", "<br>");
        }

        return "<!DOCTYPE html>"
            + "<html>"
            + "<head>"
            + "<style>"
            + "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }"
            + ".container { max-width: 600px; margin: 0 auto; padding: 20px; }"
            + "h2 { color: #4285f4; }"
            + "h3 { margin-top: 30px; }" // Added more top margin to h3
            + "table { border-collapse: collapse; width: 100%; margin-top: 20px; }"
            + "th { background-color: #f2f2f2; text-align: left; padding: 8px; border: 1px solid #ddd; }"
            + ".footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; font-size: 12px; color: #777; }"
            + ".visitor-section { margin-top: 40px; }" // Added this class for visitor section
            + "</style>"
            + "</head>"
            + "<body>"
            + "<div class='container'>"
            + "<h2>Booking Request Confirmation</h2>"
            + "<p>Dear " + fullName + ",</p>"
            + "<p>Thank you for your booking request at RAI Department. We have received your request and it is currently under review. We will notify you once your booking is confirmed.</p>"
            + "<h3>Booking Details:</h3>"
            + "<table>"
            + "<tr><th style='width: 30%; padding: 8px; border: 1px solid #ddd;'>Booking ID</th><td style='padding: 8px; border: 1px solid #ddd;'>" + bookingId + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Name</th><td style='padding: 8px; border: 1px solid #ddd;'>" + fullName + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Organization</th><td style='padding: 8px; border: 1px solid #ddd;'>" + organization + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Phone</th><td style='padding: 8px; border: 1px solid #ddd;'>" + phone + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Location</th><td style='padding: 8px; border: 1px solid #ddd;'>" + location + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Date</th><td style='padding: 8px; border: 1px solid #ddd;'>" + date + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Time Slot</th><td style='padding: 8px; border: 1px solid #ddd;'>" + formattedTimeSlot + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Number of Visitors</th><td style='padding: 8px; border: 1px solid #ddd;'>" + numVisitors + "</td></tr>"
            + "</table>"

            + "<div class='visitor-section'>"
            + "<h3>Visitor Details:</h3>"
            + "<table>"
            + "<tr>"
            + "<th style='padding: 8px; border: 1px solid #ddd;'>No.</th>"
            + "<th style='padding: 8px; border: 1px solid #ddd;'>Name</th>"
            + "<th style='padding: 8px; border: 1px solid #ddd;'>Age</th>"
            + "</tr>"
            + visitorDetails.toString()
            + "</table>"
            + "</div>"

            + "<div class='footer'>"
            + "<p>If you have any questions or need to make changes to your booking, please contact us at <a href='mailto:rai@kmitl.ac.th'>rai@kmitl.ac.th</a> or call +66 2123 4567.</p>"
            + "<p>Best regards,<br>RAI Department<br>King Mongkut's Institute of Technology Ladkrabang</p>"
            + "</div>"
            + "</div>"
            + "</body>"
            + "</html>";
    }

    // Create email content for student booking confirmation
    public static String createStudentBookingEmailContent(String fullName, String bookingId, 
                                                        String location, String date, 
                                                        String timeSlot, String phone,
                                                        String seatCode) {
        // Format time slots to display each on a new line if multiple slots exist
        String formattedTimeSlot = timeSlot;
        if (timeSlot != null && timeSlot.contains(",")) {
            formattedTimeSlot = timeSlot.replace(", ", "<br>");
        }
        
        // Format seat code to make it more readable
        String formattedSeatCode = seatCode;
        if (seatCode != null && seatCode.contains("-")) {
            // Extract the room code (e.g., RB1)
            int firstDashIndex = seatCode.indexOf('-');
            if (firstDashIndex > 0) {
                String roomCode = seatCode.substring(0, firstDashIndex);
                
                // Extract seat numbers (e.g., S27)
                String[] seatCodes = seatCode.split(",");
                StringBuilder seatDisplay = new StringBuilder(roomCode + "/");
                
                for (int i = 0; i < seatCodes.length; i++) {
                    int lastDashIndex = seatCodes[i].lastIndexOf('-');
                    if (lastDashIndex > 0) {
                        seatDisplay.append(seatCodes[i].substring(lastDashIndex + 1));
                        if (i < seatCodes.length - 1) {
                            seatDisplay.append("-");
                        }
                    }
                }
                
                formattedSeatCode = seatDisplay.toString();
            }
        }

        return "<!DOCTYPE html>"
            + "<html>"
            + "<head>"
            + "<style>"
            + "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }"
            + ".container { max-width: 600px; margin: 0 auto; padding: 20px; }"
            + "h2 { color: #e35205; }" // Changed to match RAI orange color
            + "h3 { margin-top: 30px; }"
            + "table { border-collapse: collapse; width: 100%; margin-top: 20px; }"
            + "th { background-color: #f2f2f2; text-align: left; padding: 8px; border: 1px solid #ddd; }"
            + ".footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; font-size: 12px; color: #777; }"
            + "</style>"
            + "</head>"
            + "<body>"
            + "<div class='container'>"
            + "<h2>Common Area Booking Confirmation</h2>"
            + "<p>Dear " + fullName + ",</p>"
            + "<p>Thank you for your booking at RAI Department. We have received your request and it is currently under review. We will notify you once your booking is confirmed.</p>"
            + "<h3>Booking Details:</h3>"
            + "<table>"
            + "<tr><th style='width: 30%; padding: 8px; border: 1px solid #ddd;'>Booking ID</th><td style='padding: 8px; border: 1px solid #ddd;'>" + bookingId + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Name</th><td style='padding: 8px; border: 1px solid #ddd;'>" + fullName + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Phone</th><td style='padding: 8px; border: 1px solid #ddd;'>" + phone + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Location</th><td style='padding: 8px; border: 1px solid #ddd;'>" + location + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Date</th><td style='padding: 8px; border: 1px solid #ddd;'>" + date + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Time Slot</th><td style='padding: 8px; border: 1px solid #ddd;'>" + formattedTimeSlot + "</td></tr>"
            + "<tr><th style='padding: 8px; border: 1px solid #ddd;'>Seat</th><td style='padding: 8px; border: 1px solid #ddd;'>" + formattedSeatCode + "</td></tr>"
            + "</table>"

            + "<div class='footer'>"
            + "<p>After approval, QR code will be sent to your email. Please check-in within 15 minutes from the time reserved. Late check-in will cause a penalty and auto cancellation.</p>"
            + "<p>If you have any questions or need to make changes to your booking, please contact us at <a href='mailto:rai@kmitl.ac.th'>rai@kmitl.ac.th</a>.</p>"
            + "<p>Best regards,<br>RAI Department<br>King Mongkut's Institute of Technology Ladkrabang</p>"
            + "</div>"
            + "</div>"
            + "</body>"
            + "</html>";
    }

}