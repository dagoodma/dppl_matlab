clear all;
close all;

% Add root
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

% Find Dubins plot test script
if exist('testPlotDubins') ~= 2
    error('Could not find testPlotDubins.m!')
end
%=============== Settings ===============
EPSILON_ERROR = 0.05; % error margin in length calculation

Va = 10; % (m/s) fixed airspeed
phi_max = degtorad(45); % (rad) maximum bank angle (+ and -)
g = 9.8; %(m/s^2)

r = 1;

% Path options
opts = PathOptions;
%opts.TurnRadius = Va^2/(tan(phi_max)*g); % (m) turn radius for dubins path
opts.TurnRadius = r;
opts.DubinsStepSize = 0.01; % [sec]
opts.HeadingArrowSize = 0.7;
opts.Debug = 'on';
%=============== Tests ===============
fprintf('\n');
fh = figure();
testsPassed = 0;
totalTests = 4;

%% Case I, R-S-R
subplot(2,2,1);

% Position
startPosition = [0 0];
startHeading = 0; % radians
endPosition = [5 0];
endHeading = deg2rad(180); % radians

q0 = [startPosition heading2Theta(startHeading)];
q1 = [endPosition heading2Theta(endHeading)];

% Plotting
path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
plot([startPosition(1) endPosition(1)], [startPosition(2) endPosition(2)],...
    'ko', 'MarkerFaceColor', 'k')
L =  findDubinsLength(startPosition, startHeading, endPosition, endHeading,...
    opts.TurnRadius, 1);
set(0,'currentFigure',fh)
hold on;
plot(path(1,1:end), path(2,1:end), 'Color', 'g');
title('Case I: R-S-R');
yl = ylim();
%text(0,yl(1)+5,sprintf('L = %.2f',L));

% Count length of path from DubinsPlot tool
Lexpected = 0;
for i=2:length(path)
    l_i = sqrt((path(1,i) - path(1,i-1))^2 + (path(2,i) - path(2,i-1))^2);
    Lexpected  = Lexpected + l_i;
end % for

% Results
result = L;
resultExpected = Lexpected;
fprintf('Case I (R-S-R): L = %.2f',result);
if (abs(result - resultExpected) > EPSILON_ERROR)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end

%% Case II, R-S-L
subplot(2,2,2);

% Position
startPosition = [0 0];
startHeading = deg2rad(37); % radians
endPosition = [5.27*r -1.3*r];
endHeading = deg2rad(340); % radians

q0 = [startPosition heading2Theta(startHeading)];
q1 = [endPosition heading2Theta(endHeading)];

% Plotting
path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
plot([startPosition(1) endPosition(1)], [startPosition(2) endPosition(2)],...
    'ko', 'MarkerFaceColor', 'k')
L =  findDubinsLength(startPosition, startHeading, endPosition, endHeading,...
    opts.TurnRadius, 1);
set(0,'currentFigure',fh)
hold on;
plot(path(1,1:end), path(2,1:end), 'Color', 'g');
title('Case II: R-S-L');
yl = ylim();
%text(0,yl(1)+5,sprintf('L = %.2f',L));

% Count length of path from DubinsPlot tool
Lexpected = 0;
for i=2:length(path)
    l_i = sqrt((path(1,i) - path(1,i-1))^2 + (path(2,i) - path(2,i-1))^2);
    Lexpected  = Lexpected + l_i;
end % for

% Results
result = L;
resultExpected = Lexpected;
fprintf('Case II (R-S-L): L = %.2f',result);
if (abs(result - resultExpected) > EPSILON_ERROR)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end

%% Case III, L-S-R
subplot(2,2,3);

% Position
startPosition = [0 0];
startHeading = deg2rad(245); % radians
endPosition = [5.27*r -1.3*r];
endHeading = deg2rad(165); % radians
q0 = [startPosition heading2Theta(startHeading)];
q1 = [endPosition heading2Theta(endHeading)];

% Plotting
path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
plot([startPosition(1) endPosition(1)], [startPosition(2) endPosition(2)],...
    'ko', 'MarkerFaceColor', 'k')
