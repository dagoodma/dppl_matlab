function [ ] = plotParallelTracks( polygon, width )
%PLOTPARALLELTRACKS Plots parallel field tracks for covering the polygon
%   Tracks are plotted that effectively cover the polygon. Lines are plotted
%   in the direction of the polygon's minimum altitude coverage angle.

% Find all segments that have the correct angle

sweepSegments = [];
for i=1:(polygon.N)
	s = polygon.Segments(i);
	ang = angularMod(s.getAngle(),pi);
	fprintf('Considering line %d with angle=%f\n',i, rad2deg(ang));
	if (ang == polygon.CoverageAngle )
		if (length(sweepSegments) >= 2)
			error('Polygon must not be convex!');
		end
		sweepSegments = [sweepSegments; s];
	end
end

if (length(sweepSegments) < 1)
	error('Polygon coverage angle did not match a segment');
end

%sweepSegments
%size(sweepSegments)

s = sweepSegments(1);
hold on;
plot([s.StartVertex(1),s.EndVertex(1)], [s.StartVertex(2),s.EndVertex(2)],'LineWidth',2);
%if (length(sweepSegments) > 1)
%	s = sweepSegments(2);
%	plot([s.StartVertex(1),s.EndVertex(1)], [s.StartVertex(2),s.EndVertex(2)],'LineWidth',2);
%end

%% Test new sweep line method
Tracks = findParallelTracks(polygon, width)
for i=1:length(Tracks)
	s = Tracks(i);
	plot([s.StartVertex(1) s.EndVertex(1)], [s.StartVertex(2) s.EndVertex(2)], '--g');
end
hold off;

end % function
