function [E, X, Cost] = solveGreedyLineToLine(C, V, pathOptions)
% SOLVEGREEDYLINETOLIVE solves the line to line problem with nearest-neighbor
%   solveGreedyLineToLine(C, V, pathOptions) finds a sub-optimal, line-based traversal
%   path for the n-by-2 set of vertices V from the 1-by-3 starting
%   configuration C. This solver will use a nearest neighbor approach
%   to always choose the best outgoing edge from the current node. It
%   returns an m-by-3 set of edges E, and the total cost of traversal c.
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

%=============== Find Lines ================

[B, lineCount, ~] = findBestLineSets(V, pathOptions);
[~, m] = size(B); % number of trajectory line sets

if strcmp(pathOptions.Debug,'on')
    fprintf(['Greedy LTL solver found %d line sets with %d lines. ',...
             'Trying nearest lines (%d iterations).\n'], m, lineCount, m*lineCount^2);
end

%================= Solve ===================
E = zeros(n - 1,3);
X = zeros(n + strcmp(pathOptions.Circuit,'on'), 1);
c = -1;
c_approach = 0;
c_return = 0;

% Find best over all line sets
for i=1:m
    L = B{i};
    L_new = TrajectoryLine.empty(0,lineCount);
    L_visited = zeros(1,lineCount); % vector of booleans to mark visited lines
    
    % Starting from the start position, walk to each best line.
    position = C(1:2);
    heading = C(3);
    for j=1:lineCount
        [idx, useEnd] = findBestLine([position heading], V, L, L_visited,...
            pathOptions);
        line = L(idx);
        if useEnd
            line.startAtEnd(useEnd);
        end
        L_new(j) = line;
        L_visited(idx) = 1;
        position = V(line.EndVertexIndex,:);
        heading = line.Heading;
    end % for j
    
    % Line set cost
    [E_i, X_i, c_i] = traverseLineSet(V,L_new,pathOptions);
    
    % Approach cost
    v =  V(L_new(1).StartVertexIndex,:);
    theta = L_new(1).Heading;
    c_i_approach = findPTPCost(C(1:2), C(3), v, theta, pathOptions.TurnRadius);
    c_i = c_i + c_i_approach;

    % Return cost
    if strcmp(pathOptions.Circuit, 'on')
        v =  V(L_new(end).EndVertexIndex,:);
        theta_1 = L_new(end).Heading;
        theta_2 = findHeadingFrom(v, C(1:2));
        c_i_return = findPTPCost(v, theta_1, C(1:2), theta_2,...
            pathOptions.TurnRadius);
        c_i = c_i + c_i_return;
        X_i = [X_i; theta_2];
    end
    
    % Remember this line set if it's the best so far
    if (c < 0) || (c_i < c)
        c = c_i;
        c_approach = c_i_approach;
        c_return = c_i_return;
        E = E_i;
        X = X_i;
    end
    
end % for i

Cost = [c c_approach c_return];

end % function solveGreedyLineToLine

%% Find the best line based on the pathOptions
function [idx, useEnd] = findBestLine(C, V, L, L_visited, pathOptions)
    idx = 0;
    useEnd = 0;
    c = -1;

    % Try each line endpoint in L and remember the best
    k = length(L);
    for i=1:k
        if L_visited(i), continue; end;
        line = L(i);
        
        % Try beginning of line
        v = V(line.StartVertexIndex,:);
        c_i = findPTPCost(C(1:2), C(3), v, line.Heading,...
            pathOptions.TurnRadius);
        if (c < 0) || (c_i < c)
            c = c_i;
            idx = i;
            useEnd = 0;
        end
        
        % Try end of line if there are edges
        if ~line.isPoint()
            v = V(line.EndVertexIndex,:);
            theta = mod(line.Heading + pi, pi);
            c_i = findPTPCost(C(1:2), C(3), v, theta,...
                pathOptions.TurnRadius);
            
            if (c < 0) || (c_i < c)
                c = c_i;
                idx = i;
                useEnd = 1;
            end
        end
    end
end
