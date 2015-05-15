function [ psi ] = findHeadingFrom( p1, p2 )
%FINDHEADINGFROM Finds the heading angle from point p1 to p2
%
%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 2
    error('Too many arguments given!');
end

%============== Finding Angle ==================
p1_x = p1(1);
p1_y = p1(2);
p2_x = p2(1);
p2_y = p2(2);

% Calculate angle of line between p1 and p2
if (p1_x <= p2_x) && (p1_y < p2_y)
    psi = atan((p2_x - p1_x)/(p2_y - p1_y));
elseif (p1_x < p2_x) && (p1_y >= p2_y)
    psi = atan((p1_y - p2_y)/(p2_x - p1_x)) + pi/2;
elseif (p2_x <= p1_x) && (p2_y < p1_y)
    psi = atan((p1_x - p2_x)/(p1_y - p2_y)) + pi;
elseif (p2_x < p1_x) && (p1_y <= p2_y)
    psi = atan((p2_y - p1_y)/(p1_x - p2_x)) + 3*pi/2;
else
    error('Unhandled case for p1=[%d %d] and p2=[%d %d].',p1_x,p1_y,p2_x,p2_y);
end

end % function

