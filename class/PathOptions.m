classdef PathOptions
    %PATHOPTIONS A class for path solver options
    %
    %   Options for all solvers:
    %       
    %       TurnRadius     - Turn radius for Dubins path in meters
    %                        [positive scalar | {100} ]
    %                        Must be at least three times larger than the
    %                        closest distance between vertices
    %       SensorWidth    - The width of the sensor footprint in meters
    %                        [positive scalar | {350} ]
    %       Circuit        - Option to return to starting configuration
    %                        [{'off'} | 'on']
    %       Debug          - Option for printing debug information.
    %                        [{'off'} | 'on' ]
    %
    %   Options for plotting:
    %   
    %       ShowEdgeCosts  - Show cost next to edges   
    %                        [{'off'} | 'on' ]
    %       EdgeArrowSize  - Size of arrow heads for edges in GrPlot
    %                        [positive scalar | {1}]
    %       HeadingArrowSize - Size of heading arrows (and line length)
    %                        [positive scalar | {0.15}]
    %       DubinsStepSize   - Step size for plotting Dubins paths in seconds
    %                        [positive scalar | {0.01}] 
    %       SubPlotDim     - Dimensions used by subplot command
    %                        [2-by-1 vector | {[2 2]}]
    %  
    %   Options for all line-to-line (LTL) solvers:
    %
    %       LineStepTheta - Step size angle in radians to use when fitting
    %                       trajectory lines.
    %                       [scalar in range (0,pi) | {pi/4}]
    %       LineTolTheta  - Maximum fit tolerance in radians for waypoints
    %                       to vary from trajectory lines
    %                       [scalar in range (0,2*pi) | {0.0175} ]
    %
    %   Options for all brute force solvers:
    %   
    %       BruteForce - Whether to run these solvers or not.
    %
    %   Options for the brute force point-to-point (PTP) solver:
    %
    %       MaximizeCost - Finds the maximum cost path 
    %                       [{'off'} | 'on]
    %
    
    properties
        TurnRadius = 100; % [m]
        SensorWidth = 350; % [m]
        Circuit = 'off';
        Debug = 'off';
        %========= Plot Options =========
        ShowEdgeCosts = 'off';
        EdgeArrowSize = 1; 
        HeadingArrowSize = 0.15;
        DubinsStepSize = 0.01; % [sec]
        SubPlotDim = [2 2];
        %========= LTL Options ==========
        LineStepTheta = pi/4; % [rad] default: 45 degrees
        LineTolTheta = 0.0175; % [rad] default: 1 degree
        %======= BruteForce Options =====
        BruteForce = 'on';
        %==== BruteForce PTP Options ====
        MaximizeCost = 'off';
    end
    
    methods
    end
    
end

