clear all;
close all;

% Add root
addpath('..')
fprintf('\n');

%=============== Setup ===============
annotationSize = 1;
quiverSize = 0.8;
subplotDim=22;
plotLim=[-2 2];
origin = [0 0];

%=============== Tests ===============
fprintf('\n');
figure();
testsPassed = 0;
totalTests = 4;

%% Quadrant I Boundary Heading (Psi = 0)
headingTitleStr = '0';
hAx = subplot(sprintf('%d%d', subplotDim, 1));
xlim(plotLim);
ylim(plotLim);

heading = 0;
resultExpected = pi/2;
result = heading2angle(heading);

drawHeadingArrow(hAx, [0 0], result, annotationSize, 'r'); % heading
hold on;
drawHeadingArrow(hAx, [0 0], heading, quiverSize, 'b',1); % angle
title(sprintf('\\psi = %s', headingTitleStr));
plot(origin(1),origin(2),'-r'); % for legend to work with annotation
hold off;
legend('\theta','\psi');

% Results
fprintf('Psi =%.2f:\tTheta = %.2f',heading, result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end

%% Quadrant IV Boundary Heading (Psi = pi/2)
headingTitleStr = '\\pi/2';
hAx = subplot(sprintf('%d%d', subplotDim, 2));
xlim(plotLim);
ylim(plotLim);

heading = pi/2;
resultExpected = 0;
result = heading2angle(heading);

drawHeadingArrow(hAx, [0 0], result, annotationSize, 'r'); % heading
hold on;
drawHeadingArrow(hAx, [0 0], heading, quiverSize, 'b',1); % angle
title(sprintf('\\psi = %s', headingTitleStr));
plot(origin(1),origin(2),'-r'); % for legend to work with annotation
hold off;
legend('\theta','\psi');

% Results
fprintf('Psi =%.2f:\tTheta = %.2f',heading, result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end

%% Quadrant III Boundary Heading (Psi = pi)
headingTitleStr = '\\pi';
hAx = subplot(sprintf('%d%d', subplotDim, 3));
xlim(plotLim);
ylim(plotLim);

heading = pi;
result = heading2angle(pi);
resultExpected = 3*pi/2;

drawHeadingArrow(hAx, [0 0], result, annotationSize, 'r'); % heading
hold on;
drawHeadingArrow(hAx, [0 0], heading, quiverSize, 'b',1); % angle
title(sprintf('\\psi = %s', headingTitleStr));
plot(origin(1),origin(2),'-r'); % for legend to work with annotation
hold off;
legend('\theta','\psi');

% Results
fprintf('Psi =%.2f:\tTheta = %.2f',heading, result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end

%% Quadrant II Boundary Heading (Psi = 3*pi/2)
headingTitleStr = '3\\pi/2';
hAx = subplot(sprintf('%d%d', subplotDim, 4));
xlim(plotLim);
ylim(plotLim);

heading = 3*pi/2;
result = heading2angle(heading);
resultExpected = pi;

drawHeadingArrow(hAx, [0 0], result, annotationSize, 'r'); % heading
hold on;
drawHeadingArrow(hAx, [0 0], heading, quiverSize, 'b',1); % angle
title(sprintf('\\psi = %s', headingTitleStr));
plot(origin(1),origin(2),'-r'); % for legend to work with annotation
hold off;
legend('\theta','\psi');

% Results
fprintf('Psi =%.2f:\tTheta = %.2f',heading, result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end

fprintf('----------------------------\n');

%% Results
if (testsPassed ~= totalTests)
    fprintf('\nFAILED %i of %i tests\n\n',totalTests - testsPassed, totalTests);
else
    fprintf('\nPASSED %i of %i tests.\n\n', testsPassed, totalTests);
end

