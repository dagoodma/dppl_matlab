function [minLineSet, minLineCount, minEndpointCount] = findBestLineSets(...
    V, pathOptions)
% FINDBESTLINESETS Finds all best sets of lines at uniform angles
%
% Input parameters:
%
%   V                  n-by-2 matrix of 2D vertices as (x,y) positions
%   pathOptions
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

if exist('pathOptions','var') && ~isa(pathOptions, 'PathOptions')
    error('pathOptions is not a PathOptions object!');
end
if ~exist('pathOptions','var')
    pathOptions = PathOptions;
end


%=============== Find Line Sets ================
[n, ~] = size(V);

n_angles = ceil(pi/pathOptions.LineStepTheta) + 1;
%angleList = ones(1,n_angles);                  
lineSets = cell(1,n_angles); %  1 x n cell, where each element is an k x 1 vector of
                      % trajectory lines
                      
minLineCount = n; % at most as many lines as vertices (worst case)
minEndpointCount = n;
minSetIndices = [1]; % indices into lineList of minimum line sets
minSetCount = 1;

for i=1:n_angles
    theta = pathOptions.LineStepTheta * (i-1);
    % Ensure we hit pi
    if i >= n_angles
        theta = pi;
    end
    %angleList(i) = angle;

    % Find all lines at this angle theta
    [lines] = findTrajectoryLines(V, theta, pathOptions.LineTolTheta);
    lineSets{i} = lines;
    [~, lineCount] = size(lines);
     if strcmp(pathOptions.Debug,'on')
         fprintf('Fit trajectory lines for %.3f degrees, and found %d lines.\n',...
             radtodeg(theta), lineCount);
     end
    
    % If scenario has the minimum number of lines, remember it.
    if lineCount < minLineCount 
        minLineCount = lineCount;
        minSetIndices = [i];
        minSetCount = 1;
        
        % Count endpoints for keeping tracking of problem size
        minEndpointCount = 0;
        for j=1:minLineCount
            if lines(j).isPoint()
                minEndpointCount = minEndpointCount + 1;
            else
                minEndpointCount = minEndpointCount + 2;
            end
        end
    elseif lineCount == minLineCount
        minSetIndices = [minSetIndices i];
        minSetCount = minSetCount + 1;
    end
    
    % DEBUG
    %fprintf('Edges at %d deg (%d lines)',angle, lineCount);
    %edgeList{i}
    %lineList{i}
    
    % Plot the graph with edges
    %subplot(2,2,i);
    %grPlot(waypointVertices,edgeList{1,i});
    %titleStr = sprintf('\\theta = %d [deg]   (%d lines)',angle, lineCount);
    %title(titleStr);
end

% Create a cell array of minimum line sets
minLineSet = cell(1,minSetCount);
for i=1:minSetCount
    k = minSetIndices(i);
    minLineSet{i} = lineSets{k};
end
