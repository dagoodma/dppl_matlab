function [ V ] = readGmlFile( filename )
%READMATRIXFILE Reads vertices of a graph from a GML file
% FIXME: add reading of edges as well
%   Parameters:
%       filename    Name of the GLM file to read.

%================ Dependencies ================
addpath('lib/read_gml'); 
%FIXME check if read_gml functionis in the path

%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 1
    error('Too many arguments given!');
end

if (exist(filename) ~= 2)
    error(['File does not exist: ', filename]);
end

%=============== Read Matrix file File =================
data = read_gml(filename);
nodeIds = data.node.id;

nodes = {data.node.graphics};

N = length(data.node);
V = zeros(N,2);

% FIXME rearrange by id (check for discontinuous or offset ids)
for i=1:N
    V(i,1) = nodes{i}.x;
    V(i,2) = nodes{i}.y;
end

end %function

