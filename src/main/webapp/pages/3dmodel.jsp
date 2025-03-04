<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Interactive Department Viewer</title>
    <style>
        body { margin: 0; overflow: hidden; }
        canvas { display: block; }
        #info-panel {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 15px;
            border-radius: 5px;
            width: 250px;
            display: none;
        }
        #building-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        #building-details {
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div id="info-panel">
        <div id="building-name">Building Name</div>
        <div id="building-details">Building details go here...</div>
    </div>

    <script type="importmap">
        {
            "imports": {
                "three": "https://cdnjs.cloudflare.com/ajax/libs/three.js/0.160.0/three.module.js",
                "three/addons/": "https://unpkg.com/three@0.160.0/examples/jsm/"
            }
        }
    </script>

    <script type="module">
        import * as THREE from 'three';
        import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
        import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';

        // Building data - you'll populate this with your actual building information
        const buildingData = {
            "Building_1": {
                name: "Main Building",
                details: "Administrative offices and main reception area. Built in 2010."
            },
            "Building_2": {
                name: "Science Wing",
                details: "Houses laboratories and research facilities for biology and chemistry departments."
            },
            "Building_3": {
                name: "Library",
                details: "Three floors of books, study areas, and computer labs. Open 24/7."
            }
            // Add more buildings as needed
        };

        // Scene setup
        const scene = new THREE.Scene();
        scene.background = new THREE.Color(0xf0f0f0);
        
        // Camera setup
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        camera.position.set(5, 5, 5);
        
        // Renderer setup
        const renderer = new THREE.WebGLRenderer({ antialias: true });
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.setPixelRatio(window.devicePixelRatio);
        renderer.shadowMap.enabled = true;
        document.body.appendChild(renderer.domElement);
        
        // Lighting
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
        scene.add(ambientLight);
        
        const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
        directionalLight.position.set(5, 10, 7.5);
        directionalLight.castShadow = true;
        scene.add(directionalLight);
        
        // Controls
        const controls = new OrbitControls(camera, renderer.domElement);
        controls.enableDamping = true;
        controls.dampingFactor = 0.05;
        
        // Raycaster for mouse picking
        const raycaster = new THREE.Raycaster();
        const mouse = new THREE.Vector2();
        
        // Load the model
        const loader = new GLTFLoader();
        
        // Keep track of selectable objects
        const selectableObjects = [];
        let selectedObject = null;
        
        // Load the 3D model - replace with your model path
        loader.load(
            'models/department.glb',  // Update path to where you store the model
            function (gltf) {
                const model = gltf.scene;
                
                // Process the model to make buildings selectable
                model.traverse((node) => {
                    // Assuming each building is a mesh with a name starting with "Building_"
                    if (node.isMesh && node.name.includes('Building_')) {
                        // Store original material for resetting later
                        node.userData.originalMaterial = node.material.clone();
                        
                        // Add to selectable objects
                        selectableObjects.push(node);
                    }
                });
                
                scene.add(model);
                
                // Center the model
                const box = new THREE.Box3().setFromObject(model);
                const center = box.getCenter(new THREE.Vector3());
                model.position.sub(center);
                
                // Position camera to better view the model
                const size = box.getSize(new THREE.Vector3());
                const maxDim = Math.max(size.x, size.y, size.z);
                const fov = camera.fov * (Math.PI / 180);
                let cameraDistance = maxDim / (2 * Math.tan(fov / 2));
                camera.position.set(cameraDistance, cameraDistance, cameraDistance);
                camera.lookAt(new THREE.Vector3(0, 0, 0));
                
                controls.update();
            },
            undefined,
            function (error) {
                console.error('Error loading model:', error);
            }
        );
        
        // Mouse move event to highlight buildings
        function onMouseMove(event) {
            // Calculate mouse position in normalized device coordinates
            mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
            mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;
        }
        
        // Mouse click event to select buildings
        function onClick() {
            raycaster.setFromCamera(mouse, camera);
            const intersects = raycaster.intersectObjects(selectableObjects);
            
            // Reset previous selection
            if (selectedObject) {
                selectedObject.material = selectedObject.userData.originalMaterial.clone();
                selectedObject = null;
                hideInfoPanel();
            }
            
            // Handle new selection
            if (intersects.length > 0) {
                selectedObject = intersects[0].object;
                
                // Create highlight material
                const highlightMaterial = selectedObject.userData.originalMaterial.clone();
                highlightMaterial.emissive = new THREE.Color(0x333333);
                highlightMaterial.color = new THREE.Color(0xffaa00);
                selectedObject.material = highlightMaterial;
                
                // Show info panel with building data
                showInfoPanel(selectedObject.name);
            }
        }
        
        // Show information panel
        function showInfoPanel(buildingId) {
            const infoPanel = document.getElementById('info-panel');
            const nameElement = document.getElementById('building-name');
            const detailsElement = document.getElementById('building-details');
            
            // Find building data
            const building = buildingData[buildingId];
            
            if (building) {
                nameElement.textContent = building.name;
                detailsElement.textContent = building.details;
                infoPanel.style.display = 'block';
            } else {
                nameElement.textContent = buildingId;
                detailsElement.textContent = "No detailed information available";
                infoPanel.style.display = 'block';
            }
        }
        
        // Hide information panel
        function hideInfoPanel() {
            document.getElementById('info-panel').style.display = 'none';
        }
        
        // Handle window resize
        function onWindowResize() {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        }
        
        // Animation loop
        function animate() {
            requestAnimationFrame(animate);
            
            controls.update();
            
            // Check for hover interactions
            raycaster.setFromCamera(mouse, camera);
            const intersects = raycaster.intersectObjects(selectableObjects);
            
            // Reset all non-selected objects
            selectableObjects.forEach((object) => {
                if (object !== selectedObject) {
                    object.material = object.userData.originalMaterial.clone();
                }
            });
            
            // Highlight hovered object
            if (intersects.length > 0 && intersects[0].object !== selectedObject) {
                const hoveredObject = intersects[0].object;
                const hoverMaterial = hoveredObject.userData.originalMaterial.clone();
                hoverMaterial.emissive = new THREE.Color(0x222222);
                hoveredObject.material = hoverMaterial;
            }
            
            renderer.render(scene, camera);
        }
        
        // Event listeners
        window.addEventListener('mousemove', onMouseMove, false);
        window.addEventListener('click', onClick, false);
        window.addEventListener('resize', onWindowResize, false);
        
        // Start animation
        animate();
    </script>
</body>
</html>