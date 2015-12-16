function [hPoly] = plotPolygon(poly, args)

% Get vertices and connect last to first
if isa(poly,'Polygon')
    poly = poly.Vertices;
end

if nargin < 2
	args = {'r'}; % default color is red
elseif ~iscell(args)
	args = {args};
end

P = [poly];
% Close the polygon if it's not already
if any((poly(1,:) == poly(end,:)) == 0)
	P = [P; P(1,:)];
end

%fh = plot(P(:,1),P(:,2),'--b');
hPoly = fill(P(:,1),P(:,2),args{:});%, 'FaceAlpha',0.1);
xd = get(hPoly,'XData');
set(hPoly,'ZData',-1*ones(length(xd)));


axis equal;
%expandAxes(1.3,1.3);

end % function