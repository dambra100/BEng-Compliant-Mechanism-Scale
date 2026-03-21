% =========================================================================
% SCRIPT: Plotting.m (Data Acquisition)
% Description: Captures live webcam feed of a compliant mechanism scale.
% Binarises the feed, segments it into four quadrants, and calculates both
% the active pixel count (area) and centroid displacement to gather
% calibration datasets.
% =========================================================================

% Initialise webcam feed for real-time tracking
cam = webcam();

% --- Figure 1: Live Pixel Count (Area Tracking) ---
fig1 = figure;
x1 = 0;
y1 = [0, 0, 0, 0];

% --- Figure 2: Live Centroid Displacement (Distance Tracking) ---
fig2 = figure;
x2 = 0;
y2 = [0, 0, 0, 0, 0, 0, 0, 0];

% Execute real-time optical processing loop
while isvalid(fig1) && isvalid(fig2)

    % Capture the raw frame from the load platform
    img = snapshot(cam);

    % Apply Gaussian filter to smooth optical noise
    img_filtered = imgaussfilt(img, 4);
    bwImg = im2bw(img_filtered);

    % Segment the binarised frame into four independent tracking quadrants
    [h, w] = size(bwImg);
    sectionWidth = floor(w/2);
    sectionHeight = floor(h/2);

    section1 = bwImg(1:sectionHeight, 1:sectionWidth);
    section2 = bwImg(1:sectionHeight, sectionWidth+1:end);
    section3 = bwImg(sectionHeight+1:end, 1:sectionWidth);
    section4 = bwImg(sectionHeight+1:end, sectionWidth+1:end);

    % ==========================================
    % MODULE 1: PIXEL AREA CALCULATION
    % ==========================================
    figure(fig1);

    count1 = sum(section1(:));
    count2 = sum(section2(:));
    count3 = sum(section3(:));
    count4 = sum(section4(:));

    x1 = [x1, x1(end)+1];
    y1 = [y1; [count1, count2, count3, count4]];

    plot(x1, y1);
    title('Live Marker Area (Pixel Count)');
    xlabel('Time (Frames)');
    ylabel('Active Pixels');
    legend('Quadrant 1', 'Quadrant 2', 'Quadrant 3', 'Quadrant 4');
    ylim([4500, 6500]);

    % ==========================================
    % MODULE 2: CENTROID DISPLACEMENT CALCULATION
    % ==========================================
    figure(fig2);

    props1 = regionprops(section1, 'Centroid');
    props2 = regionprops(section2, 'Centroid');
    props3 = regionprops(section3, 'Centroid');
    props4 = regionprops(section4, 'Centroid');

    % Extract centroids with safety fallback
    c1 = get_centroid(props1); c2 = get_centroid(props2);
    c3 = get_centroid(props3); c4 = get_centroid(props4);

    % Define the absolute origin
    center = [w/2, h/2];

    % Calculate relative X/Y vector distance of each centroid
    xDist1 = round(-(c1(1) - center(1))); yDist1 = round(-(c1(2) - center(2)));
    xDist2 = round(c2(1) - center(1));    yDist2 = round(-(c2(2) - center(2)));
    xDist3 = round(-(c3(1) - center(1))); yDist3 = round(c3(2) - center(2));
    xDist4 = round(c4(1) - center(1));    yDist4 = round(c4(2) - center(2));

    x2 = [x2, x2(end)+1];
    y2 = [y2; [xDist1, yDist1, xDist2, yDist2, xDist3, yDist3, xDist4, yDist4]];

    plot(x2, y2);
    title('Live Centroid Displacement Vectors');
    xlabel('Time (Frames)');
    ylabel('Distance (Pixels from Origin)');
    legend('X1', 'Y1', 'X2', 'Y2', 'X3', 'Y3', 'X4', 'Y4');
    ylim([80, 140]);

    pause(0.01);
end

clear cam;

% Helper function
function c = get_centroid(props)
    if ~isempty(props); c = props(1).Centroid; else; c = [NaN NaN]; end
end
