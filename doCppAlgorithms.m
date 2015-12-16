function [ ] = doCppAlgorithms( P, C, options)
%DOCPPALGORITHMS Solves the CPP problem.
% Plots solutions from various CPP algorithms: boustrophedon (only one
% currently) using the Dubins Path Planning Library (DPPL).
%
%   Parameters:
%       P       An n-by-2 matrix of polygon vertices.
%       C       Starting configuration, 3-by-1 vector
%       options Options for the scenario.
%
% David Goodman
% 2015.10.15

%% ================ Dependencies ===============

% Find all dependencies
% Add lib and class folders
addpath('lib','class');

%% ================== Solve =================

startPosition = C(1:2);
startHeading = C(3); % [rad]

subplotDim = options.SubPlotDim;

[n, ~] = size(P);

if strcmp(options.Debug, 'on')
    fprintf('## Testing coverage scenario with %d vertex polygon...\n\n', n);
end

% Graph title
fig = gcf;
uicontrol('Style', 'text',...
   'String', sprintf('CPP Solutions'),...
   'Units','normalized',...
   'FontSize',15,...
   'BackgroundColor', 'white',...
   'Position', [0.345 0.965 0.29 0.037]);

% ============== Boustrophedon  ======================
fprintf('Running Boustrophedon (C++) solver on CPP problem...\n');
tic;
[V, E, X, Cost] = solveCpp(P,C,options,'boustrophedon')

elapsedTime = toc;
c = Cost;
vertexOrder = getVertexOrder(E)

if strcmp(options.Debug,'on')
    fprintf(['Found Boustrophedon C++ solution with a total cost of %.2f in %.2f seconds.\n\n'],...
        c, elapsedTime);
end
titleStr = sprintf('Boustrophedon C++ (cost = %.2f)',c);
subplot(subplotDim(1),subplotDim(2),2);
plotWaypointScenario(V, E, options);
plotWaypointDubins(V, E, X, options); 
title(titleStr);
pause(0.5)

%print;

