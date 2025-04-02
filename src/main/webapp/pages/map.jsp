<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="util.LanguageUtil" %>
<%@ page import="dao.LocationsDAO" %>
<%@ page import="model.LocationsModel" %>

<%
    // Get selected language (default to English)
    String lang = (String) session.getAttribute("lang");
    if (lang == null) lang = "en";

    // Get previously selected values from session (if any)
    String selectedStartId = (String) session.getAttribute("selectedStartId");
    String selectedEndId = (String) session.getAttribute("selectedEndId");

    // Load translations
    String startText = LanguageUtil.getMessage("start", lang);
    String endText = LanguageUtil.getMessage("end", lang);
    String swapText = LanguageUtil.getMessage("swap", lang);
    String findRouteText = LanguageUtil.getMessage("search", lang);
    
    // Define hardcoded translations for buttons without resource bundle entries
    String toggle3DText = lang.equals("th") ? "สลับแผนที่ 3D" : "Toggle 3D Map";

    // Get locations from database
    LocationsDAO locationsDAO = new LocationsDAO();
    List<LocationsModel> locationsList = new ArrayList<>();
    
    try {
        locationsList = locationsDAO.getAllPendingLocations();
    } catch (Exception e) {
        out.println("Error fetching locations: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Navigation</title>
    
    <!-- Link to CSS files -->
    <link rel="stylesheet" href="../theme/menu.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Roboto', sans-serif;
        }

        body {
            background-color: #f8f9fa;
            height: 100vh;
            overflow: hidden;
        }

        /* Header with logo and language toggle */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background: #E35205; /* Updated to a more professional orange */
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 30px;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .logo-container {
            display: flex;
            align-items: center;
        }

        .back-button {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            margin-right: 15px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .logo {
            color: white;
            font-size: 24px;
            font-weight: 500;
        }

        .language-toggle {
            display: flex;
            align-items: center;
        }

        .language-toggle a {
            color: white;
            text-decoration: none;
            padding: 8px 12px;
            border-radius: 4px;
            transition: background-color 0.3s;
            font-size: 16px;
        }

        .language-toggle a:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        /* Search controls container */
        .search-container {
            position: fixed;
            top: 100px;
            left: 0;
            width: 100%;
            background: white;
            padding: 20px 30px;
            z-index: 900;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .search-form {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            grid-template-rows: auto auto;
            gap: 15px;
            align-items: center;
        }

        .location-select {
            position: relative;
            grid-column: span 1;
        }

        .location-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #203864;
            font-size: 20px;
        }

        .start-icon {
            color: #4CAF50; /* Green for start */
        }

        .end-icon {
            color: #F44336; /* Red for destination */
        }

        select {
            width: 100%;
            padding: 15px 15px 15px 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f8f9fa;
            font-size: 16px;
            color: #333;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        select:focus {
            outline: none;
            border-color: #203864;
            box-shadow: 0 0 0 3px rgba(32, 56, 100, 0.1);
        }

        select option {
            color: #333;
        }

        .swap-button {
            width: 50px;
            height: 50px;
            border: none;
            background-color: #203864;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.3s;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .swap-button:hover {
            background-color: #152749;
            transform: scale(1.05);
        }

        .swap-button i {
            font-size: 20px;
        }

        .action-buttons {
            grid-column: 1 / -1;
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }

        .action-button {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: background-color 0.3s, transform 0.3s;
        }

        .find-route-btn {
            background-color: #203864;
            color: white;
        }

        .find-route-btn:hover {
            background-color: #152749;
            transform: translateY(-2px);
        }

        .toggle-3d-btn {
            background-color: #e0e0e0;
            color: #333;
        }

        .toggle-3d-btn:hover {
            background-color: #d0d0d0;
            transform: translateY(-2px);
        }

        /* Map container */
        #map {
            width: 100%;
            height: calc(100vh - 100px - 180px);
            margin-top: 280px;
            position: relative;
            z-index: 10;
        }

        /* Route results panel */
        #result {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 0;
            background: white;
            overflow: auto;
            z-index: 800;
            transition: height 0.3s ease-in-out;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            overflow-y: auto !important;
        }

        #result.active {
            height: 40% !important;
            overflow-y: auto !important;
        }

        .result-handle {
            width: 40px;
            height: 5px;
            background-color: #ddd;
            border-radius: 3px;
            margin: 10px auto;
        }

        .result-content {
            padding: 0 20px 20px;
        }

        /* .ldroute_placeholder {
            min-width: 200px;
            font: 16px / 1.2 Tahoma, sans-serif;
        } */

        .ldroute_placeholder {
            overflow: visible !important;
            padding-top: 10px !important; /* Add some space at the top */
        }

        /* Inside result inisde .ldroute_placeholder */
        /* Update this CSS rule in your style section */
        .ldroute_placeholder .ldroute_menu,
        #resultContent .ldroute_menu,
        .result-content .ldroute_menu {
            display: none !important;
        }

        .result-content .ldroute_placeholder {
            margin-top: 70px !important; /* Add space at the top of the route content */
            position: relative !important;
        }


        .ldroute_placeholder .ldroute_info,
        #resultContent .ldroute_info,
        .result-content .ldroute_info {
            height: auto !important; /* Allow height to adjust to content */
            min-height: 60px !important; /* Minimum height on all screens */
            font-size: calc(24px + 2vw) !important; /* Responsive font size */
            padding: 5px 10px !important;
            display: flex !important;
            align-items: center !important;
            justify-content: space-between !important;
            overflow: hidden !important;
            text-overflow: ellipsis !important;
            white-space: nowrap !important;
        }
        
        /* .ldroute_placeholder .ldroute_info,
        #resultContent .ldroute_info,
        .result-content .ldroute_info {
            height: 100px;
            font-size: 70px;
            padding: 5px 30px 5px 30px;

        } */

        /* Increase spacing and prevent overlap between route elements */
        .ldroute_placeholder .ldroute_dest {
            position: relative !important;
            z-index: 5 !important; /* Lower z-index than the info element */
            margin-top: 15px !important;
            padding: 10px 5px !important;
            clear: both !important; /* Force new line */
            overflow: visible !important; /* Ensure content doesn't get cut off */
        }

        /* Make the arrow images larger */
        .ldroute_placeholder .ldroute_item img.ldroute_icon {
            width: 24px !important; /* Increase from default size */
            height: 24px !important;
            margin-right: 10px !important; /* Add space after the icon */
        }

        /* Make the destination text larger */
        .ldroute_placeholder .ldroute_item,
        .ldroute_placeholder .ldroute_poi {
            font-size: 16px !important; /* Increase text size */
            line-height: 1.4 !important; /* Add more line height for readability */
        }

        /* Make distance text larger */
        .ldroute_placeholder .ldroute_dist {
            font-size: 18px !important; /* Increase from default size */
            margin-right: 8px !important; /* Add some space after the distance */
        }

        /* Dont display remove destination option when press the marker*/
        .ldmap_placeholder .ldmap_link{
            display:none
        }

        /* Make the overall route container taller if needed */
        #resultContent {
            padding-top: 20px !important; /* Add top padding */
            padding-bottom: 30px !important; /* Add bottom padding */
            position: relative !important;
        }


        /* Animation for loading */
        @keyframes pulse {
            0% { opacity: 0.6; }
            50% { opacity: 1; }
            100% { opacity: 0.6; }
        }

        .loading {
            animation: pulse 1.5s infinite;
        }

        /* Responsive adjustments for kiosk vertical screen */
        @media screen and (max-width: 1080px) {
            .header {
                height: 80px;
                padding: 0 20px;
            }

            .search-container {
                top: 80px;
                padding: 15px 20px;
            }

            select {
                padding: 12px 12px 12px 40px;
                font-size: 14px;
            }

            .action-button {
                padding: 12px;
                font-size: 14px;
            }
            
            .ldroute_placeholder .ldroute_info,
            #resultContent .ldroute_info,
            .result-content .ldroute_info {
                font-size: 70px !important; /* Even larger font for large screens */
                min-height: 90px !important;
            }

            #map {
                height: calc(100vh - 80px - 160px);
                margin-top: 240px;
            }
        }

        /* Modal for instructions */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: white;
            width: 80%;
            max-width: 500px;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .modal-title {
            font-size: 24px;
            font-weight: 500;
            color: #203864;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #666;
        }

        .modal-body {
            font-size: 16px;
            line-height: 1.6;
            color: #333;
        }

        .modal-footer {
            margin-top: 20px;
            text-align: right;
        }

        .modal-button {
            padding: 10px 20px;
            background-color: #203864;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .modal-button:hover {
            background-color: #152749;
        }
    </style>

    <!-- Map API -->
    <script type="text/javascript" src="https://api.longdo.com/map/?key=2dfb9de8a63c31f9088f4cee5b70e795"></script>
