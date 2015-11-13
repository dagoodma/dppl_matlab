function [  ] = expandAxes( sx, sy )
%EXPANDAXES Summary of this function goes here
%   Detailed explanation goes here
xl = xlim();
xld = abs(xl(1) - xl(2));
yl = ylim();
yld = abs(yl(1) - yl(2));

newXl = [xl(1)-(xld*sx - xld)/2, xl(2)+(xld*sx - xld)/2];
newYl = [yl(1)-(yld*sx - yld)/2, yl(2)+(yld*sy - yld)/2];

xlim(newXl);
ylim(newYl);

end

