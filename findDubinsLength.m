function [ length ] = findDubinsLength( p_s, x_s, p_e, x_e, r, createPlot)
%FINDDUBINSLENGTH Find the length of the shortest Dubins path
%   Parameters:
%       p_s     Start position as a 1-by-2 matrix
%       x_s     Start angle in radians
%       p_e     End position as a 1-by-2 matrix
%       x_e     End angle in radians
%       r       Turn radius
%       createPlot  Optional argument to draw a plot of the scenario
%   Returns:
%       length  Length of the path
%
DUBINS_DEBUG = 0;
DEBUG_VERBOSE = 0; 
DEBUG_VVERBOSE = 0; % extra verbosity
%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 6
    error('Too many arguments given!');
end

if nargin < 6
    createPlot = 0;
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

theta_s = heading2angle(x_s);
theta_e = heading2angle(x_e);

% Inline function for right-handed rotation of theta about z-axis
% TODO be sure we aren't using anonymous functions anywhere. They are slow.
%rotm = @(theta) [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1]';

% TODO replace everywhere with wrapAngle()
%wrap = @(theta) mod(theta,2*pi);


% Find circles for each case
% TODO determine why these are wrong
%c_rs = p_s' + r*rotm(pi/2)*[cos(x_s) sin(theta_s) 0]';
%c_ls = p_s' + r*rotm(-pi/2) * [cos(x_s) sin(theta_s) 0]';
%c_re = p_e' + r*rotm(pi/2) * [cos(x_e) sin(x_e) 0]';
%c_le = p_e' + r*rotm(-pi/2) * [cos(x_e) sin(x_e) 0]';
% 
c_rs = p_s' + r*[cos(theta_s - pi/2) sin(theta_s - pi/2) 0]';
c_ls = p_s' + r*[cos(theta_s + pi/2) sin(theta_s + pi/2) 0]';
c_re = p_e' + r*[cos(theta_e - pi/2) sin(theta_e - pi/2) 0]';
c_le = p_e' + r*[cos(theta_e + pi/2) sin(theta_e + pi/2) 0]';

% Should be this:
%c_rs = p_s' + r*[cos(x_s + pi/2) sin(x_s + pi/2) 0]';
%c_ls = p_s' + r*[cos(x_s - pi/2) sin(x_s - pi/2) 0]';
%c_re = p_e' + r*[cos(x_e + pi/2) sin(x_e + pi/2) 0]';
%c_le = p_e' + r*[cos(x_e - pi/2) sin(x_e - pi/2) 0]';


%============ Calculate Lengths ===============
if (DUBINS_DEBUG & DEBUG_VERBOSE)
    c_rs, c_ls, c_re, c_le
end
if createPlot
    plotScenario(p_s, x_s, p_e, x_e, c_rs, c_ls, c_re, c_le,r)
end

% Case I, R-S-R
theta = findHeadingFrom(c_rs,c_re);
if (DEBUG_VVERBOSE)
fprintf('norm(c_rs - c_re)=%.6f \nr*wrap1=%0.6f \nr*wrap2=%0.6f\n',...
   norm(c_rs - c_re), r*wrapAngle(2*pi + wrapAngle(theta - pi/2) - wrapAngle(x_s - pi/2)),...
   r*wrapAngle(2*pi + wrapAngle(x_e - pi/2) - wrapAngle(theta - pi/2)));
fprintf('r*wrap2: wrapAngle(x_e - pi/2)=%0.6f, wrapAngle(theta - pi/2)=%0.6f\n',...
    wrapAngle(x_e - pi/2), wrapAngle(theta - pi/2));
end
L1 = norm(c_rs - c_re) + r*wrapAngle(2*pi + wrapAngle(theta - pi/2) - wrapAngle(x_s - pi/2))...
    + r*wrapAngle(2*pi + wrapAngle(x_e - pi/2) - wrapAngle(theta - pi/2));
if (DUBINS_DEBUG & DEBUG_VERBOSE)
    theta
    L1
end

