function [E, X, Cost] = solveDtsp(V,x,pathOptions,algorithm)
%solveDtsp Solves the DTSP with the DPP solver.
%
%   Parameters:
%       V           Set of vertices n-by-2
%       x           Start heading in radians
%       pathOptions Options for solver (uses TurnRadius and Circuit)
%       [algorithm] Algorithm name ('alternating', 'randomized', 'nearest')
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
if exist('dppSolveDTSP') ~= 3
    if exist('lib/DubinsPathPlanner') ~= 7
        error('Could not find the DubinsPathPlanner folder.');
    end
    addpath('lib/DubinsPathPlanner');
    if exist('dppSolveDTSP') ~= 3
        error('Could not find compiled dppSolveDTSP mex file.');
    end
end

% Call the MEX file
r = pathOptions.TurnRadius;
returnToInitial = 1;
extraArgs = {};

if (strcmp(pathOptions.Circuit,'off'))
    returnToInitial = 0;
    extraArgs = {returnToInitial};
end
if nargin > 3
    extraArgs = {returnToInitial, algorithm};
end
[E, X, Cost] = dppSolveDtsp(V, x, r, extraArgs{:});

end

