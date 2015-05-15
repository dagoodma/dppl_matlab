function [Xhat] = reorderHeadingsFromEdges(V, E, X, pathOptions)
%REORDERHEADINGSFROMEDGES Uses edge visitation order to reorder X
    [n, ~] = size(V);
    m = n + strcmp(pathOptions.Circuit, 'on');
    Xhat = zeros(m, 1);
    
    order = getVertexOrder(E);
    % Builds Xhat using order
    Xhat(1:n) = X(order);
    if (strcmp(pathOptions.Circuit, 'on'))
        Xhat(m) = X(m);
    end
end