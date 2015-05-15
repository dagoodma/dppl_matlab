clear all;
close all;

% Add root
addpath('..')
fprintf('\n');

%=============== Setup ===============

%=============== Tests ===============
fprintf('\n');
figure();
testsPassed = 0;
totalTests = 4;

% Theta = 0
hAx = subplot(2,2,1);
xlim([-2 2]);
ylim([-2 2]);
result = heading2Theta(0);
resultExpected = pi/2;
drawHeadingArrow(hAx, [0 0], 0, 1, 'b');
drawHeadingArrow(hAx, [0 0], result, 1, 'r');
title('\psi = 0');
plot([0],[0],'-b',[0],[0],'-r'); % for legend to work
legend('\psi','\theta');

% Results
fprintf('Psi = 0:\tTheta = %.2f',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end

% Theta = pi/2
hAx = subplot(2,2,2);
xlim([-2 2]);
ylim([-2 2]);
result = heading2Theta(pi/2);
resultExpected = 0;
drawHeadingArrow(hAx, [0 0], pi/2, 1, 'b');
drawHeadingArrow(hAx, [0 0], result, 1, 'r');
title('\psi = \pi/2');
plot([0],[0],'-b',[0],[0],'-r'); % for legend to work
legend('\psi','\theta');

% Results
fprintf('Psi = pi/2:\tTheta = %.2f',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end

% Theta = pi
hAx = subplot(2,2,3);
xlim([-2 2]);
ylim([-2 2]);
result = heading2Theta(pi);
resultExpected = 3*pi/2;
drawHeadingArrow(hAx, [0 0], pi, 1, 'b');
drawHeadingArrow(hAx, [0 0], heading2Theta(pi), 1, 'r');
plot([0],[0],'-b',[0],[0],'-r'); % for legend to work
legend('\psi','\theta');
title('\psi = \pi');

% Results
fprintf('Psi = pi:\tTheta = %.2f',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end

% Theta = 3*pi/2
hAx = subplot(2,2,4);
xlim([-2 2]);
ylim([-2 2]);
result = heading2Theta(3*pi/2);
resultExpected = pi;
drawHeadingArrow(hAx, [0 0], 3*pi/2, 1, 'b');
drawHeadingArrow(hAx, [0 0], heading2Theta(3*pi/2), 1, 'r');
title('\psi = 3\pi/2');
plot([0],[0],'-b',[0],[0],'-r'); % for legend to work
legend('\psi','\theta');

% Results
fprintf('Psi = 3pi/2:\tTheta = %.2f',result);
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

