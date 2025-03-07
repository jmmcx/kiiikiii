<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Documentation</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            padding: 30px;
            background-color: #f8f9fa;
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
            font-size: 65px;
            font-weight: bold;
            margin-top: 190px;
            margin-bottom:100px;
        }

        .document-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .document-card {
            background-color: #D9D9D9;
            border-radius: 30px;
            padding: 40px 30px;
            text-align: center;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            transition: transform 0.2s, box-shadow 0.2s;
            color: white;
        }

        .document-card:hover {
            background: #E35205;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            color: white;
        }

        .document-icon {
            width: 200px;
            height: 200px;
            margin: 0 auto 25px;
        }

        .document-title {
            font-size: 40px;
            color: white;
            font-weight: 600;
        }
        .document-title:hover{
            color: white;
        }

        /* Specific styles for vertical screens (including 1080x1920) */
        @media screen and (orientation: portrait) and (min-width: 1080px) {
            body {
                padding: 40px;
            }

            .page-title {
                font-size: 65px;
            }

            .document-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 80px;
                padding: 0 40px;
            }

            .document-card {
                padding: 60px 40px;
            }

            .document-icon {
                width: 200px;
                height: 200px;
                margin-bottom: 60px;
            }

            .document-title {
                font-size: 40px;
            }
        }

        /* Adjustments for smaller screens */
        @media (max-width: 768px) {
            .document-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }
        }

        @media (max-width: 480px) {
            .document-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <a href="../other.jsp" class="back-button">
        <img src="../../images/back_arrow.png" alt="Back"  class="back-button img">
    </a>
    
    <div class="page-title">Documentation</div>
    <div class="document-grid">
        <a href="document_type.jsp?type=General" class="document-card">
            <img src="../../images/icon/general_icon.png" alt="General" class="document-icon">
            <div class="document-title">General</div>
        </a>

        <a href="document_type.jsp?type=Internship" class="document-card">
            <img src="../../images/icon/internship_icon.png" alt="Internship" class="document-icon">
            <div class="document-title">Internship</div>
        </a>

        <a href="document_type.jsp?type=Cooperative" class="document-card">
            <img src="../../images/icon/coop.png" alt="Cooperative Education" class="document-icon">
            <div class="document-title">Cooperative Education</div>
        </a>

        <a href="document_type.jsp?type=Disbursement" class="document-card">
            <img src="../../images/icon/disbursement_icon.png" alt="Disbursement Document" class="document-icon">
            <div class="document-title">Disbursement Document</div>
        </a>
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