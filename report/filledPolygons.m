function [] = filledPolygons(P,color,args)

if (~iscell(P))
	error('Expected a cell array of polygons.')
end

if nargin < 3
	args = {};
end

hold on;
for i = 1:length(P)
	Pi = P{i};
	[nr,nc] = size(Pi);
	if nc ~= 2
		error('Expected polygon to have 2 columns.');
	end

	fill(Pi(:,1),Pi(:,2),color,'EdgeColor','None','LineStyle','none',args{:});
end
hold off;

end % function