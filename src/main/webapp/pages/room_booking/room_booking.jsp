<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Booking</title>
    <script src="https://unpkg.com/@zxing/library@latest"></script>
    <script>
        let videoStream = null; // Store video stream globally to prevent duplicate streams
    
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
                        if (result) {
                            console.log('QR Code:', result.text);
    
                            // Send QR value to servlet
                            fetch('<%= request.getContextPath() %>/VisitorCheckInServlet', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({ qrValue: result.text })
                            })
                            .then(response => {
                                if (response.redirected) {
                                    window.location.href = response.url; // Redirect if needed
                                } else {
                                    return response.json();
                                }
                            })
                            .then(data => {
                                console.log('Success:', data);
                            })
                            .catch(error => console.error('Error:', error));
    
                            // Stop camera stream after reading QR code
                            stopCamera();
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
        </div>
        <button class="main-menu-btn" onclick="goBackToMainMenu()">
            BACK TO MAIN MENU
        </button>
    </div>
</body>
</html>