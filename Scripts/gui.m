% =========================================================================
% SCRIPT: GUI.m
% Description: Live graphical user interface for the compliant mechanism scale.
% Captures webcam feed, tracks marker centroids, applies the calibration
% matrix, and estimates the physical mass in real-time.
% =========================================================================

% Initialise the camera
cam = webcam();

% Create the GUI window
fig = uifigure('Name', 'Real-Time Load Analysis');
fig.Position = [200 200 700 500];

% Create the image axes for the live feed
imgAxes = uiaxes('Parent', fig, 'Position', [50 50 400 400]);

% Create the base position for UI labels
labelPos = [450 350 100 20];

% --- UI Labels: Pixel Area Counts ---
labelCount1 = uilabel('Parent', fig, 'Position', labelPos);
labelCount2 = uilabel('Parent', fig, 'Position', labelPos + [0 -50 0 0]);
labelCount3 = uilabel('Parent', fig, 'Position', labelPos + [0 -100 0 0]);
labelCount4 = uilabel('Parent', fig, 'Position', labelPos + [0 -150 0 0]);

% --- UI Labels: Centroid X Coordinates ---
labelPosX = [550 400 100 20];
labelCentroidX1 = uilabel('Parent', fig, 'Position', labelPosX);
labelCentroidX2 = uilabel('Parent', fig, 'Position', labelPosX + [0 -50 0 0]);
labelCentroidX3 = uilabel('Parent', fig, 'Position', labelPosX + [0 -100 0 0]);
labelCentroidX4 = uilabel('Parent', fig, 'Position', labelPosX + [0 -150 0 0]);

% --- UI Labels: Centroid Y Coordinates ---
labelPosY = [550 200 100 20];
labelCentroidY1 = uilabel('Parent', fig, 'Position', labelPosY);
labelCentroidY2 = uilabel('Parent', fig, 'Position', labelPosY + [0 -50 0 0]);
labelCentroidY3 = uilabel('Parent', fig, 'Position', labelPosY + [0 -100 0 0]);
labelCentroidY4 = uilabel('Parent', fig, 'Position', labelPosY + [0 -150 0 0]);

% --- UI Label: Final Mass Output ---
labelPosMass = [650 200 100 20];
labelMass = uilabel('Parent', fig, 'Position', labelPosMass);

% Pre-calculated 3x12 Calibration Matrix [Fz; Mx; My]
C = [-0.01041686, -0.00944917, -0.02309748, 0.00729259, -0.11800460, 0.75470974, -0.24379300, -0.15457323, 0.23055772, 0.53556108, 0.40197871, 0.28965010;
      0.00000183, -0.00014389,  0.00019960, 0.00010132, -0.00283636, -0.00850192,  0.00102472, -0.00107521, -0.00133288, 0.00449615, 0.00907332, 0.00471568;
      0.00000027, -0.00000543, -0.00028777, 0.00002560,  0.00480186, -0.00131996,  0.00204177, -0.00608963, -0.00693098, 0.00949937, -0.00348653, 0.00468544];

% Execute real-time optical processing loop
while isvalid(fig)
    % Capture and process image
    img = snapshot(cam);
    img_filtered = imgaussfilt(img, 4);
    bwImg = im2bw(img_filtered);

    % Segment into quadrants
    [h, w] = size(bwImg);
    sectionWidth = floor(w/2);
    sectionHeight = floor(h/2);

    section1 = bwImg(1:sectionHeight, 1:sectionWidth);
    section2 = bwImg(1:sectionHeight, sectionWidth+1:end);
    section3 = bwImg(sectionHeight+1:end, 1:sectionWidth);
    section4 = bwImg(sectionHeight+1:end, sectionWidth+1:end);

    % Calculate active pixel area
    count1 = sum(section1(:));
    count2 = sum(section2(:));
    count3 = sum(section3(:));
    count4 = sum(section4(:));

    % Extract centroids
    props1 = regionprops(section1, 'Centroid');
    props2 = regionprops(section2, 'Centroid');
    props3 = regionprops(section3, 'Centroid');
    props4 = regionprops(section4, 'Centroid');

    centroid1 = ifelse(~isempty(props1), props1(1).Centroid, [NaN NaN]);
    centroid2 = ifelse(~isempty(props2), props2(1).Centroid, [NaN NaN]);
    centroid3 = ifelse(~isempty(props3), props3(1).Centroid, [NaN NaN]);
    centroid4 = ifelse(~isempty(props4), props4(1).Centroid, [NaN NaN]);

    % Calculate displacement from absolute origin
    center = [w/2 h/2];

    xDist1 = round(-(centroid1(1) - center(1))); yDist1 = round(-(centroid1(2) - center(2)));
    xDist2 = round(centroid2(1) - center(1));    yDist2 = round(-(centroid2(2) - center(2)));
    xDist3 = round(-(centroid3(1) - center(1))); yDist3 = round(centroid3(2) - center(2));
    xDist4 = round(centroid4(1) - center(1));    yDist4 = round(centroid4(2) - center(2));

    % Generate state vector (12x1)
    X_vector = [count1; count2; count3; count4; xDist1; yDist1; xDist2; yDist2; xDist3; yDist3; xDist4; yDist4];

    % Apply mathematical calibration matrix to estimate forces [Fz; Mx; My]
    % Handle NaNs (if markers are obscured) by setting output to 0 to prevent crash
    if any(isnan(X_vector))
        Forces = [0; 0; 0];
    else
        Forces = C * X_vector;
    end

    % Calculate physical mass (g) from Fz (N) using W = mg
    Fz = Forces(1);
    estimated_mass_grams = abs(Fz) * (1000 / 9.81);

    % Update UI Elements
    imshow(bwImg, 'Parent', imgAxes);
    labelCount1.Text = sprintf('Area 1: %d', count1);
    labelCount2.Text = sprintf('Area 2: %d', count2);
    labelCount3.Text = sprintf('Area 3: %d', count3);
    labelCount4.Text = sprintf('Area 4: %d', count4);

    labelCentroidX1.Text = sprintf('X1: %d', xDist1);
    labelCentroidX2.Text = sprintf('X2: %d', xDist2);
    labelCentroidX3.Text = sprintf('X3: %d', xDist3);
    labelCentroidX4.Text = sprintf('X4: %d', xDist4);

    labelCentroidY1.Text = sprintf('Y1: %d', yDist1);
    labelCentroidY2.Text = sprintf('Y2: %d', yDist2);
    labelCentroidY3.Text = sprintf('Y3: %d', yDist3);
    labelCentroidY4.Text = sprintf('Y4: %d', yDist4);

    labelMass.Text = sprintf('Mass: %.1f g', estimated_mass_grams);

    drawnow;
end

% Safely release hardware resources
clear cam;
delete(fig);

% Helper function for clean ternary logic
function res = ifelse(cond, trueVal, falseVal)
    if cond; res = trueVal; else; res = falseVal; end
end
