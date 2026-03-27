# Optical Force Tracking: Compliant Mechanism Scale

![MATLAB](https://img.shields.io/badge/MATLAB-e16737?style=for-the-badge&logo=mathworks&logoColor=white)
![Fusion 360](https://img.shields.io/badge/CAD-Fusion%20360-F05A28?style=for-the-badge&logo=autodesk&logoColor=white)
![Status](https://img.shields.io/badge/Status-Published-success?style=for-the-badge)

This repository contains the software architecture, CAD, and raw datasets for a low-cost optical tracking scale. The system explores the replacement of expensive mechanical load cells with compliant mechanisms and computer vision (tracking planar displacements via a standard webcam).

**📄 Read the drafted publication for IEEE Sensors Letters in the `/Documents` directory.**

## 🔬 Core Technologies

### 1. Mechanical Design & FEA
The scale utilises a custom 3D-printed compliant mechanism. Extensive Finite Element Analysis (FEA) was conducted to ensure the flexure legs operate strictly within the elastic region of the PLA material, guaranteeing repeatability and preventing mechanical yielding under load.

### 2. Optical Tracking & GUI (MATLAB)
The system tracks physical planar displacements using high-contrast optical markers. 
* A custom MATLAB GUI (`gui.m`) segments the live video feed into four distinct quadrants.
* The software calculates 12 real-time state variables (pixel areas and centroid X/Y coordinates) to track micro-deformations.

### 3. Mathematical Calibration (Machine Learning)
Using Multiple Linear Regression (MLR) trained on 99 physical test samples, the system generates a `3×12` calibration matrix. 

## ⚙️ Engineering Workflow

* **Theoretical Validation:** Computational stress limits were established using CAD and FEA.
* **Physical Assembly:** The compliant mechanism was 3D printed and assembled with high-contrast optical markers.
* **Data Acquisition:** Eccentric load testing was conducted to capture raw displacement telemetry via the MATLAB computer vision interface.
* **Mathematical Isolation:** The calibration matrix successfully calculates absolute mass ($F_z$) while mathematically ignoring bending moments ($M_x, M_y$) caused by off-centre loads.

## 📁 Repository Structure

* `/Scripts/` - Core MATLAB computer vision and regression code.
* `/CAD/` - Manufacturing `.stl` and design `.step` files.
* `/Documents/` - Academic reports, FEA analysis, and the IEEE Sensors Letters publication draft.
* `ALL_IN_ONE.xlsx` - The raw 99-sample calibration and validation dataset.

## 📊 Execution & Results

### Physical Assembly & Hardware Testing
<img src="Images/assembly.jpg" alt="Physical Assembly" width="600">
<img src="Images/markers.jpg" alt="Optical Tracking Markers" width="350">
<img src="Images/eccentric_weights.jpg" alt="Eccentric Weights Testing" width="500">

### FEA Stress Analysis
<img src="Images/fea_stress.jpg" alt="FEA Analysis" width="600">

### Digital Pipeline & Validation
<img src="Images/gui_screengrab.png" alt="MATLAB GUI" width="600">
<img src="Images/validation_graph.png" alt="Performance Graph" width="600">
