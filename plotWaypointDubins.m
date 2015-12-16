function [hAx, pDubins] = plotWaypointDubins(V, E, X, opts)
% PLOTWAYPOINTDubins plots dubins paths on top of figure

% =================== Check Arguments ========================

if nargin < 1
    error('No input arguments given!');
elseif nargin > 4
    error('Too many arguments given!');
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

if (m ~= (n + strcmp(opts.Circuit, 'on') - 1))
    error('E dimensions not compatible with V');
end


%================= Dependencies ====================

% Add Dubins plot tool
if exist('dubins') ~= 3
    if exist('lib/DubinsPlot') ~= 7
        error('Could not find the DubinsPlot folder.');
    end
    addpath('lib/DubinsPlot');
    if exist('dubins') ~= 3
        error('Could not find compiled dubins mex file.');
    end
end

% ======================== Setup ============================
PATH_COLOR = opts.DubinsPathColor;

% Normalization
%V = normalizePoints(V);
if strcmp(opts.NormalizePlots, 'on')
    md = normalizationCoeff(V);
else
    md = 1;
end

% Get waypoint order
order = getVertexOrder(E);


% ====================== Plot Dubins =========================
position = V(1,:);
heading = X(1);
C_total = 0;
pDubins = [];

if strcmp(opts.Debug,'on')
    vertexOrder = order;
end

for i=2:(m+1)
    % Generate Dubins path
    theta_0 = heading2angle(heading);
    q0 = [position(1:2) theta_0];
    vi = order(i); % get index of vertex in tour
    if i < (m+1) || (i <= (m+1) && strcmp(opts.Circuit,'off'))
        theta_1 = heading2angle(X(vi));
        q1 = [V(vi,:) theta_1];
    else
        % Return to start or first node
        if (strcmp(opts.CircuitInitial,'on'))
            theta_1 = heading2angle(X(1));
            q1 = [V(1,:) theta_1];
        else
            theta_1 = heading2angle(X(order(2)));
            q1 = [V(order(2),:) theta_1];
        end
    end
    path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
    pDubins = [pDubins; path(1,:)', path(2,:)'];
    
    if strcmp(opts.Debug,'on')
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
    hPath = plot(path(1,1:end)/md,path(2,1:end)/md, 'Color', PATH_COLOR);
    hold off;

    % Remove legend entries for duplicates
    if (i > 2)
        disableLegendEntry(hPath);
    end
    
end


if strcmp(opts.Debug,'on')
    fprintf('Simulated Dubins'' path with cost %0.2f\n', C_total);
end

% set(hAx,'DataAspectRatioMode', 'auto');
% set(hAx,'PlotBoxAspectRatioMode', 'auto');

% set(hAx,'DataAspectRatio', [1 1 1]);
% set(hAx,'PlotBoxAspectRatio', [1 1 1]);

% Plot headings
hAx = gca;
plotWaypointHeadings(hAx, V./md, X, opts);

end % function plotWaypointDubins
