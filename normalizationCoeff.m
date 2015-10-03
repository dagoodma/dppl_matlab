function [ md ] = normalizationCoeff( V )
%NORMALIZATIONCOEFF Finds the coefficient for normalizing the waypoints
%   
% Normalization (used below on path)
[n,~] = size(V);
md=inf; % the minimal distance between vertexes
for k1=1:n-1,
  for k2=k1+1:n,
    md=min(md,sum((V(k1,:)-V(k2,:)).^2)^0.5);
  end
end
if md<eps, % identical vertexes
  error('The array V have identical rows!')
end

end

