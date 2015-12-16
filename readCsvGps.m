function [ data, points ] = readCsvGps( filename, useRaw)
%READCSVGPS Reads GPS data in degrees * 1E7
%	Reads GPS data from the CSV file into matlab. Converts from degrees * 1E7
%	to degrees.
%
%   Write points to a kmlfile:
% 		kmlwrite('mypoints.kml', points)
%
%   Parameters:
%       filename    Filename of CSV file with GPS data
%

%% Parameters
if nargin < 1
    error('Not enough input arguments.');
end
if nargin > 2
    error('Too many arguments given.');
end

USE_RAW_GPS = 0;
if (exist('useRaw') && useRaw)
	USE_RAW_GPS = 1;
end

% Read the file and convert
fields = textread(filename,'%s', 11, 'delimiter', ',') % works for GPS_RAW_INT + timestamp
rawData = csvread(filename, 1);
[m, n] = size(rawData);

timeInd = find(~cellfun(@isempty,(strfind(fields,'timestamp'))));

% Get and convert from 1e7 (lat & lon) and 1e3 for altitude
% Matrix pilot does use expected MAVLINK convention for altitude
altScale = 1e2;
if USE_RAW_GPS
latInd = find(~cellfun(@isempty,(strfind(fields,'GPS_RAW_INT.lat'))));
lonInd = find(~cellfun(@isempty,(strfind(fields,'GPS_RAW_INT.lon'))));
altInd = find(~cellfun(@isempty,(strfind(fields,'GPS_RAW_INT.alt'))));
else
latInd = find(~cellfun(@isempty,(strfind(fields,'GLOBAL_POSITION_INT.lat'))));
lonInd = find(~cellfun(@isempty,(strfind(fields,'GLOBAL_POSITION_INT.lon'))));
altInd = find(~cellfun(@isempty,(strfind(fields,'GLOBAL_POSITION_INT.alt'))));
altScale = 1e3;
end

data = zeros(m,4);
data(:,1) = rawData(:,timeInd);
data(:,2) = rawData(:,latInd) / 1e7;
data(:,3) = rawData(:,lonInd) / 1e7;
data(:,4) = rawData(:,altInd) / altScale;

indGood = find(data(:,2)~=0);
data=data(indGood(1):indGood(end),:);
m_good = length(data);
points=geopoint(data(:,2)',data(:,3)');

fprintf('Cleaned data. Dropped %d rows from raw data.\n', (m-m_good));

end % function()