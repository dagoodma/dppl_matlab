clear all;
close all;

% Add root
addpath('..')
if exist('findHeadingFrom') ~= 2
    error('Could not find findHeadingFrom()!')
end

origin = [0 0];

%=============== Test ===============
testsPassed = 0;
totalTests = 4;

%% Case I: 0 <= psi < 90
disp('Case I: 0 <= psi < 90');
subTestsPassed = 0;
totalSubTests = 2;

% Case Ia
P = [0 1];
psiExpected = 0;
psiActual = rad2deg(findHeadingFrom(origin, P));
fprintf('\tIa: psi = %d', psiExpected);
if (psiExpected ~= psiActual)
    fprintf('\t-- FAILED: got %d\n',psiActual);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Case Ib
P = [1 1];
psiExpected = 45;
psiActual = rad2deg(findHeadingFrom(origin, P));
fprintf('\tIb: psi = %d', psiExpected);
if (psiExpected ~= psiActual)
    fprintf('\t-- FAILED: got %d\n',psiActual);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Results
fprintf('----------- ');
if (subTestsPassed ~= totalSubTests)
    fprintf('FAILED');
else
    fprintf('PASSED');
    testsPassed = testsPassed + 1;
end
fprintf(' -----------\n');

%% Case II: 90 <= psi < 180
disp('Case II: 90 <= psi < 180');
subTestsPassed = 0;
totalSubTests = 2;

% Case IIa
P = [1 0];
psiExpected = 90;
psiActual = rad2deg(findHeadingFrom(origin, P));
fprintf('\tIIa: psi = %d', psiExpected);
if (psiExpected ~= psiActual)
    fprintf('\t-- FAILED: got %d\n',psiActual);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Case IIb
P = [1 -1];
psiExpected = 135;
psiActual = rad2deg(findHeadingFrom(origin, P));
fprintf('\tIIb: psi = %d', psiExpected);
if (psiExpected ~= psiActual)
    fprintf('\t-- FAILED: got %d\n',psiActual);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Results
fprintf('----------- ');
if (subTestsPassed ~= totalSubTests)
    fprintf('FAILED');
else
    fprintf('PASSED');
    testsPassed = testsPassed + 1;
end
fprintf(' -----------\n');

%% Case III: 180 <= psi < 270
disp('Case III: 180 <= psi < 270');
subTestsPassed = 0;
totalSubTests = 2;

% Case IIIa
P = [0 -1];
psiExpected = 180;
psiActual = rad2deg(findHeadingFrom(origin, P));
fprintf('\tIIIa: psi = %d', psiExpected);
if (psiExpected ~= psiActual)
    fprintf('\t-- FAILED: got %d\n',psiActual);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Case IIIb
P = [-1 -1];
psiExpected = 225;
psiActual = rad2deg(findHeadingFrom(origin, P));
fprintf('\tIIIb: psi = %d', psiExpected);
if (psiExpected ~= psiActual)
    fprintf('\t-- FAILED: got %d\n',psiActual);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Results
fprintf('----------- ');
if (subTestsPassed ~= totalSubTests)
    fprintf('FAILED');
else
    fprintf('PASSED');
    testsPassed = testsPassed + 1;
end
fprintf(' -----------\n');

%% Case IV: 270 <= psi < 360
disp('Case IV: 270 <= psi < 360');
subTestsPassed = 0;
totalSubTests = 2;

% Case IVa
P = [-1 0];
psiExpected = 270;
psiActual = rad2deg(findHeadingFrom(origin, P));
fprintf('\tIVa: psi = %d', psiExpected);
if (psiExpected ~= psiActual)
    fprintf('\t-- FAILED: got %d\n',psiActual);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Case IVb
P = [-1 1];
psiExpected = 315;
psiActual = rad2deg(findHeadingFrom(origin, P));
fprintf('\tIVb: psi = %d', psiExpected);
if (psiExpected ~= psiActual)
    fprintf('\t-- FAILED: got %d\n',psiActual);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Results
fprintf('----------- ');
if (subTestsPassed ~= totalSubTests)
    fprintf('FAILED');
else
    fprintf('PASSED');
    testsPassed = testsPassed + 1;
end
fprintf(' -----------\n');

%% Boundaries
% TODO these...


%% Results
if (testsPassed ~= totalTests)
    fprintf('\n\nFAILED %i of %i tests\n\n',totalTests - testsPassed, totalTests);
else
    fprintf('\n\nPASSED %i of %i tests.\n\n', testsPassed, totalTests);
end
