%% Greedy point to point and line to line solution comparison
% Compares greedy PTP with brute force PTP for various scenarios.
%
% 2015.01.13

close all;
clear all;
clc;
% Add graph theory toolbox
if exist('grBase') ~= 2
    if exist('GrTheory') ~= 7
        error('Could not find the GrTheory folder.');
    end
    addpath('GrTheory');
end
% Add Dubins plot tool
if exist('dubins') ~= 3
    if exist('DubinsPlot') ~= 7
        error('Could not find the DubinsPlot folder.');
    end
    addpath('DubinsPlot');
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
opts.LineTolTheta = degtorad(0.5);
opts.LineStepTheta = degtorad(45);
opts.TurnRadius = Va^2/(tan(phi_max)*g); % (m) turn radius for dubins path
opts.Circuit = 'on';
opts.Debug = 'on';
opts.MaximizeCost = 'off';
opts.BruteForce = 'off';

if strcmp(opts.Debug, 'on')
    opts
end

% Plot settings
subplotDim = [2 2]; 
opts.ShowEdgeCosts = 'on';
opts.DubinsStepSize = 0.01; % [sec]
opts.EdgeArrowSize = 1;
opts.HeadingArrowSize = 0.15;

% Camera/sensor settings (assumes Theta_v = Theta_h)
Theta_horizontal = deg2rad(57.8); % [rad]
Theta_vertical = Theta_horizontal;
h = 120; % [m] altitude
A = (h*sin(Theta_horizontal)) * (h*sin(Theta_vertical)); % [m^2]

%================= Waypoints =================
% Create a triangle
triangleSize = 500;% [m]
xv = [0 1 0]' * triangleSize;
yv = [0 0 -10]' * triangleSize;
waypoints = polygrid(xv, yv, 1/A);

%plot(inPoints(:, 1),inPoints(:,2), '.k');

% Start position
startPosition = [0 -1]*triangleSize;
startHeading = 0; % [rad]
C = [startPosition, startHeading];

%waypoints = [xv, yv];
%waypointList = {[3,0; 3,-2]*50}; % 2 WPS
%waypointList = {[3,0; 5,0; 3,-2]*50}; % 3 WPS
%waypointList = {[3,0; 5,0; 3,-2; 5,-2 ]*50};


if strcmp(opts.Debug, 'on')
    fprintf('# %s is running triangle (%i meter) scenario...\n-------------------------------------\n',...
        mfilename, triangleSize);
end

%========================= Start ==============================
waypoints
V = sort(waypoints,2,'descend')
[n, ~] = size(V);

if strcmp(opts.Debug, 'on')
    fprintf('## Solving scenario with %d waypoints...\n\n',...
        n);
