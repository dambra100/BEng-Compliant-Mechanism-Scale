### 2. The Compliant Mechanism Scale (The Deep Tech Flex)
*For this one, I have structured it to highlight the massive intersection of hardware, mathematics, and software. It shows you aren't just a coder; you understand complex physics.*

**Copy and paste this into your Scale `README.md`:**

```markdown
# Optical Force Tracking: Compliant Mechanism Scale

![MATLAB](https://img.shields.io/badge/MATLAB-e16737?style=for-the-badge&logo=mathworks&logoColor=white)
![SolidWorks](https://img.shields.io/badge/CAD-SolidWorks-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Published-success?style=for-the-badge)

This repository contains the software architecture, CAD, and raw datasets for a low-cost optical tracking scale. The system explores the replacement of expensive mechanical load cells with compliant mechanisms and computer vision (tracking planar displacements via a standard webcam).

**📄 Read the drafted publication for IEEE Sensors Letters in the `/Documents` directory.**

## 🔬 Core Technologies

### 1. Mechanical Design & FEA
The scale utilises a custom 3D-printed compliant mechanism. Extensive Finite Element Analysis (FEA) was conducted to ensure the flexure legs operate strictly within the elastic region of the PLA material, guaranteeing repeatability and preventing mechanical yielding under load.

### 2. Optical Tracking & GUI (MATLAB)
The system tracks physical planar displacements using high-contrast optical markers. 
* A custom MATLAB GUI (`gui.m`) segments the live video feed into four distinct quadrants.
* The software calculates 12 real-time state variables (pixel areas and centroid X/Y coordinates) to track micro-deformations in the compliant structure.

### 3. Mathematical Calibration (Machine Learning)
Using Multiple Linear Regression (MLR) trained on 99 physical test samples, the system generates a `3×12` calibration matrix. 
* **Result:** The software successfully calculates absolute mass ($F_z$) while mathematically isolating and ignoring bending moments ($M_x, M_y$) caused by off-centre, eccentric loads.

## 📁 Repository Structure

* `/Scripts/` - Core MATLAB computer vision and regression code.
* `/CAD/` - Manufacturing `.stl` and design `.step` files.
* `/Documents/` - Academic reports, FEA analysis, and the IEEE Sensors Letters publication draft.
* `ALL_IN_ONE.xlsx` - The raw 99-sample calibration and validation dataset.

## 🖼️ Visualisation
*(Add your images here using this format: `![Alt Text](path/to/image.png)`)*
* **Image 1:** Physical Assembly vs. FEA Stress Analysis
* **Image 2:** MATLAB GUI Interface & Tracking Markers
* **Image 3:** Actual vs. Predicted Performance Graph
