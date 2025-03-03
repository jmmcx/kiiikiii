<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.ConfigUtil" %>
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
        }

        .sub-title {
            text-align: center;
            margin: 40px 0 60px;
            font-size: 40px;
            color: #666;
        }

        .document-list {
            max-width: 900px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .document-item {
            background-color: #fff;
            border: 1px solid #ddd;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            padding: 35px 40px;
            margin: 60px 0;
            font-size: 40px;
            border-radius: 40px;
        }

        .document-item:hover {
            transform: translateX(5px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            background: #E35205;
            color: white;
            opacity: 0.9;
        }

        .send-email-btn {
            display: block;
            width: 100%;
            max-width: 800px;
            margin: 100px auto;
            padding: 20px;
            background-color: #ff5722;
            color: white;
            border: none;
            border-radius: 15px;
            cursor: pointer;
            font-size: 40px;
            font-weight: bold;
            transition: background-color 0.2s;
        }

        .send-email-btn:hover {
            background-color: #f4511e;
        }

        /* Specific styles for vertical screens (including 1080x1920) */
        @media screen and (orientation: portrait) and (min-width: 1080px) {
            body {
                padding: 40px;
            }

            .page-title {
                font-size: 65px;
            }

            .sub-title {
                font-size: 40px;
                margin: 40px 0 60px;
            }

            .document-item {
                padding: 35px 40px;
                margin: 60px 0;
                font-size: 40px;
                border-radius: 40px;
            }

            .send-email-btn {
                max-width: 900px;
                padding: 25px;
                font-size: 40px;
                margin: 100px auto;
            }
        }
    </style>
</head>
<body>
    <a href="document.jsp" class="back-button">
        <img src="../../images/back_arrow.png" alt="Back">
    </a>
    
    <h1 class="page-title">Documentation</h1>
    <h2 class="sub-title" id="docType"></h2>

    <div class="document-list" id="documentList">
    </div>

    <button class="send-email-btn" id="emailBtn" style="display: none;" 
            onclick="window.location.href='../fill_studentID.jsp?type=internship&formName=All Internship Documents&mode=sendAll'">
        SEND ALL VIA EMAIL
    </button>

    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const docType = urlParams.get('type');
        
        document.getElementById('docType').textContent = docType.charAt(0).toUpperCase() + docType.slice(1);

        // Define document lists with links from ConfigUtil
        const documents = {
            General: [
                { name: 'General form', link: '<%= ConfigUtil.getProperty("general.form") %>', description: 'For general request such as late registration, section adjustment etc.' },
                { name: 'Document request form', link: '<%= ConfigUtil.getProperty("document.request") %>', description: 'For requesting documents such as transcripts, certificates of student status, etc.' },
                { name: 'Request Form for Retaining', link: '<%= ConfigUtil.getProperty("retaining.form") %>', description: 'For request to retain' },
                { name: 'Request Form for Resigning', link: '<%= ConfigUtil.getProperty("resign.form") %>', description: 'For request to resign' } 
            ],
            Internship: [
                { name: 'SI101 (Intern Application Form)', link: '<%= ConfigUtil.getProperty("si101.form") %>', description: 'Intern application form' },
                { name: 'SI201 (Summer Internship Cover Letter Request Form)', link: '<%= ConfigUtil.getProperty("si201.form") %>', description: 'Summer Internship Cover Letter Request Form' }
            ],
            Cooperative: [
                { name: 'Student Form', link: '<%= ConfigUtil.getProperty("coop.student") %>', description: 'COOP101, COOP102, COOP103, COOP104, COOP105, COOP106' },
                { name: 'Advisor Form', link: '<%= ConfigUtil.getProperty("coop.advisor") %>', description: 'COOP201, COOP202' },
                { name: 'Company Form', link: '<%= ConfigUtil.getProperty("coop.company") %>', description: 'COOP301, COOP302, COOP303, COOP304' }
            ],
            Disbursement: []
        };

        // Display the appropriate document list
        const documentList = document.getElementById('documentList');
        const contextPath = '<%= request.getContextPath() %>';
        const docs = documents[docType] || [];
        
        docs.forEach(doc => {
        const div = document.createElement('div');
        div.className = 'document-item';
        div.textContent = doc.name;
        div.onclick = function() {
            const url = contextPath + 
                       '/pages/document/document_details.jsp' + 
                       '?type=' + encodeURIComponent(docType) + 
                       '&formName=' + encodeURIComponent(doc.name) + 
                       '&link=' + encodeURIComponent(doc.link) +
                       '&description=' + encodeURIComponent(doc.description);
            window.location.href = url;
        };
        documentList.appendChild(div);
        });

        // Show email button only for internship
        if (docType === 'Internship') {
            document.getElementById('emailBtn').style.display = 'block';
        }
    </script>
</body>