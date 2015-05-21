function [x, cost] = solveBruteforcePointToPoint_helper(C, V, pathOptions, x0)
%% SOLVEBRUTEFORCEPOINTTOPOINT_HELPERFUN cost function wrapper for fmincon

%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 4
    error('Too many arguments given!');
end

if isempty(C)
    error('C is empty!');
end
if isempty(V)
    error('V is empty!');
end

if exist('pathOptions','var') && ~isa(pathOptions, 'PathOptions')
    error('pathOptions is not a PathOptions object!');
end
if ~exist('pathOptions','var')
    pathOptions = PathOptions;
end

% Is this slow?
UV = unique(V,'rows');
if ~isequal(size(V),size(UV))
    error('V contains duplicate vertices.');
end

[n, ~] = size(V);
m = n + strcmp(pathOptions.Circuit, 'on');

% Are x0 and V compatible?
if ((strcmp(pathOptions.Circuit, 'off') && (n ~= m))...
    || (strcmp(pathOptions.Circuit, 'on') && ((n + 1) ~= m)))
    error('Expected x0 and V to have compatible dimensions.');
end

% fmincon settings
fminconOptions = optimset('Algorithm', 'interior-point');
fminconOptions = optimset(fminconOptions, 'Display', 'off');
%fminconOptions = optimset(fminconOptions, 'UseParallel', 'always');


% fmincon constraints (0 <= theta <= 2*pi)
lb = zeros(m,1);
ub = ones(m,1) * (2*pi - 0.00001);

% Call fmincon
[x, cost] = fmincon(@computePathCost, x0, [], [], [], [], lb, ub, [], fminconOptions);
%[x, fval] = fminunc(@computePathCost,x0);

% Nested fmincon function that computes cost
    function [f] = computePathCost(x)
    position = C(1:2);
    heading = C(3);
    f = 0;
    
    for i=1:n
        v = V(i, :);
        theta  = x(i);
        f = f + findPTPCost(position,heading,v,theta,pathOptions.TurnRadius);
        position = v;
        heading = theta;
    end
    
    % Return cost
    if strcmp(pathOptions.Circuit, 'on')
        theta = x(n+1);
        %theta = findHeadingFrom(position,C(1:2));
        f = f + findPTPCost(position,heading,C(1:2),...
            theta, pathOptions.TurnRadius);
    end
    
    % Minimize or maximize cost
    if strcmp(pathOptions.MaximizeCost, 'on')
        f = f * -1;
    end
end

end


