% Compiles all DubinsPathPlanner (DPP) solvers
% Settings
COMPILE_DTSP=1;
COMPILE_CPP=1;
COMPILE_CPP_AS_DTSP=1;
DRY_RUN=0;
VERBOSE=1;
SILENT=0;

% Main paths
DUBINS_FOLDER='/Users/dagoodma/asl/DubinsPathPlanner/Code';
OUT_FOLDER='lib/DubinsPathPlanner';

SRC_FOLDER=[DUBINS_FOLDER, '/src'];
MEX_FOLDER=[SRC_FOLDER, '/mex'];

% Libraries and include directories
OGDF_LIBS=[DUBINS_FOLDER, '/lib/ogdf/_debug'];
DPP_LIBS=[DUBINS_FOLDER, '/build'];
DUBINSCURVES_LIBS=[DUBINS_FOLDER, '/lib/dubins-curves'];

DPP_INCLUDE=[DUBINS_FOLDER, '/include'];
OGDF_INCLUDE=[DUBINS_FOLDER, '/lib/ogdf/include'];
%EIGEN_INCLUDE=[DUBINS_FOLDER, '/lib/eigen'];
EIGEN_INCLUDE=['/usr/local/Cellar/eigen/3.2.6/include/eigen3'];
CXXOPTS_INCLUDE=[DUBINS_FOLDER, '/lib/cxxopts/src'];
DUBINSCURVES_INCLUDE=[DUBINS_FOLDER, '/lib/dubins-curves/include'];
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
    {'COIN', 'OGDF', 'DPP', 'DUBINSCURVES'}, {OGDF_LIBS, SRC_FOLDER, DPP_LIBS, DUBINSCURVES_LIBS},...
    {OGDF_INCLUDE, DPP_INCLUDE, EIGEN_INCLUDE, CXXOPTS_INCLUDE,...
    MEX_INCLUDE, STACKTRACE_INCLUDE, DUBINSCURVES_INCLUDE},...
    VERBOSE, DRY_RUN);

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
    {'COIN', 'OGDF', 'DPP', 'DUBINSCURVES'}, {OGDF_LIBS, SRC_FOLDER, DPP_LIBS, DUBINSCURVES_LIBS},...
    {OGDF_INCLUDE, DPP_INCLUDE, EIGEN_INCLUDE, CXXOPTS_INCLUDE,...
    MEX_INCLUDE, STACKTRACE_INCLUDE, DUBINSCURVES_INCLUDE},...
    VERBOSE, DRY_RUN);

end % if COMPILE_CPP_AS_DTSP

%% =========== CPP  Solver ============
if COMPILE_CPP
mexname = 'dppSolveCpp';
filename=[SRC_FOLDER, '/solveCpp.cpp'];
interface_filename=[MEX_FOLDER, '/solveCpp_interface.cpp'];
cpp_files={...
           filename,...
           interface_filename,...
           [MEX_FOLDER, '/MexHelper.cpp']};
mex_output_filepath=[OUT_FOLDER, '/', mexname];

% Compile cpp_files into  
compileDubinsPathPlanner_helper(cpp_files, mex_output_filepath,...
    {'COIN', 'OGDF', 'DPP', 'DUBINSCURVES'}, {OGDF_LIBS, SRC_FOLDER, DPP_LIBS, DUBINSCURVES_LIBS},...
    {OGDF_INCLUDE, DPP_INCLUDE, EIGEN_INCLUDE, CXXOPTS_INCLUDE,...
    MEX_INCLUDE, STACKTRACE_INCLUDE, DUBINSCURVES_INCLUDE},...
    VERBOSE, DRY_RUN);

end % if COMPILE_CPP_AS_DTSP


