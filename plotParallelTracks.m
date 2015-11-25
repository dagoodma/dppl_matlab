function [ ] = plotParallelTracks( polygon, tracks, coverageWidth, trackAngle,...
	highlightSweepSegment )
%PLOTPARALLELTRACKS Plots parallel field tracks for covering the polygon
%   Tracks are plotted that effectively cover the polygon by the coverage
%   width. Track lines are plottedin the direction of trackAngle.


hold on;

% Initial plot of sweep segment
if (exist('highlightSweepSegment') && highlightSweepSegment)
	s = polygon.findSegment(trackAngle)
	
	line = [s.StartVertex(1) ,s.StartVertex(2);...
	        s.EndVertex(1),s.EndVertex(2)]
	plot([line(1,1) line(2,1)], [line(1,2) line(2,2)],'LineWidth',2);
end

%% Test new sweep line method
%Tracks = generateParallelTracks(polygon, width)
for i=1:length(tracks)
	s = tracks(i);
	line = [s.StartVertex(1) ,s.StartVertex(2);...
	        s.EndVertex(1),s.EndVertex(2)];
    plot([line(1,1) line(2,1)], [line(1,2) line(2,2)],'--g');
end
hold off;

end % function