end
%%% Point to Point
%%=============== Initial Graph ===============
%figure('units','normalized','outerposition',[0 0 1 1])
%titleStr = sprintf('%d WP Scenario', n);
%fig = plotWaypointScenario(V, [], C, subplotDim, 1, titleStr, opts);
%uicontrol('Style', 'text',...
%   'String', sprintf('Point to Point Solutions'),...
%   'Units','normalized',...
%   'FontSize',15,...
%   'BackgroundColor', 'white',...
%   'Position', [0.345 0.965 0.29 0.037]);
%pause(0.5)
%
%%=================== Solve ==================
%% Greedy PTP Solution
%tic;
%[E, X, Cost] = solveGreedyPointToPoint(C,V,opts);
%c = Cost(1);
%vertexOrder = getVertexOrder(E)
%elapsedTime = toc;
%
%if strcmp(opts.Debug,'on')
%    fprintf(['Found greedy PTP solution with a total cost of %.2f in %.2f seconds.\n\n'],...
%        c, elapsedTime);
%end
%titleStr = sprintf('Greedy Solution (cost = %.2f)',c);
%hAx = plotWaypointScenario(V, E, C, subplotDim, 2, titleStr, opts);
%plotWaypointDubins(hAx, V, E, X, C, opts);
%
%% Brute force PTP Solution
%if strcmp(opts.BruteForce, 'on')
%    % best
%    opts.MaximizeCost = 'off';
%    tic;
%    [E, X, Cost] = solveBruteforcePointToPoint(C,V,opts);
%    c = Cost(1);
%    vertexOrder = getVertexOrder(E)
%    if strcmp(opts.Debug,'on')
%        disp('Best headings:')
%        % Reorder X to match E
%        Xhat = reorderHeadingsFromEdges(V, E, X, opts);
%        rad2deg(Xhat)
%    end
%   
%    elapsedTime = toc;
%
%    if strcmp(opts.Debug,'on')
%        fprintf(['Found brute force PTP solution with a total cost of %.2f in %.2f seconds.\n\n'],...
%            c, elapsedTime);
%    end
%    titleStr = sprintf('Brute Force Solution (cost = %.2f)',c);
%    hAx = plotWaypointScenario(V, E, C, subplotDim, 4, titleStr, opts, Cost(2), Cost(3));
%    plotWaypointDubins(hAx, V, E, X, C, opts);
%    
%    % worst
%    opts.MaximizeCost = 'on';
%    [E, X, Cost] = solveBruteforcePointToPoint(C,V,opts);
%    c = Cost(1);
%    vertexOrder = getVertexOrder(E)
%    if strcmp(opts.Debug,'on')
%        disp('Worst headings:')
%        % Reorder X to match E
%        Xhat = reorderHeadingsFromEdges(V, E, X, opts);
%        rad2deg(Xhat)
%    end
%    
%    if strcmp(opts.Debug,'on')
%        fprintf(['Found worst brute force PTP solution with a total cost of %.2f in %.2f seconds.\n\n'],...
%            c, elapsedTime);
%    end
%    titleStr = sprintf('Brute Force Solution worst-case (cost = %.2f)',c);
%    hAx = plotWaypointScenario(V, E, C, subplotDim, 3, titleStr, opts, Cost(2), Cost(3));
%    plotWaypointDubins(hAx, V, E, X, C, opts);
%    
%end % end of PTP brute force

%% Line to Line
%=============== Initial Graph ===============
figure();
titleStr = sprintf('%d WP Scenario', n);
fig = plotWaypointScenario(V, [], C, subplotDim, 1, titleStr, opts);
uicontrol('Style', 'text',...
   'String', sprintf('Line to Line Solutions'),...
   'Units','normalized',...
   'FontSize',15,...
   'BackgroundColor', 'white',...
   'Position', [0.345 0.965 0.29 0.037]);

%=================== Solve ==================
% Greedy LTL Solution
tic;
V = sort(V,2);
[E, X, Cost] = solveGreedyLineToLine(C,V,opts);
c = Cost(1);

elapsedTime = toc;

if strcmp(opts.Debug,'on')
    fprintf(['Found greedy LTL solution with a total cost of %.2f in %.2f seconds.\n\n'],...
        c, elapsedTime);
end
titleStr = sprintf('Greedy Solution (cost = %.2f)',c);
hAx = plotWaypointScenario(V, E, C, subplotDim, 2, titleStr, opts, Cost(2), Cost(3));
plotWaypointDubins(hAx, V, E, X, C, opts);

% Brute Force LTL Solution
if strcmp(opts.BruteForce, 'on')
    tic;
    [E, X, Cost] = solveBruteforceLineToLine(C,V,opts);
    c = Cost(1);
    elapsedTime = toc;
    
    if strcmp(opts.Debug,'on')
        fprintf(['Found brute force LTL solution with a total cost of %.2f in %.2f seconds.\n\n'],...
            c, elapsedTime);
    end
    titleStr = sprintf('Brute force Solution (cost = %.2f)',c);
    hAx = plotWaypointScenario(V, E, C, subplotDim, 4, titleStr, opts, Cost(2), Cost(3));
    plotWaypointDubins(hAx, V, E, X, C, opts);
end
