function [hAx] = plotCoverageScenario(P, C, subPlotDim, subPlotIndex, titleStr,...
    pathOptions)
%PLOTCOVERAGESCENARIO Plots a sensor coverage scenario
%   This function will plot the edges of the polygon P.
%
% Input parameters:
%   P(n,2) - an n-by-2 matrix of polygon vertices
%   C(1,3) - a 1-by-3 vector that holds the starting configuration
%            C(1:2) is the (x,y) position, and C(3) is the heading
%   subPlotDim - dimensions for subplot to use when plotting
%   subPlotIndex - index for subplot
%   titleStr - string to use at plot title
%   pathOptions - optional path options object. use default if not given
%
% Return variables:
%   hAx - axes handle for figure created
%

%% ================ Dependencies ===============

% Find all dependencies
% Add lib and class folders
addpath('lib','class');

% Add graph theory toolbox
if exist('grBase') ~= 2
    if exist('lib/GrTheory') ~= 7
        error('Could not find the GrTheory folder.');
    end
    addpath('lib/GrTheory');
end


%% ================ Dependencies ===============
START_HEADING_COLOR = 'r';


%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 6
    error('Too many arguments given!');
end
if isempty(P)
    error('P is empty!');
end
[n, dimc] = size(P);
if dimc ~= 2
    error('Expected P to have 2 columns');
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



%=============== Plot waypoints ===============
hAx = subplot(subPlotDim(1),subPlotDim(2),subPlotIndex);

V = [C(1:2); P];


% Normalization
md = normalizationCoeff(V);
Pn = P./md;
Cn = C(1:2)./md;

% Plotting
plot([Pn(:,1); Pn(1,1)], [Pn(:,2); Pn(1,2)], '--b');
hold on;

% initial position
plot(Cn(1), Cn(2), 'ro', 'MarkerFaceColor', 'k');



%[C(1) C(2)] = ds2nfu(hAx, C(1), C(2)); % normalize initial coordinates
% hold on;
% plot(C(1), C(2), 'ro', 'MarkerFaceColor', 'r');
% hold off;

% % Normalization
% md = normalizationCoeff([C(1:2); P]);
% P(:,1:2)=P(:,1:2)/md;
% Cn=[C(1)/md C(2)/md C(3)];

% % Plot the polygon adding a final CCW edge to close it
% hold on;
% plot([P(:,1); P(1,1)], [P(:,2); P(1,2)], '--b');

% % Plot initial position and heading arrow
% plot(Cn(1), Cn(2), 'ro', 'MarkerFaceColor', 'r');


% Set style (title, ticks, and window)
title(titleStr);
box on;
set(gca,'xtick',[],'ytick',[])
xl = xlim;
yl = ylim;
xld = abs(xl(1) - xl(2));
yld = abs(yl(1) - yl(2));
xlim([xl(1) - xld*0.1, xl(2) + xld*0.1]);
ylim([yl(1) - yld*0.1, yl(2) + yld*0.1]);

drawHeadingArrow(hAx, Cn(1:2), C(3), pathOptions.HeadingArrowSize, START_HEADING_COLOR)

hold off;

end
