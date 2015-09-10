%% Greedy point to point and line to line solution comparison
% Compares greedy PTP with brute force PTP for various scenarios.
%
% 2014.09.30

close all;
clear all;
clc;

%% Find all dependencies
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


%================= Waypoints =================
startPosition = [0 0];
startHeading = 0; % [rad]
C = [startPosition, startHeading];

% Load the waypoint list

%waypointList = 
%waypointList = {[3,0; 3,-2]*50}; % 2 WPS
%waypointList = {[3,0; 5,0; 3,-2]*50}; % 3 WPS
%waypointList = {[3,0; 5,0; 3,-2; 5,-2 ]*50};

% 2 and 3 WP
%waypointList = {[3,0; 3,-2]*50,...
%                 [3,0; 5,0; 3,-2]*50};

% 4 WP, version 1
%waypointList = {[3,0; 5,0; 3,-2; 5,-2 ]*50};

% 5 WP, version 1
waypointList = {[3,0; 5,0; 7,0; 9,0; 3,-2 ]*50};

% 5 WP, version 2
%waypointList = {[3,0; 5,0; 3,-2; 5,-2; 3,-4]*50};


%waypointList = {[3,0; 5,0; 7,0; 9,0; 3,-2; 5,-2; 7,-2; 3,-4]*50};

% 
% waypointList = {[3,0; 5,0; 7,0; 3,-2; 5,-2; 3,-4]*50,...
%                 [3,0; 5,0; 3,-2]*50,...
%                 [3,0; 5,0; 7,0; 9,0; 3,-2; 5,-2; 7,-2; 3,-4]*50};

% 225 WP
% n = 15;
% wp = zeros(n^2,2);
% idx = n^2;
% for i=1:n
% 	for j=1:n
% 		wp(idx,:) = [j i];
% 		idx = idx - 1;
% 	end
% end
% wp=wp*50;
% waypointList={wp};


[~,scenarioCount] = size(waypointList);

if strcmp(opts.Debug, 'on')
    fprintf('# %s is running %d scenario(s)...\n-------------------------------------\n',...
        mfilename, scenarioCount);
end

for k=1:scenarioCount

    V = waypointList{k};
    sortrows(V,[-2 1]); % sort by y descending, then by x ascending
    V
    [n, ~] = size(V);

    if strcmp(opts.Debug, 'on')
        fprintf('## Solving scenario with %d waypoints...\n\n',...
            n);
    end
    %% Point to Point
    %=============== Initial Graph ===============
    figure('units','normalized','outerposition',[0 0 1 1])
    titleStr = sprintf('%d WP Scenario', n);
    fig = plotWaypointScenario(V, [], C, subplotDim, 1, titleStr, opts);
    uicontrol('Style', 'text',...
       'String', sprintf('Point to Point Solutions'),...
       'Units','normalized',...
       'FontSize',15,...
       'BackgroundColor', 'white',...
       'Position', [0.345 0.965 0.29 0.037]);
    pause(0.5)
   
    %=================== Solve ==================
    % Greedy PTP Solution
    tic;
    [E, X, Cost] = solveGreedyPointToPoint(C,V,opts);
    c = Cost(1);
    vertexOrder = getVertexOrder(E)
    elapsedTime = toc;

    if strcmp(opts.Debug,'on')
        fprintf(['Found greedy PTP solution with a total cost of %.2f in %.2f seconds.\n\n'],...
            c, elapsedTime);
    end
    titleStr = sprintf('Greedy Solution (cost = %.2f)',c);
    hAx = plotWaypointScenario(V, E, C, subplotDim, 2, titleStr, opts);
    plotWaypointDubins(hAx, V, E, X, C, opts);
    
    % Brute force PTP Solution
 if strcmp(opts.BruteForce, 'on')
    % best
    opts.MaximizeCost = 'off';
    tic;
    [E, X, Cost] = solveBruteforcePointToPoint(C,V,opts);
    c = Cost(1);
    vertexOrder = getVertexOrder(E)
    if strcmp(opts.Debug,'on')
        disp('Best headings:')
        % Reorder X to match E
        Xhat = reorderHeadingsFromEdges(V, E, X, opts);
        rad2deg(Xhat)
    end
   
    elapsedTime = toc;

    if strcmp(opts.Debug,'on')
        fprintf(['Found brute force PTP solution with a total cost of %.2f in %.2f seconds.\n\n'],...
            c, elapsedTime);
    end
    titleStr = sprintf('Brute Force Solution (cost = %.2f)',c);
    hAx = plotWaypointScenario(V, E, C, subplotDim, 4, titleStr, opts, Cost(2), Cost(3));
    plotWaypointDubins(hAx, V, E, X, C, opts);
    
    % worst
    opts.MaximizeCost = 'on';
    [E, X, Cost] = solveBruteforcePointToPoint(C,V,opts);
    c = Cost(1);
    vertexOrder = getVertexOrder(E)
    if strcmp(opts.Debug,'on')
        disp('Worst headings:')
        % Reorder X to match E
        Xhat = reorderHeadingsFromEdges(V, E, X, opts);
        rad2deg(Xhat)
    end
    
    if strcmp(opts.Debug,'on')
        fprintf(['Found worst brute force PTP solution with a total cost of %.2f in %.2f seconds.\n\n'],...
            c, elapsedTime);
    end
    titleStr = sprintf('Brute Force Solution worst-case (cost = %.2f)',c);
    hAx = plotWaypointScenario(V, E, C, subplotDim, 3, titleStr, opts, Cost(2), Cost(3));
    plotWaypointDubins(hAx, V, E, X, C, opts);
    
 end
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

end
