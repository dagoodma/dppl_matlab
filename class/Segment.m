classdef Segment < handle
    %POLYGONSEGMENT Represents a segment line of a polygon.
    %   
    
    properties(SetAccess = public)
        StartVertex
        EndVertex
    end


    methods
        % Constructor takes a list of vertices minimum altitude and angle
        function segment = Segment(u, v)
        	segment.StartVertex = u;
        	segment.EndVertex = v;
        end
        % Returns the orientation of the segment
        function angle = getAngle(obj)
        	xd = obj.EndVertex(1) - obj.StartVertex(1);
        	yd = obj.EndVertex(2) - obj.StartVertex(2);
			angle = angularMod(atan2(yd,xd), 2*pi);
        end
        % Returns true if the point lies on the segment
        function result = containsPoint(obj, p)
        	l = Line(obj);
        	onLine = l.containsPoint(p);
        	if onLine
        		disp('Checking if p is on segment with')
        		maxX = max(obj.StartVertex(1), obj.EndVertex(1))
        		maxY = max(obj.StartVertex(2), obj.EndVertex(2))
        		minX = min(obj.StartVertex(1), obj.EndVertex(1))
        		minY = min(obj.StartVertex(2), obj.EndVertex(2))
        		result = (p(1) >= minX && p(1) <= maxX...
        			&& p(2) >= minY && p(2) <= maxY);
        	else
        		result = false;
        	end
        	result
        end

   end
end
    

