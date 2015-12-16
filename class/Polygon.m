classdef Polygon < handle
    %POLYGON Represents a polygon defined by its vertices listed in a
    % counter-clockwise direction.
    %   
    
    properties(SetAccess = public)
        N = 0
        Vertices % Counter-clockwise vertices of the polygon
        Segments = [ ] % Segments that make up the edges of the polygon
        Width % Minimum width across polygon
        CoverageAngle % Angle perpendicular to the distance line of altitude, in rad
        MinX
        MinY
        MaxX
        MaxY
    end
    
    methods
        % Constructor takes a list of vertices and optional minimum
        % width and angle of the polygon.
        function self = Polygon(V, w, a)
            self.Vertices = V;
            [self.N, dimC] = size(V);
            if (dimC ~= 2)
                error('Expected V to have 2 columns.');
            end
            if (self.N < 3)
                error('Expected at least 3 vertices.');
            end
            if nargin > 1
                self.Width = w;
            end
            if nargin > 2
                self.CoverageAngle = a;
            end
            
            self.MinX = self.Vertices(1,1);
            self.MinY = self.Vertices(1,2);
            self.MaxX = self.Vertices(1,1);
            self.MaxY = self.Vertices(1,2);

            for i=2:self.N
                u = V(i-1, :);
                v = V(i, :);
                s = Segment(u,v);
                self.Segments = [self.Segments; s];

                if (v(1) < self.MinX)
                    self.MinX = v(1);
                end
                if (v(1) > self.MaxX)
                    self.MaxX = v(1);
                end
                if (v(2) < self.MinY)
                    self.MinX  = v(2);
                end
                if (v(2) > self.MaxY )
                    self.MaxX  = v(2);
                end
            end

            % Add segment back to start (Does not add another vertex!)
            s = Segment(V(self.N,:), V(1,:));
            self.Segments = [self.Segments; s];
        end % function
        
        % Finds the polygon segment with the angle of its line (mod pi) for sweeping.
        % The sweep segment is extended to become a line.
        function [sweepSegment] = findSegment(obj, lineAngle)
            ANGLE_EPSILON = 0.1;

            sweepSegments = [];
            for i=1:(obj.N)
                s = obj.Segments(i);
                ang = angularMod(s.getAngle(), pi);
                % fprintf('Considering line %d with angle=%f\n',i, rad2deg(ang));
                if (abs(ang - lineAngle) < ANGLE_EPSILON)
                    if (length(sweepSegments) >= 2)
                        error('Polygon must not be convex!');
                    end
                    sweepSegments = [sweepSegments; s];
                end
            end

            if (length(sweepSegments) < 1)
                error('Polygon coverage angle did not match a segment');
            end

            sweepSegment = sweepSegments(1)
        end % function
    end % methods
end
