<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="util.LanguageUtil" %>  <!-- Import the utility class Language Switcher-->
<%@ page import="util.ExcelReader" %> <!-- Import the utility class - Excel Reader-->
<%@ page import="dao.LocationsDAO" %> <!-- Import the LocationsDAO -->
<%@ page import="model.LocationsModel" %> <!-- Import the LocationsModel -->

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
    
    // Define hardcoded translations for buttons without resource bundle entries
    String findRouteText = lang.equals("th") ? "ค้นหาเส้นทาง" : "Find Route";
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
    <title>Navigation</title>
    
    <!-- Link to CSS files -->
    <link rel="stylesheet" href="../theme/menu.css">    <!-- Call menu bar -->
    
    <style type="text/css">

        /* 🏹 Back Arrow - Always Visible & Scaling */
        .back-arrow-container {
            position: fixed;  /* Keep it fixed */
            top: 15px;   /* Near the top */
            left: 15px;  /* Near the left */
            z-index: 1500;  /* Keep it above all elements */
        }

        .back-arrow {
            width: max(2vw, 25px);   /* At least 25px but scales */
            height: max(2vw, 25px);
            cursor: pointer; /* Make it clickable */
        }

        /* 📱 Adjust for small screens */
        @media screen and (max-width: 768px) {
            .back-arrow {
                width: max(4vw, 30px);  
                height: max(4vw, 30px);
            }
            .language-toggle {
                right: 10px; /* Less padding on small screens */
            }
            .language-toggle a {
                font-size: max(1.2vw, 10px);
                padding: 3px 5px;
            }
            .center {
                gap: 0.2vw; /* Tighter gap on small screens */
            }
            .swap-button {
                margin: 0 2px;
            }
        }

        /* 🌍 Language Toggle (Right-Aligned) */
        .language-toggle {
            position: absolute;
            right: 70px;
            top: 50%;
            transform: translateY(-50%);
            display: flex;
            align-items: right;
            white-space: nowrap;
        }

        .language-toggle a {
            background: none; /* Transparent */
            border: none;
            font-size: max(1.2vw, 14px);
            color: white; /* Change color to contrast with orange */
            cursor: pointer;
            padding: 5px 10px;
            text-decoration: none;
        }

        /* Hover effect */
        .language-toggle a:hover {
            font-weight: bold;
            color: #f0f0f0;
        }

        /* 🔶 Orange Background for Controls */
        .controls {
            position: fixed;  /* Keep at the top */
            top: 0;
            left: 0;
            width: 100%;  /* Full width */
            height: 10vh;  /* Height based on viewport */
            background: #E35205;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0vh 2vw;  /* Adjust padding */
            z-index: 1000;
        }

        /* 🎯 Center dropdowns & buttons */
        .center {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1vw;
            flex-wrap: wrap; /* Allow wrapping */
        }

        /* 🌐 Right-aligned elements (Language Toggle) */
        .right {
            display: flex;
            align-items: center;
            gap: 1vw;
        }

        .swap-button {
            margin: 0 5px; /* Add some horizontal margin */
            background: none;
            border: none;
        }

        /* 🎛️ Dropdowns & Buttons */
        select, button:not(.icon-button) {
            flex: 8;
            max-width: 15vw;  
            min-width: 80px;  
            padding: 1.5vh 1.5vw;
            font-size: 1.3vw;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        select {
            color: #888; /* Light gray text for placeholder */
        }

        select option:first-child {
            color: #888; /* Placeholder color */
        }

        select option:not(:first-child) {
            color: black; /* Actual options color */
        }

        button {
            background: white;
            color: black;
        }

        /* Button Hover Effect */
        button:hover {
            background: #f0f0f0;
        }

        /* Labels for dropdowns */
        label {
            color: white;
            font-size: 1.3vw;
            margin-right: 5px;
        }

        .icon-button {
            background: transparent;
            border: none;
            padding: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
           /* border-radius: 5px; */ 
        }

        .button-icon {
            width: 24px;  /* Adjust size as needed */
            height: 24px; /* Adjust size as needed */
            object-fit: contain;
        }

        .icon-button:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        #map { 
            width: 100%; 
            height: calc(100vh - 10vh); /* Ensure it fills the remaining screen */
            margin-top: 10vh; /* Push it down to avoid overlap */
        }
        /* route result */
        #result {
            position: absolute;
            top: 10;
            bottom: 0;
            right: 0;
            width: 1px;
            height: 80%;
            margin: auto;
            border: 3px solid #dddddd;
            background: #ffffff;
            overflow: auto;
            z-index: 2;
        }
    </style>

    <!-- Map API -->
    <script type="text/javascript" src="https://api.longdo.com/map/?key=2dfb9de8a63c31f9088f4cee5b70e795"></script>
