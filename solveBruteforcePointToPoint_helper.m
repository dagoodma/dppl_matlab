function f = solveBruteforcePointToPoint_helperFun(x)
%% SOLVEBRUTEFORCEPOINTTOPOINT_HELPERFUN cost function for fmincon
    %============ Check input and workspace variables ============
    global ptpPathOptions ptpPathWaypoints ptpPathStartConfig;
    
    if ~isa(ptpPathOptions, 'PathOptions')
        error('You must define ptpPathOptions in the workspace.');
    end
    
    if isequal(size(ptpPathWaypoints), [0 0])
        error('You must define ptpPathWaypoints in the workspace.');
    end
    
    if isequal(size(ptpPathStartConfig), [0 0])
        error('You must define ptpPathStartConfig in the worksapce.');
    end
    
    if isempty(x)
        error('x is empty!');
    end
    
    [m, ~] = size(x);
    [n, ~] = size(ptpPathWaypoints);
    
    if ((strcmp(ptpPathOptions.Circuit, 'off') && (n ~= m))...
        || (strcmp(ptpPathOptions.Circuit, 'on') && ((n + 1) ~= m)))
        error('Expected x and ptpPathWaypoints to have compatible dimensions.');
    end
    
    %====================== Compute cost =======================
    position = ptpPathStartConfig(1:2);
    heading = ptpPathStartConfig(3);
    f = 0;
    
    for i=1:n
        v = ptpPathWaypoints(i, :);
        theta  = x(i);
        f = f + findPTPCost(position,heading,v,theta,ptpPathOptions.TurnRadius);
        position = v;
        heading = theta;
    end
    
    % Return cost
    if strcmp(ptpPathOptions.Circuit, 'on')
        theta = x(n+1);
        %theta = findHeadingFrom(position,ptpPathStartConfig(1:2));
        f = f + findPTPCost(position,heading,ptpPathStartConfig(1:2),...
            theta, ptpPathOptions.TurnRadius);
    end
    
    % Minimize or maximize cost
    if strcmp(ptpPathOptions.MaximizeCost, 'on')
        f = f * -1;
    end

end


