% A script for adding polygons to the workspace that are useful in testing
% CPP algorithms, e.g. right triangle, isosceles triangle, ...

addpath('lib','class');

cppDataFolder = '../data/test/cpp';

%Define each of the polygons, along their minimum width and coverage
%  orientation angle.

% FIXME load the width and coverage angle from the gml files

square = Polygon(readGmlFile([cppDataFolder,'/square.gml']), 10, 0);

rectangle = Polygon(readGmlFile([cppDataFolder,'/rectangle.gml']), 10, deg2rad(90));
        
isoscelesTriangle = Polygon(readGmlFile([cppDataFolder,'/isoscelesTriangle.gml']), 2, deg2rad(0));

rightTriangle = Polygon(readGmlFile([cppDataFolder,'/rightTriangle.gml']), 7.5710678118654746, deg2rad(135));

trapezoid = Polygon(readGmlFile([cppDataFolder,'/trapezoid.gml']), 10, deg2rad(90));

isoscelesTrapezoid = Polygon(readGmlFile([cppDataFolder,'/isoscelesTrapezoid.gml']), 12, 0);

% Put them together in a list
coveragePolygons = [square, rectangle, isoscelesTriangle,rightTriangle,...
    trapezoid, isoscelesTrapezoid];