<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../theme/home.css">
    <title>Scholarship</title>
    <style>
        body {
            margin: 0;
            padding: 0;
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

        .title{
            text-align: center;
            margin: 80px 0 20px;
            font-size: 50px;
            font-weight: bold;
            margin-top: 190px;
            font-size: 65px;
        }

        /* Main content container */
        .content {
            padding: 0 20px 90px 20px;
            max-width: 1000px;
            margin: 0 auto;
            text-align: center;
        }


        .moreinfo-button {
            width: 90%;
            max-width: 600px;
            padding: 40px;
            background-color: #ff5722;
            margin-top: 40px;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 32px;
            cursor: pointer;
            text-decoration: none;
            text-transform: uppercase;
            font-weight: bold;
            text-align: center;
        }
        .faq-section {
            max-width: 900px;
            margin-top: 50px;
            padding: 20px;
        }

    /* Center the FAQ heading */
        .faq-section h1 {
            text-align: center;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .faq-item {
            border-bottom: 1px solid #ddd;
            padding: 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        /* Large Orange Dot */
        .faq-dot {
            width: 25px;
            height: 25px;
            background-color: #FFA560;
            border-radius: 50%;
            flex-shrink: 0;
            margin-right: 12px;
        }

        .faq-content {
            display: flex;
            align-items: center;
            flex-grow: 1;
        }

        .faq-question {
            font-size: 30px;
            flex-grow: 1;
        }

      /* Down arrow */
        .faq-toggle {
            font-size: 30px;
            color: #FFA560;
            transition: transform 0.3s ease;
        }

      /* Rotate arrow when active */
        .faq-item.active .faq-toggle {
            transform: rotate(180deg);
        }

        /* Answer Style */
        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease-out, padding 0.3s ease-out;
            background-color: #F6F6F6;
            font-size: 30px;
            color: black;
            font-weight: bold;
            padding: 0 15px; /* Initially no padding */
            margin-top: 0;
            line-height: 1.6;
            text-align: left;
        }
        /* Center only the title inside .faq-answer */
        .faq-title {
            text-align: center;
            font-size: 25px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        /* List styling remains left-aligned */
        .faq-answer ul {
            padding-left: 20px;
            margin: 10px 0;
        }

        .faq-answer li {
            margin-bottom: 5px;
        }
        /* Expanded state */
        .faq-item.active + .faq-answer {
            max-height: none; /* large enough for full content */
            height: auto; 
            padding: 15px;
            margin-top: 5px;
        }
        .scholarship-container {
          display: flex;
          justify-content: center;
          gap: 40px;
          margin-bottom: 20px;
        }

      .scholarship-box {
          width: 300px;
          padding: 20px;
          border-radius: 10px;
          text-align: center;
          font-size: 20px;
          font-weight: bold;
          box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
          background-color: #d9d9d9; /* Light grey background */
          border: 2px solid #f2f2f2; /* Same color as background */
        }

        /* Responsive Design */
        @media screen and (max-width: 768px) {
            .back-arrow {
                width: 25px;
                height: 25px;
            }

            .title-box {
                font-size: 22px;
                padding: 10px;
            }
            .moreinfo-button {
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <!-- Back button -->
    <div class="back-button">
      <img src="../images/back_arrow.png" alt="Back" class="back-button img" onclick="window.location.href='other.jsp'">
    </div>
    <div class="title">Scholarship</div>
    <!-- Title -->
    <div class="content">
  
      <div class="faq-section">
      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">Type of Scholarship</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        <div>Type 1: 100% Tuition Fee waiver (Full Scholarship)</div>
        <div>Type 2: 50% Tuition Fee waiver (Partial Scholarship)</div>
        <div>Type 3: 75% Tuition Fee waiver (Three Quarter Scholarship)</div>
    </div>
    <div class="faq-item">
      <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">Minimum Requirement</div>
      </div>
      <div class="faq-toggle">▼</div>
    </div>
    <div class="faq-answer">
      <ul>
          <li>Non-Thai Passport Holders</li>
          <li>Excellent Academic Background and English Proficiency</li>
          <li>Transcript of Record</li>
          <li>GPA in Math and Science subjects at least 3.0 out of 4.0 scale</li>
      </ul>
    </div>
    <div class="faq-item">
    <div class="faq-content">
        <div class="faq-dot"></div>
        <div class="faq-question">Applying for Scholarship</div>
    </div>
    <div class="faq-toggle">▼</div>
    </div>
    <div class="faq-answer">
    <ul>
        <li>Scholarship is considered for international students during admission process.</li>
        <li>Scholarship Result will be announced within February 2025</li>
    </ul>
    </div>
    <div class="faq-item">
    <div class="faq-content">
        <div class="faq-dot"></div>
        <div class="faq-question">For more Details</div>
    </div>
    <div class="faq-toggle">▼</div>
  </div>
  <div class="faq-answer">
    <div class="faq-title">Freshmen Scholarships for Thai students</div>
    <div class="scholarship-container">
        <div class="scholarship-box">
          <strong>Full Scholarship</strong>
          <p>100% Tuition waiver for 2 semesters (1 year)</p>
        </div>
        <div class="scholarship-box">
          <strong>Half Scholarship</strong>
          <p>50% Tuition waiver for 2 semesters (1 year)</p>
        </div>
      </div>
  
    <div>Requirements</div>
      <ul>
        <li>SAT score at least 1300</li>
        <li>
          <div>TOEFL (paper-based) of at least 550</div>
          <div>TOEFL (computer-based) of at least 213</div>
          <div>TOEFL (internet-based) of at least 79</div>
          <div>IELTS of at least 6.0</div>
        </li>
      </ul>
    <div>Notes</div>
      <ul>
        <li>SIIE will send the selection results to the scholarship recipients via email.</li>
        <li>Scholarships are limited. Applicants who meet the scholarship criteria may not be selected for the scholarship.
          Scholarships will be considered based on SAT scores, English language scores, and interview scores.
        </li>
        <li>Scholarship recipients are required to assist the Faculty of Engieering or SIIE Office or Department or Program
          for at least 45 hours per semester.
        </li>
      </ul>
    </div>
  </div>
<div class="content">
    <div><a onclick="window.location.href= 'scholarship_detail.jsp?type=scholarship'"class="moreinfo-button">FOR MORE INFORMATION</a><div>
</div>
  <!-- JavaScript for FAQ functionality -->
  <script>
    document.querySelectorAll('.faq-item').forEach(item => {
    item.addEventListener('click', () => {
        // Close all open items
        document.querySelectorAll('.faq-item').forEach(otherItem => {
            if (otherItem !== item) {
                otherItem.classList.remove('active');
                otherItem.nextElementSibling.style.maxHeight = null; // Collapse other answers
                otherItem.nextElementSibling.style.padding = "0 15px";
            }
        });
        // Toggle the clicked item
        item.classList.toggle('active');
        let answer = item.nextElementSibling;
        
        if (item.classList.contains('active')) {
            answer.style.maxHeight = answer.scrollHeight + "px"; // Expand based on content
            answer.style.padding = "15px"; // Add padding when expanded
        } else {
            answer.style.maxHeight = null; // Collapse
            answer.style.padding = "0 15px"; // Remove padding when collapsed
        }
        });
    });
  </script>
</body>
</html>
