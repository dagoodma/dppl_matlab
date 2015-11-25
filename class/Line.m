classdef Line < handle
    %LINE Represents a line in the plane
    %   
    
    properties(SetAccess = public)
        IsVertical = false;
    % Normal form
        A
        B
        C
    end % properties
    
    methods
        % Constructor that takes the slope and intercept of the line
        function self = Line(varargin)
            %disp('Constructing line with:');
            %disp(varargin); 
            %for i=1:nargin, disp(varargin{1}), end
            if nargin == 1
                s = varargin{1};
                if (s.StartVertex == s.EndVertex)
                    error('Segment has length 0');
                end
                varargin = {s.StartVertex; s.EndVertex};
            end
            if (~isscalar(varargin{1}))
                % Given 2 points
                p1 = varargin{1};
                p2 = varargin{2};
                self.A = -(p2(2) - p1(2))/(p2(1) - p1(1)); % divide by zero if line is parallel to y-axis
                self.B = 1;
                self.C = p1(2) + self.A * p1(1);
            else 
                error('here');
            end

            %self.updateNormalForm();
            if (isinf(self.A))
                self.IsVertical = true;
                self.A = p1(1);
            end
        end

        function result = containsPoint(obj, p)
            fprintf('Checking if line contains p =[%.0f %.0f]', p(1), p(2));
            epsError = 1e-12;
            obj;
            if (~obj.IsVertical)
                result = (obj.C - (obj.A*p(1) + obj.B*p(2))) < epsError;
                %err = (obj.A*p(1) + obj.B*p(2)) - obj.C
            else
                result = (p(1) - obj.A) < epsError;
            end
        end

        % Translates the line by the given distance in the direction of angle.
        % This does not rotate the line (change the slope).
        function translate(obj, d, theta)
            %fprintf('Translating line by %.2f at %.0f deg\n', d, rad2deg(theta));
            %obj

            theta = angularMod(theta, 2*pi);
            [dx, dy] = pol2cart(theta, d);
            
            if (~obj.IsVertical)
                obj.C = obj.C + dy + obj.A*dx;
            else
                % FIXME compute component for non-perpendicular angles
                %db = d;
                %if (theta == pi)
                %    db = -db;
                %end
                obj.A = obj.A + dx;
            end
            %fprintf('New inercept: %.2f\n', obj.Intercept);
            %obj
        end

        % Sets the normal form properties using slope-intercept form properties
        %function updateNormalForm(obj)
        %    obj.A = -obj.Slope;
        %    obj.B = 1;
        %    obj.C = obj.Intercept;
        %end

        % Find the point of interception with another line. Returns an empty array if the lines
        % are identical, or if they are parallel.
        function p = findIntercept(obj, line2)
            p = [];

            if (obj.slope() ~= line2.slope())
                if (~obj.IsVertical && ~line2.IsVertical) 
                    p = [(obj.C*line2.B - obj.B*line2.C)/(obj.A*line2.B - obj.B*line2.A),...
                        (obj.A*line2.C - obj.C*line2.A)/(obj.A*line2.B - obj.B*line2.A)];
                elseif (~obj.IsVertical && line2.IsVertical) 
                    p = [line2.A, (obj.C-obj.A*line2.A)/obj.B];
                elseif (obj.IsVertical && ~line2.IsVertical)
                    p = [obj.A, (line2.C-line2.A*obj.A)/line2.B];
                end
            end
        end 
        
        function m = slope(obj)
            if (~obj.IsVertical)
                m = -obj.A
            else
                m = inf;
            end
        end % function

    end % methods

end % function