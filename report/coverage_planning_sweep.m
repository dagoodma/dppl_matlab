% Plot coverage polygon decomposition method example
%   This script requires modifications to tex.m, a MATLAB builtin file.
%   See: message 5/12 http://www.mathworks.com/matlabcentral/newsreader/view_thread/283068
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
P.Vertices(:,1) = -P.Vertices(:,1);
fh = plotPolygon(P,'w');
expandAxes(1.1,1.1);
axis equal;
%set(fh,'FaceColor',[1 1 1]);

% Plot sweep-line
hold on;
arrowSize = 0.5;
x0 = 3;
yl = ylim();
plot([x0, x0], [yl(1), yl(2)], '--b');
quiver(x0,1.5,1.5,0,arrowSize, 'AutoScale', 'off', 'Color', [0 0 0],...
	    'MaxHeadSize', 0.5e2,'Color',[0 0 1]);
text(3.4, 2, '$\ell_{\textrm{sweep}}$','Interpreter','latex','fontsize',16)

% Plot cells
plot([0,0],[-5,-10], 'LineStyle', '--','Color',[.7 0 0]);
text(-6, -7.5, 'Cell 1','fontsize',13)
text(4, -5, 'Cell 2','fontsize',13)

% Clear axes and ticks
set(gca, 'XTick', [x0]);
set(gca, 'YTick', []);
set(gca,'XTickLabel',sprintf('x'));
set(gca,'YTickLabel','');
title('');
spaceplots();


hold off;