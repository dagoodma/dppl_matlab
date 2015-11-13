function [ data, points ] = readCsvGps( filename )
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
if nargin > 1
    error('Too many arguments given.');
end

% Read the file and convert
fields = textread(filename,'%s', 11, 'delimiter', ',') % works for GPS_RAW_INT + timestamp
rawData = csvread(filename, 1);
[m, n] = size(rawData);

% Get at convert coordinates
latInd = find(~cellfun(@isempty,(strfind(fields,'GPS_RAW_INT.lat'))));
lonInd = find(~cellfun(@isempty,(strfind(fields,'GPS_RAW_INT.lon'))));
altInd = find(~cellfun(@isempty,(strfind(fields,'GPS_RAW_INT.alt'))));

data = zeros(m,3);
data(:,1) = rawData(:,latInd) / 1e7;
data(:,2) = rawData(:,lonInd) / 1e7;
data(:,3) = rawData(:,altInd) / 1e3;

indGood = find(data(:,1)~=0);
m_good = length(indGood);
data=data(indGood,:);
points=geopoint(data(:,1)',data(:,2)');

fprintf('Cleaned data. Dropped %d rows from raw data.\n', (m-m_good));

end % function()