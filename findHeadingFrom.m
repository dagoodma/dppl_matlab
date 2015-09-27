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
x1 = p1(1);
y1 = p1(2);
x2 = p2(1);
y2 = p2(2);

% Calculate angle of line between p1 and p2
if (x1 <= x2) && (y1 < y2)
    psi = atan((x2 - x1)/(y2 - y1));
elseif (x1 < x2) && (y1 >= y2)
    psi = atan((y1 - y2)/(x2 - x1)) + pi/2;
elseif (x2 <= x1) && (y2 < y1)
    psi = atan((x1 - x2)/(y1 - y2)) + pi;
elseif (x2 < x1) && (y1 <= y2)
    psi = atan((y2 - y1)/(x1 - x2)) + 3*pi/2;
else
    error('Unhandled case for p1=[%d %d] and p2=[%d %d].',x1,y1,x2,y2);
end

end % function

