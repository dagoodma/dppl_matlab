function [E, X, Cost] = solveGreedyPointToPoint(V, x, pathOptions)
% SOLVEGREEDYPOINTTOPOINT solves the point to point problem with nearest-neighbor
%   solveGreedyPointToPoint(V, pathOptions) finds a sub-optimal, point-to-point
%   path for the n-by-2 set of vertices V starting from V(1) with heading
%   x. This solver chooses the nearest points, returning an
%   m-by-3 set of edges E, and the Cost of traversal. Cost is the total
%   cost of the solution, and if Circuit is set to 'on' in pathOptions,
%   the return cost will be included. 
%
%   This algorithm runs in O( n^2 ) time.
%


%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 3
    error('Too many arguments given!');
end

if isempty(V)
    error('V is empty!');
end
if (isempty(x) || x < 0 || x >= 2*pi)
    error('x is invalid!');
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
m = n + strcmp(pathOptions.Circuit, 'on') - 1; % number of Edges

%================= Solve ===================
E = zeros(m, 3);
X = zeros(n, 1);
c = -1;
V_visited = zeros(1, n);

if strcmp(pathOptions.Debug,'on')
    fprintf('Greedy PTP solver is finding nearest paths (%d iterations).\n',...
        n^2);
end

% From the start position, traverse all vertices
position = V(1,:);
heading = x;
idx = 1;
V_visited(idx) = 1;
X(idx) = x;

for i=2:n
    c_i = -1;
    idx_i = -1;
    theta_i = 0;
    
    % Find nearest vertex
    for j=2:n
        if V_visited(j), continue; end;
        
        v = V(j,:);
        theta = findHeadingFrom(position,v);
        c_j = findPTPCost(position, heading, v, theta, pathOptions.TurnRadius);
        %fprintf('Considering node %d from node %d. cost=%0.1f\n',j, idx, c_j); 
        
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
    
    %fprintf('Chose leg (%i,%i) with cost %0.2f and final heading %0.2f\n',...
    %    lastIdx, idx, c_i, theta_i);
    
    % Build an edge
    E(i-1,:) = [lastIdx idx c_i];
    
    % Update position
    position = V(idx,:);
    heading = theta_i;
end % for i
    
    
% Return cost
if strcmp(pathOptions.Circuit, 'on')
    theta = x; % findHeadingFrom(position,C(1:2));
    c_i = findPTPCost(position,heading,V(1,:),theta,...
        pathOptions.TurnRadius);
    c = c + c_i;
    E(n,:) = [idx 1 c_i];
end

Cost = c;

end % function solveGreedyPointToPoint
