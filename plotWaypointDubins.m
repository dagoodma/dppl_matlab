function [fig] = plotWaypointDubins(hAx, V, E, X, pathOptions)
% PLOTWAYPOINTDubins plots dubins paths on top of figure

% =================== Check Arguments ========================

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

if (min(X) < 0 || max(X) > 2*pi)
    error('X has invalid elements');
end

[n, ~] = size(V);
[m, ~] = size(E);

if (n ~= length(X))
    error('Length of V and X do not match');
end

if (n ~= (m + strcmp(pathOptions.Circuit, 'on') - 1))
    error('E dimensions not compatible with V');
end

% ======================== Setup ============================
PATH_COLOR = 'g';

% Plot waypoint headings first
plotWaypointHeadings(hAx, V, X, pathOptions);

% Normalization
%V = normalizePoints(V);
md = normalizationCoeff(V);

% Get waypoint order
order = getVertexOrder(E);


% ====================== Plot Dubins =========================
position = V(1,:);
heading = X(1);
C_total = 0;

if strcmp(pathOptions.Debug,'on')
    vertexOrder = order;
end

for i=2:(m+1)
    % Generate Dubins path
    theta_0 = heading2Theta(heading);
    q0 = [position(1:2) theta_0];
    vi = order(i);
    if i < (m+1)
        theta_1 = heading2Theta(X(vi));
        q1 = [V(vi,:) theta_1];
    else
        % Return to start
        q1 = [V(1,:) X(1)];
    end
    path = dubins(q0, q1, pathOptions.TurnRadius, pathOptions.DubinsStepSize);
    
    if strcmp(pathOptions.Debug,'on')
        c = 0;
        for j=2:length(path)
            c_i = sqrt((path(1,j) - path(1,j-1))^2 + (path(2,j) - path(2,j-1))^2);
            c  = c + c_i;
        end % for
        C_total = C_total + c;
        %fprintf('Cost of leg (%i,%i) is %0.2f\n', order(i-1), vi, c);
    end
    
    % Update position
    
    position = q1(1:2);
    heading = X(order(i));
    
    % Plot path
    hold on;
    plot(path(1,1:end)/md,path(2,1:end)/md, 'Color', PATH_COLOR);
    hold off;
    
end


if strcmp(pathOptions.Debug,'on')
    fprintf('Simulated Dubins'' path with cost %0.2f\n', C_total);
end


end % function plotWaypointDubins
