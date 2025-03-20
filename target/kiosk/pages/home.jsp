<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" type="text/css" href="../theme/home.css">
  <title>RAI Department</title>
  <script type="text/javascript">
    function enterFullScreen() {
      if (document.documentElement.requestFullscreen) {
        document.documentElement.requestFullscreen();
      } else if (document.documentElement.webkitRequestFullscreen) { /* Safari */
        document.documentElement.webkitRequestFullscreen();
      } else if (document.documentElement.mozRequestFullScreen) { /* Firefox */
        document.documentElement.mozRequestFullScreen();
      } else if (document.documentElement.msRequestFullscreen) { /* IE/Edge */
        document.documentElement.msRequestFullscreen();
      }
    }
  
    function exitFullScreen() {
      if (document.fullscreenElement || document.webkitFullscreenElement || document.mozFullScreenElement || document.msFullscreenElement) {
        if (document.exitFullscreen) {
          document.exitFullscreen();
        } else if (document.webkitExitFullscreen) { /* Safari */
          document.webkitExitFullscreen();
        } else if (document.mozCancelFullScreen) { /* Firefox */
          document.mozCancelFullScreen();
        } else if (document.msExitFullscreen) { /* IE/Edge */
          document.msExitFullscreen();
        }
      }
    }
    // Trigger fullscreen when image is clicked (for demonstration purposes)
    document.querySelector('.logo').addEventListener('click', () => {
      if (document.fullscreenElement || document.webkitFullscreenElement || document.mozFullScreenElement || document.msFullscreenElement) {
        exitFullScreen();  // Exit fullscreen if currently in fullscreen mode
      } else {
        enterFullScreen();  // Enter fullscreen if not currently in fullscreen mode
      }
    });
    document.addEventListener("DOMContentLoaded", function () {
        let videoSource = document.getElementById("videoSource");
        videoSource.src = "../3dModel/3dmodel.mp4?nocache=" + new Date().getTime();
        document.getElementById("videoPlayer").load();
    });
  </script>
  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #ffffff;
      color: #333;
      padding-top: 100px;
      padding-bottom: 100px; /* Increased for larger menu bar */
      min-height: 100vh;
      position: relative;
      overflow-y: auto;
      padding-bottom: 150px;
  }
    /* FAQ Section */
    .faq-section {
      max-width: 800px;
      margin: auto;
      padding: 20px;
      padding-bottom: 80px;
      margin-top: 95vh; /* Push the FAQ section down to full screen height */
    }
    .faq-section::after {
    content: "";
    display: block;
    height: 150px; /* Space for scrolling */
}
    /* Center the FAQ heading */
    .faq-section h1 {
      text-align: center;
      font-size: 50px;
      font-weight: bold;
      margin-bottom: 30px;
    }

    .faq-item {
      border-bottom: 1px solid #ddd;
      padding: 30px;
      margin-bottom: 30px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    /* Large Orange Dot */
    .faq-dot {
      width: 25px;
      height: 25px;
      background-color: #FFb884;
      border-radius: 50%;
      flex-shrink: 0;
      margin-right: 12px;
    }

    .faq-content {
      display: flex;
      align-items: center;
      flex-grow: 1;
      overflow-y: auto;
    }

    .faq-question {
      font-size: 30px;
      flex-grow: 1;
    }

    /* Down arrow */
    .faq-toggle {
      font-size: 30px;
      color: #FFb884;
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
      transition: max-height 0.4s ease-out, padding 0.3s ease-out;
      background-color: #f6f6f6;
      font-size: 25px; /* same font size as question */
      color: black;
      font-weight: bold;
      padding: 0 15px; /* no vertical padding when collapsed */
      margin-top: 0;
      line-height: 2.0; /* adds space between lines */
    }

    /* Expanded state */
    .faq-item.active + .faq-answer {
      max-height: 600px; /* large enough for full content */
      padding: 15px;
      margin-top: 10px;
    }
    .sponsor-container {
      overflow: hidden;
      white-space: nowrap;
      position: relative;
      width: 100%;
    }

    .sponsor-slider {
      display: inline-block;
      white-space: nowrap;
      animation: slide 30s linear infinite;
    }

    @keyframes slide {
      from {
        transform: translateX(100%);
      }
      to {
        transform: translateX(-100%);
      }
    }

    .sponsor-slider img {
      height: 200px; /* Standardize height for all logos */
      width: auto; /* Maintain aspect ratio */
      max-width: 200px; /* Prevent logos from getting too wide */
      object-fit: contain;
      margin: 0 15px;
      background-color: white; /* Optional: Adds contrast for transparent logos */
      padding: 10px; /
    }

  </style>
</head>
<body>
  <!-- Fixed Header -->
  <div class="header">
    <img src="../images/rai_logo.png" alt="RAI Logo" class="logo" onclick="exitFullScreen()">
  </div>

  <div class="container">
    <a href="3dmodel.jsp" class="video-link">
      <video class="community-video" autoplay muted loop>
        <source src="../3dModel/3DVIDVAVDO.webm" type="video/webm">
        Your browser does not support the video tag.
      </video>
    </a>
    <!-- RAI Community Image -->
    <!--div class="community-section">
      <img src="../images/rai_community.png" alt="RAI Community" class="community-image">
    </div-->

    <!-- FAQ Section -->
    <div class="faq-section">
      <h1>FAQ</h1> <!-- Centered Title -->

      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">What is RAI?</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        RAI stands for Bachelor of Engineering Program in Robotics and Artificial Intelligence Engineering (International Program).
      </div>

      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">What’s the skill required?</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        We require teamwork, passion, and hard work because we believe that “The results you achieve will be in direct proportion to the effort you apply.”
      </div>

      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">What do we learn?</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        In the first year, we study basic engineering and an introduction to robotics and AI. The second year covers deeper topics like computer vision and algorithms, while the third and fourth years allow students to choose electives based on their interests.
      </div>

      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">What job can I apply for after graduation?</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        Career opportunities include Roboticist, AI Engineer, System Engineer, AI Programmer, Solution Engineer, and high-tech startup entrepreneur. Additionally, roles like Automation Engineer, Software Developer, and other positions in the tech industry are also available.
      </div>

      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">Is there a lot of projects?</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        The KMITL engineering program combines both theory and hands-on learning through projects that enhance knowledge and skills. Students typically work on 2-5 projects per semester.
      </div>

      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">How much is the tuition fee?</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        The tuition fee is 105,000 THB per semester for RAI and 135,000 THB per semester for MATBOT.
      </div>

      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">Do you offer scholarships?</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        Scholarships are offered to applicants with excellent academic performance to pursue their undergraduate education in international programs, based on the requirements outlined in the announcement.
      </div>

      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">What are the requirements to apply?</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        We require a minimum SAT score of 1020, a language proficiency certificate, a personal statement, and two recommendation letters.
      </div>

      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">What should I include in my portfolio?</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        Your academic activities related to Robotics, AI, and engineering that show your passion and skills.
      </div>

      <div class="faq-item">
        <div class="faq-content">
          <div class="faq-dot"></div>
          <div class="faq-question">Where can I research more about RAI?</div>
        </div>
        <div class="faq-toggle">▼</div>
      </div>
      <div class="faq-answer">
        Check out more info from this link: <a href="homefaq_detail.jsp?type=raiofficialwebsite">RAI Official Website</a>
      </div>
      <div class="sponsor-container">
        <div class="sponsor-slider">
          <img src="../images/sponsor/abb.png" alt="Sponsor 1">
          <img src="../images/sponsor/autodesk.png" alt="Sponsor 2">
          <img src="../images/sponsor/aws.png" alt="Sponsor 3">
          <img src="../images/sponsor/delta.png" alt="Sponsor 4">
          <img src="../images/sponsor/depa.png" alt="Sponsor 5">
          <img src="../images/sponsor/dsignage.png" alt="Sponsor 6">
          <img src="../images/sponsor/festo.png" alt="Sponsor 7">
          <img src="../images/sponsor/gti.png" alt="Sponsor 8">
          <img src="../images/sponsor/krungthai.png" alt="Sponsor 9">
          <img src="../images/sponsor/mitsu.png" alt="Sponsor 10">
          <img src="../images/sponsor/nachi.png" alt="Sponsor 11">
          <img src="../images/sponsor/nvidia.png" alt="Sponsor 12">
          <img src="../images/sponsor/ptt.png" alt="Sponsor 13">
          <img src="../images/sponsor/pwc.png" alt="Sponsor 14">
          <img src="../images/sponsor/seagate.png" alt="Sponsor 15">
          <img src="../images/sponsor/solimac.png" alt="Sponsor 16">
          <img src="../images/sponsor/thaisteel.png" alt="Sponsor 17">
        </div>
      </div>
    </div>
  </div>
  <div class="menu-bar">
    <div class="menu-container">
        <a href="3dmodel.jsp" class="menu-item">
            <img src="${pageContext.request.contextPath}/images/icon/map_icon1.png" alt="Map" class="menu-icon" id="map-icon">
        </a>
        <a href="home.jsp" class="menu-item">
            <img src="${pageContext.request.contextPath}/images/icon/home_icon1.png" alt="Home" class="menu-icon" id="home-icon">
        </a>
        <a href="other.jsp" class="menu-item">
            <img src="${pageContext.request.contextPath}/images/icon/other_icon1.png" alt="Other" class="menu-icon" id="other-icon">
        </a>
    </div>
</div>

  <!-- JavaScript for FAQ functionality -->
  <script>
    document.querySelectorAll('.faq-item').forEach(item => {
        item.addEventListener('click', () => {
    // Close all other open FAQ items
    document.querySelectorAll('.faq-item').forEach(otherItem => {
      if (otherItem !== item) {
        otherItem.classList.remove('active');
      }
    });
    // Toggle the current FAQ item
    item.classList.toggle('active');
    });
  });
  </script>
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
