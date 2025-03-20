package servlets;

import java.io.IOException;
import java.io.OutputStream;
import java.awt.image.BufferedImage;
import java.awt.Graphics2D;
import java.awt.Color;
import java.io.File;
import java.util.Date;
import java.util.List;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.fazecast.jSerialComm.SerialPort;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import util.QRCodeUtil;
import model.ReservationModel;
import model.StudentBookingModel; // Add this import

@SuppressWarnings("unused")
@WebServlet("/CheckinPrintServlet")
public class CheckinPrintServlet extends HttpServlet {
    
    // ESC/POS command constants
    private static final byte[] ESC_INIT = {0x1B, 0x40};  // Initialize printer
    private static final byte[] ESC_ALIGN_CENTER = {0x1B, 0x61, 0x01};  // Center alignment
    private static final byte[] ESC_ALIGN_LEFT = {0x1B, 0x61, 0x00};  // Left alignment
    private static final byte[] ESC_FONT_LARGE = {0x1B, 0x21, 0x30};  // Large font
    private static final byte[] ESC_FONT_EXTRA_LARGE = {0x1B, 0x21, 0x38}; // Extra large font
    private static final byte[] ESC_FONT_MEDIUM = {0x1B, 0x21, 0x08};  // Medium font
    private static final byte[] ESC_FONT_NORMAL = {0x1B, 0x21, 0x00};  // Normal font
    private static final byte[] ESC_FONT_BOLD = {0x1B, 0x45, 0x01};  // Bold font on
    private static final byte[] ESC_FONT_BOLD_OFF = {0x1B, 0x45, 0x00};  // Bold font off
    private static final byte[] ESC_CUT_PAPER = {0x1D, 0x56, 0x41, 0x10};  // Cut paper
    private static final byte[] ESC_LINE_SPACING_SMALL = {0x1B, 0x33, 0x10};  // Small line spacing
    private static final byte[] ESC_LINE_SPACING_DEFAULT = {0x1B, 0x32};  // Default line spacing
    private static final byte[] ESC_LINE_SPACING_LARGE = {0x1B, 0x33, 0x30};  // Large line spacing
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        ReservationModel reservation = (ReservationModel) session.getAttribute("reservation");

        // comment if no print student slip
        StudentBookingModel studentBooking = (StudentBookingModel) session.getAttribute("studentBooking");
        
        if (reservation == null && studentBooking == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No reservation or student booking found");
            return;
        }
        // till this one

        // uncomment for visitor slip only
/* 
        if (reservation == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No reservation found");
            return;
        } */
        
