classdef TrajectoryLine < handle
    %TRAJCTORYLINE Represents a line of vertices.
    %   
    
    properties(SetAccess = private)
        StartVertexIndex % Vertex index to the start of the line
        EndVertexIndex   % Vertex index to the end of the line
        VertexIndices % Ordered indices of vertices on the line
        Heading         % Angle in radians between the pos. y-axis and the line
        Length = 0;   % Number of edges in the line
        StartAtEnd = 0; % Whether iterator starts at end or not
        IteratorIndex = 1;
    end
    
    methods
        % Constructor takes a starting vertex index and an angle in radians
        function line = TrajectoryLine(startVertex, psi)
            if nargin > 1
                line.VertexIndices = [startVertex];
                line.Heading = psi;
            end
        end
        % Extends the end of the line by adding the new vertex index.
        function addEdge(obj, newEndVertex)
            obj.VertexIndices = [obj.VertexIndices newEndVertex];
            obj.Length = obj.Length + 1;
        end
        % Return true of this line has only one vertex
        function result = isPoint(obj)
            result = obj.Length < 1;
        end
        % Returns index of start vertex on line
        function i = get.StartVertexIndex(obj)
            if obj.StartAtEnd
                i = obj.VertexIndices(end);
            else
                i = obj.VertexIndices(1);
            end
        end
        % Returns index of end vertex on line
        function i = get.EndVertexIndex(obj)
            if obj.StartAtEnd
                i = obj.VertexIndices(1);
            else
                i = obj.VertexIndices(end);
            end
        end
        % Returns the line's heading angle
        function psi = get.Heading(obj)
            if obj.StartAtEnd
                psi = mod(obj.Heading + pi, pi);
            else
                psi = obj.Heading;
            end
        end
        %================== Iterator functions ===================
        % Returns the next vertex index and advances the iterator.
        function i = getNext(obj)
            % If the iterator is at the end, return -1
            if ~obj.hasNext()
                i = -1;
                return;
            end
            
            % Return the vertex index and advance iterator
            i = obj.VertexIndices(obj.IteratorIndex);

            if ~obj.StartAtEnd
                obj.IteratorIndex = obj.IteratorIndex + 1;
            else
                obj.IteratorIndex = obj.IteratorIndex - 1;
            end
            % Reset iterator if we're  at the end
            %if (obj.StartAtEnd && obj.IteratorIndex < 1)...
            %    || (~obj.StartAtEnd && obj.IteratorIndex > (obj.Length + 1))
            %    obj.resetIterator();
            %end
        end
        % Returns true if the iterator has a next item
        function result = hasNext(obj)
            result = (obj.IteratorIndex >= 1)...
                && (obj.IteratorIndex <= (obj.Length + 1));
        end
        % Resets the iterator to either the end or the beginning.
        function resetIterator(obj)
            if ~obj.StartAtEnd
                obj.IteratorIndex = 1;
            else
                obj.IteratorIndex = obj.Length + 1;
            end
        end
        % Whether iterator starts at end. This also resets the iterator.
        function startAtEnd(obj,value)
            obj.StartAtEnd = value > 0;
            obj.resetIterator();
        end
        
    end
    
end

