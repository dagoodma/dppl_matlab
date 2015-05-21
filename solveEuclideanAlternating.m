function [E, X, Cost] = solveEuclideanAlternating(C, V, pathOptions)
% SOLVEGREEDYPOINTTOPOINT find the euclidean alternating solution
%   solveEuclideanAlternating(C, V, pathOptions) finds a sub-optimal, 
%   euclidean solution and modifies it with the alternating algorithm
%   


point-to-point
%   path for the n-by-2 set of vertices V from the 1-by-3 starting
%   configuration C. This solver chooses the nearest points, returning an
%   m-by-3 set of edges E, and the Cost of traversal. Cost is a 1-by-3
%   vector where the first element is total cost, the second is cost to
%   approach the first waypoint, and lastly is the return cost if Circuit
%   is set to 'on' in pathOptions. Otherwise, the last element is 0. This
%   was done because the returned edges E only include the cost of
%   traversal from waypoints 1 to n, but not from the start configuration
%   to waypoint 1, and waypoint n back to the start configuration.
%
%   This algorithm runs in O( n^2 ) time.
%


%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 3
    error('Too many arguments given!');
end

if isempty(C)
    error('C is empty!');
end
if isempty(V)
    error('V is empty!');
end

if exist('pathOptions','var') && ~isa(pathOptions, 'PathOptions')
    error('pathOptions is not a PathOptions object!');
end
if ~exist('pathOptions','var')
    pathOptions = PathOptions;
end

UV = unique(V,'rows');
if ~isequal(size(V),size(UV))
    error('V contains duplicate vertices.');
end

[n, ~] = size(V);
m = n + strcmp(pathOptions.Circuit, 'on');

%================= Solve ===================