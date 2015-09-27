function [ cost ] = findPTPCost( p1, x1, p2, x2, r )
%FINDPTPCOST Finds the cost of traversing from one configuration to another
%   findPTPCost(p1, x1, p2, x2, r)
%   The PTP cost is determined using the shortest Dubins path length.
%
if nargin < 1
    error('No input arguments given!');
elseif nargin > 5
    error('Too many arguments given!');
end

cost = findDubinsLength(p1, x1, p2, x2, r);

end  % function findPTPCost
