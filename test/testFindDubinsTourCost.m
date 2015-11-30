% FindDubinsTourLength Test
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
EPSILON_ERROR = 0.0005; % error margin in length calculation

Va = 10; % (m/s) fixed airspeed
phi_max = degtorad(45); % (rad) maximum bank angle (+ and -)
g = 9.8; %(m/s^2)

r = 1;

% Path options
opts = PathOptions;
%opts.TurnRadius = Va^2/(tan(phi_max)*g); % (m) turn radius for dubins path
opts.TurnRadius = r;
opts.DubinsStepSize = 0.0001; % [sec]
opts.HeadingArrowSize = 0.7;
opts.Debug = 'on';
opts.Circuit = 'off';
%=============== Tests ===============
fprintf('\n');
fh = figure();
testsPassed = 0;
totalTests = 2;



%% 3 Node tour with no returns
subplot(2,1,1);
% Define path
V = [0 0;
     5.1*r 0.0;
     5.1*r -3.3*r];
X = [0, deg2rad(180), deg2rad(270)];
E = [1 2;
     2 3;
     3 1];
%expectedLength = 16.623390656993465;
%expectedEdgeLengths = [6.24

[m, ~] = size(E);

m = m - 1 + strcmp(opts.Circuit, 'on'); % number of edges
hold on;
% Find expected tour cost from DubinsCurve lib
expectedTourCost = 0;
for i=1:m
    src_id = E(i,1);
    targ_id = E(i,2);
    V0 = V(src_id,:);
    V1 = V(targ_id,:);
    q0 = [V0 heading2angle(X(src_id))];
    q1 = [V1 heading2angle(X(targ_id))];
    
    path_i = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
    l_i = 0;
    for i=1:(length(path_i)-1)
        l_i = l_i + sqrt((path_i(1,i+1) - path_i(1,i))^2 + (path_i(2,i+1) - path_i(2,i))^2);
    end
    expectedTourCost = expectedTourCost + l_i;
    plot(path_i(1,1:end), path_i(2,1:end), 'Color', 'g');
    
    if strcmp(opts.Debug,'on')
        fprintf('Edge %d is %d -> %d, expectedCost=%0.5f\n',i,src_id,...
        targ_id, l_i);
    end
    
end % for

plot(V(:,1), V(:,2),'or');
hold off;

[actualTourCost, Eactual] = findDubinsTourCost(V,X,E,opts);

if strcmp(opts.Debug,'on')
    Eactual
end


% Results
result = actualTourCost;
resultExpected = expectedTourCost;
fprintf('ThreeNodeTour (c=%0.4f)\n',result);
if (abs(result - resultExpected) > EPSILON_ERROR)
    fprintf('\t-- FAILED: expected %.2f\n',resultExpected);
else
    fprintf('\t-- PASS\n');
    testsPassed = testsPassed + 1;
end



%% 3 Node tour with return edge
opts.Circuit = 'on';
subplot(2,1,2);
% Define path
V = [0 0;
     5.1*r 0.0;
     5.1*r -3.3*r];
X = [0, deg2rad(180), deg2rad(270)];
E = [1 2;
     2 3;
     3 1];
%expectedLength = 16.623390656993465;
%expectedEdgeLengths = [6.24

[m, ~] = size(E);

m = m - 1 + strcmp(opts.Circuit, 'on'); % number of edges
hold on;
% Find expected tour cost from DubinsCurve lib
expectedTourCost = 0;
for i=1:m
    src_id = E(i,1);
    targ_id = E(i,2);
    V0 = V(src_id,:);
    V1 = V(targ_id,:);
    q0 = [V0 heading2angle(X(src_id))];
    q1 = [V1 heading2angle(X(targ_id))];
    
    path_i = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
    l_i = 0;
    for i=1:(length(path_i)-1)
        l_i = l_i + sqrt((path_i(1,i+1) - path_i(1,i))^2 + (path_i(2,i+1) - path_i(2,i))^2);
    end
    expectedTourCost = expectedTourCost + l_i;
    plot(path_i(1,1:end), path_i(2,1:end), 'Color', 'g');
    
    if strcmp(opts.Debug,'on')
        fprintf('Edge %d is %d -> %d, expectedCost=%0.5f\n',i,src_id,...
        targ_id, l_i);
    end
    
end % for

plot(V(:,1), V(:,2),'or');
hold off;

[actualTourCost, Eactual] = findDubinsTourCost(V,X,E,opts);

if strcmp(opts.Debug,'on')
    Eactual
end


% Results
result = actualTourCost;
resultExpected = expectedTourCost;
fprintf('ThreeNodeTourReturns (c=%0.4f)\n',result);
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

