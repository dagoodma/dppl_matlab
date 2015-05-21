clear all;
close all;

% Add root
addpath('..','../class')
if exist('TrajectoryLine') ~= 2
    error('Could not find TrajectoryLine class');
end

%============== Setup ===============

%=============== Test ===============
testsPassed = 0;
totalTests = 3;

%% Constructor and basic class
line = TrajectoryLine(1,pi);
disp('Constructor');
subTestsPassed = 0;
totalSubTests = 6;

% Constructs
result = exist('line');
resultExpected = 1;
fprintf('\tConstructs');
if (result ~= resultExpected)
    fprintf('\t-- FAILED: got %d\n',result);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Start vertex
result = line.StartVertexIndex();
resultExpected = 1;
fprintf('\tStart vertex: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% End vertex
result = line.EndVertexIndex();
resultExpected = 1;
fprintf('\tEnd vertex: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Heading
result = line.Heading();
resultExpected = pi;
fprintf('\tHeading: %.4f', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %.4f\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Length (# of edges)
result = line.Length();
resultExpected = 0;
fprintf('\tLength: %i',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Point line
result = line.isPoint();
resultExpected = 1;
resultStr = 'yes'; if (~result) resultStr = 'no'; end
resultExpectedStr = 'yes'; if (~resultExpected) resultExpectedStr = 'no'; end
fprintf('\tPoint line: %s',resultStr);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: %s\n',resultExpectedStr);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Results
fprintf('----------- ');
if (subTestsPassed ~= totalSubTests)
    fprintf('FAILED');
else
    fprintf('PASSED');
    testsPassed = testsPassed + 1;
end
fprintf(' -----------\n');


%% Adding edges
disp('Adding edges');
subTestsPassed = 0;
totalSubTests = 8;

% Length for first add
line.addEdge(2);
result = line.Length();
resultExpected = 1;
fprintf('\t1st length: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Start vertex for first add
result = line.StartVertexIndex();
resultExpected = 1;
fprintf('\t1st start: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% End vertex for first add
result = line.EndVertexIndex();
resultExpected = 2;
fprintf('\t1st end: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% First add is not point
result = line.isPoint();
resultExpected = 0;
resultStr = 'yes'; if (~result) resultStr = 'no'; end
resultExpectedStr = 'yes'; if (~resultExpected) resultExpectedStr = 'no'; end
fprintf('\t1st point: %s',resultStr);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpectedStr);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Length for second add
line.addEdge(3);
result = line.Length();
resultExpected = 2;
fprintf('\t2nd length: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Start vertex for second add
result = line.StartVertexIndex();
resultExpected = 1;
fprintf('\t2nd start: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% End vertex for second add
result = line.EndVertexIndex();
resultExpected = 3;
fprintf('\t2nd end: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Second still has first add
result = line.VertexIndices(2);
resultExpected = 2;
fprintf('\t2nd middle: %i',result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Results
fprintf('----------- ');
if (subTestsPassed ~= totalSubTests)
    fprintf('FAILED');
else
    fprintf('PASSED');
    testsPassed = testsPassed + 1;
end
fprintf(' -----------\n');

%% Iterator
disp('Iterator');
subTestsPassed = 0;
totalSubTests = 10;

% Has next
result = line.hasNext();
resultExpected = 1;
resultStr = 'yes'; if (~result) resultStr = 'no'; end
resultExpectedStr = 'yes'; if (~resultExpected) resultExpectedStr = 'no'; end
fprintf('\tHas next: %s', resultStr);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpectedStr);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Get next
result = line.getNext();
resultExpected = 1;
fprintf('\tGet next: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %i\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Not have next
line.getNext(); line.getNext();
result = line.hasNext();
resultExpected = 0;
resultStr = 'no'; if (~result) resultStr = 'yes'; end
resultExpectedStr = 'no'; if (~resultExpected) resultExpectedStr = 'yes'; end
fprintf('\tNo next: %s', resultStr);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpectedStr);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Reset 
line.resetIterator();
result = line.hasNext() && (line.getNext() == 1);
resultExpected = 1;
resultStr = 'yes'; if (~result) resultStr = 'no'; end
resultExpectedStr = 'yes'; if (~resultExpected) resultExpectedStr = 'no'; end
fprintf('\tReset: %s', resultStr);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpectedStr);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Start at end has next
line.getNext();
line.startAtEnd(1);
result = line.hasNext();
resultExpected = 1;
resultStr = 'yes'; if (~result) resultStr = 'no'; end
resultExpectedStr = 'yes'; if (~resultExpected) resultExpectedStr = 'no'; end
fprintf('\tFlip next: %s', resultStr);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpectedStr);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Start at end has first
result = line.getNext();
resultExpected = 3;
fprintf('\tFlip 1st: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Start at end has second
result = line.getNext();
resultExpected = 2;
fprintf('\tFlip 2nd: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Start at end has third
result = line.getNext();
resultExpected = 1;
fprintf('\tFlip 3rd: %i', result);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpected);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Flip not have next
result = line.hasNext();
resultExpected = 0;
resultStr = 'yes'; if (~result) resultStr = 'no'; end
resultExpectedStr = 'yes'; if (~resultExpected) resultExpectedStr = 'no'; end
fprintf('\tFlip next: %s', resultStr);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpectedStr);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Flip reset
line.resetIterator();
result = line.hasNext() && line.StartAtEnd && (line.getNext == 3);
resultExpected = 1;
resultStr = 'yes'; if (~result) resultStr = 'no'; end
resultExpectedStr = 'yes'; if (~resultExpected) resultExpectedStr = 'no'; end
fprintf('\tFlip reset: %s', resultStr);
if (result ~= resultExpected)
    fprintf('\t-- FAILED: expected %s\n', resultExpectedStr);
else
    fprintf('\t-- PASS\n');
    subTestsPassed = subTestsPassed + 1;
end

% Results
fprintf('----------- ');
if (subTestsPassed ~= totalSubTests)
    fprintf('FAILED');
else
    fprintf('PASSED');
    testsPassed = testsPassed + 1;
end
fprintf(' -----------\n');


%% Overall Results
if (testsPassed ~= totalTests)
    fprintf('\n\nFAILED %i of %i tests\n\n',totalTests - testsPassed, totalTests);
else
    fprintf('\n\nPASSED %i of %i tests.\n\n', testsPassed, totalTests);
end

