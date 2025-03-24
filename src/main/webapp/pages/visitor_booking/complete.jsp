<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Complete</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }

        body {
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center; /* Center vertically */
            padding: 20px 10px; /* Side padding for small screens */
        }

        .container {
            width: 100%;
            max-width: 400px; /* Matches the card width in the image */
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
            margin: 0 auto;
        }

        .title {
            font-size: 17px;
            font-weight: 600;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            color: #333;
        }

        .content {
            padding: 20px 0;
        }

        .status-title {
            font-size: 24px;
            font-weight: 600;
            margin: 20px 0;
            color: #333;
        }

        .check-icon {
            width: 80px;
            height: 80px;
            margin: 20px 0;
        }

        .status-message {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
            margin: 20px 0;
            padding: 0 10px;
        }

        .home-button {
            display: inline-block;
            width: 100%;
            max-width: 300px;
            padding: 12px;
            background-color: #e35205;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            text-decoration: none;
            text-align: center;
            margin-top: 25px;
            transition: background-color 0.3s;
            cursor: pointer;
        }

        .home-button:hover {
            background-color: #c94704; /* Darker shade on hover */
        }

        /* Tablet (768px and up) */
        @media (min-width: 768px) {
            .container {
                max-width: 500px;
                padding: 30px;
            }

            .title {
                font-size: 20px;
                padding: 15px 0;
            }

            .status-title {
                font-size: 28px;
                margin: 25px 0;
            }

            .check-icon {
                width: 100px;
                height: 100px;
            }

            .status-message {
                font-size: 15px;
                margin: 25px 0;
            }

            .home-button {
                max-width: 350px;
                font-size: 18px;
                padding: 14px;
            }
        }

        /* Desktop (1024px and up) */
        @media (min-width: 1024px) {
            .container {
                max-width: 600px;
                padding: 40px;
            }

            .title {
                font-size: 22px;
                padding: 20px 0;
            }

            .status-title {
                font-size: 32px;
                margin: 30px 0;
            }

            .check-icon {
                width: 120px;
                height: 120px;
            }

            .status-message {
                font-size: 16px;
                margin: 30px 0;
            }

            .home-button {
                max-width: 400px;
                font-size: 20px;
                padding: 16px;
            }
        }

        /* Handle horizontal orientation and smaller screens */
        @media (max-width: 480px) and (orientation: landscape) {
            .container {
                max-width: 90%;
                padding: 15px;
            }

            .status-title {
                font-size: 20px;
                margin: 15px 0;
            }

            .check-icon {
                width: 60px;
                height: 60px;
            }

            .status-message {
                font-size: 12px;
                margin: 15px 0;
            }

            .home-button {
                font-size: 14px;
                padding: 10px;
                margin-top: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="title">Reservation</div>
        <div class="content">
            <h1 class="status-title">Booking completed</h1>
            <img src="../../images/success.png" alt="Checkmark" class="check-icon">
            <p class="status-message">
                After approval, QR code will be sent via email<br>
                Please check in within 15 minutes from the time reserved.<br>
            </p>
            <a href="../other.jsp" class="home-button">BACK TO HOME</a>
        </div>
    </div>
</body>
</html>