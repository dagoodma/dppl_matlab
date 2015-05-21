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
bestCost = -1;
X = zeros(m, 1);
V_ordered = V;

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

%parpool('local', 4);

for i=1:permCount
    E_i = zeros(n - 1, 3);
    c_i_approach = 0;
    c_i_return = 0;
    V_i = V(P(i,:)',:);
    
    % Initial guess for x
    % improve this with heuristics try alternating algorithm
    % (shorted euclidean with alternating headings
    expectedX = initialGuess(C, V_i, pathOptions); 
    
    % Find minimum cost theta for traversal
    %ptpPathWaypoints = V_i;
    
    %x = fmincon(@solveBruteforcePointToPoint_helper, expectedX, [], [], [], [], ...
    %    lb, ub, [], fminconOptions);
    
    [x_i, fval] = solveBruteforcePointToPoint_helper(C, V_i, pathOptions, expectedX);
    
    % DEBUG Results
    %disp('X: ');
    %x
    %disp('Xexpected: ');
    %expectedX
    %disp('Error: ');
    %norm(x - expectedX)

    % Remember this traversal if it's min/max cost
    fprintf('Comparing fval=%d to bestCost=%d\n',fval, bestCost);
    if (i == 1 || (fval < bestCost))
        disp('here!');
        bestCost = fval;
        X = x_i;
        V_ordered = V_i;
    end
    
end % for i

% Walk mincost path and reconstruc
[E, Cost] = findTrajectoryCost(C, V, V_ordered, X, pathOptions);
X = reorderHeadingsFromEdges(V, E, X, pathOptions); % align X with V instead of V_ordered

end % function solveBruteforcePointToPoint


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


