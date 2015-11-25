function [ Segments ] = generateParallelTracks( polygon, width, angle )
%GENERATEPARALLELTRACKS Returns a set of parallel tracks that cover the polygon
%   Uses a simplified sweep line method to find track segments.
    Segments = [];
    disp('Found sweep segment:');
    s = polygon.findSegment(angle)
    sweepAngle = findSweepAngle(polygon, s);
    sweepLine = Line(s);
    sweepLine.translate(width/2, sweepAngle);
    sweepLine
    %disp('Translated sweep line:');
    %sweepLine
    atEnd = false;
    
    while ~atEnd
        sTrack = computeIntersectingSegment(polygon, sweepLine);
        if (isempty(sTrack))
            atEnd = true;
        else
            Segments = [Segments; sTrack(1)];
            % Translate line by width
            sweepLine.translate(width, sweepAngle);
            %sweepLine
        end
    end % while
    
    fprintf('Found %d track segments.', length(Segments));
end % function

% Computes the segment of the line that intersects at least two 
% segments of the polygon. If an intersecting segment does not exist, NaN
% is returned. This assumes a polygon is convex, so the line can only
% intersect 0 segments, 1 segment, or 2 segments. The latter case is the
% only that does not return NaN. An error is thrown if more than 2
% interception points are found with the polygon.
function [sIntersect] = computeIntersectingSegment(polygon, line)
    Intercepts = [];
    sIntersect = [];
    fprintf('Computing intersect with %.0fx + %.0fy = %.0f\n', line.A, line.B, line.C);
    % Find all se
    for i=1:polygon.N
        s = polygon.Segments(i);
        lseg = Line(s);
        p = line.findIntercept(lseg);
        fprintf('Intercept point with line of seg (%.0f,%.0f)->(%.0f,%0.0f)\n',... %, lseg.A, lseg.B, lseg.C);
            s.StartVertex(1), s.StartVertex(2), s.EndVertex(1), s.EndVertex(2));

        if (~isempty(p) && s.containsPoint(p))
            disp('Added p to intercepts');
            Intercepts = [Intercepts; p];
        elseif (~isempty(p))
            disp('Segment does not contain p')
        end
    end
    [n, colDim] = size(Intercepts);
    if (n == 2)
        %fprintf('Added point to intercepts.');
        sIntersect = [Segment(Intercepts(1,:), Intercepts(2,:))];
    elseif (length(Intercepts) > 2)
        error('Polygon is not convex!');
    end
end

% Assumes polygon is ccw defined
function [thetaSweep] = findSweepAngle(polygon, segment)
    minX = polygon.MinX;
    maxY = polygon.MaxY;
    thetaSweep = angularMod(segment.getAngle() + pi/2, 2*pi);
    
    fprintf('Found sweep angle %.2f, when coverage angle is %.2f\n',...
        thetaSweep, rad2deg(polygon.CoverageAngle));
    thetaSweep = angularMod(thetaSweep, 2*pi);
end