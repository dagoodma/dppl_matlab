function [order] = getVertexOrder(E)  
% GETVERTEXORDER obtains the ordered indices of vertices from E

if isempty(E)
    error('E is empty!');
end
[m, ~] = size(E);
n = m + 1;

% Grab the order of waypoints visited from E
order = zeros(1, n);
order(1:n-1) = E(:,1)';
order(n) = E(end,2);

end % function getVertexOrder