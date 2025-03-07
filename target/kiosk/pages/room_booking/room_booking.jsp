<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.ReservationDAO" %>
<%
// Check if this is a status check request - MUST be at the very top of the file
String checkStatus = request.getParameter("checkStatus");
String bookingId = request.getParameter("bookingId");

if ("true".equals(checkStatus) && bookingId != null) {
    // This is an AJAX request to check booking status
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    // Clear any existing output
    out.clearBuffer();
    
    ReservationDAO reservationDAO = new ReservationDAO();
    String status = reservationDAO.getStatusByBookingID(bookingId);
    
    // Write JSON response directly
    out.print("{\"status\": " + (status == null ? "null" : "\"" + status + "\"") + "}");
    out.flush();
    
    // End processing here
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Booking</title>
    <script src="https://unpkg.com/@zxing/library@latest"></script>
    <script>
        let videoStream = null; // Store video stream globally to prevent duplicate streams
        let isProcessing = false; // Flag to prevent multiple simultaneous processing
    
        function startQRScanner() {
            const videoElement = document.getElementById('videoElement');
    
            // Prevent multiple instances of the camera stream
            if (videoStream) {
                console.warn("Camera already running.");
                return;
            }
    
            // Access the camera
            navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } })
                .then(function(stream) {
                    videoStream = stream; // Store the stream globally
                    videoElement.srcObject = stream;
                    videoElement.play();
    
                    const codeReader = new ZXing.BrowserQRCodeReader();
                    codeReader.decodeFromVideoDevice(null, videoElement, function(result, err) {
                        if (result && !isProcessing) {
                            isProcessing = true; // Set flag to prevent multiple processing
                            console.log('QR Code:', result.text);
                            
                            // Display scanning message
                            document.getElementById('scanStatus').textContent = 'Processing QR code...';
                            document.getElementById('scanStatus').style.display = 'block';
                            
                            // Check booking status directly using AJAX to the same JSP page
                            // Using timestamp to prevent caching
                            const timestamp = new Date().getTime();
                            fetch('room_booking.jsp?checkStatus=true&bookingId=' + encodeURIComponent(result.text) + '&t=' + timestamp, {
                                method: 'GET',
                                headers: {
                                    'Accept': 'application/json',
                                    'Cache-Control': 'no-cache'
                                }
                            })
                            .then(response => response.text())
                            .then(text => {
                                try {
                                    const data = JSON.parse(text);
                                    
                                    if (data.status === "check-in") {
                                        // Already checked in - show message
                                        document.getElementById('scanStatus').textContent = 'Already checked in for this reservation.';
                                        document.getElementById('scanStatus').style.color = '#e35205';
                                        isProcessing = false;
                                    } else if (data.status === null || data.status === "NotFound") {
                                        // Booking doesn't exist
                                        document.getElementById('scanStatus').textContent = 'Invalid booking ID. Please try again.';
                                        document.getElementById('scanStatus').style.color = '#e35205';
                                        isProcessing = false;
                                    } else {
                                        // Valid booking that isn't checked in yet, proceed to servlet for check-in
                                        // Send QR value to servlet - let the servlet handle redirection
                                        fetch('<%= request.getContextPath() %>/VisitorCheckInServlet', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/json' },
                                            body: JSON.stringify({ qrValue: result.text })
                                        })
                                        .then(response => {
                                            if (response.redirected) {
                                                // Let the browser follow the redirect from the servlet
                                                window.location.href = response.url;
                                            } else {
                                                return response.json().then(data => {
                                                    // If there's an error, display it and reset processing flag
                                                    document.getElementById('scanStatus').textContent = 
                                                        data.error || 'Error processing QR code. Please try again.';
                                                    document.getElementById('scanStatus').style.color = '#e35205';
                                                    isProcessing = false;
                                                });
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            document.getElementById('scanStatus').textContent = 'Error processing QR code. Please try again.';
                                            document.getElementById('scanStatus').style.color = '#e35205';
                                            isProcessing = false;
                                        });
                                    }
                                } catch (e) {
                                    console.error('Error parsing JSON:', e, 'Response text:', text);
                                    document.getElementById('scanStatus').textContent = 'Error checking reservation status. Please try again.';
                                    document.getElementById('scanStatus').style.color = '#e35205';
                                    isProcessing = false;
                                }
                            })
                            .catch(error => {
                                console.error('Error checking status:', error);
                                document.getElementById('scanStatus').textContent = 'Error checking reservation status. Please try again.';
                                document.getElementById('scanStatus').style.color = '#e35205';
                                isProcessing = false;
                            });
                        }
                    });
                })
                .catch(error => {
                    console.error('Error accessing camera:', error);
                    alert('Error accessing camera: ' + error);
                });
        }
    
        function stopCamera() {
            if (videoStream) {
                videoStream.getTracks().forEach(track => track.stop());
                videoStream = null;
            }
        }
    
        function goBackToMainMenu() {
            stopCamera(); // Stop camera before navigation
            window.location.href = '../home.jsp';
        }
    
        window.onload = startQRScanner;
    </script>
    <style>
        /* Reset and base styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #ffffff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        /* Container with exact 1080x1920 dimensions */
        .container {
            width: 1080px;
            height: 1920px;
            flex: 1;
            flex-direction: column;
            width: 100%;
            position: relative;
            padding-top: 40px;
        }

        /* Header section */
        .header {
            width: 100%;
            height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            padding-top: 40px;
        }

        /* Title styles - centered and properly sized */
        .title {
            text-align: center;
            margin: 80px 0 20px;
            font-size: 50px;
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }

        /* Back arrow styles - positioned appropriately */
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

        /* Main content area */
        .content-area {
            flex: 1;
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 60px 0;
        }

        /* QR scan message - larger and more visible */
        .scan-message {
            font-size: 48px;
            font-weight: 700;
            color: #000;
            margin-bottom: 80px;
            text-align: center;
        }

        /* Scan status message */
        #scanStatus {
            font-size: 42px;
            font-weight: 600;
            color: #3AE180;
            margin-top: 20px;
            text-align: center;
            display: none;
        }

        /* Camera feed container */
        .camera-container {
            width: 800px;
            height: 800px;
            position: relative;
            margin-bottom: 60px;
            border-radius: 20px;
            overflow: hidden;
            border: 4px solid #3AE180;
        }

        /* Video element styling */
        #videoElement {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* QR scan overlay - a frame that shows where to position the QR code */
        .scan-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 600px;
            height: 600px;
            transform: translate(-50%, -50%);
            border: 4px solid #3AE180;
            border-radius: 20px;
            box-shadow: 0 0 0 2000px rgba(0, 0, 0, 0.3);
            z-index: 10;
        }

        /* Footer area */
        .footer {
            width: 100%;
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding-bottom: 60px;
        }

        /* Back to main menu button - larger and more prominent */
        .main-menu-btn {
            background-color: #e35205;
            color: white;
            padding: 15px;
            border: none;
            border-radius: 25px;
            width: 90%;
            max-width: 700px;
            margin: 0 auto 30px;
            cursor: pointer;
            font-size: 45px;
            display: block;
        }

        /*.main-menu-btn:hover {
            background: #c74600;
        }

        .main-menu-btn span {
            color: white;
            font-size: 42px;
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            letter-spacing: 1px;
        }*/
    </style>
</head>
<body>
    <div class="back-button">
        <a href="../other.jsp">
            <img src="../../images/back_arrow.png" alt="Back" class="back-button img">
        </a>
    </div>
    <div class="title">Room Booking</div>
    <div class="container">
        <!-- Main content area -->
        <div class="content-area">
            <!-- QR Scan Message -->
            <div class="scan-message">PLEASE SCAN YOUR QR</div>
            
            <!-- Camera feed container with overlay -->
            <div class="camera-container">
                <video id="videoElement"></video>
                <div class="scan-overlay"></div>
            </div>
            
            <!-- Status message for QR processing -->
            <div id="scanStatus"></div>
        </div>
        <button class="main-menu-btn" onclick="goBackToMainMenu()">
            BACK TO MAIN MENU
        </button>
    </div>
    <script type="text/javascript">
        // Function to redirect to the welcome page after 3 minutes (180000 milliseconds)
        function redirectToWelcomePage() {
            window.location.href = '../welcome.jsp'; 
        }
    
        // Set a timer to call the redirect function after 3 minutes
        setTimeout(redirectToWelcomePage, 180000);  // 180000 milliseconds = 3 minutes
    </script>
</body>
</html>