classdef Line < handle
    %LINE Represents a line in the plane
    %   
    
    properties(SetAccess = public)
        IsVertical = false;
    % Slope-intercept form
        Slope 
        Intercept  
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

            if (isscalar(varargin{1}))
                % Given slope/intercept scalars
                self.Slope = varargin{1};
                self.Intercept = varargin{2};
            else
                % Given 2 points
                p1 = varargin{1};
                p2 = varargin{2};
                self.Slope = (p2(2) - p1(2))/(p2(1) - p1(1)); % divide by zero if line is parallel to y-axis
                self.Intercept = p1(2) - self.Slope*p1(1);
            end

            self.updateNormalForm();
            if (isinf(self.Slope))
                %error('Vertical lines not yet supported');
                self.IsVertical = true;
                self.A = varargin{1}(1);
            end
        end

        function result = containsPoint(obj, p)
            fprintf('Checking if line contains p =[%.0f %.0f]', p(1), p(2));
            epsError = 1e-12;
            obj;
            if (~obj.IsVertical)
                result = (obj.C - (obj.A*p(1) + obj.B*p(2))) < epsError;
                err = (obj.A*p(1) + obj.B*p(2)) - obj.C
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
            if (theta <= pi/2)
                dx = d*cos(theta);
                dy = d*sin(theta);
            elseif (theta <= pi)
                dx = -d*sin(theta - pi/2);
                dy = d*cos(theta - pi/2);
            elseif (theta <= 3*pi/2)
                dx = -d*cos(theta - pi);
                dy = -d*sin(theta - pi);
            else
                dx = d*sin(theta - 3*pi/2);
                dy = -d*cos(theta - 3*pi/2);
            end

            if (~obj.IsVertical)
                obj.Intercept = obj.Intercept + dy - obj.Slope*dx;
                obj.updateNormalForm();
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
        function updateNormalForm(obj)
            obj.A = -obj.Slope;
            obj.B = 1;
            obj.C = obj.Intercept;
        end

        % Find the point of interception with another line. Returns an empty array if the lines
        % are identical, or if they are parallel.
        function p = findIntercept(obj, line2)
            p = [];

            if (obj.Slope ~= line2.Slope)
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

    end % methods

end % function