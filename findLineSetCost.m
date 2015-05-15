function [ indices, edges, totalCost ] = findLineSetCost( startPosition,...
    startHeading, vertices, lineSet, lineOrder, lineEndCode, turnRadius,...
    makeCircuit)
%FINDLINECOST Finds the total cost of traversing the line set
% Returns:
%   indices        vertex indices ordered for line set traversal
%   edges ...
%   totalCost      total cost of traversing the line set
%
% Input parameters:
%   startPosition  a 1x2 vector position to start at in meters
%   startHeading   a heading angle to start at in radians
%   vertices       a n-by-2 matrix of vertices as (x,y) locations
%   lineSet        a 1-by-k vector of n lines to traverse
%   lineOrder      line set indices in order of desired traversal
%   lineEndCode    gray code for specifying which line endpoints to use
%                  0 is start, and 1 is end.
%   turnRadius     turn radius of aircraft for Dubins path
%   makeCircuit    whether to include return to start position in cost

%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 8
    error('Too many arguments given!');
end

if isempty(vertices)
    error('Vertex set is empty!');
end
[n, ~] = size(vertices);

if isempty(lineSet)
    error('Line set is empty!');
end

[~, k] = size(lineSet);
if (lineEndCode < 0) || (lineEndCode > (2^k - 1))
    error('Line end gray code out of range.');
end

%============= Walk the Line Set ===============
totalCost = 0;
indices = zeros(1,n);
edges = zeros(n-1,3);
j = 1;
jline = 1;
currentPosition = startPosition;
currentHeading = startHeading;
currentPositionIndex = -1;
lastPosition = zeros(1,2);
lastHeading = 0;
lastPositionIndex = -1;

for i=1:k
    lineIndex = lineOrder(i);
    line = lineSet(lineIndex);
    startAtEnd = bitget(lineEndCode,lineIndex) && ~line.isPoint();
    [newIndices, newEdges, lineCost] = findLineCost(currentPosition, currentHeading,...
        line, startAtEnd, vertices, turnRadius);
    
    % Add up cost and save indices
    totalCost = totalCost + lineCost;
    indices(j:j + line.Length) = newIndices;
    j = j + 1 + line.Length;
    
    % Update position
    lastPosition = currentPosition;
    lastHeading  = currentHeading;
    lastPositionIndex = currentPositionIndex;
    currentPosition = vertices(line.EndVertexIndex,:);
    currentHeading = line.Theta;
    currentPositionIndex = line.EndVertexIndex;
    if startAtEnd
        currentPosition = vertices(line.StartVertexIndex,:);
        currentHeading = mod(currentHeading + pi, pi);
        currentPositionIndex = line.StartVertexIndex;
    end
    
    % Add approach edges
    if i > 1
        approachCost = findDubinsLength(lastPosition, lastHeading, ...
            currentPosition, currentHeading, turnRadius, 0);
        edges(jline,:) = [lastPositionIndex currentPositionIndex approachCost];
        jline = jline + 1;
    end
    
    % Add new edges if there are any
    if (line.Length > 0)
%         j
%         line.Length
%         size(edges)
%         disp('New edge size: ');
%         size(newEdges)
%         fprintf('Edges(%d:%d,:)\n', jline, (jline + line.Length - 1));
        edges(jline:jline + line.Length - 1,:) = newEdges;
        jline = jline + line.Length;
    end
end

if makeCircuit
    totalCost = totalCost + findPTPCost(currentPosition, currentHeading,...
        startPosition, startHeading, turnRadius);
end

end
