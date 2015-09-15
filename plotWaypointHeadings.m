function [fig] = plotWaypointHeadings(hAx, V, X, pathOptions)
% PLOTWAYPOINTHEADINGS plots waypoint headings on top of current figure
%   Called after plotWaypointScenario to plot headings X on top of
%   waypoints.
%
% Input parameters:
%   hAx - axes handle to plot onto
%   V(n,2) - an n-by-2 matrix of vertice coordinates
%   X(n,1) - an n-by-1 vector of headings for each vertex
%   pathOptions - optional path options object. use default if not given
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
[nX, ~] = size(X);

if (n ~= nX)
    error('X dimensions do not match V');
end

if ~exist('pathOptions','var')
    pathOptions = PathOptions;
end


% ======================== Setup ============================
HEADING_COLOR = 'm';
START_HEADING_COLOR = 'r';

% Normalization
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

% ====================== Plot Headings =========================
% Plot starting heading
%drawHeadingArrow(hAx, C(1:2), C(3), pathOptions.HeadingArrowSize, START_HEADING_COLOR)

% Plot WP headings
for i=1:n
   drawHeadingArrow(hAx, V(i,:), X(i), pathOptions.HeadingArrowSize, HEADING_COLOR)
end

% % Plot return heading (if set)
% if m > n
%     drawHeadingArrow(hAx, C(1:2), X(m), pathOptions.HeadingArrowSize, HEADING_COLOR)
% end


end % function plotWaypointHeadings
