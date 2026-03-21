% =========================================================================
% SCRIPT: Calibration.m
% Description: Uses Multiple Linear Regression (MLR) on physical test data
% to generate a 3x12 calibration matrix. Validates the matrix by comparing
% the predicted Force (Fz) and Moments (Mx, My) against the ground truth.
% =========================================================================
close all;

% 1. Load the raw physical testing dataset
% Requires 'ALL_IN_ONE.xlsx' in the active directory
data = xlsread('ALL_IN_ONE.xlsx');

% Extract Input State (X): The 12 sensor variables (Area counts + Centroid Distances)
X_data = data(1:55, 4:15);

% Extract Ground Truth (Y): The known Fz, Mx, My loads applied during testing
Y_truth = data(1:55, 1:3);

% Transpose for MLR processing
Xt = transpose(X_data);
Yt = transpose(Y_truth);

% 2. Generate the Calibration Matrix
% Initialise a 3x12 matrix to map the 12 optical inputs to the 3 physical outputs
calibration_matrix = zeros(3, 12);

% Perform linear regression for each output dimension (Fz, Mx, My)
for i = 1:3
    % The regress function determines the optimal coefficients for each dimension
    calibration_matrix(i, :) = regress(Y_truth(:, i), X_data);
end

% 3. Validate the Matrix against specific test positions
% We slice the dataset into the 9 physical testing positions (11 samples each)
% Pos 1, 6, 7, 8, and 9 are plotted for validation
positions = cell(1, 9);
predicted = cell(1, 9);

for p = 1:9
    start_idx = (p-1)*11 + 1;
    end_idx = p*11;

    % Extract sensor data for this specific position
    pos_x = transpose(data(start_idx:end_idx, 4:15));

    % Apply the generated calibration matrix to predict forces
    predicted{p} = calibration_matrix * pos_x;
end

% 4. Render Validation Plots
% Helper arrays to loop through the specific positions highlighted in the report
plot_positions = [1, 6, 7, 8, 9];
figure_names = {'Fz Only', 'Fz and +Mx', 'Fz and -Mx', 'Fz and -My', 'Fz and +My'};

for i = 1:length(plot_positions)
    p = plot_positions(i);
    start_idx = (p-1)*11 + 1;
    end_idx = p*11;

    figure(i);
    hold on;

    % Plot Ground Truth (from Excel)
    plot(data(start_idx:end_idx, 1), 'LineWidth', 1, 'Color', 'b'); % Fz
    plot(data(start_idx:end_idx, 2), 'LineWidth', 1, 'Color', 'g'); % Mx
    plot(data(start_idx:end_idx, 3), 'LineWidth', 1, 'Color', 'm'); % My

    % Plot Predictions (from Calibration Matrix)
    plot(predicted{p}(1, :), '--', 'LineWidth', 1, 'Color', 'b'); % Predicted Fz
    plot(predicted{p}(2, :), '--', 'LineWidth', 1, 'Color', 'g'); % Predicted Mx
    plot(predicted{p}(3, :), '--', 'LineWidth', 1, 'Color', 'm'); % Predicted My

    hold off;

    % Formatting
    title(sprintf('Position %d Validation (%s)', p, figure_names{i}));
    ylabel('Force [N] / Moment [Ncm]');
    xlabel('Time / Sample');
    legend('Fz Truth', 'Mx Truth', 'My Truth', 'Fz Predicted', 'Mx Predicted', 'My Predicted', 'Location', 'best');
    set(gca, 'FontSize', 12);
end
