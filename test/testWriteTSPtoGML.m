% Save Waypoints to GML File

addpath('lib','class');

graphFilename = 'output.gml';
V = [3,0; 5,0; 7,0; 9,0; 3,-2 ]*50;
C = [0, 0, 0];

writeTSPtoGML(graphFilename, V, C);

