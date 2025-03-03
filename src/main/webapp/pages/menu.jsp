<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../theme/menu.css">
</head>
<body>
    <div class="menu-bar">
        <div class="menu-container">
            <a href="map.jsp" class="menu-item">
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
</body>
</html>