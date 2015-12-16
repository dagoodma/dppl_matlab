function [Aratio, Adiff, Atotal, Polygons] = comparePathsByArea(P1, P2)
% FIXME This works for the 2 experiments conducted, but probably not for other cases.
%	Use at your own risk!

DEBUG = false;

C = P1;
D = P2;

%% Cleanup D by removing intersecting segment
% FIXME cleanup C too!
[X,Y,I,J] = intersections(D(:,1), D(:,2));

if any(diff(unique(round(I)))~=1) % check if discontinuous indices
	error('Found more than 1 intersecting segment in P2.');
end
if (~isempty(I))
	D = D(round(I(1)):round(J(end)),:);
end

% plot D and self intersections
if (DEBUG)
	figure();
	subplot(221);
	plot(P2(:,1),P2(:,2),'-k');
	hold on;
	scatter(X,Y,'or');
	scatter(P2(round(J),1), P2(round(J),2),'bx');
	scatter(P2(round(I),1), P2(round(I),2),'gx');

	plot(P1(:,1),P1(:,2),'-r');
	scatter(P1(1:50:end,1),P1(1:50:end,2),'r*');
	axis equal;
	hold off;

	subplot(222);
	%[X,Y,I,J] = intersections(D(:,1), D(:,2))
	%D = [D; D(1,:)]; % fill gap
	plot(D(:,1),D(:,2),'-g');
	axis equal;
end % DEBUG

%% Find intersections
[X,Y,I,J] = intersections(C(:,1),C(:,2), D(:,1),D(:,2));
% sort by X and I
[I,BI] = sort(I);
X=X(BI);
Y=Y(BI);
J=J(BI);
X,Y,I,J


if (length(X) < 1)
	error('No intersections. FIXME: tie endpoints together and calculate poly');
% elseif (length(X) > 1)
% 	error('Does not support multiple segments yet. FIXME');
end

if DEBUG
	plot(C(:,1),C(:,2),'-b');
	hold on;
	plot(D(:,1),D(:,2),'-r');
	scatter(X,Y,'or');
	scatter(C(round(I),1), C(round(I),2),'bx');
	scatter(D(round(J),1), D(round(J),2),'gx');
	hold off;
end % DEBUG

%% Create polygons
Polygons = {};
isCw = ispolycw(D(:,1),D(:,2)); % if D is CW

% Create first polygon
i = I(1);
j = J(1);
% going backwards on D if its CCW
Dseg = flipud(D(1:j,:));
if (isCw)
	K = dsearchn(D,C(1,:));
	k = K(1);
	if (k > j)
		error('Unhandled case.');
	end
	Dseg(k:j,:);
end
P1 = [C(1:i,:);...
	X(1), Y(1);...
	Dseg;...
	C(1,:)];
Polygons{1} = P1;

if DEBUG
	hold on;
	plot(P1(:,1),P1(:,2),':g');
	axis equal;
	hold off;
end % DEBUG

% Create middle segments
n = length(X) - 1;
index=1;
for k=1:n
	i1 = round(I(index));
	i2 = round(I(index+1));
	j1 = round(J(index));
	j2 = round(J(index+1));

	% going backwards on D if its CCW
	Dseg = flipud(D(j1:j2,:));

	if (isCw && k == n && (j2 < j1))
		% Wraps around the end 
		%Dseg = D(j1:j2,:);
		Dseg = [flipud(D(1:j2,:));...
				flipud(D(j1:end,:))];
	end

	Pi = [X(index), Y(index);...
		  C(i1:i2,:);...
		  X(index+1), Y(index+1);...
		  Dseg;...
		  X(index), Y(index)];

	Polygons{end + 1} = Pi;

	index  = index + 1;
end
	
% Create last polygon
K = dsearchn(D,C(end,:));
k = K(1);
Dmod = [D; D(k,:)];

i = round(I(end));
j = round(J(end));
% going backwards on D if its CCW
Dseg = flipud(Dmod(j:end,:));
if (isCw)
	Dseg = D(k:j,:);
end
P2 = [X(end), Y(end);...
	C(i:end,:);...
	Dseg;...
	 X(end), Y(end)];
Polygons{end + 1} = P2;

if DEBUG	 
	hold on;
	plot(P2(:,1),P2(:,2),'c');
	hold off;
end

%% Compute output variables
if (DEBUG)
	subplot(223);
end

Dmod = [D; D(1,:)];
Atotal = polyarea(Dmod(:,1),Dmod(:,2));

Adiff = 0;
for i=1:length(Polygons)
	P = Polygons{i};
	Ai = polyarea(P(:,1),P(:,2));
	Adiff = Adiff + Ai;
	if DEBUG
		%fprintf('Added area from polygon %i: %.2f [m]\n',i,Ai);
		fill(P(:,1),P(:,2),rand(1,3));
		axis equal;
		hold on;
	end
end

Aratio = (Atotal-Adiff)/Atotal;

% Final plot of results
if DEBUG
	hold off;

	title(sprintf('Path Similarity: %.2f\n (%.2f [m^2] difference)',Aratio,Adiff));
end


end % function