        try {
            SerialPort comPort = SerialPort.getCommPort("COM4");
            comPort.setBaudRate(115200);
            comPort.setNumDataBits(8);
            comPort.setParity(SerialPort.NO_PARITY);
            comPort.setNumStopBits(1);
            
            if (!comPort.openPort()) {
                throw new IOException("Failed to open COM port");
            }
            
            OutputStream outputStream = comPort.getOutputStream();
            
            if (reservation != null) {
                // Handle visitor reservation printing
                String location = null;
                String location_model = reservation.getLocation();
                if (location_model.equals("HM Building, Robotics Lab")) {
                    location = "HM BUILDING, RBLAB";
                } else if (location_model.equals("E-12 Building, Future Lab")) {
                    location = "E-12 BUILDING, FTLAB";
                } else {
                    location = location_model.toUpperCase();
                }
                String bookingDate = reservation.getBookingDate();
                String timeSlot = reservation.getMergedTimeSlots();
                String organization = reservation.getOrganization().toUpperCase();
                List<String> visitorNames = reservation.getVisitorNames();
                int visitorNumber = reservation.getNumVisitors();
                
                // Ensure we have the right number of visitors
                for (int i = 0; i < visitorNumber; i++) {
                    // Initialize printer
                    outputStream.write(ESC_INIT);
                    
                    // Use smaller line spacing for compact design
                    outputStream.write(ESC_LINE_SPACING_SMALL);
                    
                    // Print logo centered
                    outputStream.write(ESC_ALIGN_CENTER);
                    String logoPath = getServletContext().getRealPath("/images/rai_logoBW.png");
                    printBitmapImage(outputStream, logoPath, 240, 80); 
                    
                    // Increased space between booking details
                    outputStream.write("\n\n".getBytes());  // Extra line for more space
                    
                    // Location and date details
                    outputStream.write(ESC_FONT_BOLD);
                    outputStream.write(location.getBytes());
                    outputStream.write("\n\n".getBytes());  // Extra line for more space
                    
                    outputStream.write(bookingDate.getBytes());
                    outputStream.write("\n\n".getBytes());  // Extra line for more space
                    
                    outputStream.write(timeSlot.getBytes());
                    outputStream.write("\n\n\n".getBytes());  // Extra lines for more space
                    outputStream.write(ESC_FONT_BOLD_OFF);
                    
                    // Generate and print QR code
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
                    String timestamp = LocalDateTime.now().format(formatter);
                    String qrContent = reservation.getBookingId() + "_" + timestamp;
                    printQRCodeFromBuffer(outputStream, QRCodeUtil.generateQRCodeImage(qrContent, 240, 240));
                    
                    // Print visitor name in all caps with the LARGE font (same as VISITOR)
                    String visitorName = "";
                    if (i < visitorNames.size()) {
                        visitorName = visitorNames.get(i).toUpperCase();
                    }
                    
                    // Split visitor name into first and last name
                    String[] nameParts = visitorName.trim().split(" ", 2);
                    String firstName = nameParts[0];
                    String lastName = (nameParts.length > 1) ? nameParts[1] : "";
                    
                    outputStream.write("\n\n".getBytes());  // Extra line for more space
                    outputStream.write(ESC_FONT_LARGE);  // Same font as VISITOR
                    outputStream.write(ESC_FONT_BOLD);
                    
                    // Print first name and last name on separate lines
                    outputStream.write(firstName.getBytes());
                    outputStream.write("\n".getBytes());
                    outputStream.write(lastName.getBytes());
                    outputStream.write("\n\n\n".getBytes());  // Extra line for more space
                    
                    // Print organization
                    outputStream.write(ESC_FONT_MEDIUM);
                    outputStream.write(organization.getBytes());
                    outputStream.write("\n\n\n".getBytes());  // Extra lines for more space
                    
                    // Print VISITOR in large text
                    outputStream.write(ESC_FONT_EXTRA_LARGE);
                    outputStream.write("VISITOR".getBytes());
                    outputStream.write("\n".getBytes());
                    
                    // Reset font, add final spacing and cut
                    outputStream.write(ESC_FONT_NORMAL);
                    outputStream.write(ESC_LINE_SPACING_DEFAULT);
                    outputStream.write("\n\n".getBytes());
                    outputStream.write(ESC_CUT_PAPER);
                }
            } 
            // START OF STUDENT PRINTING SECTION - COMMENT FROM HERE
            else if (studentBooking != null) {
                // Handle student booking printing
                // Initialize printer
                outputStream.write(ESC_INIT);
                
                // Use smaller line spacing for compact design
                outputStream.write(ESC_LINE_SPACING_SMALL);
                
                // Print logo centered
                outputStream.write(ESC_ALIGN_CENTER);
                String logoPath = getServletContext().getRealPath("/images/rai_logoBW.png");
                printBitmapImage(outputStream, logoPath, 240, 80);
                
                // Increased space between booking details
                outputStream.write("\n\n".getBytes());
                
                // Format location similar to visitor format
                String location = null;
                String location_model = studentBooking.getLocation();
                if (location_model.equals("HM Building, Robotics Lab")) {
                    location = "HM BUILDING, RBLAB";
                } else if (location_model.equals("E-12 Building, Future Lab")) {
                    location = "E-12 BUILDING, FTLAB";
                } else {
                    location = location_model.toUpperCase();
                }
                
                // Location, date, time and seat details
                outputStream.write(ESC_FONT_BOLD);
                outputStream.write(location.getBytes());
                outputStream.write("\n\n".getBytes());
                
                outputStream.write(studentBooking.getBookingDate().getBytes());
                outputStream.write("\n\n".getBytes());
                
                outputStream.write(studentBooking.getTimeSlot().getBytes());
                outputStream.write("\n\n".getBytes());
                
                // Print seat code
                outputStream.write(("SEAT: " + studentBooking.getSeatCode()).getBytes());
                outputStream.write("\n\n\n".getBytes());
                outputStream.write(ESC_FONT_BOLD_OFF);
                
                // Generate and print QR code
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
                String timestamp = LocalDateTime.now().format(formatter);
                String qrContent = studentBooking.getBookingID() + "_" + timestamp;
                printQRCodeFromBuffer(outputStream, QRCodeUtil.generateQRCodeImage(qrContent, 240, 240));
                
                // Print student name in all caps
                String studentName = studentBooking.getName().toUpperCase();
                
                // Split student name into first and last name
                String[] nameParts = studentName.trim().split(" ", 2);
                String firstName = nameParts[0];
                String lastName = (nameParts.length > 1) ? nameParts[1] : "";
                
                outputStream.write("\n\n".getBytes());
                outputStream.write(ESC_FONT_LARGE);
                outputStream.write(ESC_FONT_BOLD);
                
                // Print first name and last name on separate lines
                outputStream.write(firstName.getBytes());
                outputStream.write("\n".getBytes());
                outputStream.write(lastName.getBytes());
                outputStream.write("\n\n\n".getBytes());
                
                // Print STUDENT in large text instead of VISITOR
                outputStream.write(ESC_FONT_EXTRA_LARGE);
                outputStream.write("STUDENT".getBytes());
                outputStream.write("\n".getBytes());
                
                // Reset font, add final spacing and cut
                outputStream.write(ESC_FONT_NORMAL);
                outputStream.write(ESC_LINE_SPACING_DEFAULT);
                outputStream.write("\n\n".getBytes());
                outputStream.write(ESC_CUT_PAPER);
            }
            // END OF STUDENT PRINTING SECTION - COMMENT UNTIL HERE
            
            outputStream.flush();
            outputStream.close();
            comPort.closePort();
            
            response.getWriter().write("Print job sent successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Print error: " + e.getMessage());
        }
    }
    
    // Improved image printing method for grayscale bitmap images (logo)
    private void printBitmapImage(OutputStream outputStream, String imagePath, int width, int height) throws IOException {
        BufferedImage originalImage = ImageIO.read(new File(imagePath));
        
        // Resize image maintaining aspect ratio
        double aspectRatio = (double) originalImage.getWidth() / originalImage.getHeight();
        int newWidth = width;
        int newHeight = (int) (width / aspectRatio);
        
        // If height is too large, scale by height instead
        if (newHeight > height) {
            newHeight = height;
            newWidth = (int) (height * aspectRatio);
        }
        
        // Create scaled image
        BufferedImage scaledImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_ARGB);
        scaledImage.createGraphics().drawImage(originalImage, 0, 0, newWidth, newHeight, null);
        
        // Calculate bytes per line (width in bytes, 8 pixels per byte)
        int bytesPerLine = (newWidth + 7) / 8;
        
        // Print raster bit image
        byte[] header = new byte[] {
            0x1D, 0x76, 0x30, 0x00,
            (byte) (bytesPerLine & 0xFF), 
            (byte) ((bytesPerLine >> 8) & 0xFF),
            (byte) (newHeight & 0xFF),
            (byte) ((newHeight >> 8) & 0xFF)
        };
        
        outputStream.write(header);
        
        // Convert and send image data
        for (int y = 0; y < newHeight; y++) {
            for (int x = 0; x < bytesPerLine; x++) {
                byte pixels = 0;
                for (int bit = 0; bit < 8; bit++) {
                    int imgX = x * 8 + bit;
                    if (imgX < newWidth) {
                        int rgb = scaledImage.getRGB(imgX, y);
                        // Check for dark pixel
                        int r = (rgb >> 16) & 0xFF;
                        int g = (rgb >> 8) & 0xFF;
                        int b = rgb & 0xFF;
                        int alpha = (rgb >> 24) & 0xFF;
                        
                        if (alpha > 128 && (r + g + b) / 3 < 128) {
                            // Dark pixel (set bit)
                            pixels |= (byte) (0x80 >> bit);
                        }
                    }
                }
                outputStream.write(pixels);
            }
        }
    }
    
    // Improved QR code printing method
    private void printQRCodeFromBuffer(OutputStream outputStream, BufferedImage qrImage) throws IOException {
        int width = qrImage.getWidth();
        int height = qrImage.getHeight();
        
        // Calculate bytes per line (width in bytes, 8 pixels per byte)
        int bytesPerLine = (width + 7) / 8;
        
        // Print raster bit image
        byte[] header = new byte[] {
            0x1D, 0x76, 0x30, 0x00,
            (byte) (bytesPerLine & 0xFF), 
            (byte) ((bytesPerLine >> 8) & 0xFF),
            (byte) (height & 0xFF),
            (byte) ((height >> 8) & 0xFF)
        };
        
        outputStream.write(header);
        
        // Convert and send image data
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < bytesPerLine; x++) {
                byte pixels = 0;
                for (int bit = 0; bit < 8; bit++) {
                    int imgX = x * 8 + bit;
                    if (imgX < width) {
                        int rgb = qrImage.getRGB(imgX, y);
                        // For QR code, black is 0 (printed) and white is 1 (not printed)
                        int luminance = (((rgb >> 16) & 0xFF) + ((rgb >> 8) & 0xFF) + (rgb & 0xFF)) / 3;
                        if (luminance < 128) {
                            // Dark pixel (set bit)
                            pixels |= (byte) (0x80 >> bit);
                        }
                    }
                }
                outputStream.write(pixels);
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}