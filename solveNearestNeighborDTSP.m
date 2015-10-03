function [E, X, Cost] = solveNearestNeighborDTSP(V,x,pathOptions)
%solveNearestNeighborDTSP returns the nearest neighbor solution for V
%   Wrapper for dubinsNearestNeighbor solver. Calls the mex function
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
if exist('dubinsNearestNeighbor') ~= 3
    if exist('lib/DubinsSensorCoverage') ~= 7
        error('Could not find the DubinsSensorCoverage folder.');
    end
    addpath('lib/DubinsSensorCoverage');
    if exist('dubinsNearestNeighbor') ~= 3
        error('Could not find compiled dubinsNearestNeighbor mex file.');
    end
end

% Call the MEX file
[E, X, Cost] = dubinsNearestNeighbor(V, x, pathOptions.TurnRadius);

end
