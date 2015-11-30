% Plot coverage polygon decomposition method example
clear all;
close all;

% Add root
addpath('..')
addpath('../lib');
addpath('../lib/read_gml');
addpath('../class');
addpath('../lib/spaceplots');


% Setup
P = Polygon(readGmlFile('../../data/test/cpp/nonConvexPolygon.gml'));

fh = plotPolygon(P);
set(fh,'color',[0 0 0]);

% Plot sweep-line
hold on;
arrowSize = 0.5;
x0 = -2;
yl = ylim();
plot([x0, x0], [yl(1), yl(2)], '--k');
quiver(x0,3,3,0,arrowSize, 'AutoScale', 'off', 'Color', [0 0 0],...
	    'MaxHeadSize', 0.5e2)
hold off;

% Clear axes and ticks
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
title('');
%spaceplots();