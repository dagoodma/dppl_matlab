function [theta] = heading2Theta(psi)
% HEADING2THETA Converts a heading angle psi to a circular angle theta

% =================== Check Arguments ========================
if nargin < 1
    error('No input arguments given!');
elseif nargin > 8
    error('Too many arguments given!');
end

if isempty(psi) || psi < 0 || psi >= 2*pi
    error('psi must be between 0 and 2*pi')
end
% =============================================================
theta = angularMod(-(psi - pi/2),2*pi);

end %% function heading2Theta()

%Note angle safe mod if:
%
%function [m] = mymod(x,y)
%   n = floor(x./y);
%   m = x - n.*y;
%end

