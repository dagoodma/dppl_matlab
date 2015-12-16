function [hAx] = plotWaypointScenario(V, E, opts)
%PLOTWAYPOINTSCENARIO Plots a waypoint scenario
%   This function will plot a matrix of vertices V. Optionally, it can also
%   plot a matrix of edges E. If opts.NormalizePlots is set to 'off', edge
%   costs and arrows will not be plotted.
%
% Input parameters:
%   V(n,2)  an n-by-2 matrix of vertice coordinates
%   E(m,2)  an m-by-2 matrix of edges connecting each vertex
%   [opts]  optional PathOptions object. Use default if not given
%
% Return variables:
%   hAx - axes handle for figure created
%


%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 3
    error('Too many arguments given!');
end
if isempty(V)
    error('V is empty!');
end
[n, dimc] = size(V);
if dimc ~= 2
    error('Expected V to have 2 columns');
end

[m, dimc] = size(E);

%E
%m
%dimc
%if dimc < 2
%    error('Expected E to have at least 2 columns');
%end

%if strcmp(opts.ShowEdgeCosts,'on') && dimc < 3
%    error('Expected E to have 3 columns for showEdgeCosts option.');
%end

if exist('opts','var') && ~isa(opts, 'PathOptions')
    error('opts is not a PathOptions object!');
end
if ~exist('opts','var')
    opts = PathOptions;
end


useGrPlot = strcmp(opts.NormalizePlots, 'on');
%% ================ Dependencies ===============

% Find all dependencies
% Add lib and class folders
addpath('lib','class');

% Add graph theory toolbox
if useGrPlot && exist('grBase') ~= 2
    if exist('lib/GrTheory') ~= 7
        error('Could not find the GrTheory folder.');
    end
    addpath('lib/GrTheory');
end

%=============== Plot waypoints ===============
%hAx = subplot(subPlotDim(1),subPlotDim(2),subPlotIndex);

%dx = 0.0; dy = -0.1; % displacement so the text does not overlay the data points
%text(C(1)+dx, C(2)+dy, 'Start/End');
if useGrPlot
    if (m < 1)
        fig = grPlot(V, [], 'g', '%d', ''); % initial plot of waypoints
        %%fig = grPlot(Vhat, [], 'g', '', ''); % initial plot of waypoints
    else
        if strcmp(opts.ShowEdgeCosts,'on')
            fig = grPlot(V, E, 'd', '', '%.1f', opts.EdgeArrowSize); % initial plot of waypoints
        else
            fig = grPlot(V, E, 'd', '', '', opts.EdgeArrowSize); % initial plot of waypoints
        end
    end
else
    hf = gcf;
    hold on;
    plot(V(2:end,1),V(2:end,2),'k.','MarkerSize',20)
    hold off;
end

if useGrPlot
    md = normalizationCoeff(V);
    V=V./md;
end

% Plot initial point
hold on;
%scatter(V(1,1), V(1,2), 100, 'b', 'filled', 'p');
hPoint = plot(V(1,1), V(1,2), 'b.', 'MarkerFaceColor', 'b', 'MarkerSize',20);
disableLegendEntry(hPoint);

% show waypoint number
if strcmp(opts.ShowWaypointNumber, 'on')
    for i=2:length(V)
        ind = i - 1;
        xl = xlim();
        yl = ylim();
        xOff = (xl(2) - xl(1))*0.015;
        yOff = (yl(2) - yl(1))*0.005;
        text(V(i,1)+xOff, V(i,2)+yOff, sprintf('%d',ind),'FontSize',11);
    end
end

hold off;

% Set title, border, and ticks
box on;
%set(gca,'xtick',[],'ytick',[])

% Change axes width/height
expandAxes(1.1,1.1);
% xl = xlim;
% yl = ylim;
% xld = abs(xl(1) - xl(2));
% yld = abs(yl(1) - yl(2));
% xlim([xl(1) - xld*0.1, xl(2) + xld*0.1]);
% ylim([yl(1) - yld*0.1, yl(2) + yld*0.1]);

end