L =  findDubinsLength(startPosition, startHeading, endPosition, endHeading,...
    opts.TurnRadius, 1);
set(0,'currentFigure',fh)
hold on;
plot(path(1,1:end), path(2,1:end), 'Color', 'g');
title('Case III: L-S-R');
yl = ylim();
%text(0,yl(1)+5,sprintf('L = %.2f',L));

% Count length of path from DubinsPlot tool
Lexpected = 0;
for i=2:length(path)
    l_i = sqrt((path(1,i) - path(1,i-1))^2 + (path(2,i) - path(2,i-1))^2);
    Lexpected  = Lexpected + l_i;
end % for

% Results
result = L;
resultExpected = Lexpected;
fprintf('Case III (L-S-R): L = %.2f',result);
if (abs(result - resultExpected) > EPSILON_ERROR)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end


%% Case IV, L-S-L
subplot(2,2,4);

% Position
startPosition = [0 0];
startHeading = deg2rad(170); % radians
endPosition = [5.27*r -1.3*r];
endHeading = deg2rad(315); % radians
q0 = [startPosition heading2Theta(startHeading)];
q1 = [endPosition heading2Theta(endHeading)];

% Plotting
path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
plot([startPosition(1) endPosition(1)], [startPosition(2) endPosition(2)],...
    'ko', 'MarkerFaceColor', 'k')
L =  findDubinsLength(startPosition, startHeading, endPosition, endHeading,...
    opts.TurnRadius, 1);
hold on;
set(0,'currentFigure',fh)
plot(path(1,1:end), path(2,1:end), 'Color', 'g');
title('Case IV: L-S-L');
yl = ylim();
%text(0,yl(1)+5,sprintf('L = %.2f',L));

% Count length of path from DubinsPlot tool
Lexpected = 0;
for i=2:length(path)
    l_i = sqrt((path(1,i) - path(1,i-1))^2 + (path(2,i) - path(2,i-1))^2);
    Lexpected  = Lexpected + l_i;
end % for

% Results
result = L;
resultExpected = Lexpected;
fprintf('Case IV (L-S-L): L = %.2f',result);
if (abs(result - resultExpected) > EPSILON_ERROR)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end

%% Boundaries when angle distance is small
%subplot(2,2,4);

% Position
%findDubinsLength([450 0], 3.927, [350, -100], 3.927, 10.2)
startPosition = [450 0];
startHeading = 3.92699 + 0.00001; % rad
endPosition = [350, -100];
endHeading = 3.92699; % rad
q0 = [startPosition heading2Theta(startHeading)];
q1 = [endPosition heading2Theta(endHeading)];

% Plotting
path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
%plot([startPosition(1) endPosition(1)], [startPosition(2) endPosition(2)],...
%    'ko', 'MarkerFaceColor', 'k')
L =  findDubinsLength(startPosition, startHeading, endPosition, endHeading,...
    opts.TurnRadius);
hold on;
%set(0,'currentFigure',fh)
%plot(path(1,1:end), path(2,1:end), 'Color', 'g');
%title('Case IV: L-S-L');
%yl = ylim();
%text(0,yl(1)+5,sprintf('L = %.2f',L));

% Count length of path from DubinsPlot tool
Lexpected = 0;
for i=2:length(path)
    l_i = sqrt((path(1,i) - path(1,i-1))^2 + (path(2,i) - path(2,i-1))^2);
    Lexpected  = Lexpected + l_i;
end % for

% Results
result = L;
resultExpected = Lexpected;
theta_diff = endHeading - startHeading;
fprintf('Boundary (Line) Test: L = %.2f, CWdiff=%0.6f',result, theta_diff);
if (abs(result - resultExpected) > EPSILON_ERROR)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end


%% Results
fprintf('----------------------------\n');
if (testsPassed ~= totalTests)
    fprintf('\nFAILED %i of %i tests\n\n',totalTests - testsPassed, totalTests);
else
    fprintf('\nPASSED %i of %i tests.\n\n', testsPassed, totalTests);
end
