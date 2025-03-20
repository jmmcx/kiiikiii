<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.ConfigUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Disbursement Guidelines</title>
    <style>
        body {
            margin: 0;
            padding: 40px;
            font-family: Arial, sans-serif;
            min-height: 100vh;
            background-color: #ffffff;
            overflow-y: auto;
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

        .sub-title {
            text-align: center;
            margin: 40px 0 0px;
            font-size: 40px;
            color: #666;
        }

        /* Main content container */
        .content {
            padding: 0 20px 90px 20px;
            max-width: 1000px;
            margin: 0 auto;
            text-align: center;
        }

        .document-list {
            max-width: 900px;
            margin-top: 50px;
            padding: 20px;
        }

        .document-item {
            border-bottom: 1px solid #ddd;
            padding: 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .document-item h3 {
            font-size: 30px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .document-item ul {
            padding-left: 20px;
            margin: 10px 0;
            font-size: 30px;
            font-weight: bold;
            text-align: left;
            line-height: 1.6;
        }

        .document-item ul li {
            margin-bottom: 5px;
        }

        .receipt-image {
            width: 750px;
            height: auto;
            border: 1px solid #ddd;
            border-radius: 10px;
            cursor: pointer;
            margin-top: 20px;
        }

        .main-menu-button {
            display: block;
            width: 100%;
            max-width: 100%;
            margin: 100px auto;
            padding: 15px;
            background-color: #ff5722;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 50px;
            cursor: pointer;
            text-decoration: none;
            text-transform: uppercase;
            font-weight: bold;
            text-align: center;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            position: relative;
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
        }

        .modal-image {
            width: 90%;
            border-radius: 10px;
        }

        .close {
            position: absolute;
            top: 10px;
            right: 20px;
            font-size: 30px;
            color: #333;
            cursor: pointer;
        }

        /* Responsive Design */
        @media screen and (max-width: 768px) {
            .back-button img {
                width: 25px;
                height: 25px;
            }

            .title {
                font-size: 22px;
                padding: 10px;
            }

            .main-menu-button {
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <!-- Back button -->
    <div class="back-button">
        <img src="../../images/back_arrow.png" alt="Back" onclick="window.location.href='document.jsp'">
    </div>

    <div class="title">Disbursement Guidelines</div>
    <div class="content">
        <div class="sub-title">Receipt Submission and Reimbursement</div>

        <div class="document-list">
            <div class="document-item">
                <h3>Section 1: Receipt Requirements</h3>
                <ul>
                    <li>The buyer’s name must be: <br><strong>School of Engineering, King Mongkut’s Institute of Technology Ladkrabang</strong><br>1 Soi Chalongkrung, Ladkrabang, Bangkok 10520<br>Taxpayer ID: 0994000160623</li>
                    <li>The receipt must include a receipt number and shop name/address or a business card.</li>
                    <li>The receipt date must be within the eligible reimbursement month.</li>
                    <li>The payee must sign the receipt.</li>
                </ul>
            </div>

            <div class="document-item">
                <h3>Section 2: Steps for Receipt Submission</h3>
                <ul>
                    <li>Submit the original receipt by the deadline:</li>
                    <ul>
                        <li>Receipts dated 1st–10th → Submit by the 12th</li>
                        <li>Receipts dated 11th–25th → Submit by the 26th</li>
                        <li>For purchases made from the 26th to the end of the month, contact P’Jean first.</li>
                    </ul>
                    <li>Fill out the Google Form and attach a photo of the receipt for validation and tracking.</li>
                </ul>
            </div>

            <div class="document-item">
                <h3>Section 3: Important Notes</h3>
                <ul>
                    <li>Shipping costs are <strong>NOT</strong> reimbursable.</li>
                    <li>The price of any single item must <strong>NOT</strong> exceed 5,000 THB.</li>
                    <li>Receipts from outside Bangkok should be avoided. If necessary, consult the admin first.</li>
                    <li>E-bills are <strong>NOT</strong> eligible for reimbursement.</li>
                </ul>
            </div>

            <div class="document-item">
                <h3>Example</h3>
                <img src="../../images/disbursement/receipt1.jpg" alt="Disbursement-Receipt" class="receipt-image" onclick="openModal('modal1')">
                <img src="../../images/disbursement/receipt2.jpg" alt="Disbursement-Receipt" class="receipt-image" onclick="openModal('modal2')">
            </div>
        </div>

        <a href="../other.jsp" class="main-menu-button">BACK TO MAIN MENU</a>
    </div>

    <!-- Modal for Receipt 1 -->
    <div id="modal1" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('modal1')">×</span>
            <img src="<%= request.getContextPath() %>/images/disbursement/receipt1.jpg" alt="Disbursement-Receipt" class="modal-image">
        </div>
    </div>

    <!-- Modal for Receipt 2 -->
    <div id="modal2" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('modal2')">×</span>
            <img src="<%= request.getContextPath() %>/images/disbursement/receipt2.jpg" alt="Disbursement-Receipt" class="modal-image">
        </div>
    </div>

    <script>
        function openModal(modalId) {
            document.getElementById(modalId).style.display = 'flex';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                document.getElementById('modal1').style.display = 'none';
                document.getElementById('modal2').style.display = 'none';
            }
        }
    </script>
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