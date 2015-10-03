% Compiles all DubinsSensorCoverage CPP solver algorithms
% Settings
DRY_RUN=0;
COMPILE_ALTERNATING=1;
COMPILE_NEARESTNEIGHBOR=1;
COMPILE_RANDOMIZED=1;
VERBOSE=0; % TODO add this
SILENT=0;

% Main paths
DUBINS_FOLDER='/Users/dagoodma/asl/dubins_area_coverage/Code';
OUT_FOLDER='lib/DubinsSensorCoverage';

% Libraries and include directories
OGDF_LIBS=[DUBINS_FOLDER, '/lib/ogdf/_debug'];
LKH_LIBS=[DUBINS_FOLDER, '/lib/LKH'];

DUBINS_INCLUDE=[DUBINS_FOLDER, '/include'];
OGDF_INCLUDE=[DUBINS_FOLDER, '/lib/ogdf/include'];
LKH_INCLUDE=[DUBINS_FOLDER, '/lib/LKH/src/include'];
EIGEN_INCLUDE=[DUBINS_FOLDER, '/lib/eigen-eigen-bdd17ee3b1b3'];
CXXOPTS_INCLUDE=[DUBINS_FOLDER, '/lib/cxxopts/src'];

SRC_FOLDER=[DUBINS_FOLDER, '/src'];
MEX_FOLDER=[SRC_FOLDER, '/mex'];


%% =========== Alternating algorithm ============
if COMPILE_ALTERNATING
filename='dubinsAlternating';
interface_filename=[MEX_FOLDER, '/', filename, '_interface.cpp'];
cpp_files={...%SRC_FOLDER, '/alternatingDTSP.cpp ',... % included by the interface
           interface_filename,...
           [SRC_FOLDER, '/TSPLib.cpp'],...
           [SRC_FOLDER, '/Dubins.cpp']};
mex_output_filepath=[OUT_FOLDER, '/', filename];

% Compile cpp_files into  
compileDubinsSensorCoverageMex(cpp_files, mex_output_filepath,...
    {'LKH', 'OGDF'}, {LKH_LIBS, OGDF_LIBS, SRC_FOLDER}, {LKH_INCLUDE,...
    OGDF_INCLUDE, DUBINS_INCLUDE, EIGEN_INCLUDE, CXXOPTS_INCLUDE},...
    VERBOSE, DRY_RUN);

end % if COMPILE_ALTERNATING

%% ============ Nearest neighbor ===========
if COMPILE_NEARESTNEIGHBOR
filename='dubinsNearestNeighbor';
interface_filename=[MEX_FOLDER, '/', filename, '_interface.cpp'];
cpp_files={...%[SRC_FOLDER, '/nearestNeighborDTSP.cpp'],...
           interface_filename,...
           [SRC_FOLDER, '/Dubins.cpp']};
mex_output_filepath=[OUT_FOLDER, '/', filename];


compileDubinsSensorCoverageMex(cpp_files, mex_output_filepath,...
    {'OGDF'}, {OGDF_LIBS, SRC_FOLDER}, {OGDF_INCLUDE, DUBINS_INCLUDE,...
    EIGEN_INCLUDE, CXXOPTS_INCLUDE}, VERBOSE, DRY_RUN);

end % if COMPILE_NEARESTNEIGHBOR

%% ============ Randomized Algorithm ===========
if COMPILE_RANDOMIZED
filename='dubinsRandomized';
interface_filename=[MEX_FOLDER, '/', filename, '_interface.cpp'];
cpp_files={...%[SRC_FOLDER, '/nearestNeighborDTSP.cpp'],...
           interface_filename,...
           [SRC_FOLDER, '/Dubins.cpp']};
mex_output_filepath=[OUT_FOLDER, '/', filename];


compileDubinsSensorCoverageMex(cpp_files, mex_output_filepath,...
    {'OGDF'}, {OGDF_LIBS, SRC_FOLDER}, {OGDF_INCLUDE, DUBINS_INCLUDE,...
    EIGEN_INCLUDE, CXXOPTS_INCLUDE}, VERBOSE, DRY_RUN);

end % if COMPILE_RANDOMIZED

