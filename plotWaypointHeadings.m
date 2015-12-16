function [fig] = plotWaypointHeadings(hAx, V, X, opts)
% PLOTWAYPOINTHEADINGS plots waypoint headings on top of current figure
%   Called after plotWaypointScenario to plot headings X on top of
%   waypoints.
%
% Input parameters:
%   hAx - axes handle to plot onto
%   V(n,2) - an n-by-2 matrix of vertice coordinates
%   X(n,1) - an n-by-1 vector of headings for each vertex
%   opts - optional path options object. use default if not given
%

% =================== Check Arguments ========================
if nargin < 1
    error('No input arguments given!');
elseif nargin > 5
    error('Too many arguments given!');
end

if isempty(hAx)
    error('hAx not given!');
end
if isempty(V)
    error('V is empty!');
end
if isempty(X)
    error ('X is empty');
end

[n, ~] = size(V);
nX = length(X);
%[nX, ~] = size(X);

if (n ~= nX)
    error(sprintf('X (%d) dimensions should match V (%d)',nX,n));
end

if ~exist('opts','var')
    opts = PathOptions;
end

useQuiver = strcmp(opts.NormalizePlots, 'off');

% ======================== Setup ============================
HEADING_COLOR = opts.HeadingArrowColor;
START_HEADING_COLOR = opts.HeadingStartArrowColor;

% % Normalization
if ~useQuiver
  md=inf; % the minimal distance between vertexes
  for k1=1:n-1,
    for k2=k1+1:n,
      md=min(md,sum((V(k1,:)-V(k2,:)).^2)^0.5);
    end
  end
  if md<eps, % identical vertexes
    error('The array V have identical rows!')
  else
    V(:,1:2)=V(:,1:2)/md; % normalization
  end
end

% md = normalizationCoeff(V);
% Vn = V./md;

%V
%[V(:,1), V(:,2)] = ds2nfu(hAx, V(:,1), V(:,2))

% ====================== Plot Headings =========================
% Plot starting heading
%drawHeadingArrow(hAx, C(1:2), C(3), opts.HeadingArrowSize, START_HEADING_COLOR)

% Plot WP headings
%V
%X
hArrow = drawHeadingArrow(hAx, V(1,:), X(1), opts.HeadingArrowSize, START_HEADING_COLOR, useQuiver);
disableLegendEntry(hArrow);
for i=2:n
   hArrow = drawHeadingArrow(hAx, V(i,:), X(i), opts.HeadingArrowSize, HEADING_COLOR, useQuiver);
   % Remove legend entries for duplicates
   if (i > 2)
      disableLegendEntry(hArrow);
   end
end

% % Plot return heading (if set)
% if m > n
%     drawHeadingArrow(hAx, C(1:2), X(m), opts.HeadingArrowSize, HEADING_COLOR)
% end


end % function plotWaypointHeadings
