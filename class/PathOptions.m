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
    %       Circuit        - Option to return to starting configuration.
    %                        [{'off'} | 'on']
    %                        If CircuitInitial is 'off', return to first node.
    %       CircuitInitial - Option to return to initial configuration if Circuit is 'on'.
    %                        [{'on'} | 'off']
    %                        Otherwise return to the first node in the tour.
    %       Debug          - Option for printing debug information.
    %                        [{'off'} | 'on']
    %
    %   Options for plotting:
    %   
    %       ShowWaypointNumber - Show waypoint numbers next to waypoint
    %                        [{'off'} | 'on' ]
    %       ShowEdgeCosts  - Show cost next to edges
    %                        [{'off'} | 'on' ]
    %                        Unless NormalizePlots is 'off'.
    %       EdgeArrowSize  - Size of arrow heads for edges in GrPlot
    %                        [positive scalar | {1}]
    %       HeadingArrowSize - Size of heading arrows (and line length)
    %                        [positive scalar | {0.15}]
    %       HeadingArrowColor - Color of heading arrows 
    %                        [{'m'} | [1 0 0], ....]
    %                        See help for ColorSpec.
    %       HeadingStartArrowColor - Color of initial heading arrow
    %                        [{'b'} | [1 0 0], ....]
    %                        See help for ColorSpec.
    %       DubinsStepSize   - Step size for plotting Dubins paths in seconds
    %                        [positive scalar | {0.01}] 
    %       DubinsPathColor  - Color for plotting Dubins paths 
    %                        [{'g'} | [1 0 0], .... ]
    %                        See help for ColorSpec.
    %       CoverageRegionColor - Color to use for plotting coverage polygon.
    %                        [{[0.9219, 0.9219, 0.9219]} | [1 0 0], .... ]
    %       SubPlotDim     - Dimensions used by subplot command
    %                        [2-by-1 vector | {[2 2]}]
    %       NormalizePlots  - Whether to normalize points when plotting. 
    %                        [{'on'} | 'off']
    %                         If 'on', use grPlot and non quiver headings. 
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
        TurnRadius = 20; % [m]
        SensorWidth = 150; % [m]
        Circuit = 'off';
        CircuitInitial = 'on';
        Debug = 'off';
        NormalizePlots = 'on';
        %========= Plot Options =========
        ShowWaypointNumber = 'off';
        ShowEdgeCosts = 'off';
        EdgeArrowSize = 1; 
        HeadingArrowSize = 0.15;
        HeadingArrowColor = 'm';;
        HeadingStartArrowColor = 'b';
        DubinsStepSize = 0.01; % [sec]
        DubinsPathColor = 'g';
        CoverageRegionColor = [0.9219, 0.9219, 0.9219]; % grey
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

