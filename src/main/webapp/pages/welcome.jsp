<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome Page</title>
    <style>
        body {
            margin: 0;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #000; /* Black background */
        }
        #slideshow {
            width: 100%;
            height: 100%;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center; /* Centers the content in the slideshow */
        }
        img {
            max-width: 100%;
            max-height: 100%;
            position: absolute;
            transition: opacity 1s ease-in-out;
            object-fit: contain; /* Ensures the image scales without distortion */
        }
    </style>
</head>
<body onclick="redirectToMain()">
    <div id="slideshow">
        <!-- Will change to retrieve image from Cloud (if possible) -->
        <img src="../images/poster/kmitl_admission.jpg" alt="Poster 1" class="poster" style="opacity: 1;">
        <img src="../images/poster/kmitl_newyear.jpg" alt="Poster 2" class="poster" style="opacity: 0;">
        <img src="../images/poster/kmitl_openhouse.jpg" alt="Poster 3" class="poster" style="opacity: 0;">
    </div>

    <script>
        const posters = document.querySelectorAll('.poster');
        let currentIndex = 0;

        function showNextPoster() {
            posters[currentIndex].style.opacity = 0; // Hide current poster
            currentIndex = (currentIndex + 1) % posters.length; // Move to next poster
            posters[currentIndex].style.opacity = 1; // Show next poster
        }

        function redirectToMain() {
            window.location.href = "home.jsp"; // Redirect to home page
        }

        // Automatically change posters every 3.5 seconds
        setInterval(showNextPoster, 3500);
    </script>
</body>
</html>
