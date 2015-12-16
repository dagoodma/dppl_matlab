function [Atotal, Acovered, Pcover] = compareCoveredArea(P, X, Y, w)
%	Parameters:
%		P		Polygon or vertices of a polygon to cover
%		X		x-component of visited points
%		Y		y-component of visited points
%		w		width of square sensor footprint
%

DEBUG = false;

% Get vertices and connect last to first
if isa(P,'Polygon')
    P = P.Vertices;
end

% Close the polygon if it's not already
if any((P(1,:) == P(end,:)) == 0)
	P = [P; P(1,:)];
end

% Clockwise for external contours
if ~ispolycw(P(:,1),P(:,2))
	P = flipud(P);
end


Atotal = polyarea(P(:,1),P(:,2));
n = length(X);

% Going clockwise
squareVert = @(x,y,w)  [(x-w/2) (y-w/2);...
					    (x-w/2) (y+w/2);...
					    (x+w/2) (y+w/2);...
					    (x+w/2) (y-w/2);...
					    (x-w/2) (y-w/2)]; % back to the beginning

if (DEBUG)
	figure()
	subplot(221);
	plot(P(:,1),P(:,2),'-k');
	hold on;
end
	
% Create intersection polygons
newPolygons = {};

for i=1:n
	p = [X(i), Y(i)]
	sq = squareVert(p(1),p(2),w);
	if (DEBUG)
		fill(sq(:,1), sq(:,2),'r');
		hold on;
	end
	
	[x,y] = polybool('intersection', sq(:,1), sq(:,2), P(:,1),P(:,2));
	newPolygons{end + 1} = [x, y];
end

if (DEBUG)
	axis equal;
	hold off;
	subplot(222)
end

% Count up the intersecting areas
Acovered = 0;
Pcover = {};
for i=1:length(newPolygons)
	Pi = newPolygons{i}
	if (DEBUG)
		fill(Pi(:,1), Pi(:,2),'r');
		hold on;
	end
	% Subtract off already covered area
	for j=1:(i-1)
		Pj = newPolygons{j};
		[x,y] = polybool('subtraction', Pi(:,1), Pi(:,2), Pj(:,1), Pj(:,2));
		Pi = [x,y];
	end
	if (~isempty(Pi))
		Pcover{end+1} = Pi;
		Ai = polyarea(Pi(:,1), Pi(:,2))
		if ~isnan(Ai)
			Acovered = Acovered + Ai;
		end
	end
end

if (DEBUG)
	plot(P(:,1), P(:,2), '-k');
	axis equal;
	hold off;
end


end % function
