function [dataNed] = convertGpsData(geoData, origin)
% CONVERTGPSDATA converts GPS data to NED
%	Waypoints are geodetic points, and are converted into local NED using the origin.
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
if isempty(geoData)
    error('Geodetic data not given!');
end
[nData,rowData] = size(geoData);
if rowData ~= 3
	error('Expected geoData with 3 columns');
end

if isempty(origin)
    error('origin is empty!');
end
[mOrigin, nOrigin] = size(origin);
if mOrigin ~= 1 || nOrigin ~= 3
    error('Expected origin as 3-dimensional row vector.');
end

%% Open the convert the data
[xNorth, yEast, zDown] = geodetic2ned(geoData(:,1),geoData(:,2),geoData(:,3),origin(1), origin(2),...
		origin(3), wgs84Ellipsoid);
dataNed = [xNorth, yEast, zDown];

end % function