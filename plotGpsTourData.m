function [dataNed] = plotGpsTourData(geoCsvLogFilename, origin)
% PLOTGPSTOURDATA plots GPS data from a DTSP tour
%	Waypoints are read as geodetic points in degrees * 1E7, and converted
%	into local NED using the origin.
%

%% Parameters
if nargin < 1
    error('No input arguments given!');
elseif nargin > 2
    error('Too many arguments given!');
end

%if isempty(hAx)
%    error('hAx not given!');
%end
if isempty(geoCsvLogFilename)
    error('Log filename not given!');
end
if exist(geoCsvLogFilename) ~= 2
	error('Failed to find log file: %s',geoCsvLogFilename);
end
if isempty(origin)
    error('origin is empty!');
end
[mOrigin, nOrigin] = size(origin);
if mOrigin ~= 1 || nOrigin ~= 3
    error('Expected origin as 3-dimensional row vector.');
end

%% Open the convert the data
[dataGeo, ~] = readCsvGps(geoCsvLogFilename);

[xNorth, yEast] = geodetic2ned(dataGeo(:,1),dataGeo(:,2),dataGeo(:,3),origin(1), origin(2),...
		origin(3), wgs84Ellipsoid);
dataNed = [xNorth, yEast];

plot(yEast, xNorth, 'ko');
xlabel('North [m]');
ylabel('East [m]');
hold on;
plot(0,0,'ro');



end % function