% Investigates solutions to various scenarios with PTAS algorithms.
%
% David Goodman
% 2015.10.02

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
filenames = {['../data/triangle_polygon.dlm']};
size = 3; % multiplier for polygon coordinates 
initialConfig = [0 0 4.7]; % initial position and headings [rad]

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
r = 1; % Va^2/(tan(phi_max)*g)
w = 3.5*r; % abs(2*h*tan(fov2/2))/(sin(pi + fov1/2));

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

N=length(filenames);

if strcmp(opts.Debug, 'on')
    fprintf('# %s is running %d scenario(s)...\n-------------------------------------\n',...
        mfilename, N);
end

for i=1:N

    % Find WPs in polygon, loaded from file
    P = readMatrixFile(filenames{i}) * size * opts.TurnRadius;
    
    % Plot polygon
    figure('units','normalized','outerposition',[0 0 1 1]);

    C = initialConfig;
    titleStr = sprintf('CPP Scenario');
   
    %md = normalizationCoeff([P; startPosition]);
    %Pn=P./md;
    %Cn=C./md;
    hAx = plotCoverageScenario(P, C, [2 2], 1, titleStr, opts);
    %plotWaypointHeadings(hAx, C(1:2), C(3), pathOptions);
    %hAx = plotWaypointScenario(V, [], [2 2], 1, titleStr, opts);
    %plotWaypointGrid(hAx, points, opts);
    pause(0.5) % need to pause or else annotations will shift
    
    runCppAsDtspAlgorithms(P, C,opts);
    
end

