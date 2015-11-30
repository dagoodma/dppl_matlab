function [fh] = plotPolygon(poly, t)

% Get vertices and connect last to first
if isa(poly,'Polygon')
    poly = poly.Vertices;
end
P = [poly; poly(1,1), poly(1,2)];

fh = plot(P(:,1),P(:,2));

if nargin > 1
    title(t);
end

axis equal;
expandAxes(1.3,1.3);

end % function