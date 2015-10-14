function [c, E] = findDubinsTourCost(V, X, E, pathOptions)
% FINDDUBINSTOURCOST find the cost of the dubins tour through V
%
%   Params:
%       V           A n-by-2 matrix of vertices.
%       X           An n-by-1 vector of headings.
%       E           An m-by-3 matrix of edges.
%       pathOptions Path options.
%


%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 4
    error('Too many arguments given!');
end

if isempty(V)
    error('V is empty!');
end

UV = unique(V,'rows');
if ~isequal(size(V),size(UV))
    error('V contains duplicate vertices.');
end

[n, ~] = size(V);

if (isempty(X) || min(X) < 0 || max(X) >= 2*pi)
    error('x is invalid!');
end
if (length(X) ~= n) 
    error('Expected size of X to match number of rows in V.');
end

UE = unique(E,'rows');
if ~isequal(size(E),size(UE))
    error('E contains duplicate edges.');
end

if (isempty(E))
    error('E is empty!');
end

[m, ~] = size(E);

m = m - 1 + strcmp(pathOptions.Circuit, 'on'); % number of edges
%m_expected = n - 1 + strcmp(pathOptions.Circuit, 'on'); % number of edges
%if (m ~= m_expected)
%    error('Expected E to have m edges!');
%end

if (E(1,1) ~= 1) 
    error('Expected tour to start at origin!');
end

if exist('pathOptions','var') && ~isa(pathOptions, 'PathOptions')
    error('pathOptions is not a PathOptions object!');
end
if ~exist('pathOptions','var')
    pathOptions = PathOptions;
end


%================= Solve ===================
c = 0;
V_visited = zeros(1, n);

if strcmp(pathOptions.Debug,'on')
    fprintf('Finding Dubins tour cost with (%d nodes and %d edges).\n',...
        n, m);
end

% From the start position, traverse all vertices
position = V(1,:);
heading = X(1);
V_visited(1) = 1;

for i=1:m
    e = E(i,:);
    src_idx = e(1);
    targ_idx = e(2);
    u = V(src_idx,:); % should already be at this position & heading
    v = V(targ_idx,:);
    xv = X(targ_idx);
    
    c_i = findPTPCost(position, heading, v, xv, pathOptions.TurnRadius);
    E(i,3) = c_i;
    c  = c + c_i;
    
    % Update position
    V_visited(targ_idx) = 1;
    position = v;
    heading = xv;
end % for i

% if (~isempty(find(V_visited < 1)))
%     if strcmp(pathOptions.Debug,'on')
%         disp('Skipped: ');
%         find(V_visited < 1)
%     end
%     error('Path in E was not a complete tour!');
% end

if strcmp(pathOptions.Debug,'on')
    fprintf('Found Dubins tour cost: %0.2f\n', c);
end

end % function findDubinsTourCost
