package servlets;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import util.SendMail;

@WebServlet("/MailServlet")
public class MailServlet extends HttpServlet {
    private static final Logger logger = LogManager.getLogger(MailServlet.class);
    private static Properties configProps = new Properties();
    //private String imageBasePath;
    private String si101;
    private String si201;

    @Override
    public void init() throws ServletException {
        super.init();
        loadConfigProperties();
    }

    private void loadConfigProperties() throws ServletException {
        try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/classes/config.properties")) {
            if (input == null) {
                logger.error("Unable to find config.properties");
                throw new ServletException("Config properties not found");
            }
            // Load properties
            configProps.load(input);

            // retrive form si101 ans si201
            si101 = configProps.getProperty("si101.form");
            si201 = configProps.getProperty("si201.form");
            
            //** will not use image local path anymore -- will be url link **
            //imageBasePath = configProps.getProperty("image.base.path");
            //if (imageBasePath == null) {
                //logger.error("Image base path is not defined in config.properties");
                //throw new ServletException("Image base path is not defined");
        //    }   
            logger.info("Config properties loaded successfully");
        } catch (IOException e) {
            logger.error("Error loading config.properties", e);
            throw new ServletException("Error loading config properties", e);
        }
    } 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String studentId = request.getParameter("studentId");
        String documentType = request.getParameter("documentType");
        String mode = request.getParameter("mode");

        try {
            if ("sendAll".equals(mode)) {
                logger.debug("Mode: Send all internship document to mail");
                // Send all documents for the given type
                switch (documentType.toLowerCase()) {
                    case "internship":
                        sendAllInternshipDocuments(studentId);
                        break;
                    // Add more cases for other document types if needed
                }
            } else {
                logger.debug("Mode: Send single document to mail");
                // Send single document
                String formName = request.getParameter("formName");
                String fileUrl = request.getParameter("fileUrl");

                // comment for now -- this is for the document as the qr path is in the local -- still not modify yet
                // Resolve the full image path
                //String imagePath = resolveImagePath(qrCodePath);
                //sendSingleDocument(studentId, documentType, formName, imagePath);
                
                // for sending the link url to mail
                sendSingleDocument(studentId, documentType, formName, fileUrl);
            }

            response.sendRedirect("pages/document/sendmail_complete.jsp");
        } catch (Exception e) {
            logger.error("Error sending email", e);
            response.sendRedirect("error.jsp");
        }
    }

    private void sendSingleDocument(String studentId, String documentType, String formName, String fileUrl) {
        // Create email with single QR code
        String emailBody = createEmailBody(studentId, documentType, formName);
        String subject = documentType + " - " + formName;

        try {
            // Debug log to show the final resolved image path
            logger.debug("QrCode in MailServlet: " + fileUrl);
            SendMail.sendDocumentEmail(studentId, subject, emailBody, fileUrl);
        } catch (Exception e) {
            logger.error("Error sending single document email", e);
            throw new RuntimeException("Failed to send email", e);
        }
    }
/*  // coment for now as the document still not edit //
    private String resolveImagePath(String relativePath) {
        // Remove context path part if it's present in the relativePath
        String contextPath = getServletContext().getContextPath();
        if (relativePath.startsWith(contextPath)) {
            relativePath = relativePath.substring(contextPath.length());
        }

        // Combine the base image path with the relative image path
        return imageBasePath + relativePath;
    }
*/
    private void sendAllInternshipDocuments(String studentId) {
        // Get all internship QR codes
        String[] fileUrl = {
            si101,
            si201
        };

        String subject = "All Internship Documents";
        String emailBody = createInternshipEmailBody(studentId);

        try {
            // Send email with multiple QR codes
            SendMail.sendDocumentEmail(studentId, subject, emailBody, fileUrl);
        } catch (Exception e) {
            logger.error("Error sending all internship documents email", e);
            throw new RuntimeException("Failed to send email", e);
        }
    }

    private String createEmailBody(String studentId, String documentType, String formName) {
        return "<html>"
            + "<body>"
            + "<p>Dear Student,</p>"
            + "<p>Here is your requested document: <strong>" + formName + "</strong></p>"
            + "<p>Please find the document attached below.</p>"
            + "<br>"
            + "<p>Best regards,<br>RAI Department</p>"
            + "</body>"
            + "</html>";
    }

    private String createInternshipEmailBody(String studentId) {
        return "<html>"
            + "<body>"
            + "<p>Dear Student,</p>"
            + "<p>Here are all your requested internship documents:</p>"
            + "<ul>"
            + "<li>SI101 (Intern Application Form)</li>"
            + "<li>SI201 (Summer Internship Cover Letter Request Form)</li>"
            + "</ul>"
            + "<p>Please find the document attached below.</p>"
            + "<br>"
            + "<p>Best regards,<br>RAI Department</p>"
            + "</body>"
            + "</html>";
    }

}