</head>
<body onload="initMap()">
    <!-- Header -->
    <header class="header">
        <div class="logo-container">
            <button class="back-button" onclick="window.location.href='home.jsp'">
                <i class="fas fa-arrow-left"></i>
            </button>
            <div class="logo">KMITL Navigator</div>
        </div>
        <div class="language-toggle">
            <a href="<%= request.getContextPath() %>/LanguageServlet?lang=en" class="lang-link">English</a> |
            <a href="<%= request.getContextPath() %>/LanguageServlet?lang=th" class="lang-link">ไทย</a>
        </div>
    </header>

    <!-- Search Controls -->
    <div class="search-container">
        <div class="search-form">
            <div class="location-select">
                <i class="fas fa-map-marker-alt location-icon start-icon"></i>
                <select id="startSelect" required>
                    <option value="" disabled selected><%= startText %></option>
                    <% for(LocationsModel location : locationsList) { 
                        String placeId = String.valueOf(location.getPlace_id());
                        boolean isSelected = placeId.equals(selectedStartId);
                    %>
                        <option value="<%= placeId %>" <%= isSelected ? "selected" : "" %>>
                            <%= "th".equals(lang) ? location.getPlace_thai() : location.getPlace_english() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <button onclick="swapSelectValues()" class="swap-button">
                <i class="fas fa-exchange-alt"></i>
            </button>

            <div class="location-select">
                <i class="fas fa-flag-checkered location-icon end-icon"></i>
                <select id="endSelect" required>
                    <option value="" disabled selected><%= endText %></option>
                    <% for(LocationsModel location : locationsList) { 
                        String placeId = String.valueOf(location.getPlace_id());
                        boolean isSelected = placeId.equals(selectedEndId);
                    %>
                        <option value="<%= placeId %>" <%= isSelected ? "selected" : "" %>>
                            <%= "th".equals(lang) ? location.getPlace_thai() : location.getPlace_english() %>
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="action-buttons">
                <button id="findRouteBtn" onclick="calculateRoute()" class="action-button find-route-btn">
                    <i class="fas fa-route"></i>
                    <%= findRouteText %>
                </button>
                <button id="toggle3DBtn" onclick="toggle3D()" class="action-button toggle-3d-btn">
                    <i class="fas fa-cube"></i>
                    <%= toggle3DText %>
                </button>
            </div>
        </div>
    </div>

    <!-- Map Container -->
    <div id="map"></div>

    <!-- Route Results Panel -->
    <div id="result">
        <div class="result-handle" id="resultHandle"></div>
        <div class="result-content" id="resultContent"></div>
    </div>

    <!-- Instructions Modal -->
    <div class="modal" id="instructionsModal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title"><%= lang.equals("th") ? "วิธีใช้" : "How to Use" %></div>
                <button class="modal-close" id="closeModal">&times;</button>
            </div>
            <div class="modal-body">
                <p><%= lang.equals("th") ? "1. เลือกจุดเริ่มต้นจากรายการ" : "1. Select your starting point from the dropdown" %></p>
                <p><%= lang.equals("th") ? "2. เลือกจุดหมายปลายทาง" : "2. Select your destination" %></p>
                <p><%= lang.equals("th") ? "3. กดปุ่ม 'ค้นหาเส้นทาง' เพื่อดูเส้นทางแนะนำ" : "3. Tap 'Find Route' to see the recommended path" %></p>
                <p><%= lang.equals("th") ? "4. ดูขั้นตอนการเดินทางด้านล่าง" : "4. View step-by-step directions at the bottom" %></p>
            </div>
            <div class="modal-footer">
                <button class="modal-button" id="startUsingBtn"><%= lang.equals("th") ? "เริ่มใช้งาน" : "Start Using" %></button>
            </div>
        </div>
    </div>

    <script>
        let map;
        let markers = [];
        let travelMode = 'Walk'; // Default travel mode
        let routeInfo = null; // Store route information
        let routed = false; // Store status if route has already been engaged

        function swapSelectValues(){
            // Get references to both select elements
            const startSelect = document.getElementById('startSelect');
            const endSelect = document.getElementById('endSelect');
            
            // Store the selected indexes
            const tempStartIndex = startSelect.selectedIndex;
            const tempEndIndex = endSelect.selectedIndex;
            
            // Swap the selected indexes
            startSelect.selectedIndex = tempEndIndex;
            endSelect.selectedIndex = tempStartIndex;

            // Save the current selections to session
            updateSessionWithSelections();

            if (routed) {
                calculateRoute(); // draw route
            } else {
                // Update markers and recalculate route
                showSelectedLocationMarker('start');
                showSelectedLocationMarker('end');
            }
        }

        function updateSessionWithSelections() {
            const startValue = document.getElementById('startSelect').value;
            const endValue = document.getElementById('endSelect').value;
            
            // Use fetch API to update the session without page reload
            fetch('<%= request.getContextPath() %>/SaveSelectionsServlet?selectedStartId=' + startValue + '&selectedEndId=' + endValue, {
                method: 'GET',
            });
        }

        function initMap() {
            let mapLanguage = '<%= lang %>';
            map = new longdo.Map({ 
                placeholder: document.getElementById("map"), 
                language: mapLanguage, 
                zoom: 17,
                ui: longdo.UiComponent.Mobile 
            });
            map.location({lon: 100.77848374843597, lat: 13.728225633281276}, true);
            map.zoomRange({min:16, max:20});
            
            // Set map language base layer
            if (mapLanguage === 'en') {
                map.Layers.setBase(longdo.Layers.GRAY_EN);
            } else if (mapLanguage === 'th') {
                map.Layers.setBase(longdo.Layers.GRAY);  // Default Thai layer
            }
            
            // Hide unnecessary UI components
            map.Ui.DPad.visible(false);
            map.Ui.Geolocation.visible(false);
            map.Ui.Toolbar.visible(false);
            map.Ui.Fullscreen.visible(false);
            map.Ui.Crosshair.visible(false);
            map.Ui.LayerSelector.visible(false);
            
            // Add event listeners to dropdown selects to save selections when changed
            document.getElementById('startSelect').addEventListener('change', function() {
                updateSessionWithSelections();
                showSelectedLocationMarker('start');
                routed = false;
            });
            
            document.getElementById('endSelect').addEventListener('change', function() {
                updateSessionWithSelections();
                showSelectedLocationMarker('end');
                routed = false;
            });
            
            // Add event listeners to language links
            document.querySelectorAll('.lang-link').forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    // Create the URL with the selections
                    let url = this.href;
                    const startValue = document.getElementById('startSelect').value;
                    const endValue = document.getElementById('endSelect').value;
                    
                    // Append selection parameters to the language servlet URL
                    url += '&selectedStartId=' + startValue + '&selectedEndId=' + endValue;
                    
                    // Navigate to the updated URL
                    window.location.href = url;
                });
            });

            // Check if locations are already selected (from session)
            const startSelect = document.getElementById('startSelect');
            const endSelect = document.getElementById('endSelect');
            
            if (startSelect.value) {
                showSelectedLocationMarker('start');
            }
            
            if (endSelect.value) {
                showSelectedLocationMarker('end');
            }

            // Set up result panel drag functionality
            setupResultPanel();
            
            // Show instructions modal on first visit
            if (!localStorage.getItem('instructionsShown')) {
                showInstructionsModal();
                localStorage.setItem('instructionsShown', 'true');
            }
        }

        function setupResultPanel() {
            const resultPanel = document.getElementById('result');
            const resultHandle = document.getElementById('resultHandle');
            
            resultHandle.addEventListener('click', function() {
                resultPanel.classList.toggle('active');
            });
            
            // Setup placeholder for route results
            map.Route.placeholder(document.getElementById('resultContent'));
        }

        function showInstructionsModal() {
            const modal = document.getElementById('instructionsModal');
            const closeBtn = document.getElementById('closeModal');
            const startBtn = document.getElementById('startUsingBtn');
            
            modal.style.display = 'flex';
            
            closeBtn.addEventListener('click', function() {
                modal.style.display = 'none';
            });
            
            startBtn.addEventListener('click', function() {
                modal.style.display = 'none';
            });
            
            // Close modal if clicking outside of it
            window.addEventListener('click', function(event) {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        }

        // Show marker for selected location
        function showSelectedLocationMarker(type) {
            const selectId = type === 'start' ? 'startSelect' : 'endSelect';
            const selectElement = document.getElementById(selectId);
            
            if (!selectElement.value) return;

            // ensure makers array is initialized
            if (!markers) markers = [];
            
            // Remove existing marker if present
            const markerIndex = type === 'start' ? 0 : 1;
            if (markers[markerIndex]) {
                map.Overlays.remove(markers[markerIndex]);
                markers[markerIndex] = null;
            }
            
            // Fetch location data
            fetch('<%= request.getContextPath() %>/LocationsServlet?id=' + selectElement.value)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(location => {
                    // Verify we have valid coordinates
                    if (!location || !location.place_lat || !location.place_long) {
                        console.error("Invalid location data received:", location);
                        return;
                    }
                    
                    // Create custom marker based on type
                    let markerOptions = {
                        title: '<%= lang %>' === 'th' ? location.place_thai : location.place_english,
                        detail: type === 'start' ? '<%= startText %>' : '<%= endText %>',
                        weight: longdo.OverlayWeight.Top,
                    };
                    
                    // Add custom icon based on type
                    // if (type === 'start') {
                    //     markerOptions.icon = {
                    //         url: '../images/icon/start_marker.png',
                    //         offset: { x: 12, y: 45 }
                    //     };
                    // } else {
                    //     markerOptions.icon = {
                    //         url: '../images/icon/end_marker.png',
                    //         offset: { x: 12, y: 45 }
                    //     };
                    // }
                    
                    // Create new marker
                    let marker = new longdo.Marker(
                        { lat: location.place_lat, lon: location.place_long },
                        markerOptions
                    );
                    
                    // Store marker in appropriate position
                    markers[markerIndex] = marker;
                    
                    // Add marker to map
                    map.Overlays.add(marker);
                    
                    // Center map on this marker
                    map.location({ lat: location.place_lat, lon: location.place_long }, true);
                    
                    console.log(`Marker added for ${type} location:`, location);
                })
                .catch(error => console.error("Error getting location data:", error));
        }

        // Calculate and display route
        function calculateRoute() {
            // Get the start and end select elements
            const startSelect = document.getElementById('startSelect');
            const endSelect = document.getElementById('endSelect');
            const resultPanel = document.getElementById('result');
            
            if (!startSelect.value || !endSelect.value) {
                showNotification("Please select start and end locations");
                return;
            } else if (startSelect.value === endSelect.value) {
                showNotification("Please select different start and end locations");
                return;
            } else {
                // Show loading states
                document.getElementById('findRouteBtn').innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
                document.getElementById('findRouteBtn').disabled = true;
                
                // Fetch location coordinates based on IDs
                fetch('<%= request.getContextPath() %>/GetLocationCoordinatesServlet?startId=' + startSelect.value + '&endId=' + endSelect.value)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok.\nCheck network connection to DB.');
                    }
                    return response.json();
                })
                .then(data => {
                    // Validate the coordinates
                    if (!data.startLat || !data.startLon || !data.endLat || !data.endLon) {
                        throw new Error('Invalid coordinates received from server');
                    }
                    
                    // Clear previous route and overlays
                    map.Overlays.clear();
                    map.Route.clear();

                    // Define start and end points
                    const startPoint = { lon: data.startLon, lat: data.startLat };
                    const endPoint = { lon: data.endLon, lat: data.endLat };

                    // Add points to the route
                    map.Route.add(startPoint);
                    map.Route.add(endPoint);
                    
                    // Display Steps and Route and Route Mode
                    map.Route.search();
                    map.Route.mode(longdo.RouteMode.Walk);
                    
                    // Show route results panel
                    resultPanel.classList.add('active');
                    
                    // Reset the button
                    document.getElementById('findRouteBtn').innerHTML = '<i class="fas fa-route"></i> <%= findRouteText %>';
                    document.getElementById('findRouteBtn').disabled = false;
                    
                    // Add markers again after clearing overlays
                    // showSelectedLocationMarker('start');
                    // showSelectedLocationMarker('end');
                    routed = true;

                })
                .catch(error => {
                    console.error("Error getting coordinates or calculating route:", error);
                    showNotification("Error calculating route. Please try again.");
                    
                    // Reset the button
                    document.getElementById('findRouteBtn').innerHTML = '<i class="fas fa-route"></i> <%= findRouteText %>';
                    document.getElementById('findRouteBtn').disabled = false;
                });
            }
        }

        function showNotification(message) {
            // Create notification element
            const notification = document.createElement('div');
            notification.textContent = message;
            notification.style.position = 'fixed';
            notification.style.top = '120px';
            notification.style.left = '50%';
            notification.style.transform = 'translateX(-50%)';
            notification.style.backgroundColor = '#333';
            notification.style.color = 'white';
            notification.style.padding = '10px 20px';
            notification.style.borderRadius = '5px';
            notification.style.zIndex = '2000';
            
            // Add to body
            document.body.appendChild(notification);
            
            // Remove after 3 seconds
            setTimeout(() => {
                notification.style.opacity = '0';
                notification.style.transition = 'opacity 0.5s';
                setTimeout(() => {
                    document.body.removeChild(notification);
                }, 500);
            }, 3000);
        }

        function toggle3D() {
            window.location.href = "3dmodel.jsp";
        }

        // Redirect to welcome page after inactivity
        let inactivityTimer;
        
        function resetInactivityTimer() {
            clearTimeout(inactivityTimer);
            inactivityTimer = setTimeout(redirectToWelcomePage, 180000); // 3 minutes
        }
        
        function redirectToWelcomePage() {
            window.location.href = 'welcome.jsp';
        }
        
        // Reset timer on user interaction
        ['click', 'touchstart', 'mousemove'].forEach(event => {
            document.addEventListener(event, resetInactivityTimer);
        });
        
        // Start the timer when page loads
        resetInactivityTimer();
    </script>
    <%@ include file="kiosk_activity.jsp" %>
    <%@ include file="voice_control.jsp" %>
</body>
</html>