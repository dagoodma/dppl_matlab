function [ ] = runPTASAlgorithms( V, x, options)
%RUNPTASALGORITHMS Find the length of the shortest Dubins path
% Plots solutions from various PTAS algorithms: nearest neighbor (greedy
% point-to-point) in MATLAB and CPP, alternating algorithm in CPP, nearest
% neighbor with line fitting (greedy line to line).
%
%   Parameters:
%       V       An n-by-2 matrix of vertices to visit.
%       x       Starting heading.
%       options Options for the scenario.
%
% David Goodman
% 2015.09.12

USE_CPP_SOLVER = 1; % C++ solvers

%% ================ Dependencies ===============

% Find all dependencies
% Add lib and class folders
addpath('lib','class');

% Add graph theory toolbox
if exist('grBase') ~= 2
    if exist('lib/GrTheory') ~= 7
        error('Could not find the GrTheory folder.');
    end
    addpath('lib/GrTheory');
end

% Add Dubins plot tool
if exist('dubins') ~= 3
    if exist('lib/DubinsPlot') ~= 7
        error('Could not find the DubinsPlot folder.');
    end
    addpath('lib/DubinsPlot');
    if exist('dubins') ~= 3
        error('Could not find compiled dubins mex file.');
    end
end

% TODO add checks for c++ solvers

%% ================== Solver =================

startPosition = V(1,:);
startHeading = x; % [rad]

subplotDim = [2 2]; 

sortrows(V,[-2 1]); % sort by y descending, then by x ascending
[n, ~] = size(V);

if strcmp(options.Debug, 'on')
    fprintf('## Testing scenario with %d waypoints...\n\n', n);
end

% Initial Graph
%figure('units','normalized','outerposition',[0 0 1 1])
%fig = plotWaypointScenario(V, [], subplotDim, 1, titleStr, options);
fig = gcf;
uicontrol('Style', 'text',...
   'String', sprintf('Point to Point Solutions'),...
   'Units','normalized',...
   'FontSize',15,...
   'BackgroundColor', 'white',...
   'Position', [0.345 0.965 0.29 0.037]);

% ============== Nearest Neighbor (greedy PTP) ======================

% Run solvers
% Call MATLAB solver
fprintf('Running Nearest Neighbor (MATLAB) Greedy PTP solver...\n');
tic;
[E, X, Cost] = solveGreedyPointToPoint(V,startHeading,options);
elapsedTime = toc;
c = Cost;
vertexOrder = getVertexOrder(E);

if strcmp(options.Debug,'on')
    fprintf(['Found nearest neighbor solution with a total cost of %.2f in %.2f seconds.\n\n'],...
        c, elapsedTime);
end
titleStr = sprintf('Nearest Neighbor MATLAB (cost = %.2f)',c);
hAx = plotWaypointScenario(V, E, subplotDim, 2, titleStr, options);
plotWaypointDubins(hAx, V, E, X, options);

% Call CPP solver
if USE_CPP_SOLVER
fprintf('Running Nearest Neighbor (CPP) solver...\n');
tic;
[E, X, Cost] = solveNearestNeighborCPP(V,startHeading,options);
%[E, X, Cost] = solveAlternatingCPP(V,startHeading,options)

elapsedTime = toc;
c = Cost;
vertexOrder = getVertexOrder(E);

if strcmp(options.Debug,'on')
    fprintf(['Found Nearest Neighbor CPP solution with a total cost of %.2f in %.2f seconds.\n\n'],...
        c, elapsedTime);
end
titleStr = sprintf('Nearest Neighbor CPP (cost = %.2f)',c);
hAx = plotWaypointScenario(V, E, subplotDim, 3, titleStr, options);
plotWaypointDubins(hAx, V, E, X, options); 
end

% ============== Alternating Algorithm (DTSP) ======================

% Call CPP solver
if USE_CPP_SOLVER
fprintf('Running Alternating Algorithm (CPP) solver...\n');
tic;
[E, X, Cost] = solveAlternatingCPP(V,startHeading,options);
%[E, X, Cost] = solveAlternatingCPP(V,startHeading,options)

elapsedTime = toc;
c = Cost;
vertexOrder = getVertexOrder(E);

if strcmp(options.Debug,'on')
    fprintf(['Found Alternating Algorithm CPP solution with a total cost of %.2f in %.2f seconds.\n\n'],...
        c, elapsedTime);
end
titleStr = sprintf('Alternating CPP (cost = %.2f)',c);
hAx = plotWaypointScenario(V, E, subplotDim, 4, titleStr, options);
plotWaypointDubins(hAx, V, E, X, options); 
end

    
end
