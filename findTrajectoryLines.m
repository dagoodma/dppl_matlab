function [ lines ] = findTrajectoryLines( V, heading, headingFitTolerance )
%findLinearEdges Finds all edges on lines connecting the vertices
%   Given a matrix of vertices and a desired angle, this function will
%   will return the edges and lines that connect the vertices as matrices.
%
% Input parameters:
%   V(n,2) - an n-by-2 matrix of vertice coordinates
%   heading - angle from y-xis of lines to find in radians from 0 to pi
%   [headingFitTolerance] - optional tolerance in radians that vertices can
%       vary from the line    
%
% Returned variables:
%   lines - an 1 x k vector of trajectory lines
%

%============= Default Settings ===============
defaultTolerance = degtorad(3); % [rad] tolerance in angle measurement

%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 3
    error('Too many arguments given!');
end
if nargin <3
    headingFitTolerance = defaultTolerance;
end

if isempty(V)
    error('V is empty!');
end
if (heading < 0.0) || (heading > pi)
    error('Theta tolernace must be from 0 to pi degrees.');
end

[n, ~] = size(V);
% Ensure no vertices are equal
for i=1:n
    for j=1:n
        if (i ~= j) && (V(i,1) == V(j,1) && V(i,2) == V(j,2))
            error('Vertices %d and %d are identical.');
        end
    end
end

%================ Find the Lines ================
V_covered = zeros(1,n);
lines = [];
k = 1; % line index

for i=1:n
    % Skip this vertex if it's already on a line
    if V_covered(i)
        continue;
    end

    % Start a new line
    V_covered(i) = 1;
    line = TrajectoryLine(i,heading);
    lines = [lines line];
    %lastj = i;
    
    % Inner loop to find angle with each other vertex
    for j=1:n
        if V_covered(j)
            continue;
        end
        
        % Assert that y_i < y_j (require sort ascending by y, then x
        % components)
        if V(i,2) < V(j,2)
            error('Vertex list not sorted by y components.');
        end
        
        if (V(i,2) == V(j,2)) && (V(i,1) > V(j,1))
            % for horizontal line, where j is to left of x
            error('Vertex list not sorted by x components.');
        end
        heading_j = findHeadingFrom(V(i,:), V(j,:));
        
        dtheta = mod(abs(heading_j - heading),pi);
        if dtheta <= headingFitTolerance
            % This point is on line k, so add it
            V_covered(j) = 1;
            line.addEdge(j);
            
            %edges(m,:) = [lastj j]; %  add an edge connecting vertex j with the
                                    %  last edge added to the line k
            %lines{k} = [lines{k} m];%  add the index of the new edge to line k
            %line.addEdge(j, m); % add vertex, j, and edge index, m, to line
            %m = m + 1;
            %lastj = j;
        end
        
    end
    
    k = k+1;
end


end

