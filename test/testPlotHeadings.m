%% Greedy point to point and line to line solution comparison
% Compares greedy PTP with brute force PTP for various scenarios.
%
% 2014.09.30

clear all;
close all;

% Add root
addpath('..')
% Add graph theory toolbox
if exist('grBase') ~= 2
    if exist('GrTheory') ~= 7
        error('Could not find the GrTheory folder.');
    end
    addpath('GrTheory');
end

%=============== Settings ===============
Va = 10; % (m/s) fixed airspeed
phi_max = degtorad(45); % (rad) maximum bank angle (+ and -)

% Path options
opts = PathOptions;
opts.LineTolTheta = degtorad(0.5);
opts.LineStepTheta = degtorad(45);
opts.TurnRadius = Va^2/(phi_max); % (m) turn radius for dubins path
opts.Circuit = 'on';
opts.Debug = 'on';
opts.MaximizeCost = 'off';
opts.BruteForce = 'on';

if strcmp(opts.Debug, 'on')
    opts
end

% Plot settings
arrowSize = 1;
headingLineSize = 0.2;
subplotDim = [2 2];
showEdgeCost = 0;


%================= Waypoints =================
startPosition = [0 0];
startHeading = 0; % [rad]
C = [startPosition, startHeading];

waypointList = {[3,0; 3,-2]*500}; % 2 WPS
%waypointList = {[3,0; 5,0; 3,-2]*500}; % 3 WPS

% 2 and 3 WP
%waypointList = {[3,0; 3,-2]*500,...
%                 [3,0; 5,0; 3,-2]*500};

% 4 WP, version 1
%waypointList = {[3,0; 5,0; 3,-2; 5,-2 ]*500};

% 5 WP, version 1
%waypointList = {[3,0; 5,0; 7,0; 9,0; 3,-2 ]*500};

% 5 WP, version 2
%waypointList = {[3,0; 5,0; 3,-2; 5,-2; 3,-4]*500};


%waypointList = {[3,0; 5,0; 7,0; 9,0; 3,-2; 5,-2; 7,-2; 3,-4]*500};

% 
% waypointList = {[3,0; 5,0; 7,0; 3,-2; 5,-2; 3,-4]*500,...
%                 [3,0; 5,0; 3,-2]*500,...
%                 [3,0; 5,0; 7,0; 9,0; 3,-2; 5,-2; 7,-2; 3,-4]*500};

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
% wp=wp*500;
% waypointList={wp};


[~,scenarioCount] = size(waypointList);

if strcmp(opts.Debug, 'on')
    fprintf('# %s is running %d scenario(s)...\n-------------------------------------\n',...
        mfilename, scenarioCount);
end

for k=1:scenarioCount

    V = waypointList{k};
    [n, ~] = size(V);

    if strcmp(opts.Debug, 'on')
        fprintf('## Solving scenario with %d waypoints...\n\n',...
            n);
    end
    %% Point to Point
    %=============== Initial Graph ===============
    figure('units','normalized','outerposition',[0 0 1 1])
    %figure()
    titleStr = sprintf('%d WP Scenario', n);
    hAx = plotWaypoints(V, [], C, subplotDim, 1, arrowSize, titleStr, opts);
    uicontrol('Style', 'text',...
       'String', sprintf('Point to Point Solutions'),...
       'Units','normalized',...
       'FontSize',15,...
       'BackgroundColor', 'white',...
       'Position', [0.345 0.965 0.29 0.037]);
    pause(3)
   
    X = [0 (pi/2+0.01) (pi-0.01)]'
    rad2deg(X)
    plotWaypointHeadings(hAx, V, X, C, headingLineSize, opts);
end
