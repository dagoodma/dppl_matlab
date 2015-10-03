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
% Vehicle settings
Va = 10; % (m/s) fixed airspeed
phi_max = degtorad(45); % (rad) maximum bank angle (+ and -)
g = 9.8; %(m/s^2)
h = 120; % (m) altitude
% Camera settings
fov1=0.6555; % [rad] y-direction
fov2=0.8457; % [rad] x-direction
% Reduced turn radius and width for visibility of costs in large scenarios
r = 1;
w = 3.5*r;

% Path options
opts = PathOptions;
opts.SensorWidth = w; %335; % abs(2*h*tan(fov2/2))/(sin(pi + fov1/2));
opts.TurnRadius = r; % Va^2/(tan(phi_max)*g); % (m) turn radius for dubins path

opts.LineTolTheta = degtorad(0.5); % maximum nodes deviation from line fitting
opts.LineStepTheta = degtorad(45); % step size for line fitting
opts.Circuit = 'on'; % include return to start configuration (node 1) in cost
opts.Debug = 'on'; % print debug information
opts.MaximizeCost = 'off'; % solve for the worst case (maximization problem)
opts.BruteForce = 'off'; % solve the true optimal problem with LP

% Plot settings
opts.ShowEdgeCosts = 'on';
opts.DubinsStepSize = 0.01; % [sec]
opts.EdgeArrowSize = 1;
opts.HeadingArrowSize = 0.15;

if strcmp(opts.Debug, 'on')
    opts
end

%% ============== Build Scenarios ============
w = opts.SensorWidth;
Vo = @(n) ones(n,2); % offset vector
Polygons = {[w*[0,0; 0,5; 5,5; 5,0] + Vo(4)*2*w],... % square
         [w*[0,0; 0,6; 3,6; 3,2; 3,0; 7,0;] + Vo(6)*2*w]}; % non-concave
N=length(Polygons);
startPosition = [0.0, 0.0];
startHeading = 0.0;

if strcmp(opts.Debug, 'on')
    fprintf('# %s is running %d scenario(s)...\n-------------------------------------\n',...
        mfilename, N);
end

for i=1:N

    % Find WPs in polygon
    P = Polygons{i};
    points=polygrid(P(:,1),P(:,2),1/(w^2));
    
    % Plot WPs
    figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(221);
    [n, ~] = size(points);
    V = [startPosition; points];
    titleStr = sprintf('%d WP Scenario', n);
    hAx = plotWaypointScenario(V, [], [2 2], 1, titleStr, opts);
    plotWaypointGrid(hAx, points, opts);
    pause(0.5) % need to pause or else annotations will shift
    
    %points = [startPosition; points];
    %points = Vo(length(points))*w/2 + points; % centroids
    %scatter(points(:,1), points(:,2));
    runDTSPAlgorithms(V, startHeading,opts);
    
end

