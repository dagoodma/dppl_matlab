function [ L, c_s, lambda_s, c_e, lambda_e, z_1, q_1, z_2, z_3, q_3 ]...
    = findDubinsParameters( p_s, x_s, p_e, x_e, r)
%FINDDUBINSPARAMETERS Find parameters for Dubins paths
% This function is unused. Instead, we use findDubinsLength to
% calculate the length of the Dubins path for our cost function.
% To plot the full path, we use the DubinsPlot c++ interface.
%   Parameters:
%       p_s     Start position as a 1-by-2 matrix
%       x_s     Start angle in radians
%       p_e     End position as a 1-by-2 matrix
%       x_e     End angle in radians
%       r       Turn radius
%   Returns:
%       L        Length of the path
%       c_s      Start circle as 1-by-2 matrix
%       lambda_s Start circle direction
%       c_e      End circle as 1-by-2 matrix
%       lambda_e End circle direction
%       z_1      
%       q_1
%       z_2
%       z_3
%       q_3


%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 5
    error('Too many arguments given!');
end
if norm(p_s - p_e) < 3*r
    error('Start and end position distance must be larger than 3 times the radius.');
end

[~,pdim] = size(p_s);
if (pdim < 3)
    p_s = [p_s 0];
end
[~,pdim] = size(p_e);
if (pdim < 3)
    p_e = [p_e 0]; 
end

% Inline function for right-handed rotation of theta about z-axis
%rotm = @(theta) [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1]';

wrap = @(theta) mod(theta,2*pi);

% Find circles for each case
c_rs = p_s' + r*rotm(pi/2)*[cos(x_s) sin(x_s) 0]';
c_ls = p_s' + r*rotm(-pi/2) * [cos(x_s) sin(x_s) 0]';
c_re = p_e' + r*rotm(pi/2) * [cos(x_e) sin(x_e) 0]';
c_le = p_e' + r*rotm(-pi/2) * [cos(x_e) sin(x_e) 0]';

%============ Calculate Lengths ===============
% Case I, R-S-R
theta = findAngleBetween(c_rs,c_re);
L1 = norm(c_rs - c_re) + r*wrap(2*pi + wrap(theta - pi/2) - wrap(x_s - pi/2))...
    + r*wrap(2*pi + wrap(x_e - pi/2) - wrap(theta - pi/2));

% Case II, R-S-L
len = norm(c_le - c_rs);
theta = findAngleBetween(c_rs,c_le);
theta2 = theta - pi/2 + real(asin((2*r)/len));
L2 = sqrt(len^2 - 4*r^2)+r*wrap(2*pi + wrap(theta2) - wrap(x_s - pi/2))...
    + r*wrap(2*pi + wrap(theta2 + pi) - wrap(x_e + pi/2));

% Case III, L-S-R
len = norm(c_re - c_ls);
theta = findAngleBetween(c_ls,c_re);
theta2 = acos((2*r)/len);

if (2*r/len) > 1 || (2*r/len) < -1
    % We have an issue, so plot it
    plotScenario(p_s, x_s, p_e, x_e, c_ls,c_re, r);
end

L3 = sqrt(len^2 - 4*r^2) + r*wrap(2*pi + wrap(x_s + pi/2) - wrap(theta + theta2))...
    + r*wrap(2*pi + wrap(x_e - pi/2) - wrap(theta + theta2 - pi));

% Case IV, L-S-L
theta = findAngleBetween(c_ls,c_le);
L4 = norm(c_ls - c_le) + r*wrap(2*pi + wrap(x_s + pi/2) - wrap(theta + pi/2))...
    + r*wrap(2*pi + wrap(theta + pi/2) - wrap(x_e + pi/2));

% Return the length of the minimum length Dubins path
length = min([L1, L2, L3, L4]);

end


% TODO finish if needed
end

