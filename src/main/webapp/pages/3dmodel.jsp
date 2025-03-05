<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <title>Engineering 3D Map</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/helpers/GridHelper.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/GLTFLoader.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/controls/OrbitControls.js"></script>
    
    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
            background-color: rgb(52, 52, 52);
            touch-action: none;
            overscroll-behavior: none;
            font-family: Arial, sans-serif;
        }
        #canvas-container {
            width: 100%;
            height: calc(100% - 60px);
            position: absolute;
            top: 60px;
            background-color: rgb(52, 52, 52);
        }
        #header {
            margin-top: 70px;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 60px;
            /* background-color: rgb(52, 52, 52); */
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        #page-title {
            color: white;
            font-size: 40px;
            font-weight: bold;
            text-align: center;
        }
        #hamburger-menu {
            margin-top: 25px;
            margin-right: 15px;
            position: fixed;
            top: 10px;
            right: 10px;
            width: 40px;
            height: 30px;
            cursor: pointer;
            z-index: 1100;
        }
        #hamburger-menu div {
            width: 100%;
            height: 4px;
            background-color: white;
            margin: 6px 0;
            transition: 0.4s;
        }
        #side-menu {
            position: fixed;
            top: 0;
            right: -300px;
            width: 300px;
            height: 100%;
            background-color: rgb(40, 40, 40);
            transition: 0.3s;
            z-index: 1050;
            padding-top: 60px;
        }
        #side-menu.open {
            right: 0;
        }
        #side-menu-content {
            padding: 20px;
        }
        #side-menu-content button {
            width: 100%;
            padding: 15px;
            margin: 10px 0;
            background-color: rgb(70, 70, 70);
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        #building-popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(255,255,255,0.9);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            z-index: 1100;
            width: 80%;
            max-width: 400px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div id="hamburger-menu" onclick="toggleSideMenu()">
        <div></div>
        <div></div>
        <div></div>
    </div>

    <div id="side-menu">
        <div id="side-menu-content">
            <button onclick="goToHomePage()">Home Page</button>
            <!-- Add more menu items as needed -->
        </div>
    </div>

    <div id="header">
        <div id="page-title">Engineering 3D Map</div>
    </div>

    <div id="canvas-container"></div>
    <div id="building-popup">
        <h2 id="popup-title">Building Name</h2>
        <p id="popup-description">Building Description</p>
        <button onclick="closePopup()">Close</button>
    </div>

    <script>
        // Building details mapping
        const buildingDetails = {
            'HM_building': { 
                name: 'HM Building', 
                description: 'HM Building at KMITL is the administrative center, housing various offices and departments. It is named in honor of His Majesty the King.'
            },
            'Gym': { 
                name: 'Engineering Gym', 
                description: 'A multi-purpose sports facility offering basketball and volleyball courts, providing a space for physical activities and recreational sports for engineering students and staff.'
            },
            'Construction_ENG': { 
                name: 'Engineering Construction Building', 
                description: 'A hub for civil and construction engineering, featuring labs, workshops, and classrooms for hands-on learning'
            },
            'Mechanical_Building': { 
                name: 'Mechanical Engineering Building', 
                description: 'Home to mechanical engineering labs and classrooms, supporting practical learning and research in mechanics and design.'
            },
            'IMSEENG&_Auditorium_ENG': { 
                name: 'IMSE Engineering & Auditorium', 
                description: 'A facility for industrial management and systems engineering, featuring classrooms and an auditorium for lectures and events.'
            },
            'Clubs_Building': { 
                name: 'Student Clubs Building', 
                description: 'A space for student organizations, offering meeting rooms and activity areas for clubs and extracurricular activities.'
            },
            'CafeteriaA': { 
                name: 'Cafeteria A', 
                description: 'A popular dining spot near HM Building, offering a variety of meals and snacks for students, faculty, and staff.'
            },
            'Architecture_building': {
                name: 'Architecture Building', 
                description: 'A facility for architecture students, featuring design studios, classrooms, and labs for creative and technical learning in architecture.'
            },
            'Sa-mo-sorn': {
                name: 'KMITL Engineering Student Association',
                description: 'A hub for engineering student activities, organizing events, academic support, and community engagement.'
            },
            'Argri&_AEFood&_CHEMENG-_concrete,_geo_lab': {
                name: 'Agri & AE Food & Chem Eng Building',
                description: 'Hosts labs and facilities for agricultural, food, chemical, and environmental engineering, including concrete and geotechnical labs.'
            },
            'E12_Building001_Small': {
                name: 'E-12 Building',
                description: 'A multi-story engineering facility with classrooms, labs, and offices, supporting education and research across various engineering fields.'
            },
            'E12_Building_BIG': {
                name: 'E-12 Building',
                description: 'A multi-story engineering facility with classrooms, labs, and offices, supporting education and research across various engineering fields.'
            }, 
            'e12-park': {
                name: 'E-12 Parking Lot',
                description: 'A designated parking area near E-12 Building for students, faculty, and staff.'
            },
            'archetechture-park': {
                name: 'Architecture Parking Lot',
                description: 'A parking area near the Architecture Building, serving students, faculty, and teachers.'
            },
            'Plane008': {
                name: 'Telecommunications Engineering Department',
                description: 'Focused on communication technology, offering labs and classrooms for wireless networks, signal processing, and telecom research.'
            },
            'Plane002': {
                name: 'Dean’s Building (Building A)',
                description: 'Administrative center of the Faculty of Engineering, housing the dean’s office and faculty offices.'
            },
            'Plane010': {
                name: 'KMITL VB',
                description: 'A volleyball club for students and staff, providing a space for training, practice, and recreational games.'
            },
            'Plane007': {
                name: 'Building B',
                description: 'Hub for Electronics and Biomedical Engineering, featuring labs and classrooms for cutting-edge tech and healthcare solutions.'
            },
            'Plane016': {
                name: 'Cafeteria B',
                description: 'A dining spot near B Building, offering a variety of meals and snacks for students, teachers, and staff'
            },
            'Plane015': {
                name: 'Industrial Engineering Building',
                description: 'Dedicated to industrial engineering studies, featuring labs, classrooms, and research facilities for process optimization and systems engineering.'
            },
            'Plane017': {
                name : 'Argriculture Reserach',
                description: 'A center for agricultural studies, featuring labs and facilities for research in farming, food science, and sustainable agriculture.'
            },
            'Plane013': {
                name: 'Mechanics Lab',
                description: 'A hands-on workspace for mechanical engineering students, equipped with tools and machinery for experiments and projects.'
            },
            'Plane005': {
                name: 'Cafeteria C',
                description: 'A dining area near E-12 Building, offering a variety of meals and refreshments for students and staff.'
            }

        };

        function toggleSideMenu() {
            const sideMenu = document.getElementById('side-menu');
            sideMenu.classList.toggle('open');
        }

        function goToHomePage() {
            window.location.href = '<%= request.getContextPath() %>/pages/home.jsp';
        }

        let scene, camera, renderer, controls, raycaster, mouse, model;
        let touchStart = new THREE.Vector2();
        let touchMove = new THREE.Vector2();
        let isMultiTouch = false;

        function init() {
            scene = new THREE.Scene();

             // Camera positioned between left and front, at an angle
            camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 2000);
            camera.position.set(-100, 100, 200);  // Adjusted to get the desired angle
            camera.lookAt(0, 0, 0);

            renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.shadowMap.enabled = true;
            renderer.shadowMap.type = THREE.PCFSoftShadowMap;
            document.getElementById('canvas-container').appendChild(renderer.domElement);

            // Comprehensive Lighting Setup
            const ambientLight = new THREE.AmbientLight(0xffffff, 0.8);
            scene.add(ambientLight);

            const directionalLight1 = new THREE.DirectionalLight(0xffffff, 1);
            directionalLight1.position.set(50, 100, 50);
            directionalLight1.castShadow = true;
            scene.add(directionalLight1);

            const directionalLight2 = new THREE.DirectionalLight(0xffffff, 0.5);
            directionalLight2.position.set(-50, -100, -50);
            scene.add(directionalLight2);

            // Controls
            controls = new THREE.OrbitControls(camera, renderer.domElement);
            controls.enableDamping = true;
            controls.dampingFactor = 0.25;
            controls.screenSpacePanning = false;
            controls.maxPolarAngle = Math.PI / 2;
            controls.minDistance = 50;   // Prevents zooming too far out
            controls.maxDistance = 300;  // Allows some zoom flexibility

            // Raycaster for click interactions
            raycaster = new THREE.Raycaster();
            mouse = new THREE.Vector2();

            const loader = new THREE.GLTFLoader();
            loader.load('<%= request.getContextPath() %>/3dModel/map_3d.glb', (gltf) => {
                model = gltf.scene;

                // Automatic scaling to fill most of the view
                const box = new THREE.Box3().setFromObject(model);
                const size = box.getSize(new THREE.Vector3());
                const maxDim = Math.max(size.x, size.y, size.z);
                const scaleFactor = 300 / maxDim;  // Maintain the zoom level

                model.scale.set(scaleFactor, scaleFactor, scaleFactor);

                // Move the entire model down
                model.position.y = -10;  // Adjust this value to move the plane down

                // Grid helper positioned lower
                const gridHelper = new THREE.GridHelper(200, 20, 0xcccccc, 0xcccccc);
                gridHelper.position.y = -10;  // Match the model's downward shift
                scene.add(gridHelper);

                model.traverse((child) => {
                    if (child.isMesh) {
                        child.castShadow = true;
                        child.receiveShadow = true;

                        // Improve material rendering
                        if (child.material) {
                            child.material.metalness = 0.4;
                            child.material.roughness = 0.8;
                            child.material.needsUpdate = true;
                        }

                        // Mark clickable buildings
                        if (buildingDetails[child.name]) {
                            child.userData.clickable = true;
                        }
                    }
                });

                scene.add(model);
            });

            // Add touch event listeners for mobile/touch support
            renderer.domElement.addEventListener('touchstart', onTouchStart, { passive: false });
            renderer.domElement.addEventListener('touchmove', onTouchMove, { passive: false });
            renderer.domElement.addEventListener('touchend', onTouchEnd, { passive: false });

            // Existing mouse and resize listeners
            window.addEventListener('resize', onWindowResize, false);
            renderer.domElement.addEventListener('click', onMouseClick, false);

            animate();
        }

        function onTouchStart(event) {
            event.preventDefault();

            if (event.touches.length === 1) {
                // Single touch for click/rotation
                touchStart.set(
                    (event.touches[0].clientX / window.innerWidth) * 2 - 1,
                    -(event.touches[0].clientY / window.innerHeight) * 2 + 1
                );
            } else if (event.touches.length === 2) {
                // Multi-touch for pinch zoom
                isMultiTouch = true;
                const touch1 = event.touches[0];
                const touch2 = event.touches[1];
                touchStart.set(
                    (touch1.clientX + touch2.clientX) / 2,
                    (touch1.clientY + touch2.clientY) / 2
                );
            }
        }

        function onTouchMove(event) {
            event.preventDefault();

            if (event.touches.length === 1 && !isMultiTouch) {
                // Single touch move for rotation
                controls.enableRotate = true;
                controls.enablePan = true;
            } else if (event.touches.length === 2) {
                // Pinch zoom
                const touch1 = event.touches[0];
                const touch2 = event.touches[1];
                
                // Calculate distance between touches
                const currentDistance = Math.hypot(
                    touch1.clientX - touch2.clientX,
                    touch1.clientY - touch2.clientY
                );

                if (typeof onTouchMove.lastDistance === 'undefined') {
                    onTouchMove.lastDistance = currentDistance;
                }

                // Adjust zoom based on pinch
                const distanceDelta = currentDistance - onTouchMove.lastDistance;
                camera.zoom *= 1 + distanceDelta * 0.01;
                camera.updateProjectionMatrix();

                onTouchMove.lastDistance = currentDistance;
            }
        }

        function onTouchEnd(event) {
            event.preventDefault();

            if (event.touches.length === 0) {
                // Single tap detection for building selection
                if (!isMultiTouch) {
                    raycaster.setFromCamera(touchStart, camera);
                    const intersects = raycaster.intersectObjects(scene.children, true);

                    for (let intersect of intersects) {
                        if (intersect.object.userData.clickable) {
                            showBuildingPopup(intersect.object.name);
                            break;
                        }
                    }
                }

                // Reset touch states
                isMultiTouch = false;
                delete onTouchMove.lastDistance;
            }
        }

        function onMouseClick(event) {
            event.preventDefault();

            // Calculate mouse position
            mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
            mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;

            raycaster.setFromCamera(mouse, camera);
            const intersects = raycaster.intersectObjects(scene.children, true);

            for (let intersect of intersects) {
                if (intersect.object.userData.clickable) {
                    showBuildingPopup(intersect.object.name);
                    break;
                }
            }
        }

        function showBuildingPopup(buildingName) {
            const popup = document.getElementById('building-popup');
            const titleElem = document.getElementById('popup-title');
            const descElem = document.getElementById('popup-description');

            const details = buildingDetails[buildingName] || { 
                name: buildingName, 
                description: 'Building information not available.' 
            };

            titleElem.textContent = details.name;
            descElem.textContent = details.description;
            popup.style.display = 'block';
        }

        function closePopup() {
            document.getElementById('building-popup').style.display = 'none';
        }

        function onWindowResize() {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        }

        function animate() {
            requestAnimationFrame(animate);
            controls.update();
            renderer.render(scene, camera);
        }

        // Prevent default touch behaviors
        document.addEventListener('touchmove', (e) => {
            e.preventDefault();
        }, { passive: false });

        // Add an event listener to close side menu when clicking outside
        document.addEventListener('click', function(event) {
            const sideMenu = document.getElementById('side-menu');
            const hamburgerMenu = document.getElementById('hamburger-menu');
            
            if (sideMenu.classList.contains('open') && 
                !sideMenu.contains(event.target) && 
                !hamburgerMenu.contains(event.target)) {
                sideMenu.classList.remove('open');
            }
        });

        document.addEventListener('click', function(event) {
            const sideMenu = document.getElementById('side-menu');
            const hamburgerMenu = document.getElementById('hamburger-menu');
            
            if (sideMenu.classList.contains('open') && 
                !sideMenu.contains(event.target) && 
                !hamburgerMenu.contains(event.target)) {
                sideMenu.classList.remove('open');
            }
        });

        init();
    </script>
</body>
</html>