classdef FlightData < handle
    %FLIGHTDATA Represents flight data and a tour
    %   

    % Add dependencies
    %addpath('..');
    
    properties(SetAccess = public)
        OriginGeo
        % Initial configuration
        InitialPosition
        InitialHeading
        % GLOBAL_POSITION data
        DataFilename
        DataGeo
        DataNed
        % GPS_RAW data
        RawDataFilename
        DataGeoRaw
        DataNedRaw
        HasRaw = false
        % Tour data
        TourPoints
        TourHeadings
        HasTour = false
    end % properties
    
    methods
        % Constructor that takes the slope and intercept of the line
        function self = FlightData(dataFilename, C0, originGeo, V, Phi)
            if iscell(dataFilename)
                self.RawDataFilename = dataFilename{2};
                self.DataFilename = dataFilename{1};
                self.HasRaw = true;
            else
                self.DataFilename = dataFilename;
            end

            self.InitialPosition = C0(1:2);
            self.InitialHeading = C0(3);
            self.OriginGeo = originGeo;

            if nargin > 3
                self.TourPoints = V;
                self.TourHeadings = Phi;
                self.HasTour = true
            end

            % Read the data. Note that units are divided into degrees and meters in readCsvGps()
            [self.DataGeo, ~] = readCsvGps(self.DataFilename);
            if self.HasRaw
                [self.DataGeoRaw, ~] = readCsvGps(self.RawDataFilename,1);
            end
            % Convert to NED
            [self.DataNed] = convertGpsData(self.DataGeo(:,2:4), self.OriginGeo);
            if self.HasRaw
                [self.DataNedRaw] = convertGpsData(self.DataGeoRaw(:,2:4), self.OriginGeo);
            end
        end % FlightData

        function [] = plotAltitude(self)
            estimatedAlt = -self.DataNed(:,3);

            if(self.HasRaw)
                rawAlt = -self.DataNedRaw(:,3); 
            end

            figure();
            plot(self.DataGeo(:,1), estimatedAlt,'--g');
            hold on;
            legendStr = {'Estimated Altitude [m]'};
            if(self.HasRaw)
                plot(self.DataGeoRaw(:,1), rawAlt,'-k');
                legendStr{end + 1} = 'Raw GPS Altitude [m]';
            end
            hold off;
            xlabel('Time [sec]');
            ylabel('Altitude Above Ground [m]')
            legend(legendStr{:})
        end

        function [] = plotWindEstimate(self)
            if (~self.HasRaw)
                error('Need raw GPS data to estimate wind.')
            end

            
            
        end
    end % methods
end % classdef

