function [E, X, c] = traverseLineSet(V, L, pathOptions)
%TRAVERSELINESET Traverses an ordered line set of trajectory lines
%   traverseLineSet(V, L) traverses V, an n-by-2 ordered set of vertices,
%   using the 1-by-k ordered set of trajector lines L, and returns an
%   ordered set of edges E and the total cost of traversal c. 
%
% Notes:
%   * To prevent having to reorder L, consider passing a vector of
%     indices to represent the traversal order.
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
if isempty(L)
    error('L is empty!');
end

if exist('pathOptions','var') && ~isa(pathOptions, 'PathOptions')
    error('pathOptions is not a PathOptions object!');
end
if ~exist('pathOptions','var')
    pathOptions = PathOptions;
end

[n, ~] = size(V);
[~, k] = size(L);

%============= Walk the Line Set ===============
E = zeros(n - 1,3);
X = zeros(n,1);
m = 1; % edge index
c = 0;

resetIterators(L); % Do we need to reset the iterators?
lastVertexIndex = -1;
vertexIndex = L(1).getNext();
position = V(vertexIndex,:);
heading = L(1).Heading;
X(vertexIndex) = heading;

% Iterate over line set
for i=1:k
    line = L(i);
    
    % Add approach edge if we aren't at the starting line
    % cost is the shortest dubins path
    if i > 1
        lastVertexIndex = vertexIndex;
        vertexIndex = line.getNext();
        v = V(vertexIndex,:);
        c_i = findDubinsLength(position, heading, v, line.Heading,...
            pathOptions.TurnRadius, 0)
        c = c + c_i;
        
        % Create and add the approach edge
        e = [lastVertexIndex vertexIndex c_i];
        E(m,:) = e;
        m = m + 1;
        
        % Update position and heading
        position = v;
        heading = line.Heading;
        X(vertexIndex) = line.Heading;
    end
    
    % Add each edge in the line, where cost is straight line distance
    while line.hasNext()
        lastVertexIndex = vertexIndex;
        vertexIndex = line.getNext();
        v = V(vertexIndex,:);
        c_i = findDubinsLength(position, heading, v, line.Heading,...
            pathOptions.TurnRadius, 0);
        c_i = sqrt( (position(1) - v(1))^2 + (position(2) - v(2))^2 )
        c = c + c_i;
        
        % Create and add the edge
        e = [lastVertexIndex vertexIndex c_i];
        E(m,:) = e;
        m = m + 1;
        
        % Update position (heading is already set)
        position = v;
        X(vertexIndex) = line.Heading;
    end
end
X

end % function traverseLineSet()

%% Resets all iterators in the line set L
function resetIterators(L)
    for i_line=1:length(L)
        L(i_line).resetIterator();
    end
end
