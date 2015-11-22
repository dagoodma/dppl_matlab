function [ ] = plotParallelTracks( polygon, tracks, coverageWidth, trackAngle )
%PLOTPARALLELTRACKS Plots parallel field tracks for covering the polygon
%   Tracks are plotted that effectively cover the polygon by the coverage
%   width. Track lines are plottedin the direction of trackAngle.

%% Get normalization coefficient
%normalizePlot = 0;
%md = get(gcf,'UserData'); % save normalization coefficient
%if (isempty(md))
    md = 1;
%end

%% Initial plot of sweep segment
s = polygon.findSegment(trackAngle);
hold on;
line = [s.StartVertex(1) ,s.EndVertex(1);...
        s.StartVertex(2),s.EndVertex(2)]./md;
plot([line(1,1) line(2,1)], [line(2,1) line(2,2)],'LineWidth',2);

%% Test new sweep line method
%Tracks = generateParallelTracks(polygon, width)
for i=1:length(tracks)
	s = tracks(i);
    line = [s.StartVertex(1) ,s.EndVertex(1);...
            s.StartVertex(2),s.EndVertex(2)]./md;
    plot([line(1,1) line(2,1)], [line(2,1) line(2,2)],'--g');
end
plot(0,0,'or');
hold off;

end % function
