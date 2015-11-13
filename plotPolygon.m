function [] = plotPolygon(polygon, t)

polygon = [polygon; polygon(1,1), polygon(1,2)];
plot(polygon(:,1),polygon(:,2));
title(t);
axis equal;
expandAxes(1.3,1.3);

end % function