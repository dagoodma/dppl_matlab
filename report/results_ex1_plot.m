close all;
clear all;

% Dependencies
addpath('..');
addpath('../class');
addpath('../lib');
addpath('../lib/DubinsPathPlanner');
addpath('../lib/DubinsPlot');
addpath('../lib/spaceplots');

%% Setup
USE_RETURN_EDGE = true; % return to first node (not starting)
dataPath='../../data/experiment'
logRawDataFilename=[dataPath, '/2015.11.07_phoenixflight1_gpsraw.csv'];
logDataFilename=[dataPath, '/2015.11.07_phoenixflight1_gps.csv'];
tourDataFilename=[dataPath, '/2015.11.07_ptp_tour.csv'];
opts = PathOptions;
opts.TurnRadius = 20; % [m]
opts.NormalizePlots = 'off';
opts.ShowWaypointNumber = 'on';
if (USE_RETURN_EDGE)
	opts.Circuit = 'on';
	opts.CircuitInitial = 'off';
end
opts.HeadingArrowSize = 4.2;
opts.HeadingArrowColor = 'r';
opts.DubinsPathColor = 'r';

markerNum = 15; % num of markers to plot on line

% Estimated wind vector
magWind = 2; % [m/s]
posWind = [40 165]
angleWind = deg2rad(200);
scaleWindVector = opts.TurnRadius/5;

% Initial configuration and geodetic origin
% Geodetic origin from raw telementry, and AMSL altitude from:
% https://www.daftlogic.com/sandbox-google-maps-find-altitude.htm
origin = [36.988505,-122.0509133,169]; % [geo deg] from raw telemetry data and altitude from 
initialPosition = [0, 0]; % [m]
initialHeading = 0.0; % [rad]
C = [initialPosition, initialHeading];

%% Read planned tour data
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
fd = FlightData({logDataFilename, logRawDataFilename},...
	C, origin, V, X);
% For filtered data, we take only i=[3530:5037]
iTour1=[3530:4044];
iTour2=[4045:4567];
iTour3=[4567:5036];
% flip NED to be E,N
T1 = fliplr(fd.DataNed(iTour1, 1:2));
T2 = fliplr(fd.DataNed(iTour2, 1:2));
T3 = fliplr(fd.DataNed(iTour3, 1:2));
Tours ={T1, T2, T3};
symbolTours = {'+', '*', 'o'};
colorTours = {'b', 'g', 'm'};


%% Plot the scenario
figure();
legendStr = {};
for i=1:length(Tours)
	tour = Tours{i};
	symbolStr = symbolTours{i};
	colorStr = colorTours{i};
	%plot(tour(:,1), tour(:,2), [colorStr,'-'], 'MarkerSize',5);
	line_fewer_markers(tour(:,1), tour(:,2), markerNum, ['-',colorStr,symbolStr],...
		'MarkerSize',9,'linewidth',1);
	%disableLegendEntry(hobj);
	hold on;
	legendStr{end + 1} = sprintf('Tour %i',i);
end
ylabel('North [m]');
xlabel('East [m]');

%plotWaypoints(V, true);
plotWaypointScenario(V,[],opts);
[hAx, pDubins] = plotWaypointDubins(V,E,X,opts);
legend(legendStr{:}, 'Waypoints', 'Planned Tour', 'Planned Heading');
hold on;
quiver(posWind(1),posWind(2),scaleWindVector*cos(angleWind),...
	scaleWindVector*sin(angleWind),opts.HeadingArrowSize,'Color','b',...
	 'AutoScale', 'off', 'MaxHeadSize', 1e2);% wind vector
text(posWind(1)-15,posWind(2)-15,sprintf('Wind\n$\\approx %i$ m/s',magWind),...
	'Interpreter','latex','fontsize',13);
text(C(1)+6, C(2), '$\big(\mathbf{p}_0,~\psi_0\big)$','Interpreter','latex','fontsize',13);
hold off;

spaceplots();
axis equal;

%% Compare flight data to the planned path
return;

% Compare by sample-based
sampleError = {0, 0, 0};
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
		sampleError{i} = sampleError{i} + min(d1,d2);
	end
	fprintf('    Tour %i: sampled error = %.2f\n', i, sampleError{i});
end

% Cleanup pDubins by removing approach segment
pSimulated = pDubins(1:100:end,:); % down-sample simulated path
[X,Y,I,J] = intersections(pSimulated(:,1), pSimulated(:,2));
if any(diff(unique(round(I)))~=1) % check if discontinuous indices
	error('Found more than 1 intersecting segment in P2.');
end
pDubinsCircuit = pSimulated(round(I(1)):round(J(end)),:);
pDubinsCircuit = [pDubinsCircuit; pDubinsCircuit(1,:)]; % close gap
%figure();
%plot(pDubinsCircuit(:,1), pDubinsCircuit(:,2));

% Compare by total length
lengthError = {0, 0, 0};
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
    lengthError{i} = 1 - min(cDubins/cTour, cTour/cDubins);
    lengthDiff = cTour - cDubins;
    lengthDifference{i} = lengthDiff;
    fprintf('    Tour %i: length error = %i%% (difference = %.2f [m], length = %.2f[m])\n',...
    	i, floor(lengthError{i} * 100), lengthDiff, cTour);
end

% Compare by difference of polygonal area
areaError = {0, 0, 0};
areaTotal = 0;
disp('Area-based error:');
%pSimulated = pDubins(1:100:end,:); % down-sample simulated path
figure();

for i=1:length(Tours)
	pTour = Tours{i};

	[ratio, difference, total, P]  = comparePathsByArea(pTour, pSimulated);
	
	areaTotal = total;
	areaError{i} = 1-ratio;

    fprintf('    Tour %i: path error = %i%% (difference = %.2f [m], ratio = %.2f)\n',...
    	i, floor(areaError{i} * 100), difference, ratio);
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
	hold off;
end
fprintf('Total simulated path area: %.2f [m]\n', areaTotal);

% Compare length and area ratios in bar plot
barData = [];
for i=1:length(Tours)
	barData = [barData; areaError{i}, lengthError{i}];
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


% plot(V(:,1), V(:,2), '*', 'MarkerSize', 10, 'Color', [1 0 0]);
% for i=1:length(V)
% 	text(V(i,1)+2.5, V(i,2)+2.0, sprintf('%d',i),'FontSize',11);
% end

% plot(C(1),C(2),'ro', 'MarkerFaceColor', 'r');

% Compare by polygon area
% figure();

% C = T1(:,1:2);
% D = pDubins(:,1:2);

% [X, Y, IC, JD] = intersections(C(:,1), C(:,2), D(:,1), D(:,2));
% P = [X, Y];
% n = length(X) - 1;

% iC = 1;
% jD = 1;

% iC_end = round(IC(1));
% jD_end = round(JD(1));

% P = [C(iC:iC_end,:);...
% 	 D(jD:jD_end,:);...
% 	 C(1,:)];
% figure();
% plot(P(:,1), P(:,2));

% % for i = 1:n
% % 	iC_end = round(IC(i));
% % 	jD_end = round(JD(i)); 

% % 	Ci = C(iC_start:iC_end, :);
% % 	Di = D(jD_start:jD_end, :);

% % end

% D = pDubins(1:100:end,:);