</head>
<body onload="initMap()">
    <div class="back-arrow-container">
        <img src="../images/back_arrow.png" alt="Back" class="back-arrow" onclick="home.jsp">
    </div>
    
    <!-- Controls (Language, Location selection) -->
    <div class="controls">        
        <!-- Centered Controls -->
        <div class="center">
            <label for="startSelect"><%= startText %>:</label>
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

            <button onclick="swapSelectValues()" class="icon-button swap-button">
                <img src="../images/icon/reverse_arrow2.png" alt="<%= swapText %>" class="button-icon">
            </button>

            <label for="endSelect"><%= endText %>:</label>
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

            <button id="findRouteBtn" onclick="calculateRoute()" class="icon-button">
                <img src="../images/icon/search_icon.png" alt="<%= findRouteText %>" class="button-icon">
            </button>
            <button id="toggle3DBtn" onclick="toggle3D()" class="icon-button">
                <img src="../images/icon/3d_icon.png" alt="<%= toggle3DText %>" class="button-icon">
            </button>
        </div>

        <!-- Right-Aligned Language Switcher -->
        <div class="language-toggle">
            <a href="<%= request.getContextPath() %>/LanguageServlet?lang=en" class="lang-link">English</a> |
            <a href="<%= request.getContextPath() %>/LanguageServlet?lang=th" class="lang-link">ไทย</a>
        </div>
    </div>

    <!-- Map Container -->
    <div id="map"></div>
    <div id="result"></div>

    <script>
        let map;
        let markers = [];
        let travelMode = 'Walk'; // Default travel mode
        let routeInfo = null; // Store route information

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

            // Update markers and recalculate route
            showSelectedLocationMarker('start');
            showSelectedLocationMarker('end');

            // Save the current selections to session
            updateSessionWithSelections();

            calculateRoute();
        }

        function saveSelections() {
            const startSelect = document.getElementById('startSelect');
            const endSelect = document.getElementById('endSelect');
            
            // Create a form to post the data
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '<%= request.getContextPath() %>/SaveSelectionsServlet';
            
            // Add hidden inputs for the selected values
            const startInput = document.createElement('input');
            startInput.type = 'hidden';
            startInput.name = 'selectedStartId';
            startInput.value = startSelect.value;
            form.appendChild(startInput);
            
            const endInput = document.createElement('input');
            endInput.type = 'hidden';
            endInput.name = 'selectedEndId';
            endInput.value = endSelect.value;
            form.appendChild(endInput);
            
            // Submit the form
            document.body.appendChild(form);
            form.submit();
        }

        // Function to update session with selections without page reload
        function updateSessionWithSelections() {
            const startValue = document.getElementById('startSelect').value;
            const endValue = document.getElementById('endSelect').value;
            
            // Use fetch API to update the session without page reload
            fetch('<%= request.getContextPath() %>/SaveSelectionsServlet?selectedStartId=' + startValue + '&selectedEndId=' + endValue, {
                method: 'GET',
            });
        }

        function initMap() {
            let mapLanguage = '<%= lang %>'
            map = new longdo.Map({ placeholder: document.getElementById("map"), language: 'en', zoom: 17 });
            map.location({lon: 100.77848374843597, lat: 13.728225633281276}, true);
            map.zoomRange({min:16, max:20});
            userInterfaceToggle(0); // Horizontal mode

            // Set map language base layer
            if (mapLanguage === 'en') {
                map.Layers.setBase(longdo.Layers.GRAY_EN);
            } else if (mapLanguage === 'th') {
                map.Layers.setBase(longdo.Layers.GRAY);  // Default Thai layer
            }
                
            // Add event listeners to dropdown selects to save selections when changed
            document.getElementById('startSelect').addEventListener('change', function() {
                updateSessionWithSelections();
                showSelectedLocationMarker('start');
            });
            document.getElementById('endSelect').addEventListener('change', function() {
                updateSessionWithSelections();
                showSelectedLocationMarker('end');
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

            // Create travel mode toggle
            createTravelModeToggle();

            // Check if locations are already selected (from session)
            const startSelect = document.getElementById('startSelect');
            const endSelect = document.getElementById('endSelect');
            
            if (startSelect.value) {
                showSelectedLocationMarker('start');
            }
            
            if (endSelect.value) {
                showSelectedLocationMarker('end');
            }

            // map.Route.placeholder(document.getElementById('result'));
            // map.Route.search();
        }

        // 2. Show marker for selected location
        function showSelectedLocationMarker(type) {
            const selectId = type === 'start' ? 'startSelect' : 'endSelect';
            const selectElement = document.getElementById(selectId);
            
            if (!selectElement.value) return;
            
            // Remove existing marker if present
            if (markers.length > 0) {
                if (type === 'start' && markers[0]) {
                    map.Overlays.remove(markers[0]);
                    markers[0] = null;
                } else if (type === 'end' && markers[1]) {
                    map.Overlays.remove(markers[1]);
                    markers[1] = null;
                }
            }
            
            // Fetch location data
            fetch('<%= request.getContextPath() %>/LocationsServlet?id=' + selectElement.value)
                .then(response => response.json())
                .then(location => {
                    // Create new marker
                    // let markerColor = type === 'start' ? 'green' : 'red';
                    // let iconUrl = '../images/icon/' + (type === 'start' ? 'start_marker.png' : 'end_marker.png');
                    let marker = new longdo.Marker(
                        { lat: location.place_lat, lon: location.place_long },
                        { 
                            title: '<%= lang %>' === 'th' ? location.place_thai : location.place_english,
                            detail: type === 'start' ? '<%= startText %>' : '<%= endText %>',
                            weight: longdo.OverlayWeight.Top,
                            // lineColor: markerColor
                        }
                    );
                    
                    // Store marker in appropriate position
                    if (type === 'start') {
                        markers[0] = marker;
                    } else {
                        markers[1] = marker;
                    }

                    map.Overlays.add(marker);
                    
                    // Center map on this marker
                    map.location({ lat: location.place_lat, lon: location.place_long }, true);
                    
                    // Check if we can draw a route
                    if (markers[0] && markers[1]) {
                        // calculateRoute();
                        console.log("Route can be drawn");
                    }
                })
                .catch(error => conFole.error("Error getting location data:", error));
        }

        // 3. Calculate and display route
        function calculateRoute() {
            // Get the start and end select elements
            const startSelect = document.getElementById('startSelect');
            const endSelect = document.getElementById('endSelect');
            if (!startSelect.value || !endSelect.value) {
                alert("Please select start and end locations");
                console.error("Start or End location not selected.");
                return;
            } else if (startSelect.value === "" || endSelect.value === "") {
                alert("Please select start and end locations");
                return;
            } else if (startSelect.value === endSelect.value) {
                alert("Please select different start and end locations");
                return;
            } else {
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
                    map.Overlays.clear()
                    map.Route.clear();

                    // Define start and end points
                    const startPoint = { lon: data.startLon, lat: data.startLat };
                    const endPoint = { lon: data.endLon, lat: data.endLat };

                    // Add points to the route
                    map.Route.add(startPoint);
                    map.Route.add(endPoint);
                    
                    // Display Steps and Route and Route Mode
                    map.Route.placeholder(document.getElementById('result'));
                    map.Route.search();
                    map.Route.mode(longdo.RouteMode.Walk);
                    
                })
                .catch(error => {
                    console.error("Error getting coordinates or calculating route:", error);
                });
            }
        }

        function userInterfaceToggle(mode){
            if (mode != 0) {
                map = new longdo.Map({
                placeholder: document.getElementById('map'),
                ui: longdo.UiComponent.Mobile
                });
                map.Ui.Geolocation.visible(false);
                map.Ui.Fullscreen.visible(false);
                map.Ui.Crosshair.visible(false);
            } else {
                map.Ui.DPad.visible(false);
                map.Ui.Geolocation.visible(false);
                map.Ui.Toolbar.visible(false);
                map.Ui.Fullscreen.visible(false);
                map.Ui.Crosshair.visible(false);
                map.Ui.LayerSelector.visible(true);
                longdo.LayerSelector(null, null, button)
            }
        }

        // 5. Create travel mode toggle and route info overlay
        function createTravelModeToggle() {
            // Create container
            const infoOverlay = document.createElement('div');
            infoOverlay.id = 'routeInfoOverlay';
            infoOverlay.style.position = 'absolute';
            infoOverlay.style.top = '15vh';
            infoOverlay.style.left = '70px';
            infoOverlay.style.backgroundColor = 'white';
            infoOverlay.style.padding = '10px';
            infoOverlay.style.borderRadius = '5px';
            infoOverlay.style.boxShadow = '0 2px 5px rgba(0,0,0,0.2)';
            infoOverlay.style.zIndex = '1000';
            infoOverlay.style.maxWidth = '250px';
            
            // Travel mode toggle
            const modeToggle = document.createElement('div');
            modeToggle.classList.add('mode-toggle');
            modeToggle.style.display = 'flex';
            modeToggle.style.marginBottom = '10px';
            modeToggle.style.borderRadius = '4px';
            modeToggle.style.overflow = 'hidden';
            modeToggle.style.border = '1px solid #ccc';
            
            const walkBtn = document.createElement('button');
            walkBtn.innerText = '<%= lang %>' === 'th' ? 'เดิน' : 'Walk';
            walkBtn.style.flex = '1';
            walkBtn.style.padding = '8px';
            walkBtn.style.border = 'none';
            walkBtn.style.cursor = 'pointer';
            walkBtn.style.backgroundColor = travelMode === 'Walk' ? '#E35205' : '#f1f1f1';
            walkBtn.style.color = travelMode === 'Walk' ? 'white' : 'black';
            
            const motorBtn = document.createElement('button');
            motorBtn.innerText = '<%= lang %>' === 'th' ? 'รถจักรยานยนต์' : 'Motorcycle';
            motorBtn.style.flex = '1';
            motorBtn.style.padding = '8px';
            motorBtn.style.border = 'none';
            motorBtn.style.cursor = 'pointer';
            motorBtn.style.backgroundColor = travelMode === 'Distance' ? '#E35205' : '#f1f1f1';
            motorBtn.style.color = travelMode === 'Distance' ? 'white' : 'black';
            
            walkBtn.addEventListener('click', function() {
                travelMode = 'Walk';
                walkBtn.style.backgroundColor = '#E35205';
                walkBtn.style.color = 'white';
                motorBtn.style.backgroundColor = '#f1f1f1';
                motorBtn.style.color = 'black';
                calculateRoute();
            });
            
            motorBtn.addEventListener('click', function() {
                travelMode = 'Distance';
                motorBtn.style.backgroundColor = '#E35205';
                motorBtn.style.color = 'white';
                walkBtn.style.backgroundColor = '#f1f1f1';
                walkBtn.style.color = 'black';
                calculateRoute();
            });
            
            modeToggle.appendChild(walkBtn);
            modeToggle.appendChild(motorBtn);
            
            // Route info display
            const routeTimeDiv = document.createElement('div');
            routeTimeDiv.id = 'routeTime';
            routeTimeDiv.style.marginBottom = '5px';
            routeTimeDiv.innerHTML = '<i>Select locations to see travel time</i>';
            
            const routeDistanceDiv = document.createElement('div');
            routeDistanceDiv.id = 'routeDistance';
            routeDistanceDiv.style.marginBottom = '5px';
            routeDistanceDiv.innerHTML = '<i>Select locations to see distance</i>';
            
            // Assemble overlay
            infoOverlay.appendChild(modeToggle);
            infoOverlay.appendChild(routeTimeDiv);
            infoOverlay.appendChild(routeDistanceDiv);
            
            // Add to document
            document.body.appendChild(infoOverlay);
        }

        // Update route info display
        function updateRouteInfoDisplay() {
            const timeDiv = document.getElementById('routeTime');
            const distanceDiv = document.getElementById('routeDistance');
            
            if (routeInfo && timeDiv && distanceDiv) {
                // Format time (comes in seconds)
                const totalSeconds = routeInfo.searchTime;
                const hours = Math.floor(totalSeconds / 3600);
                const minutes = Math.floor((totalSeconds % 3600) / 60);
                const seconds = Math.floor(totalSeconds % 60);
                
                let timeText = '';
                if (hours > 0) {
                    timeText += hours + ' ' + ('<%= lang %>' === 'th' ? 'ชั่วโมง ' : 'hr ');
                }
                if (minutes > 0 || hours > 0) {
                    timeText += minutes + ' ' + ('<%= lang %>' === 'th' ? 'นาที ' : 'min ');
                }
                timeText += seconds + ' ' + ('<%= lang %>' === 'th' ? 'วินาที' : 'sec');
                
                // Format distance (comes in meters)
                const distance = routeInfo.distance;
                let distanceText = '';
                if (distance >= 1000) {
                    distanceText = (distance / 1000).toFixed(2) + ' ' + ('<%= lang %>' === 'th' ? 'กม.' : 'km');
                } else {
                    distanceText = Math.round(distance) + ' ' + ('<%= lang %>' === 'th' ? 'เมตร' : 'm');
                }
                
                // Update display
                timeDiv.innerHTML = '<strong>' + ('<%= lang %>' === 'th' ? 'เวลา: ' : 'Time: ') + '</strong>' + timeText;
                distanceDiv.innerHTML = '<strong>' + ('<%= lang %>' === 'th' ? 'ระยะทาง: ' : 'Distance: ') + '</strong>' + distanceText;
            } else {
                // Reset if no route
                if (timeDiv) timeDiv.innerHTML = '<i>Select locations to see travel time</i>';
                if (distanceDiv) distanceDiv.innerHTML = '<i>Select locations to see distance</i>';
            }
        }

        function toggle3D() {
            window.location.href = "3dmodel.jsp";
        }

        // window.onload = initMap;
    </script>
</body>
</html>