% Case II, R-S-L
len = norm(c_le - c_rs);
theta = findHeadingFrom(c_rs,c_le);
theta2 = theta - pi/2 + asin((2*r)/len);
L2 = sqrt(len^2 - 4*r^2)+r*wrapAngle(2*pi + wrapAngle(theta2) - wrapAngle(x_s - pi/2))...
    + r*wrapAngle(2*pi + wrapAngle(theta2 + pi) - wrapAngle(x_e + pi/2));
if (DUBINS_DEBUG & DEBUG_VERBOSE)
    L2
end

% Case III, L-S-R
len = norm(c_re - c_ls);
theta = findHeadingFrom(c_ls,c_re);
ratio_oa = (2*r)/len;
if ratio_oa > 1, ratio_oa = 1; end
if ratio_oa < -1, ratio_oa = -1; end
theta2 = acos(ratio_oa);
if (DUBINS_DEBUG & DEBUG_VERBOSE)
    fprintf('Ratio OA: %0.5f, theta=%0.5f, theta2=%0.5f, len=%0.5f\n',...
        ratio_oa, theta, theta2, len);
end

%if (2*r/len) > 1 || (2*r/len) < -1
%    error('Error in case III');
%end

L3 = sqrt(len^2 - 4*r^2) + r*wrapAngle(2*pi + wrapAngle(x_s + pi/2) - wrapAngle(theta + theta2))...
    + r*wrapAngle(2*pi + wrapAngle(x_e - pi/2) - wrapAngle(theta + theta2 - pi));
if (DUBINS_DEBUG & DEBUG_VERBOSE)
    L3
end

% Case IV, L-S-L
theta = findHeadingFrom(c_ls,c_le);
L4 = norm(c_ls - c_le) + r*wrapAngle(2*pi + wrapAngle(x_s + pi/2) - wrapAngle(theta + pi/2))...
    + r*wrapAngle(2*pi + wrapAngle(theta + pi/2) - wrapAngle(x_e + pi/2));
if (DUBINS_DEBUG & DEBUG_VERBOSE)
    L4
end

% Return the length of the minimum length Dubins path
length = min([L1, L2, L3, L4]);

end


%% 
function plotCircle(x,y,r,args)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
if ~iscell(args)
    args = {[args]};
end
plot(x+xp,y+yp,args{:});
end

%%

function plotScenario(p_s, x_s, p_e, x_e, c_rs, c_ls, c_re, c_le, r)
hold on;
% Plot center of circles and line between them
%scatter([c_s(1) c_e(1)],[c_s(2) c_e(2)],'r+');
%plot([c_s(1) c_e(1)],[c_s(2) c_e(2)],'k--');
% Plot circles
formatArgs={'-k','LineWidth',0.005};
plotCircle(c_rs(1), c_rs(2), r, formatArgs);
plotCircle(c_re(1), c_re(2), r, formatArgs);
plotCircle(c_ls(1), c_ls(2), r, formatArgs);
plotCircle(c_le(1), c_le(2), r, formatArgs);
text(c_rs(1), c_rs(2), 'c_{rs}', 'FontSize', 17);
text(c_re(1), c_re(2), 'c_{re}', 'FontSize', 17);
text(c_ls(1), c_ls(2), 'c_{ls}', 'FontSize', 17);
text(c_le(1), c_le(2), 'c_{le}', 'FontSize', 17);

% Change graph dimensions
% xl = xlim;
% yl = ylim;
% maxDimLen = max(abs(xl(1) - xl(2)),abs(yl(1) - yl(2)));
% xld = abs(xl(1) - xl(2));
% yld = abs(yl(1) - yl(2));
% xlim([xl(1) - xld*0.1, xl(2) + maxDimLen*0.1]);
% ylim([yl(1) - yld*0.1, yl(2) + maxDimLen*0.1]);
% axis square;
axis equal tight;
expandAxes(1.25,1.25);
%axis equal;

% Plot headings
hAx = gca;
scatter([p_s(1) p_e(1)], [p_s(2) p_e(2)], 'r');
drawHeadingArrow(hAx, p_s(1:2), x_s, 0.8, 'b',1);
drawHeadingArrow(hAx, p_e(1:2), x_e, 0.8, 'b',1);

hold off;
end

%% Rotation matrix right-handed about z-axis by theta
function M = rotm(theta)
M = [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1]';
end



