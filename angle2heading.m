function [psi] = angle2heading(theta)
% ANGLE2HEADING Converts a circular angle theta to a heading psi

% =================== Check Arguments ========================
if nargin < 1
    error('No input arguments given!');
elseif nargin > 1
    error('Too many arguments given!');
end

if isempty(theta) || theta < 0 || theta >= 2*pi
    error('theta must be between 0 and 2*pi')
end
% =============================================================
psi = heading2angle(theta); % function is involutory

end %% function heading2angle()

%Here's an angle safe mod that's used under the hood by MATLAB:
%
%function [m] = mymod(x,y)
%   n = floor(x./y);
%   m = x - n.*y;
%end

