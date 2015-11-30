function drawHeadingArrow(hAx, origin, psi, arrowSize, color, useQuiver)
% DRAWHEADINGARROW draws an annotation arrow at the heading psi
%
% If useQuiver is set, the plot does not have to be normalized.

%% ================ Dependencies ===============

% Find all dependencies
% Add lib and class folders
addpath('lib','class');

% =================== Check Arguments ========================
if nargin < 1
    error('No input arguments given!');
elseif nargin > 6
    error('Too many arguments given!');
end

if isempty(hAx)
    error('hAx not given!');
end
if isempty(origin)
    error('origin is empty!');
end
if isempty(psi)
    error ('psi not given!');
end
if isempty(arrowSize)
    error('arrowSize not given!');
end
if (isempty(color))
    error('color not given!');
end
if nargin < 6
	useQuiver = false;
end


headLength = 10; %arrowSize *2;
headWidth = 10; %arrowSize *2;

% ================== Draw Arrow =======================
ox = origin(1);
oy = origin(2);

theta = heading2angle(psi);
% 
% if (psi < 0 || psi >= 2*pi)
%     error('Unexpected psi value: %f', psi);
% elseif (psi < pi/2)
%     px = ox + arrowSize*sin(psi);
%     py = oy + arrowSize*sin(pi/2 - psi);
% elseif (psi < pi)
%     psi = psi - pi/2;
%     px = ox + arrowSize*sin(pi/2 - psi);
%     py = oy - arrowSize*sin(psi);
% elseif (psi < 3*pi/2)
%     psi = psi - pi;
%     px = ox - arrowSize*sin(psi);
%     py = oy - arrowSize*sin(pi/2 - psi);
% else
%     psi = psi - 3*pi/2;
%     px = ox - arrowSize*sin(pi/2 - psi);
%     py = oy + arrowSize*sin(psi);
% end

%[of, pf] = dsxy2figxy(gca, [ox oy], [px py])
%oxf = of(1), oyf = of(2)
%pxf = pf(1), pyf = pf(2)
%[pxf, pyf] = dsxy2figxy(hAx, px, py);

%[oxf, oyf] = ds2nfu(hAx, ox, oy)
%[pxf, pyf] = ds2nfu(hAx, px, py)

% annotation('textarrow',ox,oy,'String','y = x ')

% ox, px, oy, py
% hold on;
% plot(ox, oy, '*g');
% hold off;
% [of pf] = axescoord2figurecoord([ox px], [oy py], hAx);
% oxf = of(1); 
% oyf = of(2);
% pxf = pf(1);
% pyf = pf(2);

% annotation_pinned('arrow', [oxf pxf], [oyf pyf], 'Color', color,...
%     'HeadLength', headLength, 'HeadWidth', headWidth, 'axes', hAx);

if (~useQuiver)
	%[dx, dy] = pol2cart(theta, arrowSize);
	%px = ox + dx;
	%py = ox + dy;
	[px, py] = getArrowEndpoint([ox, oy], psi, arrowSize/10);

	[oxf, oyf] = ds2nfu(hAx, ox, oy);
	[pxf, pyf] = ds2nfu(hAx, px, py);
	annotation('arrow', [oxf pxf], [oyf pyf], 'Color', color,...
	   'HeadLength', headLength, 'HeadWidth', headWidth);
else
	u = arrowSize*cos(theta);
	v = arrowSize*sin(theta);
	qv = quiver(ox, oy, u, v, arrowSize, 'AutoScale', 'off', 'Color', color,...
	    'MaxHeadSize', 1e2);
end
%set(qv,'MaxHeadSize',arrowSize/2);
%set(qv,'Color', color);

% Works for non-normalized
% FIXME add an argument to use this instead
%%vectarrow([ox oy], [px py]);

% annotation_pinned('arrow', [oxf pxf], [oyf pyf], 'Color', color,...
%     'HeadLength', headLength, 'HeadWidth', headWidth, 'axes', hAx);

end % function drawHeadingArrow()

function [px, py] = getArrowEndpoint(origin, psi, s)
	ox = origin(1);
	oy = origin(2);

	px = ox;
	py = oy;
	if (psi < 0 || psi >= 2*pi)
	    error('Unexpected psi value: %f', psi);
	elseif (psi < pi/2)
	    px = ox + s*sin(psi);
	    py = oy + s*sin(pi/2 - psi);
	elseif (psi < pi)
	    psi = psi - pi/2;
	    px = ox + s*sin(pi/2 - psi);
	    py = oy - s*sin(psi);
	elseif (psi < 3*pi/2)
	    psi = psi - pi;
	    px = ox - s*sin(psi);
	    py = oy - s*sin(pi/2 - psi);
	else
	    psi = psi - 3*pi/2;
	    px = ox - s*sin(pi/2 - psi);
	    py = oy + s*sin(psi);
	end
end % function

