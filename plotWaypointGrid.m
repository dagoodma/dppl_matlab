function [fig] = plotWaypointGrid(hAx, V, options)
% PLOTWAYPOINTGRID Plot a grid around the waypoints in V

% =================== Check Arguments ========================

if nargin < 1
    error('No input arguments given!');
elseif nargin > 3
    error('Too many arguments given!');
end

if isempty(hAx)
    error('hAx not given!');
end
if isempty(V)
    error('V is empty!');
end
[n, ~] = size(V);

% ======================== Setup ============================


md = normalizationCoeff(V);
%V = V./md;

xv = V(:,1);
yv = V(:,2);
w = options.SensorWidth;
wd = w/md;
%Find the bounding rectangle
N = 1/w;
	lower_x = min(xv);
	higher_x = max(xv);

	lower_y = min(yv);
	higher_y = max(yv);
%Create a grid of points within the bounding rectangle
	inc_x = 1/N;
	inc_y = 1/N;
	
	interval_x = lower_x:inc_x:higher_x + w;
	interval_y = lower_y:inc_y:higher_y + w;
    %meshgrid(interval_x, interval_y)
	[X, Y] = meshgrid(interval_x, interval_y);
    
    % Transform into grid
    %[1 0 -w; 0 
    %X = X*2 + options.SensorWidth/2;
    hold on;
    X=X./md
    Y=Y./md
    plot(X-wd/2, Y-wd/2, ':k');
    plot(Y-wd/2, X-wd/2, ':k');
	%plot(bigGridX, bigGridY);
    %set(axes_handle,'XGrid','on')
    %set(axes_handle,'XGrid','on')
    hold off;
    
% ====================== Plot Grid =========================



end % function plotWaypointGrid


function [X,Y] = expandPoints(X,Y,w) 
%     Rt = [1 0 -w/2;
%           0 1 -w/w;
%           0 0  1];
%     Rs = [w/2 0 0;
%         0 w/2 0;
%         0 0 1];
    Rt = [1 0 0;
          0 1 0;
          -w/2 w/2  1];
    Rs = [w/2 0 0;
          0 w/2 0;
          0 0 1];

    n = length(X);
    
    tform_trans = affine2d(Rt);
    tform_scale = affine2d(Rs);
    for i = 1:n
        Vhat = [X(i), Y(i), 1];
        
        Vprime = Rt*Vhat';
        X(i) = Vprime(1)/Vprime(3);
        Y(i) = Vprime(2)/Vprime(3);
    end

end