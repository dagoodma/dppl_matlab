% Compiles all DubinsAreaCoverage CPP solver algorithms
% Settings
DRY_RUN=0;
COMPILE_ALTERNATING=1;
COMPILE_NEARESTNEIGHBOR=1;
VERBOSE=0; % TODO add this
SILENT=0;

% Main paths
DUBINS_FOLDER='/Users/dagoodma/asl/dubins_area_coverage/Code';
OUT_FOLDER='lib/DubinsAreaCoverage';

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


%% Alternating algorithm
if COMPILE_ALTERNATING
filename='dubinsAlternating';
interface_filename=[MEX_FOLDER, '/', filename, '_interface.cpp'];
cpp_files={...%SRC_FOLDER, '/alternatingDTSP.cpp ',... % included by the interface
           interface_filename,...
           [SRC_FOLDER, '/TSPLib.cpp'],...
           [SRC_FOLDER, '/Dubins.cpp']};
mex_output_filepath=[OUT_FOLDER, '/', filename];

% Compile cpp_files into  
compileDubinsAreaCoverageMex(cpp_files, mex_output_filepath,...
    {'LKH', 'OGDF'}, {LKH_LIBS, OGDF_LIBS, SRC_FOLDER}, {LKH_INCLUDE,...
    OGDF_INCLUDE, DUBINS_INCLUDE, EIGEN_INCLUDE, CXXOPTS_INCLUDE},...
    VERBOSE, DRY_RUN);
    
%     
% mex('-v', ['LDFLAGS=\$LDFLAGS -std=c++11 -g -Wl,-search_paths_first ',...
%        ['-Wl,-rpath,', OGDF_LIBS], [' -Wl,-rpath,', LKH_LIBS],...
%         ' -Wl,-headerpad_max_install_names'], ['-I', DUBINS_INCLUDE],...
%         ['-I', OGDF_INCLUDE], ['-I', LKH_INCLUDE], ['-I', EIGEN_INCLUDE],...
%         ['-L', OGDF_LIBS], ['-L', LKH_LIBS], ['-L', SRC_FOLDER],...
%         '-lOGDF','-lCOIN', '-lLKH',interface_filename,...
%         [SRC_FOLDER, '/TSPLib.cpp'], [SRC_FOLDER, '/Dubins.cpp'],...
%         '-output', mex_output_filepath, dry_run_flag);

end % if COMPILE_ALTERNATING

%% Nearest neighbor
if COMPILE_NEARESTNEIGHBOR
filename='dubinsNearestNeighbor';
interface_filename=[MEX_FOLDER, '/', filename, '_interface.cpp'];
cpp_files={...%[SRC_FOLDER, '/nearestNeighborDTSP.cpp'],...
           interface_filename,...
           [SRC_FOLDER, '/Dubins.cpp']};
mex_output_filepath=[OUT_FOLDER, '/', filename];


compileDubinsAreaCoverageMex(cpp_files, mex_output_filepath,...
    {'OGDF'}, {OGDF_LIBS, SRC_FOLDER}, {OGDF_INCLUDE, DUBINS_INCLUDE,...
    EIGEN_INCLUDE, CXXOPTS_INCLUDE}, VERBOSE, DRY_RUN);

end % if COMPILE_NEARESTNEIGHBOR
