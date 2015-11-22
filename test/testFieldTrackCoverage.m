% Plots a few convex polygons using their minimum width and optimal
% coverage orientation angle.
% FIXME make this into a test some how
close all;
clear all;

%% =============== Dependencies ===============
% Find all dependencies
% Add lib and class folders
addpath('..', '../lib','../class');

%% Parameters
sensorWidth = 2;

% Polygons
loadCoveragePolygons; 

%% Plotting

figure();
subplot(3,2,1);
nSquare = ceil(square.Width/sensorWidth);
plotPolygon(square.Vertices, sprintf('Square (%d tracks, \\theta=%.1f^{\\circ})',...
    nSquare, rad2deg(square.CoverageAngle)));
tracks = generateParallelTracks(square, sensorWidth, square.CoverageAngle);
plotParallelTracks(square,tracks, sensorWidth, square.CoverageAngle);

subplot(3,2,2);
nRectangle = ceil(rectangle.Width/sensorWidth);
plotPolygon(rectangle.Vertices, sprintf('Rectangle (%d tracks, \\theta=%.1f^{\\circ})',...
    nRectangle, rad2deg(rectangle.CoverageAngle)));
tracks = generateParallelTracks(rectangle, sensorWidth, rectangle.CoverageAngle);
plotParallelTracks(rectangle,tracks, sensorWidth, rectangle.CoverageAngle);

subplot(3,2,3);
nIsoscelesTriangle = ceil(isoscelesTriangle.Width/sensorWidth);
plotPolygon(isoscelesTriangle.Vertices, sprintf('Isosceles Triangle (%d tracks, \\theta=%.1f^{\\circ})',...
    nIsoscelesTriangle, rad2deg(isoscelesTriangle.CoverageAngle)));
tracks = generateParallelTracks(isoscelesTriangle, sensorWidth, isoscelesTriangle.CoverageAngle);
plotParallelTracks(isoscelesTriangle,tracks, sensorWidth, isoscelesTriangle.CoverageAngle);

subplot(3,2,4);
nRightTriangle = ceil(rightTriangle.Width/sensorWidth);
plotPolygon(rightTriangle.Vertices, sprintf('Right Triangle (%d tracks, \\theta=%.1f^{\\circ})',...
    nRightTriangle, rad2deg(rightTriangle.CoverageAngle)));
tracks = generateParallelTracks(rightTriangle, sensorWidth, rightTriangle.CoverageAngle);
plotParallelTracks(rightTriangle,tracks, sensorWidth, rightTriangle.CoverageAngle);

subplot(3,2,5);
nTrapezoid = ceil(trapezoid.Width/sensorWidth);
plotPolygon(trapezoid.Vertices, sprintf('Trapezoid (%d tracks, \\theta=%.1f^{\\circ})',...
    nTrapezoid, rad2deg(trapezoid.CoverageAngle)));
tracks = generateParallelTracks(trapezoid, sensorWidth, trapezoid.CoverageAngle);
plotParallelTracks(trapezoid, tracks, sensorWidth, trapezoid.CoverageAngle);

subplot(3,2,6);
nIsoscelesTriangle = ceil(isoscelesTrapezoid.Width/sensorWidth);
plotPolygon(isoscelesTrapezoid.Vertices, sprintf('Isosceles Trapezoid (%d tracks, \\theta=%.1f^{\\circ})',...
    nIsoscelesTriangle, rad2deg(isoscelesTrapezoid.CoverageAngle)));
tracks = generateParallelTracks(isoscelesTrapezoid, sensorWidth, isoscelesTrapezoid.CoverageAngle);
plotParallelTracks(isoscelesTrapezoid,tracks, sensorWidth, isoscelesTrapezoid.CoverageAngle);

