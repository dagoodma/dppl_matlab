function [ E, Cost ] = findWaypointSetCost( C, V, V_ordered, X, pathOptions)
%FINDWAYPOINTSETCOST traverses a set of waypoints (configurations) and finds cost
% Returns:
%   E       an m-by-3 list of edges formed by traversing the waypoints
%   Cost    a 1-by-3 vector of costs: [c_total, c_apporach, c_return]
%
% Input parameters:
%   C           a 1-by-3 starting configuration
%   V           an n-by-2 ordered list of vertices
%   X           an m-by-1 vector of headings at each waypoint
%   pathOptions options for traversal
%
%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 5
    error('Too many arguments given!');
end

if isempty(C)
    error('C is empty!');
end

if isempty(V)
    error('V is empty!');
end
[n, nn] = size(V);
m = n + strcmp(pathOptions.Circuit, 'on');

if (nn ~= 2)
    error('Expected V to have 2 columns.');
end

if isempty(V_ordered)
    error('V_ordered is empty!');
end
if ~isequal(size(V_ordered), size(V))
    error('Expected V_ordered and V to be the same size.');
end

if isempty(X)
    error('X is empty!');
end

if ~isequal(size(X), [m 1])
    error('Expected x to have dimensions m-by-1.');
end

if exist('pathOptions','var') && ~isa(pathOptions, 'PathOptions')
    error('pathOptions is not a PathOptions object!');
end
if ~exist('pathOptions','var')
    pathOptions = PathOptions;
end

%============= Walk the Configuration Set ===============
E = zeros(n - 1, 3);

position = C(1:2);
heading = C(3);
lastIdx = -1;
idx = -1;
c = 0;


for i=1:n
    v = V_ordered(i,:);
    theta  = X(i);
    c_i = findPTPCost(position,heading,v,theta, pathOptions.TurnRadius);
    c = c + c_i;

    % Create an edge
    lastIdx = idx;
    idx = findWaypointIndex(V,v);
    if i > 1
     E(i - 1,:) = [lastIdx idx c_i];
    else
     c_approach = c_i;
    end
    position = v;
    heading = theta;
end % for i
     
% Return cost
if strcmp(pathOptions.Circuit, 'on')
    c_i = findPTPCost(position,heading,C(1:2),X(m), pathOptions.TurnRadius);
    c = c + c_i;
    c_return = c_i;
end

Cost = [c c_approach c_return];

end % function findWaypointSetCost()

%% Find old index of permutated waypoint
function idx = findWaypointIndex(V, v)
    idx = -1;
    [n,~] = size(V);
    for i=1:n
        if isequal(V(i,:), v)
            idx = i;
            return;
        end
    end
end

