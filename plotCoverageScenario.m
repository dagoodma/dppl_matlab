function [hAx] = plotCoverageScenario(P, C, opts)
%PLOTCOVERAGESCENARIO Plots a sensor coverage scenario
%   This function will plot the edges of the polygon P.
%
% Input parameters:
%   P(n,2) - an n-by-2 matrix of polygon vertices or Polygon object
%   C(1,3) - a 1-by-3 vector that holds the starting configuration
%            C(1:2) is the (x,y) position, and C(3) is the heading
%   opts - optional path options object. use default if not given
%
% Return variables:
%   hAx - axes handle for figure created
%

% Find all dependencies
% Add lib and class folders
addpath('lib','class');

%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 3
    error('Too many arguments given!');
end
if isempty(P)
    error('P is empty!');
end

% [n, dimc] = size(P);
% if dimc ~= 2
%     error('Expected P to have 2 columns');
% end
% if (n < 3)
%     error('P must have at least 3 vertices.');
% end

if exist('opts','var') && ~isa(opts, 'PathOptions')
    error('opts is not a PathOptions object!');
end
if ~exist('opts','var')
    opts = PathOptions;
end

plotInitial = false;
if exist('C','var') && ~isempty(C)
    plotInitial = true;
end

% FIXME support normalized plots
%useGrPlot = strcmp(opts.NormalizePlots, 'on');

%% ================ Dependencies ===============

% Add graph theory toolbox
% if useGrPlot && exist('grBase') ~= 2
%     if exist('lib/GrTheory') ~= 7
%         error('Could not find the GrTheory folder.');
%     end
%     addpath('lib/GrTheory');
% end


%=============== Plot waypoints ===============
COVERAGE_REGION_COLOR = opts.CoverageRegionColor
START_HEADING_COLOR = opts.HeadingStartArrowColor;

hAx = gca;

% Normalization
%md = normalizationCoeff(V);

%set(gcf,'UserData',md); % save normalization coefficient

%Pn = P;

% Plotting
%plot([Pn(:,1); Pn(1,1)], [Pn(:,2); Pn(1,2)], '--b');
hold on;
plotPolygon(P, COVERAGE_REGION_COLOR);

% initial position
if plotInitial
    Cn = C(1:2);
    plot(Cn(1), Cn(2), 'ro', 'MarkerFaceColor', 'k');
    drawHeadingArrow(hAx, Cn(1:2), C(3), pathOptions.HeadingArrowSize, START_HEADING_COLOR, true);
end

% Set style (title, ticks, and window)
box on;
%set(gca,'xtick',[],'ytick',[])
hold off;

end
