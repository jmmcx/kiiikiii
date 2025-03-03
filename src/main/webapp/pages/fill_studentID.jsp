<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enter Student ID</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            padding: 20px;
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

        .container {
            max-width: 900px;
            margin: 60px auto 0;
            text-align: center;
            padding: 20px;
        }

        .title {
            font-size: 50px;
            font-weight: bold;
            margin: 190px 0;
        }
        .sub-title {
            text-align: center;
            margin: 40px 0 40px;
            font-size: 40px;
            color: #666;
        }
        .document-type {
            display: inline-block;
            background-color: #ff5722;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            margin: 15px 0;
            font-size: 50px;
        }

        .input-field {
            width: 100%;
            max-width: 625px;
            margin: 60px auto;
            padding: 45px;
            font-size: 50px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 50px;
            background: #f5f5f5;
        }

        .numpad {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            max-width: 600px;
            margin: 0 auto;
        }

        .num-button {
            padding: 20px;
            font-size: 50px;
            border: none;
            background: #f0f0f0;
            border-radius: 10px;
            cursor: pointer;
            aspect-ratio: 1;
        }

        .num-button:active {
            background: #e0e0e0;
        }

        .action-button {
            background: red;
            color: white;
        }

        .submit-button {
            background: green;
            color: white;
        }

        .submit-button:disabled {
            background: #cccccc;
            cursor: not-allowed;
        }
    </style> 
</head>
<body>
    <!--Back to Previous Page
        To change back to Main Menu, change path at href="[CHANGE HERE]"
    -->
    <a href="javascript:history.back()" class="back-button">
        <img src="../images/back_arrow.png" alt="Back"  class="back-button img">
    </a>

    <div class="container">
        <h1 class="title">${param.documentType}</h1>
        <div class="document-type">${param.formName}</div>
        <div class="sub-title">Please Insert your Student ID</div>
        <form id="studentIdForm" action="<%= request.getContextPath() %>/MailServlet" method="POST">

            <input type="hidden" name="documentType" value="${param.type}">
            <input type="hidden" name="formName" value="${param.formName}">
            <input type="hidden" name="fileUrl" value="${param.fileUrl}">
            <input type="hidden" name="mode" value="${param.mode}">
            
            <input type="text" id="studentId" name="studentId" class="input-field" 
                   placeholder="" readonly>
            
            <div class="numpad">
                <button type="button" class="num-button" onclick="addNumber('1')">1</button>
                <button type="button" class="num-button" onclick="addNumber('2')">2</button>
                <button type="button" class="num-button" onclick="addNumber('3')">3</button>
                <button type="button" class="num-button" onclick="addNumber('4')">4</button>
                <button type="button" class="num-button" onclick="addNumber('5')">5</button>
                <button type="button" class="num-button" onclick="addNumber('6')">6</button>
                <button type="button" class="num-button" onclick="addNumber('7')">7</button>
                <button type="button" class="num-button" onclick="addNumber('8')">8</button>
                <button type="button" class="num-button" onclick="addNumber('9')">9</button>
                <button type="button" class="num-button action-button" onclick="clearInput()">←</button>
                <button type="button" class="num-button" onclick="addNumber('0')">0</button>
                <button type="submit" class="num-button submit-button" id="submitBtn" disabled>→</button>
            </div>
        </form>
    </div>

    <script>
        const studentIdInput = document.getElementById('studentId');
        const submitBtn = document.getElementById('submitBtn');
        const MAX_LENGTH = 8;

        function addNumber(num) {
            if (studentIdInput.value.length < MAX_LENGTH) {
                studentIdInput.value += num;
                updateSubmitButton();
            }
        }

        function deleteLastDigit() {
            studentIdInput.value = studentIdInput.value.slice(0, -1); // Remove the last character
            updateSubmitButton();
        }

        function updateSubmitButton() {
            submitBtn.disabled = studentIdInput.value.length !== MAX_LENGTH;
        }
    </script>
</body>
</html>