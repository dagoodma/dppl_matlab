function [E, X, Cost] = solveBruteforceLineToLine(C, V, pathOptions)
% SOLVEBRUTEFORCELINETOLINE solves the line to line problem by brute-force
%   solveBruteforceLineToLine(C, V, pathOptions) finds an optimal, line-based 
%   path for the n-by-2 set of vertices V from the 1-by-3 starting
%   configuration C. This solver will try all possible paths and return an
%   m-by-3 set of edges E, and the total cost of traversal c.
%
%   The algorithm runs in O( (p - 2) * 2^k ), where p is the number of
%   line endpoints (since some lines have only 1 endpoint), and k is the
%   number of lines.
%

%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 3
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

UV = unique(V,'rows');
if ~isequal(size(V),size(UV))
    error('V contains duplicate vertices.');
end

[n, ~] = size(V);

%=============== Find Lines ================
[B, lineCount, p] = findBestLineSets(V, pathOptions);
[~, m] = size(B); % number of trajectory line sets

if strcmp(pathOptions.Debug,'on')
    pathCount = (p - 2)*2^lineCount * factorial(lineCount) * m;
    if (pathCount < 2), pathCount = 2; end;
    fprintf(['Brute force LTL solver found %d line sets with %d lines. ',...
             'Trying %d paths.\n'], m, lineCount, pathCount);
end

%================= Solve ===================
E = zeros(n - 1,3);
X = zeros(n + strcmp(pathOptions.Circuit,'on'), 1);
c_approach = 0;
c_return = 0;
c = -1;

% Find minimum over all line sets
for i=1:m
    % Minimum cost results for line set i
    c_i = -1;
    c_i_approach = 0;
    c_i_return = 0;
    E_i = zeros(n - 1, 3);
    X_i = zeros(n + strcmp(pathOptions.Circuit,'on'), 1);
    
    % Find minimum over all permutations of this line set i
    L_i = B{i};
    Lperms = perms(L_i);
    for j=1:length(Lperms)
        % Minimum cost results for permutation j
        c_j = -1;
        c_j_approach = 0;
        c_j_return = 0;
        E_j = zeros(n - 1, 3);
        X_j = zeros(n + strcmp(pathOptions.Circuit,'on'), 1);
        
        % Find minimum cost configuration of permutation j using gray code
        % for line configuration
        L_j = Lperms(j,:);
        for k=0:(2^lineCount)
            if configIsRedundant(L_j, k), continue; end
            L_k = configureLineSet(L_j, k);
            
            % Approach cost
            v =  V(L_k(1).StartVertexIndex,:);
            theta = L_k(1).Heading;
            c_k_approach = findPTPCost(C(1:2), C(3), v, theta,...
                pathOptions.TurnRadius);
            c_k = c_k_approach;
            
            % Line set cost
            [E_k, X_k, c_tmp] = traverseLineSet(V,L_j,pathOptions);
            c_k = c_k + c_tmp;
            
            % Return cost
            if strcmp(pathOptions.Circuit,'on')
                v =  V(L_k(end).EndVertexIndex,:);
                theta_1 = L_k(end).Heading;
                theta_2 = findHeadingFrom(v, C(1:2));
                c_k_return = findPTPCost(v, theta_1, C(1:2), theta_2,...
                    pathOptions.TurnRadius);
                c_k = c_k + c_k_return;
                X_k = [X_k; theta_2];
            end 
            
            % Remember this if it's a minimum result
            if (c_j < 0) || (c_k < c_j)
                c_j = c_k;
                c_j_approach = c_k_approach;
                c_j_return = c_k_return;
                E_j = E_k;
                X_j = X_k;
            end
            
        end % for each config
        
        % Remember this if it's a minimum result
        if (c_i < 0) || (c_j < c_i)
            c_i = c_j;
            c_i_approach = c_j_approach;
            c_i_return = c_j_return;
            E_i = E_j;
            X_i = X_j;
        end
        
    end % for each permutation
    
    % Remember this if it's a minimum result
    if (c < 0) || (c_i < c)
        c = c_i;
        c_approach = c_i_approach;
        c_return = c_i_return;
        E = E_i;
        X = X_i;
    end
    
end % for each line set

Cost = [c c_approach c_return];

end

%% Determines whether the line configutation is redundant and can be skipped
%   Single point lines that have their respective bit in the configuration
%   code set to 1, and can be skipped because their start and end points
%   are the same.
function result = configIsRedundant(L, config)
    result = 0;
    [~,k] = size(L);
    for idx=1:k
        if L(idx).isPoint() && bitget(config,idx)
            result = 1;
            return;
        end
    end
end

%% Configures the given line set by setting the starting and ending points
function L_configured = configureLineSet(L, config)
    L_configured = L;
    k = length(L);
    for idx=1:k
        if bitget(config,idx)
            L_configured(idx).startAtEnd(1);
        end
    end
end
