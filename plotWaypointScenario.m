function [hAx] = plotWaypointScenario(V, E, C, subPlotDim, subPlotIndex, titleStr,...
    pathOptions,  c_approach, c_return)
%PLOTWAYPOINTSCENARIO Plots a waypoint scenario
%   This function will plot a matrix of vertices V. Optionally, it can also
%   plot a matrix of edges E, a starting configuration C, a subplot index
%   subPlotIndex, subPlotDim, plot title titleStr, pathOptions, and
%   approach and return costs c_approach and c_return respectively.
%
% Input parameters:
%   V(n,2) - an n-by-2 matrix of vertice coordinates
%   E(m,2) - an m-by-2 matrix of edges connecting each vertex
%   C(1,3) - a 1-by-3 vector that holds the starting configuration
%            C(1:2) is the (x,y) position, and C(3) is the heading
%   subPlotDim - dimensions for subplot to use when plotting
%   subPlotIndex - index for subplot
%   titleStr - string to use at plot title
%   pathOptions - optional path options object. use default if not given
%   c_approach - cost for approach edge
%   c_return - cost for return edge
%
% Return variables:
%   hAx - axes handle for figure created
%

%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 9
    error('Too many arguments given!');
end
if isempty(V)
    error('V is empty!');
end
[n, dimc] = size(V);
if dimc ~= 2
    error('Expected V to have 2 columns');
end

if isempty(C)
    error('C is empty!');
end
if isempty(subPlotDim)
    error('subPlotDim is empty!');
end
if (subPlotIndex < 1) || (subPlotIndex > (subPlotDim(1) * subPlotDim(2)))
    error('Subplot index out of range');
end

if exist('pathOptions','var') && ~isa(pathOptions, 'PathOptions')
    error('pathOptions is not a PathOptions object!');
end
if ~exist('pathOptions','var')
    pathOptions = PathOptions;
end


%========= Rebuild V and E to include starting configuration ===========
[n,~] = size(V);
[m,~] = size(E);
Vhat = [C(1:2);V];
Ehat = E;

if (m > 0)
    i_first = E(1,1) + 1;
    i_last = E(end,2) + 1;
    i_secondlast = E(end,1) + 1;

    % Increment old edge indices
    I = ones(m,3);
    I(:,3) = 0;
    Ehat = Ehat + I;

    % Add approach edge
    v = Vhat(i_first,:);
    theta = findHeadingFrom(C(1:2),v); % Note: should be line theta
    c = findPTPCost(C(1:2), C(3), v, theta, pathOptions.TurnRadius);
    if exist('c_approach', 'var')
        c = c_approach;
    end
    Ehat = [1 i_first c; Ehat];

    % Add return edge
    if pathOptions.Circuit
        v = Vhat(i_last,:);
        v_hat = Vhat(i_secondlast,:);
        theta_start = findHeadingFrom(v_hat,v);
        theta_end = findHeadingFrom(v,C(1:2));
        c = findPTPCost(v, theta_start, C(1:2), theta_end,...
            pathOptions.TurnRadius);
        if exist('c_return', 'var')
            c = c_return;
        end
        Ehat = [Ehat; i_last 1 c];
    end      
end

%=============== Plot waypoints ===============
hAx = subplot(subPlotDim(1),subPlotDim(2),subPlotIndex);
%dx = 0.0; dy = -0.1; % displacement so the text does not overlay the data points
%text(C(1)+dx, C(2)+dy, 'Start/End');
if (m < 1)
    fig = grPlot(V, [], 'g', '%d', ''); % initial plot of waypoints
    fig = grPlot(Vhat, [], 'g', '', ''); % initial plot of waypoints
else
    if strcmp(pathOptions.ShowEdgeCosts,'on')
        fig = grPlot(Vhat, Ehat, 'd', '', '%.1f', pathOptions.EdgeArrowSize); % initial plot of waypoints
    else
        fig = grPlot(Vhat, Ehat, 'd', '', '', pathOptions.EdgeArrowSize); % initial plot of waypoints
    end
end
hold on;
fh1 = text(C(1), C(2), '\color{red} Start');
plot(C(1), C(2), 'ro', 'MarkerFaceColor', 'r');
title(titleStr);
box on;
set(gca,'xtick',[],'ytick',[])
xl = xlim;
yl = ylim;
xld = abs(xl(1) - xl(2));
yld = abs(yl(1) - yl(2));
xlim([xl(1) - xld*0.1, xl(2) + xld*0.1]);
ylim([yl(1) - yld*0.1, yl(2) + yld*0.1]);
hold off;

end
