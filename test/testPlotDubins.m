clear all;
close all

% Add DubinsPlot lib
addpath('..')
addpath('../lib');
addpath('../class');
% Add Dubins plot tool
if exist('dubins') ~= 3
    if exist('../lib/DubinsPlot') ~= 7
        error('Could not find the DubinsPlot folder.');
    end
    addpath('../lib/DubinsPlot');
    if exist('dubins') ~= 3
        error('Could not find compiled dubins mex file.');
    end
end

%=============== Settings ===============
Va = 10; % (m/s) fixed airspeed
phi_max = degtorad(45); % (rad) maximum bank angle (+ and -)
g = 9.8; %(m/s^2)

% Path options
opts = PathOptions;
opts.TurnRadius = Va^2/(tan(phi_max)*g); % (m) turn radius for dubins path
opts.DubinsStepSize = 0.01; % [sec]
opts.HeadingArrowSize = 1.5;

% Position
startPosition = [0 0];
startHeading = 0; % radians
q0 = [startPosition heading2angle(startHeading)];

endPosition = [50 0];
endHeading = deg2rad(180); % radians
q1 = [endPosition heading2angle(endHeading)];

% Plotting
figure();
path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
plot([startPosition(1) endPosition(1)], [startPosition(2) endPosition(2)],...
    'ko', 'MarkerFaceColor', 'k')

xlim([-5 55]);
ylim([-5 12]);

hold on;
plot(path(1,1:end), path(2,1:end), 'Color', 'g');
hAx = gca;
drawHeadingArrow(hAx, startPosition, startHeading, opts.HeadingArrowSize, 'm')
drawHeadingArrow(hAx, endPosition, endHeading, opts.HeadingArrowSize, 'm')
hold off;
