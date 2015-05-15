clear all;
close all;

% Add root
addpath('..')
if exist('findTrajectoryLines') ~= 2
    error('Could not find findTrajectoryLines()');
end

%============== Setup ===============

%=============== Test ===============
testsPassed = 0;
totalTests = 4;

%% Single vertex
V=[0 0];
disp('Single vertex');
subTestsPassed = 0;
totalSubTests = 5;

% Count
L = findTrajectoryLines(V,0);
result = length(L);
resultExpected = 1;
fprintf('\tCount: %i', result);
if (result ~= resultExpected)
    fprintf('\t\t-- FAILED: expected %d\n',resultExpected);
else
    fprintf('\t\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Is TrajectoryLine
result = class(L(1));
resultExpected = 'TrajectoryLine';
fprintf('\tClass: %s',result);
if (~strcmp(result,resultExpected))
    fprintf('\t-- FAILED: expected %s\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Length
line = L(1);
result = line.Length;
resultExpected = 0;
fprintf('\tLength: %i',result);
if (result ~= resultExpected)
    fprintf('\t\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Get next is 1
result = line.getNext();
resultExpected = 1;
fprintf('\tFirst vertex: %i',result);
if (result ~= resultExpected)
    fprintf('\t\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Heading is 0
result = line.Heading;
resultExpected = 0;
fprintf('\tHeading: %.2f',result);
if (result ~= resultExpected)
    fprintf('\t\t-- FAILED: expected %.2f\n', resultExpected);
else
    fprintf('\t\t-- PASS\n');
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

%% Two vertices (Quadrant I/IV)
disp('Two vertices (Quadrant I/IV)');
subTestsPassed = 0;
totalSubTests = 8;

% Psi = 0, count
V = [0 0;
     1 0];

L = findTrajectoryLines(V,pi/2,0);
result = length(L);
resultExpected = 1;
fprintf('\tPsi = pi/2, count: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %d\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = 0, length
line = L(1);
result = line.Length;
resultExpected = 1;
fprintf('\tLength: %i',result);
if (result ~= resultExpected)
    fprintf('\t\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = 0, heading
result = line.Heading;
resultExpected = pi/2;
fprintf('\tHeading: %.2f',result);
if (result ~= resultExpected)
    fprintf('\t\t-- FAILED: expected %.2f\n', resultExpected);
else
    fprintf('\t\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Ordered
result = mat2str(line.VertexIndices);
resultExpected = '[1 2]';
fprintf('\tVertex order: %s',result);
if (~strcmp(result,resultExpected))
    fprintf('\t-- FAILED: expected %s\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = pi, count = 2
L = findTrajectoryLines(V,pi,0);
result = length(L);
resultExpected = 2;
fprintf('\tPsi = pi, count: %i',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = pi, heading = 0
% SKIP if last test failed
skip = 0;
if (result ~= resultExpected)
    skip = 1;
    resultStr = '';
else
    result = (L(1).Heading == pi) && (L(2).Heading == pi);
    resultExpected = 1;
    resultStr = 'yes'; if (~result) resultStr = 'no'; end
    resultExpectedStr = 'yes'; if (~resultExpected) resultExpectedStr = 'no'; end
end
fprintf('\tPsi = pi, heading: %s', resultStr);
if (skip)
    fprintf('-- SKIP\n');
elseif (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpectedStr);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = 3*pi/4, count = 2
L = findTrajectoryLines(V,3*pi/4,0);
result = length(L);
resultExpected = 2;
fprintf('\tPsi = 3*pi/4, count: %i',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% SKIP if last test failed
skip = 0;
if (result ~= resultExpected)
    skip = 1;
    resultStr = '';
else
    result = (L(1).Heading == 3*pi/4) && (L(2).Heading == 3*pi/4);
    resultExpected = 1;
    resultStr = 'y'; if (~result) resultStr = 'n'; end
    resultExpectedStr = 'y'; if (~resultExpected) resultExpectedStr = 'n'; end
end
fprintf('\tPsi = 3*pi/4, heading: %s', resultStr);
if (skip)
    fprintf('-- SKIP\n');
elseif (result ~= resultExpected)
    fprintf('-- FAILED: expected %s\n', resultExpectedStr);
else
    fprintf('-- PASS\n');
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


%% Two vertices (Quadrant IV)
disp('Two vertices (Quadrant IV)');
subTestsPassed = 0;
totalSubTests = 6;

% Psi = 3*pi/4, count
V = [0 0;
     3 -3];

L = findTrajectoryLines(V,3*pi/4,0);
result = length(L);
resultExpected = 1;
fprintf('\tPsi = 3*pi/4, count: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %d\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = 3*pi/4, length
line = L(1);
result = line.Length;
resultExpected = 1;
fprintf('\tLength: %i',result);
if (result ~= resultExpected)
    fprintf('\t\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = 3*pi/4, heading
result = line.Heading;
resultExpected = 3*pi/4;
fprintf('\tHeading: %.2f',result);
if (result ~= resultExpected)
    fprintf('\t\t-- FAILED: expected %.2f\n', resultExpected);
else
    fprintf('\t\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Ordered
result = mat2str(line.VertexIndices);
resultExpected = '[1 2]';
fprintf('\tVertex order: %s',result);
if (~strcmp(result,resultExpected))
    fprintf('\t-- FAILED: expected %s\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = pi, count = 2
L = findTrajectoryLines(V,pi,0);
result = length(L);
resultExpected = 2;
fprintf('\tPsi = pi, count: %i',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = pi, heading = 0
% SKIP if last test failed
skip = 0;
if (result ~= resultExpected)
    skip = 1;
    resultStr = '';
else
    result = (L(1).Heading == pi) && (L(2).Heading == pi);
    resultExpected = 1;
    resultStr = 'yes'; if (~result) resultStr = 'no'; end
    resultExpectedStr = 'yes'; if (~resultExpected) resultExpectedStr = 'no'; end
end
fprintf('\tPsi = pi, heading: %s', resultStr);
if (skip)
    fprintf('\t-- SKIP\n');
elseif (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpectedStr);
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


%% Two vertices (Quadrant III/IV)
disp('Two vertices (Quadrant III/IV)');
subTestsPassed = 0;
totalSubTests = 8;

% Psi = 0, count
V = [0 0;
     0 -1];
L = findTrajectoryLines(V,0,0);
result = length(L);
resultExpected = 1;
fprintf('\tPsi = 0, count: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %d\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = 0, length
line = L(1);
result = line.Length;
resultExpected = 1;
fprintf('\tLength: %i',result);
if (result ~= resultExpected)
    fprintf('\t\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = 0, heading
result = line.Heading;
resultExpected = 0;
fprintf('\tHeading: %.2f',result);
if (result ~= resultExpected)
    fprintf('\t\t-- FAILED: expected %.2f\n', resultExpected);
else
    fprintf('\t\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Ordered
result = mat2str(line.VertexIndices);
resultExpected = '[1 2]';
fprintf('\tVertex order: %s',result);
if (~strcmp(result,resultExpected))
    fprintf('\t-- FAILED: expected %s\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = pi/2, count = 2
L = findTrajectoryLines(V,pi/2,0);
result = length(L);
resultExpected = 2;
fprintf('\tPsi = pi/2, count: %i',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = pi/2, heading = pi/2
% SKIP if last test failed
skip = 0;
if (result ~= resultExpected)
    skip = 1;
    resultStr = '';
else
    result = (L(1).Heading == pi/2) && (L(2).Heading == pi/2);
    resultExpected = 1;
    resultStr = 'yes'; if (~result) resultStr = 'no'; end
    resultExpectedStr = 'yes'; if (~resultExpected) resultExpectedStr = 'no'; end
end
fprintf('\tPsi = pi/2, heading: %s', resultStr);
if (skip)
    fprintf('-- SKIP\n');
elseif (result ~= resultExpected)
    fprintf('-- FAILED: expected %s\n', resultExpectedStr);
else
    fprintf('-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = pi, count = 1
L = findTrajectoryLines(V,pi,0);
result = length(L);
resultExpected = 1;
fprintf('\tPsi = pi, count: %i',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Psi = pi, heading = 0
line = L(1);
result = line.Heading;
resultExpected = pi;
fprintf('\tPsi = pi, heading: %.2f',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %.2f\n', resultExpected);
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




%% Overall Results
if (testsPassed ~= totalTests)
    fprintf('\n\nFAILED %i of %i tests\n\n',totalTests - testsPassed, totalTests);
else
    fprintf('\n\nPASSED %i of %i tests.\n\n', testsPassed, totalTests);
end


