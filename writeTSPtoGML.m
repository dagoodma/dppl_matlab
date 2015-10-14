function [  ] = writeTSPtoGML( filename, V)
%writeTSPtoGML Writes the TSP problem to a GML file.
%   Parameters:
%       filename    Name of the GML file to save.
%       V           Nx2 Matrix of vertex positions [x,y]
%================ Dependencies ================
addpath('lib');

%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 2
    error('Too many arguments given!');
end

[n,cDim] = size(V);
if (cDim ~= 2)
    error('Expected a V as 2xN matrix.');
end

%=============== Save GML File =================
A = zeros(n,n); % no edges in GML file

%V = [C(1:2); V];

graphtogml(filename, A, [], V);

end

