function [ A ] = readMatrixFile( filename )
%READMATRIXFILE Reads a matrix from the DLM file.
%   Parameters:
%       filename    Name of the DLM file to read.

%================ Dependencies ================

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
A = dlmread(filename);

end

