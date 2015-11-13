classdef Polygon < handle
    %POLYGON Represents a polygon defined by its vertices listed in a
    % counter-clockwise direction.
    %   
    
    properties(SetAccess = public)
        N = 0
        Vertices % Counter-clockwise vertices of the polygon
        Segments = [ ] % Segments that make up the edges of the polygon
        Width % Minimum width across polygon
        CoverageAngle % Angle perpendicular to the distance line of altitude
        MinX
        MinY
        MaxX
        MaxY
    end
    
    methods
        % Constructor takes a list of vertices minimum altitude and angle
        function self = Polygon(V, w, a)
            self.Vertices = V;
            self.CoverageAngle = a;
            self.Width = w;
            self.N = length(V);

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

            s = Segment(V(self.N,:), V(1,:));
            self.Segments = [self.Segments; s];
        end % function
    end % methods
end
