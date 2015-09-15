function [E, X, Cost] = solveAlternatingCPP(V,x,pathOptions)
%solveAlternatingCPP returns the alternating algorithm solution for V
%   Wrapper for dubinsAlternating solver. Calls the mex function
%   and solves the vertex set V given the starting heading x.
%
%   TODO If pathOptions.Circuit is set to 'on', the return cost will be included
%   in the total, and a return edge will be added to E (m=n).
%
%   Parameters:
%       V           Set of vertices n-by-2
%       x           Start heading in radians
%       pathOptions Options for solver
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
if exist('dubinsAlternating') ~= 3
    if exist('lib/DubinsAreaCoverage') ~= 7
        error('Could not find the DubinsAreaCoverage folder.');
    end
    addpath('lib/DubinsAreaCoverage');
    if exist('dubinsAlternating') ~= 3
        error('Could not find compiled dubinsAlternating mex file.');
    end
end

% Call the MEX file
[E, X, Cost] = dubinsAlternating(V, x, pathOptions.TurnRadius);

end

