function [hf] = plotWaypoints(V, notNormalized)
%PLOTWAYPOINTS Plots a waypoints (simple plot)
%   This function will plot a matrix of vertices V.

% Input parameters:
%   V(n,2) - an n-by-2 matrix of vertice coordinates
%	notNormalized - if true, do not plot normalized with grPlot
%
% Return variables:
%   hAx - axes figure handle
%

%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 2
    error('Too many arguments given!');
end
if isempty(V)
    error('V is empty!');
end
[n, dimc] = size(V);
if dimc ~= 2
    error('Expected V to have 2 columns');
end
useGrPlot = true;
if nargin == 2
	useGrPlot = ~notNormalized
end

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
[n,~] = size(V);
%dx = 0.0; dy = -0.1; % displacement so the text does not overlay the data points
%text(C(1)+dx, C(2)+dy, 'Start/End');

if (useGrPlot)
	hf = grPlot(V, [], 'g', '%d', ''); % initial plot of waypoints
else
	hf = gcf;
	hold on;
	plot(V(:,1),V(:,2),'k.','MarkerSize',20)
	hold off;
end

box on;
set(gca,'xtick',[],'ytick',[])
xl = xlim;
yl = ylim;
xld = abs(xl(1) - xl(2));
yld = abs(yl(1) - yl(2));
xlim([xl(1) - xld*0.1, xl(2) + xld*0.1]);
ylim([yl(1) - yld*0.1, yl(2) + yld*0.1]);

end
