function [fig] = plotWaypointDubins(hAx, V, E, X, C, pathOptions)
% PLOTWAYPOINTDubins plots dubins paths on top of figure

% =================== Check Arguments ========================
E
if nargin < 1
    error('No input arguments given!');
elseif nargin > 6
    error('Too many arguments given!');
end

if isempty(hAx)
    error('hAx not given!');
end
if isempty(V)
    error('V is empty!');
end
if isempty(E)
    error('E is empty!');
end
if isempty(X)
    error ('X is empty');
end
if isempty(C)
    error('C is empty!');
end

[n, ~] = size(V);
[m, ~] = size(X);

if (n ~= (m - strcmp(pathOptions.Circuit, 'on')))
    error('X dimensions not compatible with V');
end

if (length(C) ~= 3)
    error ('C should have 3 components');
end

% ======================== Setup ============================
PATH_COLOR = 'g';

% Plot waypoint headings first
plotWaypointHeadings(hAx, V, X, C, pathOptions);

% Normalization (used below on path)
md=inf; % the minimal distance between vertexes
for k1=1:n-1,
  for k2=k1+1:n,
    md=min(md,sum((V(k1,:)-V(k2,:)).^2)^0.5);
  end
end
if md<eps, % identical vertexes
  error('The array V have identical rows!')
end

% Get waypoint order
order = getVertexOrder(E);

% ====================== Plot Dubins =========================
position = C(1:2);
heading = C(3);

for i=1:m
    % Generate Dubins path
    theta_0 = heading2Theta(heading);
    q0 = [position(1:2) theta_0];
    if i < m
        theta_1 = heading2Theta(X(order(i)));
        q1 = [V(order(i),:) theta_1];
    else
        % Return to start
        theta_1 = heading2Theta(X(m));
        q1 = [C(1:2) theta_1];
    end
    path = dubins(q0, q1, pathOptions.TurnRadius, pathOptions.DubinsStepSize);
    
    if strcmp(pathOptions.Debug,'on')
        c = 0;
        for j=2:length(path)
            c_i = sqrt((path(1,j) - path(1,j-1))^2 + (path(2,j) - path(2,j-1))^2);
            c  = c + c_i;
        end % for
        fprintf('Cost of leg %i is %d\n', i, c);
    end
    
    % Update position
    if i < m
        position = q1(1:2);
        heading = X(order(i));
    end
    
    % Plot path
    hold on;
    plot(path(1,1:end)/md,path(2,1:end)/md, 'Color', PATH_COLOR);
    hold off;
    
end


end % function plotWaypointDubins
