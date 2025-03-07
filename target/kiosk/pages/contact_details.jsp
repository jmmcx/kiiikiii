<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Details</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #ffffff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .container {
            flex: 1;
            display: flex;
            flex-direction: column;
            width: 100%;
            position: relative;
            padding-top: 40px; /* Add padding to top of container */
        }

        .back-button {
            position: fixed;
            top: 90px;
            left: 70px;
            z-index: 100;
        }
    
        .back-button img {
            width: 80px;
            height: 80px;
        }

        .page-title {
            text-align: center;
            margin: 80px 0 20px;
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }

        .contact-header {
            background-color: #e35205;
            color: white;
            padding: 30px;
            text-align: center;
            margin-bottom: 35px;
        }

        .contact-header h2 {
            margin: 0;
            font-size: 43px;
        }

        .contact-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 0 20px;
            flex: 1;
        }

        .logo-container {
            margin: 50px 0;
            text-align: center;
        }

        .logo-img {
            width: 450px;
            height: auto;
        }

        .contact-details {
            width: 100%;
            max-width: 800px;
            display: flex;
            flex-direction: column;
            gap: 60px;
            margin-bottom: 100px;
            margin-right: 60px;
        }

        .contact-item {
            display: flex;
            align-items: center;
            text-decoration: none;
            color: #333;
            padding: 15px 0;
        }

        .contact-icon {
            width: 70px;
            height: 70px;
            margin-right: 30px;
        }

        .bottom-button {
            background-color: #e35205;
            color: white;
            padding: 15px;
            border: none;
            border-radius: 25px;
            width: 90%;
            max-width: 500px;
            margin: 0 auto 30px;
            cursor: pointer;
            font-size: 16px;
            display: block;
        }

        .qr-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
            margin-top: 30px; /* Reduced top margin for QR section */
        }

        .qr-code {
            margin-bottom: 50px;
        }

        .qr-code img {
            max-width: 800px;
            width: 100%;
            height: auto;
        }

        /* Specific styles for 1080x1920 screens */
        @media screen and (min-width: 1080px) and (min-height: 1920px) {
            .container {
                padding-top: 30px;
            }
            
            .contact-header {
                padding: 30px;
            }
            
            .contact-header h2 {
                font-size: 43px;
            }
            
            .logo-container {
                margin: 50px 0;
            }
            
            .logo-img {
                width: 450px;
            }
            
            .contact-item {
                font-size: 40px;
            }
            
            .contact-icon {
                width: 70px;
                height: 70px;
                margin-right: 30px;
            }
            
            .bottom-button {
                max-width: 800px;
                padding: 30px;
                font-size: 45px;
                margin-bottom: 50px;
                border-radius: 35px;
            }
            
            .qr-code img {
                width: 600px;
            }

            .qr-section {
                margin-top: 50px;
            }
        }
    </style>
</head>
<body>
    <%
        String contactId = request.getParameter("id");
        String showQR = request.getParameter("qr");
        
        // Basic information arrays
        String[] titles = {"Robotics and AI", "KESA", "SIIE", "ia.eng", "OIA"};
        String[] logos = {"rai_logo.png", "kesa_logo.png", "siie_logo.png", "ia_logo.jpg", "oia_logo.png"};
        
        // Contact information
        String[][] contacts = {
            // RAI
            {"rai@kmitl.ac.th", "084 624 4535", "@rai_kmitl", "KMITL.RoboticsAI"},
            // KESA
            {"smoeng@kmitl.ac.th", "kmitl.esa.official", "esa.kmitl"},
            // SIIE
            {"siie@kmitl.ac.th", "093 474 7468", "@siie_kmitl", "KMITL.SIIE"},
            // IA.ENG
            {"ia.eng@kmitl.ac.th", "02 329 8320", "@iaeng_kmitl", "kmitl.engineer.inter"},
            // OIA
            {"inter@kmitl.ac.th", "02 329 8140", "@vyz6619b", "kmitl.engineer.inter"}
        };
        
        int index = Integer.parseInt(contactId);
    %>
    <div class="back-button">
        <a href="contact.jsp">
            <img src="../images/back_arrow.png" alt="Back" class="back-button img">
        </a>
    </div>
    <div class="page-title">Contact</div>
    <div class="container">
        <!-- Contact Header -->
        <div class="contact-header">
            <h2><%= titles[index] %></h2>
        </div>

        <!-- Contact Content -->
        <% if (showQR == null || !showQR.equals("true")) { %>
            <div class="contact-content">
                <div class="logo-container">
                    <img src="../images/<%= logos[index] %>" alt="Logo" class="logo-img">
                </div>
                
                <div class="contact-details">
                    <% if (index == 1) { // KESA %>
                        <a href="mailto:<%= contacts[index][0] %>" class="contact-item">
                            <img src="../images/icon/email_icon.png" alt="Email" class="contact-icon">
                            <span><%= contacts[index][0] %></span>
                        </a>
                        
                        <a href="https://www.instagram.com/<%= contacts[index][1] %>" class="contact-item">
                            <img src="../images/icon/instagram_icon.png" alt="Instagram" class="contact-icon">
                            <span><%= contacts[index][1] %></span>
                        </a>
                        
                        <a href="https://www.facebook.com/<%= contacts[index][2] %>" class="contact-item">
                            <img src="../images/icon/fb_icon.png" alt="Facebook" class="contact-icon">
                            <span>https://www.facebook.com/<%= contacts[index][2] %></span>
                        </a>
                    <% } else { // Other contacts %>
                        <a href="mailto:<%= contacts[index][0] %>" class="contact-item">
                            <img src="../images/icon/email_icon.png" alt="Email" class="contact-icon">
                            <span><%= contacts[index][0] %></span>
                        </a>
                        
                        <a href="tel:<%= contacts[index][1] %>" class="contact-item">
                            <img src="../images/icon/phone_icon.png" alt="Phone" class="contact-icon">
                            <span><%= contacts[index][1] %></span>
                        </a>
                        
                        <div class="contact-item">
                            <img src="../images/icon/line_icon1.png" alt="Line" class="contact-icon">
                            <span><%= contacts[index][2] %></span>
                        </div>
                        
                        <a href="https://www.facebook.com/<%= contacts[index][3] %>" class="contact-item">
                            <img src="../images/icon/fb_icon.png" alt="Facebook" class="contact-icon">
                            <span>https://www.facebook.com/<%= contacts[index][3] %></span>
                        </a>
                    <% } %>
                </div>
                
                <button class="bottom-button" onclick="window.location.href='?id=<%= index %>&qr=true'">
                    QR CODE
                </button>
            </div>
        <% } else { %>
            <div class="qr-section">
                <div class="qr-code">
                    <img src="../images/contact/qr_<%= index %>.png" alt="QR Code">
                </div>
                
                <button class="bottom-button" onclick="window.location.href='other.jsp'">
                    BACK TO MAIN MENU
                </button>
            </div>
        <% } %>
    </div>
    <script type="text/javascript">
        // Function to redirect to the welcome page after 3 minutes (180000 milliseconds)
        function redirectToWelcomePage() {
            window.location.href = 'welcome.jsp'; 
        }
    
        // Set a timer to call the redirect function after 3 minutes
        setTimeout(redirectToWelcomePage, 180000);  // 180000 milliseconds = 3 minutes
      </script>
</body>
</html>