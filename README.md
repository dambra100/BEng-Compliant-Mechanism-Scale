# BEng Dissertation: Low-Cost Portable Scale via Image Processing

## Overview
This repository contains the final report, models, and MATLAB scripts for my First-Class Mechanical Engineering dissertation at Brunel University London. The project successfully developed a conceptual low-cost, portable scale integrated into a smartphone case, utilising computer vision to estimate applied forces. 

The methodology and findings from this project were peer-reviewed and published in the *IEEE Sensors Letters* (August 2023).

## Core Architecture & Hardware
* **Compliant Mechanism:** Engineered a 3D-printed platform manufactured from ABS. The design features four deformable cantilever beams that act as the primary sensing structure.
* **Vision System:** Integrated a webcam to simulate a smartphone camera, positioned to capture real-time spatial variations of four distinct white markers against a black surface as external loads are applied.

## Data Processing & Methodology
1. **Image Processing Pipeline:** Utilised the MATLAB Image Processing Toolbox to capture real-time frames. Applied Gaussian filters for noise reduction, and converted the feed from RGB to grayscale, and subsequently to binary images.
2. **Feature Extraction:** Isolated regions of interest (ROI) to continuously calculate two key parameters: the total number of white pixels per marker, and their centroid positions relative to the image centre.
3. **Sensor Calibration:** Implemented Multiple Linear Regression (MLR) to compute a calibration matrix, translating raw pixel displacement data into physical force estimations.

## Key Findings
* Successfully validated the core sensing principle of using a compliant mechanism and image processing for weight measurement.
* Proposed an optimised future architecture adopting stiffer materials and high-resolution smartphone cameras to heavily miniaturise the physical footprint whilst improving measurement precision.
