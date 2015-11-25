function [V, E, X, Cost] = solveCpp(P,C,pathOptions,algorithm)
%solveCpp Solves the coverage scenario with DPP CPP solver.
%
%   Parameters:
%       P           Set of vertices n-by-2
%       C           Start position and heading [rad] 3-by-1
%       pathOptions Options for solver (uses TurnRadius, SensorWidth, Circuit)
%       [algorithm] Algorithm name ('boustrophedon')
%   Returns:
%       E       m-by-2 set of edges representing the tour
%       X       n-by-1 vector of headings at each vertex
%       Cost    The total cost of the solution
%
%   Note: m = n-1 if Circuit is 'off'

% Find all dependencies
% Add lib and class folders
addpath('lib','class');

% Add nearest neighbor MEX
if exist('dppSolveCpp') ~= 3
    if exist('lib/DubinsPathPlanner') ~= 7
        error('Could not find the DubinsPathPlanner folder.');
    end
    addpath('lib/DubinsPathPlanner');
    if exist('dppSolveCpp') ~= 3
        error('Could not find compiled dppSolveCpp mex file.');
    end
end

% Call the MEX file
r = pathOptions.TurnRadius;
e = pathOptions.SensorWidth;
returnToInitial = 1;
extraArgs = {};

if (strcmp(pathOptions.Circuit,'off'))
    returnToInitial = 0;
    extraArgs = {returnToInitial};
end
if nargin > 3
    extraArgs = {returnToInitial, algorithm};
end

C
[V, E, X, Cost] = dppSolveCpp(P, C, r, e, extraArgs{:});

end

