% Investigates solutions to various coverage path plannng (CPP) scenarios.
% Test polygon data is read from loadCoveragePolygons.m
%
% David Goodman
% 2015.11.18

close all;
clear all;
clc;

%% =============== Dependencies ===============
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

%% =============== Settings ===============
%filenames = {['../data/triangle_polygon.dlm']};
%size = 3; % multiplier for polygon coordinates 
initialConfig = [0 0 0.0]; % initial position and headings [rad]

% % Vehicle settings
% Va = 10; % [m/s] fixed airspeed
% phi_max = degtorad(45); % [rad] maximum bank angle (+ and -)
% g = 9.8; % [m/s^2]
% h = 120; % [m] altitude
% % Camera settings
% fov1=0.6555; % [rad] y-direction
% fov2=0.8457; % [rad] x-direction
% % Reduced turn radius and width for visibility of costs in large scenarios
% Just hardcode for now
r = 23; % Va^2/(tan(phi_max)*g)
w = 160; % abs(2*h*tan(fov2/2))/(sin(pi + fov1/2));

% Path options
opts = PathOptions;
opts.SensorWidth = w; % coverage width (m)
opts.TurnRadius = r; % vehicle turn radius (m)

%opts.LineTolTheta = degtorad(0.5); % maximum nodes deviation from line fitting
%opts.LineStepTheta = degtorad(45); % step size for line fitting
opts.Circuit = 'on'; % include return to start configuration (node 1) in cost
opts.Debug = 'on'; % print debug information
%opts.MaximizeCost = 'off'; % solve for the worst case (maximization problem)
%opts.BruteForce = 'off'; % solve the true optimal problem with LP

% Plot settings
opts.ShowEdgeCosts = 'on';
opts.DubinsStepSize = 0.01; % [sec]
opts.EdgeArrowSize = 1;
opts.HeadingArrowSize = 0.10;

% Print options if debug is on
if strcmp(opts.Debug, 'on')
    opts
end

%% ============== Build Scenarios ============
startPosition = initialConfig(1:2);
startHeading = initialConfig(3);

loadCoveragePolygons;

% Another simple convex polygon
P =  Polygon([26.6357, 135.882;...
    -166.484, 146.488;...
    -195.627, -99.1082;...
    -71.6223, -331.982;...
     139.126, -258.175]);



for i=1:N
    
    % Plot polygon
    figure('units','normalized','outerposition',[0 0 1 1]);

    C = initialConfig;
    titleStr = sprintf('CPP Scenario');
   
    %md = normalizationCoeff([P; startPosition]);
    %Pn=P./md;
    %Cn=C./md;
    hAx = plotCoverageScenario(P, C, [2 2], 1, titleStr, opts);
    axis square;
    %plotWaypointHeadings(hAx, C(1:2), C(3), pathOptions);
    %hAx = plotWaypointScenario(V, [], [2 2], 1, titleStr, opts);
    %plotWaypointGrid(hAx, points, opts);
    pause(0.5) % need to pause or else annotations will shift
    
    %runCppAsDtspAlgorithms(P, C,opts);
    runCppAlgorithms(P, C,opts);
    
