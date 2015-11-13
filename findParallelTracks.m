function [ Segments ] = findParallelTracks( polygon, width )
%FINDPARALLELTRACKS Returns a set of parallel tracks that cover the polygon
%   Uses a simplified sweep line method to find track segments.
    Segments = [];
    s = findSweepSegment(polygon);
    theta = findSweepAngle(polygon, s);
    sweepLine = Line(s);
    sweepLine.translate(width/2, theta);
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
            sweepLine.translate(width, theta);
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
        lseg = Line(s)
        p = line.findIntercept(lseg);
        fprintf('Intercept point with line of seg (%.0f,%.0f)->(%.0f,%0.0f)\n',... %, lseg.A, lseg.B, lseg.C);
            s.StartVertex(1), s.StartVertex(2), s.EndVertex(1), s.EndVertex(2));
        p
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
    fprintf('Found intercepts: ');
    disp(Intercepts);
    fprintf('And track segment: ');
    disp(sIntersect);
end


% Finds a polygon segment and sweep angle for sweeping the polygon.
% The sweep segment is extended to become a line.
function [sweepSegment] = findSweepSegment(polygon)
    sweepSegments = [];
    for i=1:(polygon.N)
        s = polygon.Segments(i);
        ang = angularMod(s.getAngle(), pi);
        % fprintf('Considering line %d with angle=%f\n',i, rad2deg(ang));
        if (ang == polygon.CoverageAngle )
            if (length(sweepSegments) >= 2)
                error('Polygon must not be convex!');
            end
            sweepSegments = [sweepSegments; s];
        end
    end

    sweepSegment = sweepSegments(1);
    if (length(sweepSegments) < 1)
        error('Polygon coverage angle did not match a segment');
    end
end % function

% Assumes polygon is ccw defined
function [thetaSweep] = findSweepAngle(polygon, segment)
    minX = polygon.MinX;
    maxY = polygon.MaxY;
    thetaSweep = angularMod(segment.getAngle() + pi/2, 2*pi);
    
    % if (thetaSweep <= pi)
    %     thetaSweep = thetaSweep + 3*pi/2;
    % else
    %     thetaSweep = thetaSweep + 3*pi/2;
    % end
    % if (thetaSweep <= pi/2)
    % If segment is on the left or the top side
    % isOnTop = segment.StartVertex(2) == maxY || segment.EndVertex(2) == maxY
    % isOnLeft = segment.StartVertex(1) == minX || segment.EndVertex(1) == minX
    % if (polygon.CoverageAngle <= pi...
    %     && (isOnTop || isOnLeft))
    %     thetaSweep = thetaSweep + pi;
    % elseif (polygon.CoverageAngle > pi...
    %     && ~(isOnTop || isonLeft))
    %     thetaSweep = thetaSweep + pi;
    % end
    fprintf('Found sweep angle %.2f from coverage angle %.2f\n',...
        thetaSweep, rad2deg(polygon.CoverageAngle));
    thetaSweep = angularMod(thetaSweep, 2*pi);
end