function [E, X, Cost] = solveGreedyPointToPoint(C, V, pathOptions)
% SOLVEGREEDYPOINTTOPOINT solves the point to point problem with nearest-neighbor
%   solveGreedyPointToPoint(C, V, pathOptions) finds a sub-optimal, point-to-point
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
E = zeros(n - 1, 3);
X = zeros(m, 1);
c = -1;
c_approach = 0;
c_return = 0;
V_visited = zeros(1, n);

if strcmp(pathOptions.Debug,'on')
    fprintf('Greedy PTP solver is finding nearest paths (%d iterations).\n',...
        n^2);
end

% From the start position, traverse all vertices
position = C(1:2);
heading = C(3);
idx = -1;

for i=1:n
    c_i = -1;
    idx_i = -1;
    theta_i = 0;
    
    % Find nearest vertex
    for j=1:n
        if V_visited(j), continue; end;
        
        v = V(j,:);
        theta = findHeadingFrom(position,v);
        c_j = findPTPCost(position, heading, v, theta, pathOptions.TurnRadius);
        
        % Remember this vertex if it's our nearest neighbor
        if (c_i < 0) || (c_j < c_i)
            c_i = c_j;
            idx_i = j;
            theta_i = theta;
        end
    end % for j
    
    % Traverse to nearest
    c = c + c_i;
    lastIdx = idx;
    idx = idx_i;
    V_visited(idx) = 1;
    X(idx) = theta_i;
    
    % Build an edge if neccessary
    if i > 1
        E(i-1,:) = [lastIdx idx c_i];    
    else
        c_approach = c_i;
    end
    
    % Update position
    position = V(idx,:);
    heading = theta_i;
end % for i
    
    
% Return cost
if strcmp(pathOptions.Circuit, 'on')
    theta = findHeadingFrom(position,C(1:2));
    c_i = findPTPCost(position,heading,C(1:2),theta,...
        pathOptions.TurnRadius);
    c = c + c_i;
    c_return = c_i;
    X(m) = theta;
end

Cost = [c c_approach c_return];

end % function solveGreedyPointToPoint
