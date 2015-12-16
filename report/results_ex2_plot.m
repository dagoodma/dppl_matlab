close all;
clear all;

% Dependencies
addpath('..');
addpath('../class');
addpath('../lib');
addpath('../lib/DubinsPathPlanner');
addpath('../lib/DubinsPlot');
addpath('../lib/spaceplots');
addpath('../lib/read_gml');

%% Setup
USE_RETURN_EDGE = true; % return to first node (not starting)
dataPath='../../data/experiment'
logDataFilename=[dataPath, '/2015.11.18_phoenixflight2_gps.csv'];
tourDataFilename=[dataPath, '/2015.11.18_cpp_tour.csv'];
areaDataFilename=[dataPath, '/2015.11.18_cpp_polygon.gml'];
opts = PathOptions;
opts.TurnRadius = 20; % [m]
opts.SensorWidth = 160;
opts.NormalizePlots = 'off';
opts.ShowWaypointNumber = 'on';
if (USE_RETURN_EDGE)
	opts.Circuit = 'on';
	opts.CircuitInitial = 'off';
end
opts.HeadingArrowSize = 4.7;
opts.HeadingArrowColor = 'r';
opts.DubinsPathColor = 'r'; %[.10,.97,.33];
opts.CoverageRegionColor = [.89,.89,.86];

markerNum = 15; % num of markers to plot on line

% Estimated wind vector
magWind = 4; % [m/s]
posWind = [220 -75]
angleWind = deg2rad(259);
scaleWindVector = opts.TurnRadius/2.2;

% Initial configuration and geodetic origin
origin = [36.9884633,-122.0509466,169]; % [geo deg] from raw telemetry data
initialPosition = [0, 0]; % [m]
initialHeading = 0.0; % [rad]
C = [initialPosition, initialHeading];

%% Read planned tour data and polygon
polygonVertices = readGmlFile(areaDataFilename);
coveragePolygon = Polygon(polygonVertices);

[tourData] = csvread(tourDataFilename, 1);
V = tourData(:,1:2);
X = tourData(:,3);
L = tourData(:,4);
n = length(V);
E=[[1:n-1]',[2:n]'];
if (USE_RETURN_EDGE) % return to "second" node
	E = [E; n, 2];
end
Cost = sum(L)

%% Read real flight data
fd = FlightData(logDataFilename,...
	C, origin, V, X);
