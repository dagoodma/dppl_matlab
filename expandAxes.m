function [  ] = expandAxes( sx, sy, square )
%EXPANDAXES Expands
%   Detailed explanation goes here
useSquare = 0;
if (nargin == 3 && square == 1)
    % Use square axes with largest dimension
    useSquare = 1;
    
    limMax = max([xlim(), ylim()]);
    limMin = min([xlim(), ylim()]);
    
    xl = [limMin limMax];
    yl = [limMin limMax];

else
    % Keep axes dimensions
    xl = xlim();
    yl = ylim();

end
xld = abs(xl(1) - xl(2));
yld = abs(yl(1) - yl(2));

newXl = [xl(1)-(xld*sx - xld)/2, xl(2)+(xld*sx - xld)/2];
newYl = [yl(1)-(yld*sx - yld)/2, yl(2)+(yld*sy - yld)/2];

xlim(newXl);
ylim(newYl);

if useSquare
    axis square;
end

end

