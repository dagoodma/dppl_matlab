function [E, X, Cost] = solveBruteforcePointToPoint(C, V, pathOptions)
% SOLVEBRUTEFORCEPOINTTOPOINT solves the point to point solution by brute-force
%   path for the n-by-2 set of vertices V from the 1-by-3 starting
%   configuration C. This solver will try all possible paths and return an
%   m-by-3 set of edges E, the orientation angles X at each vertex, and the
%   Cost of traversal. Cost is a 1-by-3 vector where the first element is
%   total cost, the second is cost to approach the first waypoint, and
%   lastly is the return cost if Circuit is set to 'on' in pathOptions.
%   Otherwise, the last element is 0. This was done because the returned
%   edges E only include the cost of traversal from waypoints 1 to n,
%   but not from the start configuration to waypoint 1, and waypoint n
%   back to the start configuration.
%
%   This algorithm runs in O( n! * P(n) ), where n is the number of 
%   waypoints, and P(n) is the running time for MATLAB's fmincon
%   function on solveBruteforcePointToPoint_helper() with n variables using the
%   interior-point method.
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
c = -1;
c_approach = 0;
c_return = 0;
X = zeros(m, 1);

P = perms(1:n);
[permCount, ~] = size(P);

if strcmp(pathOptions.Debug,'on')
    caseStr = 'best';
    if strcmp(pathOptions.MaximizeCost,'on')
        caseStr = 'worst';
    end
    fprintf('Brute force PTP solver is finding %s of %d paths with %d variables.\n',...
        caseStr, permCount, n);
end

global ptpPathOptions ptpPathWaypoints ptpPathStartConfig;
ptpPathOptions = pathOptions;
ptpPathStartConfig = C;

% fmincon settings
fminconOptions = optimset('Algorithm', 'interior-point');
%fminconOptions = optimset('UseParallel', 'always');
fminconOptions = optimset(fminconOptions, 'Display', 'off');


% fmincon constraints (0 <= theta <= 2*pi)
lb = zeros(m,1);
ub = ones(m,1) * (2*pi - 0.00001);

for i=1:permCount
    E_i = zeros(n - 1, 3);
    c_i = 0;
    c_i_approach = 0;
    c_i_return = 0;
    V_i = V(P(i,:)',:);
    
    % Find minimum cost theta for traversal
    ptpPathWaypoints = V_i;
    expectedX = initialGuess(C, V_i, pathOptions);
    x = fmincon(@solveBruteforcePointToPoint_helper, expectedX, [], [], [], [], ...
        lb, ub, [], fminconOptions);
    
    % DEBUG Results
    %disp('X: ');
    %x
    %disp('Xexpected: ');
    %expectedX
    %disp('Error: ');
    %norm(x - expectedX)
    
    % Traverse waypoints with minimum theta
    position = C(1:2);
    heading = C(3);
    lastIdx = -1;
    idx = -1;
    for j=1:n
        v = V_i(j,:);
        theta  = x(j);
        c_j = findPTPCost(position,heading,v,theta, pathOptions.TurnRadius);
        c_i = c_i + c_j;
        
        % Create an edge
        lastIdx = idx;
        idx = findWaypointIndex(V,v);
        if j > 1
            E_i(j - 1,:) = [lastIdx idx c_j];
        else
            c_i_approach = c_j;
        end
        position = v;
        heading = theta;
    end % for j
    
    % Return cost
    if strcmp(pathOptions.Circuit, 'on')
        %theta = findHeadingFrom(position,C(1:2));
        c_j = findPTPCost(position,heading,C(1:2),x(m), pathOptions.TurnRadius);
        c_i = c_i + c_j;
        c_i_return = c_j;
    end
    
    % Remember this traversal if it's min cost
    if (strcmp(pathOptions.MaximizeCost, 'off') && ((c < 0) || (c_i < c)))...
        || (strcmp(pathOptions.MaximizeCost, 'on') && ((c < 0) || (c_i > c)))
        c = c_i;
        c_approach = c_i_approach;
        c_return = c_i_return;
        E = E_i;
        X = x;
    end
    
end % for i

Cost = [c c_approach c_return];

X = reorderHeadingsFromEdges(V, E, X, pathOptions);

end % function solveBruteforcePointToPoint


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

%% Iterate through V and find theta between each ordered vertex
function x = initialGuess(C, V, pathOptions)
    [n,~] = size(V);
    m = n + strcmp(pathOptions.Circuit, 'on');
    x = zeros(m,1);
    position = C(1:2);
    for i=1:n
        x(i) = findHeadingFrom(position,V(i,:));
        position = V(i,:);
    end
    % Return guess
    if  n ~= m
        x(m) = findHeadingFrom(position,C(1:2));
    end
end


