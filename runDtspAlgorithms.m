function [ ] = runDtspAlgorithms( V, x, options)
%RUNDTSPALGORITHMS Solves the DTSP with 3 different solvers.
% Plots solutions from various DTSP PTAS algorithms: nearest neighbor (greedy
% point-to-point), alternating algorithm, randomized algorithm using the 
% Dubins Path Planner (DPP) solver.
%
%   Parameters:
%       V       An n-by-2 matrix of vertices to visit.
%       x       Starting heading.
%       options Options for the scenario.
%
% David Goodman
% 2015.10.03

%% ================ Dependencies ===============

% Find all dependencies
% Add lib and class folders
addpath('lib','class');

%% ================== Solve =================

startPosition = V(1,:);
startHeading = x; % [rad]

subplotDim = [2 2]; 

sortrows(V,[-2 1]); % sort by y descending, then by x ascending
[n, ~] = size(V);

if strcmp(options.Debug, 'on')
    fprintf('## Testing scenario with %d waypoints...\n\n', n);
end

% Graph title
%figure('units','normalized','outerposition',[0 0 1 1])
%fig = plotWaypointScenario(V, [], subplotDim, 1, titleStr, options);
fig = gcf;
uicontrol('Style', 'text',...
   'String', sprintf('DTSP Solutions'),...
   'Units','normalized',...
   'FontSize',15,...
   'BackgroundColor', 'white',...
   'Position', [0.345 0.965 0.29 0.037]);

% ============== Nearest Neighbor (greedy PTP) ======================
fprintf('Running Nearest Neighbor (C++) solver...\n');
tic;
[E, X, Cost] = solveDtsp(V,startHeading,options,'nearest')

elapsedTime = toc;
c = Cost;
vertexOrder = getVertexOrder(E)

if strcmp(options.Debug,'on')
    fprintf(['Found Nearest Neighbor C++ solution with a total cost of %.2f in %.2f seconds.\n\n'],...
        c, elapsedTime);
end
titleStr = sprintf('Nearest Neighbor C++ (cost = %.2f)',c);
hAx = plotWaypointScenario(V, E, subplotDim, 2, titleStr, options);
plotWaypointDubins(hAx, V, E, X, options); 


% ============== Alternating Algorithm (DTSP) ======================

fprintf('Running Alternating Algorithm (C++) solver...\n');
tic;
[E, X, Cost] = solveDtsp(V,startHeading,options,'alternating');

elapsedTime = toc;
c = Cost;
vertexOrder = getVertexOrder(E);

if strcmp(options.Debug,'on')
    fprintf(['Found Alternating Algorithm C++ solution with a total cost of %.2f in %.2f seconds.\n\n'],...
        c, elapsedTime);
end
titleStr = sprintf('Alternating C++ (cost = %.2f)',c);
hAx = plotWaypointScenario(V, E, subplotDim, 3, titleStr, options);
plotWaypointDubins(hAx, V, E, X, options); 

% ============== Randomized Algorithm (DTSP) ======================

fprintf('Running Randomized Algorithm (C++) solver...\n');
tic;
[E, X, Cost] = solveDtsp(V,startHeading,options,'randomized');

elapsedTime = toc;
c = Cost;
vertexOrder = getVertexOrder(E);
findDubinsTourCost(V,X,E,options);

if strcmp(options.Debug,'on')
    fprintf(['Found Randomized Algorithm C++ solution with a total cost of %.2f in %.2f seconds.\n\n'],...
        c, elapsedTime);
end
titleStr = sprintf('Randomized C++ (cost = %.2f)',c);
hAx = plotWaypointScenario(V, E, subplotDim, 4, titleStr, options);
plotWaypointDubins(hAx, V, E, X, options); 

