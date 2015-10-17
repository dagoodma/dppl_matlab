% Compiles all DubinsPathPlanner (DPP) solvers
% Settings
COMPILE_DTSP=0;
COMPILE_CPP_AS_DTSP=1;
DRY_RUN=0;
VERBOSE=1;
SILENT=0;

% Main paths
DUBINS_FOLDER='/Users/dagoodma/asl/dubins_area_coverage/Code';
OUT_FOLDER='lib/DubinsPathPlanner';

SRC_FOLDER=[DUBINS_FOLDER, '/src'];
MEX_FOLDER=[SRC_FOLDER, '/mex'];

% Libraries and include directories
OGDF_LIBS=[DUBINS_FOLDER, '/lib/ogdf/_debug'];
DPP_LIBS=[DUBINS_FOLDER, '/build'];

DPP_INCLUDE=[DUBINS_FOLDER, '/include'];
OGDF_INCLUDE=[DUBINS_FOLDER, '/lib/ogdf/include'];
EIGEN_INCLUDE=[DUBINS_FOLDER, '/lib/eigen-eigen-bdd17ee3b1b3'];
CXXOPTS_INCLUDE=[DUBINS_FOLDER, '/lib/cxxopts/src'];
STACKTRACE_INCLUDE=[DUBINS_FOLDER, '/lib/stacktrace'];
MEX_INCLUDE=MEX_FOLDER;


%% =========== DTSP Solver ============
if COMPILE_DTSP
mexname = 'dppSolveDtsp';
filename=[SRC_FOLDER, '/solveDtsp.cpp'];
interface_filename=[MEX_FOLDER, '/solveDtsp_interface.cpp'];
cpp_files={...
           filename,...
           interface_filename,...
           [MEX_FOLDER, '/MexHelper.cpp']};
mex_output_filepath=[OUT_FOLDER, '/', mexname];

% Compile cpp_files into  
compileDubinsPathPlanner_helper(cpp_files, mex_output_filepath,...
    {'COIN', 'OGDF', 'DPP'}, {OGDF_LIBS, SRC_FOLDER, DPP_LIBS},...
    {OGDF_INCLUDE, DPP_INCLUDE, EIGEN_INCLUDE, CXXOPTS_INCLUDE,...
    MEX_INCLUDE, STACKTRACE_INCLUDE},VERBOSE, DRY_RUN);

end % if COMPILE_DTSP

%% =========== CPP As DTSP Solver ============
if COMPILE_CPP_AS_DTSP
mexname = 'dppSolveCppAsDtsp';
filename=[SRC_FOLDER, '/solveCppAsDtsp.cpp'];
interface_filename=[MEX_FOLDER, '/solveCppAsDtsp_interface.cpp'];
cpp_files={...
           filename,...
           interface_filename,...
           [MEX_FOLDER, '/MexHelper.cpp']};
mex_output_filepath=[OUT_FOLDER, '/', mexname];

% Compile cpp_files into  
compileDubinsPathPlanner_helper(cpp_files, mex_output_filepath,...
    {'COIN', 'OGDF', 'DPP'}, {OGDF_LIBS, SRC_FOLDER, DPP_LIBS},...
    {OGDF_INCLUDE, DPP_INCLUDE, EIGEN_INCLUDE, CXXOPTS_INCLUDE,...
    MEX_INCLUDE, STACKTRACE_INCLUDE},VERBOSE, DRY_RUN);

end % if COMPILE_CPP_AS_DTSP

