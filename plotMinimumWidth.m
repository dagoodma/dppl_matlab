% Plots a few convex polygons and shows their minimum width and optimal
% coverage orientation angle.
close all;
clear all;

%% =============== Dependencies ===============
% Find all dependencies
% Add lib and class folders
addpath('lib','class');

%% Parameters
sensorWidth = 2;

%% Define each of the polygons, along their minimum width and coverage
%  orientation angle.

square = Polygon([0, 0;...
         -10, 0;...
         -10.0, -10.0;...
         0, -10], 10, 0);


rectangle = Polygon([0, 0;...
            -10, 0;...
            -10.0, -20;...
            0, -20], 10, deg2rad(90));
        

isoscelesTriangle = Polygon([...
	6, 2;...
    4, 4;...
    2, 2], 12, deg2rad(0));

rightTriangle = Polygon([...
    0, 0;...
    -10.0, 10.0;...
    -10.0, 0], 7.5710678118654746, deg2rad(135));

trapezoid = Polygon([...
	0, 0;...
	-10,10;...
	-10, -20; ...
	0, -10], 10, deg2rad(90));

isoscelesTrapezoid = Polygon([...
	0, 0;...
	10,12;...
	-10, 12; ...
	-8, 0], 12, 0);

%% Plotting

figure();
subplot(3,2,1);
nSquare = ceil(square.Width/sensorWidth);
plotPolygon(square.Vertices, sprintf('Square (%d tracks, \\theta=%.1f^{\\circ})',...
    nSquare, rad2deg(square.CoverageAngle)));
plotParallelTracks(square, sensorWidth)

subplot(3,2,2);
nRectangle = ceil(rectangle.Width/sensorWidth);
plotPolygon(rectangle.Vertices, sprintf('Rectangle (%d tracks, \\theta=%.1f^{\\circ})',...
    nRectangle, rad2deg(rectangle.CoverageAngle)));
plotParallelTracks(rectangle, sensorWidth)

subplot(3,2,3);
nIsoscelesTriangle = ceil(isoscelesTriangle.Width/sensorWidth);
plotPolygon(isoscelesTriangle.Vertices, sprintf('Isosceles Triangle (%d tracks, \\theta=%.1f^{\\circ})',...
    nIsoscelesTriangle, rad2deg(isoscelesTriangle.CoverageAngle)));
plotParallelTracks(isoscelesTriangle, sensorWidth)

subplot(3,2,4);
nRightTriangle = ceil(rightTriangle.Width/sensorWidth);
plotPolygon(rightTriangle.Vertices, sprintf('Right Triangle (%d tracks, \\theta=%.1f^{\\circ})',...
    nRightTriangle, rad2deg(rightTriangle.CoverageAngle)));
plotParallelTracks(rightTriangle, sensorWidth)

subplot(3,2,5);
nTrapezoid = ceil(trapezoid.Width/sensorWidth);
plotPolygon(trapezoid.Vertices, sprintf('Trapezoid (%d tracks, \\theta=%.1f^{\\circ})',...
    nTrapezoid, rad2deg(trapezoid.CoverageAngle)));
plotParallelTracks(trapezoid, sensorWidth)
clc;
subplot(3,2,6);
nIsoscelesTriangle = ceil(isoscelesTriangle.Width/sensorWidth);
plotPolygon(isoscelesTrapezoid.Vertices, sprintf('Isosceles Trapezoid (%d tracks, \\theta=%.1f^{\\circ})',...
    nIsoscelesTriangle, rad2deg(isoscelesTrapezoid.CoverageAngle)));
plotParallelTracks(isoscelesTrapezoid, sensorWidth)