% For filtered data, we take only i=[4740:6610
iTour1=[4740:5320];
iTour2=[5321:5889];
iTour3=[5890:6610];
% flip NED to be E,N
T1 = fliplr(fd.DataNed(iTour1, 1:2));
T2 = fliplr(fd.DataNed(iTour2, 1:2));
T3 = fliplr(fd.DataNed(iTour3, 1:2));
Tours ={T1, T2, T3};
colorTours = {'b', [0 .9 0], 'm'};
styleTours = {'-+', '-x', '-o'};

%% Plot the scenario
figure();
legendStr = {};
for i=1:length(Tours)
	style = styleTours{i};
	color = colorTours{i};
	tour = Tours{i};
	line_fewer_markers(tour(:,1), tour(:,2), markerNum, style,'Color', color, 'MarkerSize',7);
	legendStr{end + 1} = sprintf('Tour %i',i);
	hold on;
end
ylabel('North [m]');
xlabel('East [m]');

plotCoverageScenario(coveragePolygon,[],opts);
plotWaypointScenario(V,[],opts);
[hAx, pDubins] = plotWaypointDubins(V,E,X,opts);
legend(legendStr{:}, 'Coverage Region','Waypoints',...
	'Planned Tour', 'Planned Heading');
hold on;
quiver(posWind(1),posWind(2),scaleWindVector*cos(angleWind),...
	scaleWindVector*sin(angleWind),opts.HeadingArrowSize,'Color','b',...
	 'AutoScale', 'off', 'MaxHeadSize', 1e2);% wind vector
text(posWind(1)-15,posWind(2)+18,sprintf('Wind\n$\\approx %i$ m/s',magWind),...
	'Interpreter','latex','fontsize',13);
text(C(1)+6, C(2), '$\big(\mathbf{p}_0,~\psi_0\big)$','Interpreter','latex','fontsize',13);
hold off;

%set(gca,'xtick',[],'ytick',[])
spaceplots();

% Compare by total length
% Cleanup pDubins by removing approach segment
pSimulated = pDubins(1:100:end,:); % down-sample simulated path
K = dsearchn(pSimulated(1:(end-5),:),pSimulated(end,:));
if (isempty(K))
	error('Could not find end of approach segment.');
end
pDubinsCircuit = pSimulated(K(1):end,:);
%figure();
%plot(pDubinsCircuit(:,1), pDubinsCircuit(:,2));

% Compare by sample-based
SampleErrorTour = {0, 0, 0};
disp('Sample-based error:');
for i=1:length(Tours)
	pTour = Tours{i};
	for j=1:50:length(pTour)
		p = pTour(j,:);
		[k1, d1] = dsearchn(pDubins, p);
		if ~isscalar(k1)
			k1 = k1(1);
			d1 = d1(1);
		end
		[~, d2] = dsearchn(pTour, pDubins(k1,:));
		if ~isscalar(d2)
			d2 = d2(1);
		end
		SampleErrorTour{i} = SampleErrorTour{i} + min(d1,d2);
	end
	fprintf('    Tour %i: sampled error = %.2f\n', i, SampleErrorTour{i});
end

% Compare by total length
LengthErrorTour = {0, 0, 0};
lengthDifference = {0, 0, 0};
cDubins = 0;
for j=2:length(pDubinsCircuit)
    c_i = sqrt((pDubinsCircuit(j,1) - pDubinsCircuit(j-1,1))^2 + (pDubinsCircuit(j,2) - pDubinsCircuit(j-1,2))^2);
    cDubins = cDubins + c_i;
end
fprintf('Length error (expected length = %.2f [m]):\n', cDubins);
for i=1:length(Tours)
	pTour = Tours{i};
	cTour = 0;
    for j=2:length(pTour)
    	c_j = sqrt((pTour(j,1) - pTour(j-1,1))^2 + (pTour(j,2) - pTour(j-1,2))^2);
    	cTour = cTour + c_j;
    end
    LengthErrorTour{i} = 1 - min(cDubins/cTour, cTour/cDubins);
    lengthDiff = cTour - cDubins;
    lengthDifference{i} = lengthDiff;
    fprintf('    Tour %i: length error = %i%% (difference = %.2f [m], length = %.2f[m])\n',...
    	i, floor(LengthErrorTour{i} * 100), lengthDiff, cTour);
end

% Compare by difference of polygonal area
PathErrorTour = {0, 0, 0};
areaTotal = 0;
disp('Area-based path error:');
%pSimulated = pDubins(1:100:end,:); % down-sample simulated path
figure();

for i=1:length(Tours)
	pTour = Tours{i};

	[ratio, difference, total, P]  = comparePathsByArea(pTour, pDubinsCircuit);
	
	areaTotal = total;
	PathErrorTour{i} = 1-ratio;

    fprintf('    Tour %i: path error = %i%% (difference = %.2f [m], ratio = %.2f)\n',...
    	i, floor(PathErrorTour{i} * 100), difference, ratio);
    % Plot the polygons
    subplot(2,2,i);
    for j=1:length(P)
   		Pj = P{j};
		fill(Pj(:,1),Pj(:,2),'r');
		hold on;
	end
	xlabel('East [m]');
	ylabel('North [m]');
	title (sprintf('Tour %i: %i%% Similar',i,floor(ratio*100)));
	axis equal;
	hold off;
end
fprintf('Total simulated path area: %.2f [m]\n', areaTotal);

% Compare length and area ratios in bar plot
barData = [];
for i=1:length(Tours)
	barData = [barData; PathErrorTour{i}, LengthErrorTour{i}];
end
figure();
hBar = bar(barData);
set(hBar(1),'FaceColor',[0.207,0.16,0.52]);
set(hBar(2),'FaceColor',[.97,.98,.05]);
% Add length difference above
for i1=1:numel(barData(:,2))
	x = i1;
	y = barData(i1,2);
	val = lengthDifference{i1};
    text(x+.162,y,num2str(val,'%0.2f [m]'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom');
end
xlabel('Tour #');
%ylabel('Path Error');
legend('Dissimilarity','Length Error');

% Compare by area covered per tour
AreaCoveredTour = {0, 0, 0};
areaTotal = 0;
figure();
Ptotal = coveragePolygon.Vertices;
Ptotal = [Ptotal; Ptotal(1,1), Ptotal(1,2)];

% Find coverage of planned route
subplot(221);
[areaTotal, areaPlanned, Pplan] = compareCoveredArea(coveragePolygon, V(:,1), V(:,2), opts.SensorWidth)
percentPlanned = floor(100*(areaPlanned / areaTotal));
% Plot the planned coverage
filledPolygons(Pplan,'g');
hold on;
% Plot coverage region
plot(Ptotal(:,1),Ptotal(:,2),'-k');
hold off;
title(sprintf('Planned Coverage: %d%%',percentPlanned));
	xlabel('East [m]');
	ylabel('North [m]');
axis equal;
box on;

% Plot coverage for each tour
for i=1:length(Tours)
	pTour = Tours{i};
	K = dsearchn(pTour, V);
	pTour = pTour(K,:)

	[areaTotal, areaCovered, Pcover] = compareCoveredArea(coveragePolygon,...
		 pTour(:,1),pTour(:,2), opts.SensorWidth)
	AreaCoveredTour{i} = areaCovered;

	subplot(2,2,i + 1);

	% Plot tour coverage
	filledPolygons(Pcover,'g');
	percentCovered = floor(100*(areaCovered / areaTotal));
	title(sprintf('Coverage of Tour %i: %d%%',i,percentCovered));

	% Plot coverage region
	hold on;
	plot(Ptotal(:,1),Ptotal(:,2),'-k');
	hold off;
	xlabel('East [m]');
	ylabel('North [m]');
	axis equal;
	box on;
end
AreaCoveredTour{:}

