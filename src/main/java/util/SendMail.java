package util; 

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;
//import java.io.File;
//import java.io.FileNotFoundException;
import java.io.IOException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class SendMail {
    private static final Logger logger = LogManager.getLogger(SendMail.class);
    private static Properties emailProps;
    
    static {
        try {
            emailProps = new Properties();
            emailProps.load(SendMail.class.getClassLoader().getResourceAsStream("mail.properties"));
            logger.info("Email properties loaded successfully");
        } catch (IOException e) {
            logger.error("Failed to load email properties", e);
            throw new RuntimeException("Failed to load email properties", e);
        }
    }

    public static void sendBorrowConfirmation(String studentId, String studentName, 
            String itemDetails, String borrowDate, String dueDate) {
        try {
            // Set mail properties
            Properties props = new Properties();
            props.put("mail.smtp.host", emailProps.getProperty("mail.smtp.host"));
            props.put("mail.smtp.port", "465");  // Use SSL port 465
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            
            // Create session with authenticator
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(
                        emailProps.getProperty("mail.username"),
                        emailProps.getProperty("mail.password")
                    );
                }
            });

            // Construct student email
            //String recipientEmail = studentId + "@kmitl.ac.th"; 
            String recipientEmail = "patramont.03@gmail.com";

            // Create message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(emailProps.getProperty("mail.username")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Equipment Loan Confirmation");

            // Create HTML content
            String htmlContent = String.format("""
                <html>
                <body>
                    <h2>Items Request Confirmation</h2>
                    <p>Dear %s,</p>
                    <p>Your items borrowing request has been confirmed with the following details:</p>
                    
                    <h3>Student Information:</h3>
                    <ul>
                        <li>Student ID: %s</li>
                    </ul>
                    
                    <h3>Borrowed Items:</h3>
                    <p>%s</p>
                    
                    <h3>Borrowing Period:</h3>
                    <ul>
                        <li>Borrow Date: %s</li>
                        <li>Due Date: %s</li>
                    </ul>
                    
                    <h3>Important Notes:</h3>
                    <ul>
                        <li>Please return the items in the same condition as borrowed</li>
                        <li>Late returns will incur penalties</li>
                        <li>Any damage must be reported immediately</li>
                    </ul>
                    
                    <p>For any questions, please contact the inventory room.</p>
                    
                    <p>Best regards,<br>Inventory Room</p>
                </body>
                </html>
                """, 
                studentName, studentId, itemDetails, borrowDate, dueDate);

            // Set content
            message.setContent(htmlContent, "text/html; charset=utf-8");

            // Send message
            Transport.send(message);

            logger.info("Mail has been sent successfully to " + recipientEmail);

        } catch (MessagingException e) {
            logger.error("Failed to send email: " + e.getMessage(), e);
            throw new RuntimeException("Failed to send email: " + e.getMessage(), e);
        }
    }
/*  // Used for Mail with attch images (qr code), right now not used //
    public static void sendDocumentEmail(String studentId, String subject, String emailBody, String... qrCodePaths) {
        try {
            // Get email properties
            String host = emailProps.getProperty("mail.smtp.host");
            String username = emailProps.getProperty("mail.username");
            String password = emailProps.getProperty("mail.password");
    
            if (host == null || username == null || password == null) {
                logger.error("Missing email configuration properties");
                throw new RuntimeException("Email configuration is incomplete");
            }
    
            // Set properties for SSL connection (Port 465)
            Properties props = new Properties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", "465");  // Use SSL port
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    
            // Create session with authentication
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });
    
            // Create email message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(studentId + "@kmitl.ac.th"));
            message.setSubject(subject);
    
            // Create multipart message
            Multipart multipart = new MimeMultipart();
    
            // Add text part
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setContent(emailBody, "text/html; charset=utf-8"); // Ensure HTML content
            multipart.addBodyPart(textPart);
            logger.debug("Added email body text successfully");
    
            // Add QR code attachments
            for (String qrCodePath : qrCodePaths) {
                if (qrCodePath != null && !qrCodePath.isEmpty()) {
                    try {
                        MimeBodyPart imagePart = new MimeBodyPart();
                        File qrFile = new File(qrCodePath);
    
                        if (!qrFile.exists()) {
                            logger.error("QR code file not found: {}", qrCodePath);
                            throw new FileNotFoundException("QR code file not found: " + qrCodePath);
                        }
    
                        imagePart.attachFile(qrFile);
                        multipart.addBodyPart(imagePart);
                        logger.debug("Added QR code attachment successfully: {}", qrCodePath);
                    } catch (IOException e) {
                        logger.error("Failed to attach QR code file: {}", qrCodePath, e);
                        throw new MessagingException("Failed to attach QR code file", e);
                    }
                } else {
                    logger.warn("Skipping null or empty QR code path");
                }
            }
    
            message.setContent(multipart);
    
            // Send message
            Transport.send(message);
            logger.debug("Attached QR code file im SendMail:", qrCodePaths[0]);
            logger.info("Email sent successfully to student ID: {}", studentId);
    
        } catch (MessagingException e) {
            logger.error("Failed to send email to student ID: {}", studentId, e);
            throw new RuntimeException("Failed to send email", e);
        }
    }
*/  
    public static void sendDocumentEmail(String studentId, String subject, String emailBody, String... documentLinks) {
        try {
            // Get email properties
            String host = emailProps.getProperty("mail.smtp.host");
            String username = emailProps.getProperty("mail.username");
            String password = emailProps.getProperty("mail.password");

            if (host == null || username == null || password == null) {
                logger.error("Missing email configuration properties");
                throw new RuntimeException("Email configuration is incomplete");
            }

            // Set properties for SSL connection (Port 465)
            Properties props = new Properties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", "465");  // Use SSL port
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

            // Create session with authentication
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            // Create email message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(studentId + "@kmitl.ac.th"));
            message.setSubject(subject);

            // Build document links section
            StringBuilder linksSection = new StringBuilder("<p><strong>Attached Documents:</strong></p><ul>");
            for (String link : documentLinks) {
                if (link != null && !link.isEmpty()) {
                    linksSection.append("<li><a href='").append(link).append("' target='_blank'>").append(link).append("</a></li>");
                }
            }
            linksSection.append("</ul><br>");

            // Create multipart message
            Multipart multipart = new MimeMultipart();

            // Add email body with links
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setContent(emailBody + linksSection.toString(), "text/html; charset=utf-8"); // Ensure HTML content
            multipart.addBodyPart(textPart);
            logger.debug("Added email body with document links successfully");

            message.setContent(multipart);

            // Send message
            Transport.send(message);
            logger.info("Email with document links sent successfully to student ID: {}", studentId);

        } catch (MessagingException e) {
            logger.error("Failed to send email to student ID: {}", studentId, e);
            throw new RuntimeException("Failed to send email", e);
        }
    }

}