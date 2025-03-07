<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.QRCodeUtil" %>
<%
    String documentType = request.getParameter("type");
    String formName = request.getParameter("formName");
    String fileUrl = request.getParameter("link");
    String description = request.getParameter("description");

    // Generate QR Code as Base64
    String qrCodeBase64 = QRCodeUtil.generateQRCode(fileUrl, 200, 200);

    request.setAttribute("documentType", documentType);
    request.setAttribute("formName", formName);
    request.setAttribute("fileUrl", fileUrl);
    request.setAttribute("description", description);
    request.setAttribute("qrCodeBase64", qrCodeBase64);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document Detail</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
    
        body {
            min-height: 100vh;
            background-color: #ffffff;
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

        .title {
            text-align: center;
            margin: 80px 0 20px;
            font-size: 65px;
            font-weight: bold;
            margin-top: 190px;
        }
    
        .container {
            min-height: 100vh;
            width: 100%;
            max-width: 1080px;
            margin: 0 auto;
            padding: 60px 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
    
        .content-wrapper {
            width: 100%;
            max-width: 600px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 30px; /* Consistent spacing between elements */
        }
    
        .document-type {
            background-color: #ff5722;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 40px;
        }
    
        .qr-code {
            width: 750px;
            height: 750px;
        }
    
        .description {
            color: #666;
            line-height: 1.5;
            font-size: 30px;
            font-weight:bold;
            text-align: center;
            padding: 0 20px;
        }
    
        .email-button {
            width: 90%;
            max-width: 600px;
            padding: 15px;
            background-color: #ff5722;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 40px;
            cursor: pointer;
            text-decoration: none;
            text-transform: uppercase;
            font-weight: bold;
            text-align: center;
            margin-top: 40px;
        }
    
        @media screen and (min-width: 1080px) {
            .container {
                padding: 60px 20px;
            }
    
            .content-wrapper {
                gap: 30px;
            }
    
            .title {
                font-size: 65px;
            }
    
            .document-type {
                font-size: 40px;
            }
    
            .qr-code {
                width: 750px;
                height: 750px;
            }
    
            .description {
                font-size: 30px;
            }
    
            .email-button {
                font-size: 40px;
            }
        }
    </style>
</head>
<body>
    <a onclick="window.history.back()" class="back-button">
        <img src="../../images/back_arrow.png" alt="Back">
    </a>
    <div class="title">${documentType}</div>
    <div class="container">
        <div class="content-wrapper">
            <div class="document-type">${formName}</div>
            <img src="data:image/png;base64,${qrCodeBase64}" alt="QR Code" class="qr-code">
            <p class="description">${description}</p>
            <a href="../fill_studentID.jsp?type=${documentType}&formName=${formName}&fileUrl=${fileUrl}" class="email-button">
                RECEIVE VIA EMAIL
            </a>
        </div>
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