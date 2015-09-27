function compileDubinsAreaCoverageMex( input_files, output_file,...
    lib_names, lib_dirs, include_dirs, verbose, dry_run)
%UNTITLED Summary of this function goes here
%   Parameters:
%       input_files     A Cell array of .cpp filepaths
%       output_file     Output filepath
%       lib_names       A Cell array of library names to link
%       lib_dirs        A Cell array of library paths
%       inlude_dirs     A Cell array of include directories
%       verbose         A true or false for verbose mode
%       dry_run         A true or false for dry-run mode
% 

% Input validation:
if nargin < 1
    error('No input arguments given!');
elseif nargin > 7
    error('Expected at most 7 arguments.');
end

if isempty(input_files)
    error('input_files is empty!');
end

if isempty(output_file)
    error('Expected an output_file.');
end

if ~iscell(input_files)
    error('input_files should be a cell array!');
end
if ~iscell(lib_dirs) && ~isempty(lib_dirs)
    error('lib_dirs should be a cell array!');
end
if ~iscell(include_dirs) && ~isempty(include_dirs)
    error('include_dirs should be a cell array!');
end


% Library path flags (loader and compiler)
ld_flags = ['LDFLAGS=\$LDFLAGS -std=c++11 -g -Wl,-search_paths_first ',...
    '-Wl,-headerpad_max_install_names'];
if iscell(lib_dirs)
    n = length(lib_dirs);
    for i = 1:n
        ld_flags = [ld_flags, ' -Wl,-rpath,', lib_dirs{i}];
        lib_dirs{i} = [ '-L', lib_dirs{i} ];
    end
else
    lib_dirs = {};
end

% Include dirs
if iscell(include_dirs)
    n = length(include_dirs);
    for i = 1:n
        include_dirs{i} = [ '-I', include_dirs{i} ];
    end
else
    include_dirs = {};
end

% Library names for linker
if iscell(lib_names)
    n = length(lib_names);
    for i = 1:n
        lib_names{i} = [ '-l', lib_names{i} ];
    end
else
    lib_names = {};
end

% Misc flags
flags = {};
if dry_run
    flags{end+1} = ['-n'];
end
if verbose
    flags{end+1} = ['-v'];
end

% Call mex function
% ld_flags
% include_dirs
% lib_dirs
% lib_names
% input_files
% output_file

%disp(output_file)
output_filename = [output_file, '.', mexext];
if exist(output_filename, 'file')==3
  delete(output_filename);
end

mex(flags{:}, ld_flags, include_dirs{:}, lib_dirs{:},...
    lib_names{:}, input_files{:}, '-output', output_file);


end % function




