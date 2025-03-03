<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Page</title>
    <!-- Link to CSS files -->
    <link rel="stylesheet" href="../theme/menu.css">
</head>
<body>
    <!-- Page Content -->
    <div class="content">
        <h1>Welcome to BOOKING page</h1>
        <!-- Other page content -->
    </div>

    <!-- Include Menu -->
    <jsp:include page="menu.jsp">
        <jsp:param name="activePage" value="booking" />
    </jsp:include>
</body>
</html>